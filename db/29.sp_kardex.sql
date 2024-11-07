-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribuMax;
-- Procedimiento para obtener el último stock
DROP PROCEDURE IF EXISTS getultimostock;

CREATE PROCEDURE getultimostock (
    IN _idproducto      INT,
    OUT stock_actual    INT
)
BEGIN
    SELECT stockactual INTO stock_actual
    FROM kardex
    WHERE idproducto = _idproducto
    ORDER BY create_at DESC
    LIMIT 1;
END ;

-- Procedimiento para registrar movimiento de detalle de pedido
DROP PROCEDURE IF EXISTS sp_registrarmovimiento_kardex;

CREATE PROCEDURE sp_registrarmovimiento_kardex (
    IN _idusuario           INT,
    IN _idproducto          INT,
    IN _fecha_vencimiento   DATE,
    IN _numlote             VARCHAR(60),
    IN _tipomovimiento      ENUM('Ingreso', 'Salida'),
    IN _cantidad            INT, -- Cambiado a INT si debe ser entero
    IN _motivo              VARCHAR(255)
)
BEGIN
    DECLARE _ultimo_stock_actual INT DEFAULT 0;
    DECLARE _nuevo_stock_actual INT;

    CALL getultimostock(_idproducto, _ultimo_stock_actual);

    IF _ultimo_stock_actual IS NULL THEN
        SET _ultimo_stock_actual = 0;
    END IF;

    IF _tipomovimiento = 'Ingreso' THEN
        SET _nuevo_stock_actual = _ultimo_stock_actual + _cantidad;
    ELSEIF _tipomovimiento = 'Salida' THEN
        IF _ultimo_stock_actual >= _cantidad THEN
            SET _nuevo_stock_actual = _ultimo_stock_actual - _cantidad;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para esta operación';
        END IF;
    END IF;

    INSERT INTO kardex (idusuario, idproducto,fecha_vencimiento,numlote, stockactual, tipomovimiento, cantidad, motivo)
    VALUES (_idusuario, _idproducto,_fecha_vencimiento,_numlote, _nuevo_stock_actual, _tipomovimiento, _cantidad, _motivo);
END;

-- Procedimiento para reporte de producto
DROP PROCEDURE IF EXISTS spu_producto_reporte;

