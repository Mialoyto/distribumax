USE distribumax;

-- REGISTRAR TIPO DE PROMOCIONES
DROP PROCEDURE IF EXISTS sp_tipo_promocion_registrar;
DELIMITER $$
CREATE PROCEDURE sp_tipo_promocion_registrar(
    IN _tipopromocion       VARCHAR(150),
    IN _descripcion         VARCHAR(250)
)
BEGIN
    INSERT INTO tipos_promociones (tipopromocion, descripcion) 
    VALUES (_tipopromocion, _descripcion);

    SELECT LAST_INSERT_ID() as "id";
END$$

select * from tipos_promociones;
-- ACTUALIZAR TIPO DE PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_promocion(
	IN _idtipopromocion INT,
    IN _tipopromocion   VARCHAR(150),
    IN _descripcion     VARCHAR(250),
 	IN _estado			CHAR(1)
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
IN  _estado CHAR(1),
IN  _idtipopromocion INT 
)
BEGIN
	UPDATE tipos_promociones SET
      estado=_estado
      WHERE idtipopromocion =_idtipopromocion;
END$$

DELIMITER $$
CREATE PROCEDURE sp_listar_tipo_promociones()
BEGIN
    SELECT 
        tipopromocion,
        descripcion,
        create_at,
        update_at,
        CASE 
            WHEN estado = '1' THEN 'Activo'
            WHEN estado = '0' THEN 'Inactivo'
        END AS estado
    FROM 
        tipos_promociones
    ORDER BY 
        create_at DESC;
END $$
CALL sp_listar_tipo_promociones();

