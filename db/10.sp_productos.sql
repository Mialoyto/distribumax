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

CALL sp_buscar_productos ('cas');

-- buscar productos por codigo
DROP PROCEDURE IF EXISTS spu_buscar_lote;

CREATE PROCEDURE spu_buscar_lote(
    IN _idproducto INT)
BEGIN
SELECT
    LOT.idlote,
    LOT.numlote,
    PRO.idproducto,
    KAR.stockactual
FROM productos PRO
INNER JOIN lotes LOT ON LOT.idproducto = PRO.idproducto
LEFT JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
    AND KAR.idkardex = (
        SELECT MAX(K2.idkardex)
        FROM kardex K2
        WHERE K2.idproducto = PRO.idproducto
        AND K2.idlote = LOT.idlote
    )
WHERE
    PRO.idproducto  = _idproducto
    AND PRO.estado = '1'
ORDER BY
    numlote DESC
LIMIT 10;    
END;

-- CALL spu_buscar_lote (7);

DROP PROCEDURE IF EXISTS spu_render_lote;

CREATE PROCEDURE spu_render_lote(
    IN _idlote INT
)
BEGIN
SELECT
    LOT.fecha_vencimiento,
    PRO.codigo,
    UME.unidadmedida,
    COALESCE(KAR.stockactual, 0) AS stockactual
FROM productos PRO
INNER JOIN lotes LOT ON LOT.idproducto = PRO.idproducto
INNER JOIN unidades_medidas UME ON UME.idunidadmedida = PRO.idunidadmedida
LEFT JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
    AND KAR.idkardex = (
        SELECT MAX(K2.idkardex)
        FROM kardex K2
        WHERE K2.idproducto = PRO.idproducto
        AND K2.idlote = LOT.idlote
    )
    WHERE
    PRO.idlote  = _idlote
    AND PRO.estado = '1'
ORDER BY
    numlote DESC
LIMIT 10;    
END;
-- select * from kardex WHERE idproducto = 7;
SELECT * FROM kardex;

SELECT * FROM lotes;
-- CALL spu_render_lote (7);
-- select * from lotes WHERE idproducto = 7;
select * from kardex 
WHERE idproducto = 7
order by idlote ASC;
select * from kardex;
-- DROP PROCEDURE IF EXISTS spu_render_lote;
DROP PROCEDURE IF EXISTS spu_render_lote;
CREATE PROCEDURE spu_render_lote(
    IN _idlote INT
)
BEGIN
SELECT
    LOT.idlote,
    LOT.numlote,
    LOT.fecha_vencimiento,
    PRO.codigo,
    UME.unidadmedida,
    COALESCE(LOT.stockactual, 0) AS stockactual,
    LOT.estado
FROM lotes LOT
INNER JOIN productos PRO ON PRO.idproducto = LOT.idproducto
INNER JOIN unidades_medidas UME ON UME.idunidadmedida = PRO.idunidadmedida
WHERE LOT.idproducto = _idlote
ORDER BY
    LOT.numlote DESC
LIMIT 10;    
END;
CALL spu_render_lote (7);
SELECT * FROM kardex WHERE idproducto = 7;
select * from lotes WHERE idproducto = 7;

SELECT * FROM productos;
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

-- LISTAR PRODUCTOS

CREATE PROCEDURE sp_listar_productos()
BEGIN
    SELECT 
        m.marca,
        c.categoria,
        p.nombreproducto,
        p.codigo
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