CREATE PROCEDURE spu_producto_reporte (
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
END ;

DROP PROCEDURE IF EXISTS spu_listar_kardex;

CREATE PROCEDURE spu_listar_kardex()
BEGIN
    SELECT p.nombreproducto, k.fecha_vencimiento,
        k.numlote, k.stockactual, k.tipomovimiento, k.cantidad, k.motivo,k.estado
    FROM kardex k
    JOIN productos p ON k.idproducto = p.idproducto;
END;

DROP PROCEDURE IF EXISTS spu_listar_producto_kardex;

CREATE PROCEDURE spu_listar_producto_kardex(
    IN _idproducto INT
)
BEGIN
    SELECT 
        k.idkardex,
        p.nombreproducto, 
        k.fecha_vencimiento, 
        k.numlote, 
        k.tipomovimiento AS movimiento,
        k.tipomovimiento, 
        k.stockactual, 
        k.cantidad, 
        k.motivo, 
        k.estado
    FROM kardex k
    INNER JOIN productos p ON k.idproducto = p.idproducto
    WHERE k.idproducto = _idproducto
    ORDER BY k.idkardex DESC
    LIMIT 10;
END;



/* UPDATE kardex
SET
    estado = 'Por agotarse'
WHERE
    stockactual < 20
    AND estado != 'Por agotarse';
-- Evita cambiar el estado si ya es 'Por agotarse'
SELECT
    k.numlote, -- Número de lote
    k.idproducto, -- ID del producto
    p.nombreproducto, -- Nombre del producto
    p.codigo, -- Código del producto
    SUM(k.cantidad) AS cantidad_total, -- Sumar la cantidad por lote
    k.stockactual AS ultimo_stockactual, -- El último stock actual de cada lote
    MAX(k.fecha_vencimiento) AS fecha_vencimiento, -- Fecha de vencimiento más reciente por lote
    k.estado -- Estado del producto
FROM
    kardex k
    INNER JOIN (
        SELECT
            idproducto,
            numlote,
            MAX(idkardex) AS max_idkardex -- Obtener el último idkardex para cada lote y producto
        FROM kardex
        GROUP BY
            idproducto,
            numlote
    ) latest_kardex ON k.idkardex = latest_kardex.max_idkardex
    INNER JOIN productos p ON k.idproducto = p.idproducto
WHERE
    k.stockactual > 0 -- Filtrar solo por productos con stock disponible
GROUP BY
    p.codigo, -- Agrupar por el código del producto
    k.numlote, -- Agrupar por número de lote
    k.idproducto, -- Agrupar por producto (ID)
    p.nombreproducto, -- Agrupar por nombre del producto
    k.estado -- Agrupar por estado
ORDER BY k.numlote, -- Ordenar por número de lote
    p.codigo;
-- Ordenar también por código de producto
SELECT * FROM kardex;

SELECT
    k.numlote, -- Número de lote
    k.idproducto, -- ID del producto
    p.nombreproducto, -- Nombre del producto
    p.codigo, -- Código del producto
    SUM(k.cantidad) AS cantidad_total, -- Sumar la cantidad por lote
    k.stockactual AS ultimo_stockactual, -- El stock actual debe ser por cada lote específico
    MAX(k.fecha_vencimiento) AS fecha_vencimiento, -- Fecha de vencimiento más reciente por lote
    k.estado -- Estado del producto
FROM
    kardex k
    INNER JOIN (
        SELECT
            idproducto,
            numlote,
            MAX(idkardex) AS max_idkardex -- Obtener el último idkardex para cada lote y producto
        FROM kardex
        GROUP BY
            idproducto,
            numlote
    ) latest_kardex ON k.idkardex = latest_kardex.max_idkardex
    INNER JOIN productos p ON k.idproducto = p.idproducto
WHERE
    k.stockactual > 0 -- Filtrar solo por productos con stock disponible
GROUP BY
    k.numlote, -- Agrupar por número de lote
    k.idproducto, -- Agrupar por producto (ID)
    p.codigo, -- Agrupar por código del producto
    p.nombreproducto, -- Agrupar por nombre del producto
    k.estado, -- Agrupar por estado
    k.stockactual -- No se debe sumar el stock actual, solo se selecciona por lote
ORDER BY k.numlote, -- Ordenar por número de lote
    p.codigo;

SELECT
    k.numlote, -- Número de lote
    k.idproducto, -- ID del producto
    p.nombreproducto, -- Nombre del producto
    p.codigo, -- Código del producto
    SUM(k.cantidad) AS cantidad_total, -- Sumar la cantidad por lote
    k.stockactual AS ultimo_stockactual, -- El stock actual debe ser por cada lote (último ingreso)
    MAX(k.fecha_vencimiento) AS fecha_vencimiento, -- Fecha de vencimiento más reciente por lote
    k.estado -- Estado del producto
FROM
    kardex k
    INNER JOIN (
        SELECT
            idproducto,
            numlote,
            MAX(idkardex) AS max_idkardex -- Obtener el último idkardex para cada lote y producto
        FROM kardex
        -- GROUP BY
            idproducto,
            numlote
    ) latest_kardex ON k.idkardex = latest_kardex.max_idkardex
    INNER JOIN productos p ON k.idproducto = p.idproducto
WHERE
    k.stockactual > 0 -- Filtrar solo por productos con stock disponible
GROUP BY
    k.numlote, -- Agrupar por número de lote
    k.idproducto, -- Agrupar por producto (ID)
    p.codigo, -- Agrupar por código del producto
    p.nombreproducto, -- Agrupar por nombre del producto
    k.estado, -- Agrupar por estado
    k.stockactual -- No se debe sumar el stock actual, solo se selecciona por lote
ORDER BY k.numlote, -- Ordenar por número de lote
    p.codigo; */