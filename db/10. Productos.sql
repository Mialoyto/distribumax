-- Active: 1728058749643@@127.0.0.1@3306@distribumax
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

-- BUSCAR PRODUCTOS
DROP PROCEDURE IF EXISTS sp_buscar_productos;
DELIMITER $$
CREATE PROCEDURE sp_buscar_productos(
   IN _item VARCHAR(250)
)
BEGIN
    SELECT 
        PRO.idproducto,
        PRO.codigo,
        PRO.nombreproducto,
        kAR.stockactual,
        UME.unidadmedida
    FROM  productos PRO
    INNER JOIN detalle_productos DTP ON PRO.idproducto = DTP.idproducto
    INNER JOIN unidades_medidas UME ON DTP.idunidadmedida = UME.idunidadmedida
    INNER JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
        AND KAR.idkardex = (SELECT MAX(K2.idkardex) FROM kardex K2 WHERE K2.idproducto = PRO.idproducto)
    WHERE (codigo LIKE CONCAT ('%',_item, '%') OR nombreproducto LIKE CONCAT('%', _item, '%')) 
    AND PRO.estado = '1' 
    AND KAR.stockactual > 0;
END$$

CALL sp_buscar_productos('a');
