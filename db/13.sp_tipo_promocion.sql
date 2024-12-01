/* -- Active: 1726698325558@@127.0.0.1@3306@distribumax
USE distribumax;
-- ! ELIMINAR ESTE ARCHIVO NO SE REQUIERE PARA EL PROYECTO
-- REGISTRAR TIPO DE PROMOCIONES

DROP PROCEDURE IF EXISTS sp_tipo_promocion_registrar;

CREATE PROCEDURE sp_tipo_promocion_registrar(
    IN _tipopromocion       VARCHAR(150),
    IN _descripcion         VARCHAR(250)
)
BEGIN
    DECLARE v_tipoProm VARCHAR(150);
    DECLARE v_mensaje VARCHAR(150);
    DECLARE v_id   INT;

    SELECT tipopromocion INTO v_tipoProm
    FROM tipos_promociones
    WHERE tipopromocion = _tipopromocion;

    IF v_tipoProm= _tipopromocion THEN
        SET v_id = -1;
        SET v_mensaje = CONCAT("El tipo de promoción ",UPPER(_tipopromocion)," ya se encuentra registrada");
    ELSE
        INSERT INTO tipos_promociones (tipopromocion, descripcion) 
        VALUES (_tipopromocion, _descripcion);
        SET v_id = LAST_INSERT_ID();
        SET v_mensaje = CONCAT("Registro exitoso");
    END IF;

    SELECT v_id AS id, v_mensaje AS mensaje;
END;

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
END;

-- DESACTIVAR TIPO DE PROMOCIONES
CREATE PROCEDURE sp_estado_tipo_promocion(
IN  _estado CHAR(1),
IN  _idtipopromocion INT 
)
BEGIN
	UPDATE tipos_promociones SET
      estado=_estado
      WHERE idtipopromocion =_idtipopromocion;
END;

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
END ; */