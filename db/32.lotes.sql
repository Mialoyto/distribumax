-- Active: 1732807506399@@127.0.0.1@3306@distribumax
USE distribumax;
-- TODO: REGISTRAR LOTES (OK)
DROP PROCEDURE IF EXISTS sp_registrar_lote;

CREATE PROCEDURE sp_registrar_lote(
    IN p_id_producto INT,
    IN p_lote VARCHAR(60),
    IN p_fecha_vencimiento DATE
)
BEGIN
    DECLARE existing_id INT;

    -- Verificar si el lote y producto ya están registrados
    SELECT idlote INTO existing_id
    FROM lotes
    WHERE idproducto = p_id_producto AND numlote = p_lote;

    IF existing_id IS NOT NULL THEN
        -- Si ya existe, devolver -1
        SELECT -1 AS idlote;
    ELSE
        -- Si no existe, insertar el nuevo registro
        INSERT INTO lotes (idproducto, numlote, fecha_vencimiento )
        VALUES (p_id_producto,p_lote, p_fecha_vencimiento);
        -- Devolver el ID del nuevo registro
        SELECT LAST_INSERT_ID() AS idlote;
    END IF;
END;

-- TODO: TRIGGERS PARA ACTUALIZAR ESTADO DE LOTES Y VALIDAR FECHA DE VENCIMIENTO
DROP TRIGGER IF EXISTS before_insert_lotes;

CREATE TRIGGER before_insert_lotes
BEFORE INSERT ON lotes
FOR EACH ROW
BEGIN
    DECLARE v_dias_vencimiento INT;

    -- Validar fecha de vencimiento
    IF NEW.fecha_vencimiento <= CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de vencimiento debe ser mayor a la fecha actual';
    END IF;
    
    -- Calcular días hasta vencimiento/*  */
    SET v_dias_vencimiento = DATEDIFF(NEW.fecha_vencimiento, CURDATE());
    
    -- Establecer estado inicial
    IF NEW.stockactual = 0 THEN
        SET NEW.estado = 'Agotado';
    ELSEIF v_dias_vencimiento < 0 THEN
        SET NEW.estado = 'Vencido';
    ELSEIF v_dias_vencimiento <= 30 THEN
        SET NEW.estado = 'Por vencer';
    ELSEIF NEW.stockactual <= 30 THEN
        SET NEW.estado = 'Por agotarse';
    ELSE
        SET NEW.estado = 'Disponible';
    END IF;

END;

-- Este trigger se ejecuta después de insertar un registro en la tabla kardex
DROP TRIGGER IF EXISTS after_insert_kardex;

CREATE TRIGGER after_insert_kardex
AFTER INSERT ON kardex
FOR EACH ROW
BEGIN 

    IF NEW.tipomovimiento = 'Ingreso' THEN
        -- Actualizar stock para ingresos
        UPDATE lotes 
        SET stockactual = stockactual + NEW.cantidad,
            update_at = NOW()
        WHERE idlote = NEW.idlote;
    ELSE
        -- Actualizar stock para salidas
        UPDATE lotes 
        SET stockactual = stockactual - NEW.cantidad,
            update_at = NOW()
        WHERE idlote = NEW.idlote;
    END IF;

    -- Actualizar estado del lote
    UPDATE lotes 
    SET estado = CASE
        WHEN stockactual = 0 THEN 'Agotado'
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) <= 0 THEN 'Vencido'
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) <= 30 THEN 'Por vencer'
        WHEN stockactual <= 30 THEN 'Por agotarse'
        ELSE 'Disponible'
    END,
    update_at = NOW()
    WHERE idlote = NEW.idlote;
END;

--
CREATE TRIGGER before_insert_kardex
BEFORE INSERT ON kardex
FOR EACH ROW
BEGIN
    DECLARE v_stock_actual INT;
    
    -- Obtener stock actual del lote
    SELECT IFNULL(SUM(stockactual),0) INTO v_stock_actual
    FROM lotes 
    WHERE idproducto = NEW.idproducto
    AND estado != 'Vencido';

    -- Calcular y asignar el nuevo stockactual
    IF NEW.tipomovimiento = 'Ingreso' THEN
        SET NEW.stockactual = v_stock_actual + NEW.cantidad;
    ELSE
        SET NEW.stockactual = v_stock_actual - NEW.cantidad;
    END IF;
