-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;
-- REGISTRAR PRODUCTOS
DELIMITER $$
CREATE PROCEDURE sp_registrar_producto(
IN _idmarca         INT,
IN _idsubcategoria  INT,
IN _nombreproducto  VARCHAR(250),
IN _descripcion     VARCHAR(250),
IN _codigo          CHAR(30),
IN _preciounitario  DECIMAL(8, 2)	
)BEGIN
	INSERT INTO productos 
    (idmarca,idsubcategoria,nombreproducto,descripcion,codigo) 
    VALUES
    (_idmarca,_idsubcategoria,_nombreproducto,_descripcion,_codigo);
END$$

-- ACTUALIZA PRODUCTOS
DELIMITER $$
CREATE PROCEDURE sp_actualziar_producto(
IN _idmarca         INT,
IN _idsubcategoria  INT,
IN _nombreproducto  VARCHAR(250),
IN _descripcion     VARCHAR(250),
IN _codigo          CHAR(30),
IN _idproducto		INT
)
BEGIN
	UPDATE productos
		SET 
			idmarca=_idmarca,
			idsubcategoria=_idsubcategoria,
			nombreproducto=_nombreproducto,
			descripcion=_descripcion,
			codigo=_codigo,
			update_at=now()
        WHERE idproducto=_idproducto;
END$$

-- ESTADO producto
DELIMITER $$
CREATE PROCEDURE sp_estado_producto(
IN  _estado 		CHAR(1),
IN  _idproducto INT 
)
BEGIN
	UPDATE productos SET
      estado=_estado
      WHERE idproducto=_idproducto;
END$$

-- PRUEBA DE BUSQUEDA
DROP PROCEDURE IF EXISTS sp_buscar_productos;
DELIMITER $$
CREATE PROCEDURE sp_buscar_productos(
    IN _item VARCHAR(250)
)
BEGIN
    SELECT 
        PRO.idproducto,
        PRO.nombreproducto,
        PRO.codigo,
        UME.unidadmedida,
        COALESCE(KAR.stockactual, 0) AS stockactual
    FROM productos PRO
        LEFT JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
            AND KAR.idkardex = (SELECT MAX(K2.idkardex) 
            FROM kardex K2 WHERE K2.idproducto = PRO.idproducto) 
        INNER JOIN detalle_productos DET ON DET.idproducto = PRO.idproducto
        INNER JOIN unidades_medidas UME ON UME.idunidadmedida = DET.idunidadmedida
    WHERE (codigo LIKE CONCAT ('%',_item, '%') OR nombreproducto LIKE CONCAT('%', _item, '%')) 
    AND PRO.estado = '1'
        ORDER BY PRO.idproducto ASC ;
END $$