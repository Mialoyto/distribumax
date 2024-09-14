USE distribumax;

-- REGISTRAR TIPO DE PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_tipo_promocion_registrar(
    IN _tipopromocion       VARCHAR(150),
    IN _descripcion         VARCHAR(250),
    IN _estado              BIT
)
BEGIN
    INSERT INTO tipos_promociones (tipopromocion, descripcion, estado) 
    VALUES (_tipopromocion, _descripcion, _estado);
END$$

-- ACTUALIZAR TIPO DE PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_promocion(
	IN _idtipopromocion INT,
    IN _tipopromocion   VARCHAR(150),
    IN _descripcion     VARCHAR(250),
 	IN _estado			BIT
)
BEGIN
	UPDATE tipos_promociones
		SET
			idtipopromocion =_idtipopromocion,
            tipopromocion = _tipopromocion,
			descripcion =_descripcion,
            estado = _estado,
			update_at=now()
        WHERE idtipopromocion =_idtipopromocion;
END$$

-- DESACTIVAR TIPO DE PROMOCIONES
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_estado_tipo_promocion;
CREATE PROCEDURE sp_estado_tipo_promocion(
IN  _estado BIT,
IN  _idtipopromocion INT 
)
BEGIN
	UPDATE tipos_promociones SET
      estado=_estado
      WHERE idtipopromocion =_idtipopromocion;
END$$