END;

--

-- Modificar el procedimiento para manejar múltiples lotes
DROP PROCEDURE IF EXISTS sp_registrar_salida_pedido;

CREATE PROCEDURE sp_registrar_salida_pedido (
    IN _idusuario    INT,
    IN _idproducto   INT,
    IN _cantidad     INT,
    IN _motivo       VARCHAR(255),
    IN _idpedido     CHAR(15) -- - //FIXME - NUEVO PARAMET
)
BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_cantidad_pendiente INT;
    DECLARE v_cantidad_descontar INT;
    DECLARE v_idlote INT;
    DECLARE v_stock_total INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idpedido CHAR(15); -- - //FIXME - NUEVO PARAMETRO
    
    DECLARE lotes_cursor CURSOR FOR
        SELECT idlote, stockactual 
        FROM lotes 
        WHERE idproducto = _idproducto 
        AND stockactual > 0
        AND estado != 'Vencido'
        ORDER BY fecha_vencimiento ASC;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Verificar stock total disponible
    SELECT IFNULL(SUM(stockactual), 0) INTO v_stock_total
    FROM lotes
    WHERE idproducto = _idproducto
    AND stockactual > 0
    AND estado != 'Vencido';

    -- Valida si hay suficiente stock total
    IF v_stock_total < _cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock total insuficiente';
    END IF;

    SET v_cantidad_pendiente = _cantidad;

-- Procesa cada lote hasta cubrir la cantidad requerida    
    OPEN lotes_cursor;
    
    read_loop: LOOP
        FETCH lotes_cursor INTO v_idlote, v_stock_actual;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calcula cantidad a descontar del lote actual
        IF v_stock_actual >= v_cantidad_pendiente THEN
            SET v_cantidad_descontar = v_cantidad_pendiente;
        ELSE
            SET v_cantidad_descontar = v_stock_actual;
        END IF;

        -- Registrar movimiento en kardex
        INSERT INTO kardex (
            idusuario,
            idproducto,
            idpedido, -- - //FIXME - NUEVO PARAMETRO
            idlote,
            tipomovimiento,
            cantidad,
            motivo
        ) VALUES (
            _idusuario,
            _idproducto,
            _idpedido, -- - //FIXME - NUEVO PARAMETRO
            v_idlote,
            'Salida',
            v_cantidad_descontar,
            _motivo
        );

        
        -- Actualiza la cantidad pendiente
        SET v_cantidad_pendiente = v_cantidad_pendiente - v_cantidad_descontar;
        
        IF v_cantidad_pendiente <= 0 THEN
            LEAVE read_loop;
        END IF;
    END LOOP;
    
    CLOSE lotes_cursor;
END;



DROP PROCEDURE IF EXISTS sp_productos_por_agotarse_o_vencimiento;

CREATE PROCEDURE sp_productos_por_agotarse_o_vencimiento()
BEGIN
    SELECT 
        l.fecha_vencimiento,
        l.numlote,
        p.nombreproducto,
        l.estado,
        l.stockactual
    FROM 
        lotes l
    INNER JOIN 
        productos p ON p.idproducto = l.idproducto
    WHERE 
        -- Lotes por agotarse o agotados
        l.estado IN ('Por Agotarse', 'Agotado')
        OR 
        -- Lotes que vencen dentro de las próximas dos semanas
        (l.fecha_vencimiento BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 2 WEEK))
        OR 
        -- Lotes que vencen muy pronto (considerando unos días antes del rango de 2 semanas)
        (l.fecha_vencimiento BETWEEN DATE_SUB(NOW(), INTERVAL 3 DAY) AND NOW())
    ORDER BY 
        l.fecha_vencimiento ASC;
END ;