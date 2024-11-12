-- Active: 1728548966539@@127.0.0.1@3306@distribumax
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

CALL getultimostock(7, @stock_actual);
SELECT @stock_actual;

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

        -- Obtener stock total del producto
    SELECT IFNULL(SUM(stockactual), 0) INTO v_stock_total
    FROM lotes
    WHERE idproducto = _idproducto
    AND estado != 'Vencido';

    -- Obtener el stock actual específico del lote
/*     SELECT stockactual INTO v_stock_actual
    FROM kardex
    WHERE idproducto = _idproducto AND idlote = _idlote
    ORDER BY idkardex DESC
    LIMIT 1; */

    -- Si es un movimiento de ingreso
    IF _tipomovimiento = 'Ingreso' THEN
        SET v_nuevo_stock = v_stock_total + _cantidad;

    -- Si es un movimiento de salida
    ELSEIF _tipomovimiento = 'Salida' THEN
        IF v_stock_total >= _cantidad THEN
            SET v_nuevo_stock = v_stock_total - _cantidad;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para el producto';
        END IF;
    END IF;

    -- Insertar el registro de movimiento en el kardex
    INSERT INTO kardex (idusuario, idproducto, idlote, stockactual, tipomovimiento, cantidad, motivo)
    VALUES (_idusuario, _idproducto, _idlote, v_nuevo_stock, _tipomovimiento, _cantidad, _motivo);
END;


-- CALL sp_registrarmovimiento_kardex(1, 7, 15, 'Ingreso', 100, 'Ingreso de productos');
select * from lotes;

-- -----------------------------------------------------------------------
-- Modificar el procedimiento almacenado
DROP PROCEDURE IF EXISTS sp_registrar_salida_pedido;
-- PROCEDIMIENTO PARA DESCONTAR STOCK DE LOS LOTES DISPONIBLES Y REGISTRAR EL MOVIMIENTO EN EL KARDEX
CREATE PROCEDURE sp_registrar_salida_pedido (
    IN _idusuario           INT,
    IN _idproducto          INT,
    IN _cantidad            INT,
    IN _motivo              VARCHAR(255)
)
BEGIN
    DECLARE v_CantidadPendiente INT ;
    DECLARE v_LoteID INT;
    DECLARE v_StockLote INT;
    DECLARE v_cantidadDescontar INT;
    DECLARE v_StockDespues INT;
    DECLARE v_StockTotal INT;
    DECLARE done INT DEFAULT FALSE;
    DECLARE lotes_cursor CURSOR FOR
        SELECT idlote, stockactual
        FROM lotes
        WHERE idproducto = _idproducto 
        AND stockactual > 0
        AND estado != 'Vencido'
        ORDER BY fecha_vencimiento ASC;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    
    -- verificar stock total disponible
    SELECT IFNULL(SUM(stockactual), 0) INTO v_StockTotal
    FROM lotes
    WHERE idproducto = _idproducto
    AND stockactual > 0
    AND estado != 'Vencido';

    IF v_StockTotal < _cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente en los lotes disponibles';
    END IF;

    SET v_cantidadPendiente = _cantidad;

    OPEN lotes_cursor;

    read_loop: LOOP
        FETCH lotes_cursor INTO v_LoteID, v_StockLote;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- DETERMINAR LA CANTIDAD A DESCONTAR EN EL LOTE ACTUAL
        IF v_StockLote >= v_CantidadPendiente THEN
            SET v_CantidadDescontar = v_CantidadPendiente;
        ELSE
            SET v_CantidadDescontar = v_StockLote;
        END IF;

        -- CALCULAR EL STOCK DESPUÉS DEL MOVIMIENTO
        SET v_StockDespues = v_StockLote - v_CantidadDescontar;

        -- ACTUALIZAR EL STOCK EN LA TABLA LOTES
        UPDATE lotes
        SET stockactual = v_StockDespues
        WHERE idlote = v_LoteID;

        -- REGISTRAR EL MOVIMIENTO EN EL KARDEX
        CALL sp_registrarmovimiento_kardex(
            _idusuario,
            _idproducto, 
            v_LoteID, 
            'Salida', 
            v_CantidadDescontar,
            _motivo);

        -- ACTUALIZAR LA CANTIDAD PENDIENTE A DESCONTAR
        SET v_CantidadPendiente = v_CantidadPendiente - v_CantidadDescontar;

        -- SI SE HA DESCONTADO TODA LA CANTIDAD, SALIR DEL BUCLE
        IF v_CantidadPendiente <= 0 THEN
            LEAVE read_loop;
        END IF;
    END LOOP;

    -- CERRAR EL CURSOR
    CLOSE lotes_cursor;

    -- SI NO SE PUDO DESCONTAR TODA LA CANTIDAD, MOSTRAR UN MENSAJE DE ERROR
    IF v_CantidadPendiente > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente en los lotes disponibles';
    END IF;
