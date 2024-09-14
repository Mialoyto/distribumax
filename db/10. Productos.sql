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
    (idmarca,idsubcategoria,nombreproducto,descripcion,codigo,preciounitario) 
    VALUES
    (_idmarca,_idsubcategoria,_nombreproducto,_descripcion,_codigo,_preciounitario);
END$$

-- ACTUALIZA PRODUCTOS
DELIMITER $$
CREATE PROCEDURE sp_actualziar_producto(
IN _idmarca         INT,
IN _idsubcategoria  INT,
IN _nombreproducto  VARCHAR(250),
IN _descripcion     VARCHAR(250),
IN _codigo          CHAR(30),
IN _preciounitario  DECIMAL(8, 2),
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
			preciounitario=_preciounitario,
			update_at=now()
        WHERE idproducto=_idproducto;
END$$

-- ESTADO producto
DELIMITER $$
CREATE PROCEDURE sp_estado_producto(
IN  _estado 	CHAR(1),
IN  _idproducto INT 
)
BEGIN
	UPDATE productos SET
      estado=_estado
      WHERE idproducto=_idproducto;
END$$