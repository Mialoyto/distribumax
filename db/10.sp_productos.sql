-- Active: 1726698325558@@127.0.0.1@3306@distribumax

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
    IN _precio_mayorista          DECIMAL(10, 2),
    IN _precio_minorista         DECIMAL(10, 2)
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
        precio_mayorista,
        precio_minorista
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
        _precio_mayorista,
        _precio_minorista
        );
        SELECT LAST_INSERT_ID() AS idproducto;
END;
-- call sp_registrar_producto(1, 1, 1, 'Producto 1', 1, 1, '1', 1, 1, 2, 3);

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


-- PRUEBA DE BUSQUEDA de productos
DROP PROCEDURE IF EXISTS sp_buscar_productos;
CREATE PROCEDURE sp_buscar_productos(
    IN _nombreproducto VARCHAR (250)) 
BEGIN
SELECT
    PRO.idproducto,
    PRO.nombreproducto,
    UME.unidadmedida
FROM
    productos PRO
    INNER JOIN unidades_medidas UME ON UME.idunidadmedida = PRO.idunidadmedida
WHERE
    ( nombreproducto LIKE CONCAT ('%', _nombreproducto, '%'))
    AND PRO.estado = '1'
GROUP BY
    PRO.idproducto
ORDER BY
    PRO.idproducto DESC
    LIMIT 10;
END;

-- CALL sp_buscar_productos ('cas');

-- buscar productos por codigo
DROP PROCEDURE IF EXISTS spu_buscar_lote;
CREATE PROCEDURE spu_buscar_lote(
    IN _idproducto INT)
BEGIN
SELECT
    LOT.idlote,
    LOT.numlote,
    LOT.fecha_vencimiento,
    UNM.unidadmedida,
    LOT.stockactual
FROM productos PRO
INNER JOIN lotes LOT ON LOT.idproducto = PRO.idproducto
INNER JOIN unidades_medidas UNM ON UNM.idunidadmedida = PRO.idunidadmedida
WHERE
    PRO.idproducto  = _idproducto
    AND PRO.estado = '1'
ORDER BY
    numlote DESC
LIMIT 10;    
END;
call spu_buscar_lote(7);
-- select * from kardex WHERE idproducto = 7;

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

CALL sp_get_codigo_producto('AJI-SZ-001');
-- LISTAR PRODUCTOS


DROP PROCEDURE IF EXISTS sp_listar_productos;
CREATE PROCEDURE sp_listar_productos()
BEGIN
    SELECT 
        m.marca,
        c.categoria,
        p.nombreproducto,
        p.codigo,
        CASE p.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE p.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`
    FROM 
        productos p
    JOIN 
        marcas m ON p.idmarca = m.idmarca
    JOIN 
        categorias c ON m.idcategoria = c.idcategoria
    WHERE 
        p.estado = '1'; -- Solo productos activos
END;

CREATE PROCEDURE sp_eliminar_producto(IN _idproducto INT)
BEGIN
    -- Verifica que el producto existe antes de eliminarlo
    IF EXISTS (SELECT 1 FROM productos WHERE idproducto = _idproducto) THEN
    DELETE FROM productos WHERE idproducto = _idproducto;
    ELSE
    -- Si el producto no existe, puedes lanzar un mensaje de error o simplemente terminar
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto no existe';
    END IF;
END;