END;

-- CALL sp_registrar_salida_pedido(1, 7, 100, 'Venta por pedido');
-- CALL spu_render_lote (7);






-- ---------------------------------------------------------------------


-- DROP PROCEDURE IF EXISTS spu_producto_reporte;

/* CREATE PROCEDURE spu_producto_reporte (
IN _idproducto INT
)
BEGIN
SELECT 
MAR.marca,
TPRO.tipoproducto,
PRO.modelo,
PRO.descripcion,
KAR.cantidad,
KAR.tipomovimiento,
KAR.stockactual,
KAR.create_at,
COL.nomusuario
FROM kardex KAR
INNER JOIN productos PRO ON PRO.idproducto = KAR.idproducto
INNER JOIN marcas MAR ON MAR.idmarca = PRO.idmarca
INNER JOIN tipoProductos TPRO ON TPRO.idtipoproducto = PRO.idtipoproducto
INNER JOIN colaboradores COL ON COL.idcolaborador = KAR.idcolaborador
WHERE KAR.idproducto = _idproducto;
END ;*/

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

DROP PROCEDURE IF EXISTS spu_listar_producto_kardex;

CREATE PROCEDURE spu_listar_producto_kardex(
    IN _idproducto INT
)
BEGIN
    SELECT 
        k.idkardex,
        p.nombreproducto, 
        l.fecha_vencimiento, 
        l.numlote, 
        k.tipomovimiento AS movimiento,
        k.tipomovimiento, 
        k.stockactual, 
        k.cantidad, 
        k.motivo, 
        k.estado
    FROM kardex k
    INNER JOIN productos p ON k.idproducto = p.idproducto
    INNER JOIN lotes l ON k.idlote = l.idlote
    WHERE k.idproducto = _idproducto
    ORDER BY k.idkardex DESC
    LIMIT 10;
END;

-- CALL spu_listar_producto_kardex (1);

/* UPDATE kardex
SET
estado = 'Por agotarse'
WHERE
stockactual < 20
AND estado != 'Por agotarse'; */

-- Evita cambiar el estado si ya es 'Por agotarse'
SELECT
    k.idlote, -- Número de lote
    k.idproducto, -- ID del producto
    p.nombreproducto, -- Nombre del producto
    p.codigo, -- Código del producto
    SUM(k.cantidad) AS cantidad_total, -- Sumar la cantidad por lote
    k.stockactual AS ultimo_stockactual, -- El último stock actual de cada lote
    MAX(l.fecha_vencimiento) AS fecha_vencimiento, -- Fecha de vencimiento más reciente por lote
    k.estado -- Estado del producto
FROM
    kardex k
    INNER JOIN (
        SELECT
            idproducto,
            idlote,
            MAX(idkardex) AS max_idkardex -- Obtener el último idkardex para cada lote y producto
        FROM kardex
        GROUP BY
            idproducto,
            idlote
    ) latest_kardex ON k.idkardex = latest_kardex.max_idkardex
    INNER JOIN productos p ON k.idproducto = p.idproducto
    INNER JOIN lotes l ON k.idlote = l.idlote
WHERE
    k.stockactual > 0 -- Filtrar solo por productos con stock disponible
GROUP BY
    p.codigo, -- Agrupar por el código del producto
    k.idlote, -- Agrupar por número de lote
    k.idproducto, -- Agrupar por producto (ID)
    p.nombreproducto, -- Agrupar por nombre del producto
    k.estado -- Agrupar por estado
ORDER BY k.idlote, -- Ordenar por número de lote
    p.codigo;
-- Ordenar también por código de producto

