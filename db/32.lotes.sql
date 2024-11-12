-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

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

DROP TRIGGER IF EXISTS before_insert_lotes;
CREATE TRIGGER before_insert_lotes
BEFORE INSERT ON lotes
FOR EACH ROW
BEGIN
    IF NEW.fecha_vencimiento <= CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de vencimiento debe ser mayor a la fecha actual';
    END IF;
END;

DROP TRIGGER IF EXISTS before_update_lotes;

CREATE TRIGGER before_update_lotes
BEFORE UPDATE ON lotes
FOR EACH ROW
BEGIN
    IF NEW.fecha_vencimiento <= CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de vencimiento debe ser mayor a la fecha actual';
    END IF;
END;

-- Trigger para validar y establecer estado inicial
DROP TRIGGER IF EXISTS before_insert_lotes;

CREATE TRIGGER before_insert_lotes
BEFORE INSERT ON lotes
FOR EACH ROW
BEGIN
    DECLARE v_dias_vencimiento INT;
    
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


-- Trigger para actualizar stock y estado
DROP TRIGGER IF EXISTS after_insert_kardex;

CREATE TRIGGER after_insert_kardex
AFTER INSERT ON kardex
FOR EACH ROW
BEGIN
    DECLARE v_dias_vencimiento INT;
    DECLARE v_estado VARCHAR(100);
    DECLARE v_stock_actual INT;
    DECLARE v_cantidad_pendiente INT;
    DECLARE v_cantidad_descontar INT;
    DECLARE v_idlote INT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE lotes_cursor CURSOR FOR
        SELECT idlote, stockactual 
        FROM lotes 
        WHERE idproducto = NEW.idproducto 
        AND stockactual > 0
        AND estado != 'Vencido'
        ORDER BY fecha_vencimiento ASC;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    IF NEW.tipomovimiento = 'Ingreso' THEN
        -- Proceso normal para ingresos
        UPDATE lotes 
        SET stockactual = stockactual + NEW.cantidad,
            update_at = NOW()
        WHERE idlote = NEW.idlote;
    ELSE
        -- Proceso para salidas con múltiples lotes
        SET v_cantidad_pendiente = NEW.cantidad;
        
        OPEN lotes_cursor;
        
        read_loop: LOOP
            FETCH lotes_cursor INTO v_idlote, v_stock_actual;
            IF done THEN
                LEAVE read_loop;
            END IF;
            
            IF v_stock_actual >= v_cantidad_pendiente THEN
                SET v_cantidad_descontar = v_cantidad_pendiente;
            ELSE
                SET v_cantidad_descontar = v_stock_actual;
            END IF;
            
            -- Actualizar stock del lote actual
            UPDATE lotes 
            SET stockactual = stockactual - v_cantidad_descontar,
                update_at = NOW()
            WHERE idlote = v_idlote;
            
            SET v_cantidad_pendiente = v_cantidad_pendiente - v_cantidad_descontar;
            
            IF v_cantidad_pendiente <= 0 THEN
                LEAVE read_loop;
            END IF;
        END LOOP;
        
        CLOSE lotes_cursor;
        
        IF v_cantidad_pendiente > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente en todos los lotes disponibles';
        END IF;
    END IF;
    
    -- Actualizar estados de los lotes
    UPDATE lotes 
    SET estado = CASE
        WHEN stockactual = 0 THEN 'Agotado'
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) <= 0 THEN 'Vencido'
        WHEN DATEDIFF(fecha_vencimiento, CURDATE()) <= 30 THEN 'Por vencer'
        WHEN stockactual <= 30 THEN 'Por agotarse'
        ELSE 'Disponible'
    END,
    update_at = NOW()
    WHERE idproducto = NEW.idproducto;
    
END;

/* DROP TRIGGER IF EXISTS after_insert_kardex;
CREATE TRIGGER after_insert_kardex
AFTER INSERT ON kardex
FOR EACH ROW
BEGIN
    DECLARE v_dias_vencimiento INT;
    DECLARE v_estado VARCHAR(100);
    DECLARE v_stock_actual INT;
    DECLARE v_stock_final INT;
    
    -- Obtener stock actual
    SELECT stockactual 
    INTO v_stock_actual
    FROM lotes 
    WHERE idlote = NEW.idlote;
    
    -- Calcular stock final según tipo de movimiento
    IF NEW.tipomovimiento = 'Ingreso' THEN
        SET v_stock_final = v_stock_actual + NEW.cantidad;
    ELSE 
        SET v_stock_final = v_stock_actual - NEW.cantidad;
        -- Validar que no quede stock negativo
        IF v_stock_final < 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Stock insuficiente. No se puede realizar la operación';
        END IF;
    END IF;
    
    -- Actualizar stock en lotes
    UPDATE lotes 
    SET stockactual = v_stock_final,
        update_at = NOW()
    WHERE idlote = NEW.idlote;
    
    -- Obtener días hasta vencimiento
    SELECT DATEDIFF(fecha_vencimiento, CURDATE())
    INTO v_dias_vencimiento
    FROM lotes 
    WHERE idlote = NEW.idlote;
    
    -- Determinar nuevo estado
    IF v_stock_final = 0 THEN
        SET v_estado = 'Agotado';
    ELSEIF v_dias_vencimiento <= 0 THEN
        SET v_estado = 'Vencido';
    ELSEIF v_dias_vencimiento >= 1 AND v_dias_vencimiento <= 30 THEN
        SET v_estado = 'Por vencer';
    ELSEIF v_stock_final <= 30 THEN
        SET v_estado = 'Por agotarse';
    ELSE
        SET v_estado = 'Disponible';
    END IF;
    
    -- Actualizar estado del lote
    UPDATE lotes 
    SET estado = v_estado
    WHERE idlote = NEW.idlote;
    
END; */

-- Trigger para registrar en kardex
/* DROP TRIGGER IF EXISTS after_insert_lotes;

CREATE TRIGGER after_insert_lotes
AFTER INSERT ON lotes
FOR EACH ROW
BEGIN
    INSERT INTO kardex (
        idusuario,
        idproducto,
        idlote,
        stockactual,
        tipomovimiento,
        cantidad,
        motivo,
        estado
    ) VALUES (
        IFNULL(@id_usuario_sesion, 1),
        NEW.idproducto,
        NEW.idlote,
        NEW.stockactual,
        'Ingreso',
        NEW.stockactual,
        'Registro inicial de lote',
        NEW.estado
    );
END; */

SELECT * FROM lotes;

-- SELECT DATEDIFF('2024-11-10', CURDATE()) AS dias_vencimiento;