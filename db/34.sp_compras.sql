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

DROP PROCEDURE IF EXISTS sp_listar_compras;

CREATE PROCEDURE sp_listar_compras()
BEGIN
SELECT 
c.idcompra,
c.numcomprobante, 
c.fechaemision, 
pr.proveedor,
CASE c.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE c.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`
FROM compras c 
INNER JOIN proveedores pr ON pr.idproveedor=c.idproveedor;
END ;



CREATE PROCEDURE sp_update_estadocompras(
    IN _estado CHAR(1),
    IN _idcompra INT
   
)
BEGIN
    UPDATE compras
    SET estado = _estado,
        update_at= NOW()
    WHERE idcompra = _idcompra;
END;



CREATE PROCEDURE sp_reporte_compras(IN _idcompra INT)
BEGIN	
	SELECT 
    c.idcompra,
    c.numcomprobante,
    p.proveedor,
    p.idempresa,
    lt.numlote,
	pr.nombreproducto,
    dc.cantidad,
    dc.precio_compra,
	c.fechaemision
    FROM compras c 
    INNER JOIN detalles_compras dc ON dc.idcompra=c.idcompra
    INNER JOIN proveedores p ON p.idproveedor=c.idproveedor
    LEFT  JOIN productos pr ON pr.idproducto=dc.idproducto
    LEFT JOIN lotes lt  ON lt.idlote=dc.idlote
    WHERE c.idcompra=_idcompra;
END;