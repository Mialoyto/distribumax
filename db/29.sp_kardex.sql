-- Active: 1732807506399@@127.0.0.1@3306@distribumax
USE distribumax;
-- Procedimiento para obtener el último stock
DROP PROCEDURE IF EXISTS getultimostock;

CREATE PROCEDURE getultimostock (
    IN _idproducto      INT,
    OUT stock_actual    INT
)
BEGIN
    SELECT stockactual INTO stock_actual
    FROM lotes
    WHERE idproducto = _idproducto
    ORDER BY create_at DESC
    LIMIT 1;
END ;

-- modificado
DROP PROCEDURE IF EXISTS sp_registrarmovimiento_kardex;

CREATE PROCEDURE sp_registrarmovimiento_kardex (
    IN _idusuario           INT,
    IN _idproducto          INT,
    IN _idlote              INT,
    IN _tipomovimiento      ENUM('Ingreso', 'Salida'),
    IN _cantidad            INT,
    IN _motivo              VARCHAR(255)
)
BEGIN
    DECLARE v_stock_total INT DEFAULT 0;
    DECLARE v_nuevo_stock INT;

    -- Obtener stock total del producto ANTES del movimiento, considerando todo los lotes
    SELECT IFNULL(SUM(stockactual), 0) INTO v_stock_total
    FROM lotes
    WHERE idproducto = _idproducto
    AND estado != 'Vencido';

    -- Validar si hay suficiente stock para salidas
    IF _tipomovimiento = 'Salida' AND v_stock_total < _cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para el producto';
    END IF;

    IF _tipomovimiento = 'Ingreso' THEN
        SET v_nuevo_stock = v_stock_total + _cantidad;
    ELSE 
        SET v_nuevo_stock = v_stock_total - _cantidad;
    END IF;

        
    -- Insertar el registro de movimiento en el kardex con el stock total actualizado
    INSERT INTO kardex (idusuario, idproducto, idlote, stockactual, tipomovimiento, cantidad, motivo)
    VALUES (_idusuario, _idproducto, _idlote, v_nuevo_stock, _tipomovimiento, _cantidad, _motivo);

    select v_nuevo_stock;
END;

-- -----------------------------------------------------------------------
-- Modificar el procedimiento almacenado
DROP PROCEDURE IF EXISTS sp_registrar_salida_pedido;

CREATE PROCEDURE sp_registrar_salida_pedido (
    IN _idusuario    INT,
    IN _idproducto   INT,
    IN _cantidad     INT,
    IN _motivo       VARCHAR(255),
    IN _idpedido     CHAR(15)  -- - //FIXME: NUEVO PARAMETRO PARA IDENTIFICAR EL PEDIDO
)
BEGIN
    DECLARE v_nuevo_stock INT;

    DECLARE v_CantidadPendiente INT;
    DECLARE v_LoteID INT;
    DECLARE v_StockLote INT;
    DECLARE v_CantidadDescontar INT;
    DECLARE v_StockDespues INT;
    DECLARE v_StockTotal INT;
    DECLARE done INT DEFAULT FALSE;
    
    -- Cursor para lotes ordenados por fecha de vencimiento
    DECLARE lotes_cursor CURSOR FOR
        SELECT idlote, stockactual
        FROM lotes
        WHERE idproducto = _idproducto 
        AND stockactual > 0
        AND estado != 'Vencido'
        ORDER BY fecha_vencimiento ASC;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Verificar stock total disponible
    SELECT IFNULL(SUM(stockactual), 0) INTO v_StockTotal
    FROM lotes
    WHERE idproducto = _idproducto
    AND stockactual > 0
    AND estado != 'Vencido';

    IF v_StockTotal < _cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente en los lotes disponibles';
    END IF;

    SET v_CantidadPendiente = _cantidad;

    OPEN lotes_cursor;

    read_loop: LOOP
        FETCH lotes_cursor INTO v_LoteID, v_StockLote;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calcular cantidad a descontar del lote actual
        IF v_StockLote >= v_CantidadPendiente THEN
            SET v_CantidadDescontar = v_CantidadPendiente;
        ELSE
            SET v_CantidadDescontar = v_StockLote;
        END IF;

        -- Actualizar stock del lote
        SET v_StockDespues = v_StockLote - v_CantidadDescontar;
        
        UPDATE lotes
        SET stockactual = v_StockDespues
        WHERE idlote = v_LoteID;


        SET v_nuevo_stock = v_StockTotal - v_CantidadDescontar;
        -- Registrar movimiento en kardex
        CALL sp_registrarmovimiento_kardex(
            _idusuario,
            _idproducto, 
            _idpedido, -- -//FIXME - NUEVO PARAMETRO
            v_LoteID, 
            v_nuevo_stock,
            'Salida', 
            v_CantidadDescontar,
            _motivo
        );

        -- Actualizar cantidad pendiente
        SET v_CantidadPendiente = v_CantidadPendiente - v_CantidadDescontar;

        IF v_CantidadPendiente <= 0 THEN
            LEAVE read_loop;
        END IF;
    END LOOP;

    CLOSE lotes_cursor;
END;
--  --------------------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS spu_listar_kardex;
CREATE PROCEDURE spu_listar_kardex()
BEGIN
    SELECT 
        p.nombreproducto, 
        l.fecha_vencimiento,
        l.numlote, 
        k.stockactual, 
        k.tipomovimiento, 
        k.cantidad, 
        k.motivo,
        k.estado
    FROM kardex k
    INNER JOIN productos p ON k.idproducto = p.idproducto
    INNER JOIN lotes l ON k.idlote = l.idlote
    WHERE k.estado = 'Disponible'
    ORDER BY k.idkardex DESC;
END;

-- CALL spu_listar_kardex ();

DROP PROCEDURE IF EXISTS spu_list_idproducto;

CREATE PROCEDURE spu_list_idproducto(
    IN _idproducto INT
)
BEGIN
 SELECT 
    LOT.numlote AS lote,
    PRO.nombreproducto AS producto,
    KAR.tipomovimiento,
    KAR.motivo,
    KAR.cantidad,
    KAR.stockactual,
    KAR.create_at AS fechaMovimiento
FROM kardex KAR
    INNER JOIN lotes LOT ON KAR.idlote = LOT.idlote
    INNER JOIN productos PRO ON LOT.idproducto = PRO.idproducto
WHERE KAR.idproducto = _idproducto ORDER BY KAR.idkardex DESC LIMIT 10;
END;
-- CALL spu_list_idproducto(8);
SELECT * FROM kardex WHERE idproducto = 8;