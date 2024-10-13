-- Active: 1728548966539@@127.0.0.1@3306@distribumax

USE distribumax;

-- REGISTRAR PRODUCTOS
CREATE PROCEDURE sp_registrar_producto (
    IN _idproveedor             INT,
    IN _idmarca                 INT,
    IN _idsubcategoria          INT,
    IN _nombreproducto          VARCHAR (250),
    IN _idunidad_medida          INT,
    IN _cantidad_presentacion    INT,
    IN _peso_unitario            VARCHAR (10), 
    IN _codigo                  CHAR (30),
    IN _precio_compra            DECIMAL(10, 2),
    IN _precio_minorista         DECIMAL(10, 2),
    IN _precio_mayorista          DECIMAL(10, 2)
) BEGIN
INSERT INTO
    productos (
        idproveedor,
        idmarca,
        idsubcategoria,
        nombreproducto,
        idunidadmedida,
        cantidad_presentacion,
        peso_unitario,
        codigo,
        precio_compra,
        precio_minorista,
        precio_mayorista
        )
VALUES
    (
        _idproveedor,
        _idmarca,
        _idsubcategoria,
        _nombreproducto,
        _idunidad_medida,
        _cantidad_presentacion,
        _peso_unitario,
        _codigo,
        _precio_compra,
        _precio_minorista,
        _precio_mayorista
        );
        SELECT LAST_INSERT_ID() AS idproducto;
END;


-- ACTUALIZA PRODUCTOS
CREATE PROCEDURE sp_actualziar_producto (
    IN _idmarca INT,
    IN _idsubcategoria INT,
    IN _nombreproducto VARCHAR (250),
    IN _descripcion VARCHAR (250),
    IN _codigo CHAR (30),
    IN _idproducto INT
) BEGIN
UPDATE
    productos
SET
    idmarca = _idmarca,
    idsubcategoria = _idsubcategoria,
    nombreproducto = _nombreproducto,
    descripcion = _descripcion,
    codigo = _codigo,
    update_at = NOW()
WHERE
    idproducto = _idproducto;
END;

-- ESTADO producto


CREATE PROCEDURE sp_estado_producto (
    IN _estado CHAR (1), 
    IN _idproducto INT) 
BEGIN
UPDATE
    productos
SET
    estado = _estado
WHERE
    idproducto = _idproducto;

END;

-- PRUEBA DE BUSQUEDA
DROP PROCEDURE IF EXISTS sp_buscar_productos;
CREATE PROCEDURE `sp_buscar_productos`(
    IN _item VARCHAR (250)) 
BEGIN
SELECT
    PRO.idproducto,
    PRO.nombreproducto,
    PRO.codigo,
    UME.unidadmedida,
    COALESCE(KAR.stockactual, 0) AS stockactual
FROM
    productos PRO
    LEFT JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
    AND KAR.idkardex = (
        SELECT MAX(K2.idkardex)
        FROM kardex K2
        WHERE K2.idproducto = PRO.idproducto
    )
    INNER JOIN detalle_productos DET ON DET.idproducto = PRO.idproducto
    INNER JOIN unidades_medidas UME ON UME.idunidadmedida = DET.idunidadmedida
WHERE
    (
        codigo LIKE CONCAT ('%', _item, '%')
        OR nombreproducto LIKE CONCAT ('%', _item, '%')
    )
    AND PRO.estado = '1'
ORDER BY
    PRO.idproducto ASC;
END;


-- BUSCAR PRODUCTOS
DROP PROCEDURE IF EXISTS sp_buscar_productos;
CREATE PROCEDURE sp_buscar_productos(
    IN _item VARCHAR (250)
) 
BEGIN
SELECT
    PRO.idproducto,
    PRO.codigo,
    PRO.nombreproducto,
    kAR.stockactual,
    UME.unidadmedida
FROM
    productos PRO
    INNER JOIN detalle_productos DTP ON PRO.idproducto = DTP.idproducto
    INNER JOIN unidades_medidas UME ON DTP.idunidadmedida = UME.idunidadmedida
    INNER JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
    AND KAR.idkardex = (
        SELECT MAX(K2.idkardex)
        FROM kardex K2
        WHERE K2.idproducto = PRO.idproducto
    )
WHERE
    (
        codigo LIKE CONCAT ('%', _item, '%')
        OR nombreproducto LIKE CONCAT ('%', _item, '%')
    )
    AND PRO.estado = '1'
    AND KAR.stockactual > 0;
END;

-- BUSCAR PRODUCTOS
DROP PROCEDURE IF EXISTS sp_get_codigo_producto;
CREATE PROCEDURE sp_get_codigo_producto(
    IN _codigo CHAR(30)
)
BEGIN
    SELECT
        CONCAT(PRO.nombreproducto,'-',UNM.unidadmedida,' ',PRO.cantidad_presentacion, 'X', PRO.peso_unitario) AS nombreproducto,
        codigo
    FROM
        productos PRO
    INNER JOIN unidades_medidas UNM ON UNM.idunidadmedida = PRO.idunidadmedida
    WHERE
        PRO.codigo = _codigo
        AND PRO.estado = '1';
END;