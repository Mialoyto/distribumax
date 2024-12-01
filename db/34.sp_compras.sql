-- Active: 1732798376350@@127.0.0.1@3306@distribumax
-- TODO: OBTENER PRODUCTOS POR PROVEEDOR (OK)
-- * IMPORTANT: NO MODIFICAR ESTE PROCEDIMIENTO
DROP PROCEDURE IF EXISTS sp_get_productos_proveedor;

CREATE PROCEDURE sp_get_productos_proveedor(
    IN _idproveedor INT,
    IN _producto VARCHAR(100)
)
BEGIN
    SELECT
        PRO.idproducto,
        CONCAT(PRO.nombreproducto,' ',UNM.unidadmedida,' ',PRO.cantidad_presentacion,' X ',PRO.peso_unitario) AS producto,
        UNM.unidadmedida,
        LOT.numlote,
        LOT.idlote,
        LOT.stockactual
    FROM productos PRO
        INNER JOIN unidades_medidas UNM ON PRO.idunidadmedida = UNM.idunidadmedida
        INNER JOIN lotes LOT ON PRO.idproducto = LOT.idproducto
    WHERE PRO.idproveedor = _idproveedor
    AND PRO.nombreproducto LIKE CONCAT('%',_producto,'%')
    AND _producto <> ''
    AND PRO.estado = '1'
    ORDER BY PRO.nombreproducto ASC;
END;

-- TODO: REGISTRAR EN LA TABLA DE COMPRAS (OK)
-- * IMPORTANT: NO MODIFICAR ESTE PROCEDIMIENTO
DROP PROCEDURE IF EXISTS sp_registrar_compra;

CREATE PROCEDURE sp_registrar_compra (
    IN _idusuario INT,
    IN _idproveedor INT,
    IN _idcomprobante INT,
    IN _numcomprobante VARCHAR(100),
    IN _fechaemision DATE
)
BEGIN
    INSERT INTO compras(
        idusuario,
        idproveedor,
        idtipocomprobante,
        numcomprobante,
        fechaemision
    ) VALUES (
        _idusuario,
        _idproveedor,
        _idcomprobante,
        _numcomprobante,
        _fechaemision
    );
    SELECT LAST_INSERT_ID() AS idcompra;
END;

-- TODO: REGISTRAR DETALLE DE COMPRA (OK)
-- * IMPORTANT: NO MODIFICAR ESTE PROCEDIMIENTO
DROP PROCEDURE IF EXISTS sp_registrar_detalle_compra;

CREATE PROCEDURE sp_registrar_detalle_compra (
    IN _idcompra INT,
    IN _idlote INT,
    IN _idproducto INT,
    IN _cantidad INT,
    IN _preciocompra DECIMAL(10,2)
)
BEGIN

    DECLARE _idusuario INT;
    DECLARE v_subtotal DECIMAL(10,2);

    -- Obtener el usuario que registró la compra
    SELECT idusuario INTO _idusuario
    FROM compras 
    WHERE idcompra = _idcompra;

    -- Calcular el subtotal
    SET v_subtotal = _cantidad * _preciocompra;

    -- Registrar en detalle de compra
    INSERT INTO detalles_compras(
        idcompra,
        idlote,
        idproducto,
        cantidad,
        precio_compra,
        subtotal
    ) VALUES (
        _idcompra,
        _idlote,
        _idproducto,
        _cantidad,
        _preciocompra,
        v_subtotal
    );
    --  * IMPORTANTE: TRAER LOS ID DE KADEX Y DETALLE DE COMPRA
    SELECT LAST_INSERT_ID() AS iddetallecompra;

        -- Registrar en kardex
    CALL sp_registrarmovimiento_kardex(
        _idusuario,
        _idproducto,
        _idlote,
        'Ingreso',
        _cantidad,
        'Ingreso por compra'
    );
END;

-- CALL sp_registrar_detalle_compra(1,1,1,9,1);


