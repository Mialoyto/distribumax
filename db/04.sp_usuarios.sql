-- Active: 1732637704938@@127.0.0.1@3306@distribumax
USE distribumax;
-- Registrar

CREATE PROCEDURE sp_registrar_usuario(
   IN   _idpersona          VARCHAR(11),
   IN   _idperfil           INT,
   IN   _perfil             CHAR(3),
   IN   _nombre_usuario     VARCHAR(100),
   IN   _password_usuario   VARCHAR(150)  
)
BEGIN
	INSERT INTO usuarios 
    (idpersona, idperfil, perfil, nombre_usuario, password_usuario) 
    VALUES (_idpersona, _idperfil,_perfil, _nombre_usuario, _password_usuario);
    
    SELECT LAST_INSERT_ID() AS idusuario;
END;


-- Login
DROP PROCEDURE IF EXISTS sp_usuario_login;

CREATE PROCEDURE sp_usuario_login(IN _nombre_usuario	VARCHAR(100))
BEGIN
SELECT
	USU.idusuario,
    USU.idpersona AS dni,
    PER.appaterno,
    PER.apmaterno,
    PER.nombres,
    USU.nombre_usuario,
    USU.password_usuario,
    PERF.perfil,
    USU.idperfil
    FROM usuarios USU
	INNER JOIN personas PER ON USU.idpersona = PER.idpersonanrodoc
    INNER JOIN perfiles PERF	ON USU. idperfil = PERF. idperfil
    WHERE USU.nombre_usuario = _nombre_usuario AND USU.estado=1;
END;

SELECT * FROM usuarios;

SELECT * FROM perfiles;
-- Actualizar
CALL sp_usuario_login ('administrador');

CREATE PROCEDURE sp_actualizar_usuario(

   IN     _nombre_usuario		VARCHAR(100),
   IN     _password_usuario		VARCHAR(150),
   IN     _idusuario            INT 
)
BEGIN
	UPDATE usuarios
		SET
            nombre_usuario = _nombre_usuario,
            password_usuario = _password_usuario,
            update_at = NOW()
		WHERE idusuario = _idusuario;
END;

-- Eliminar

CREATE PROCEDURE sp_desactivar_usuario(
	IN  _estado	CHAR(1),
    IN 	_nombre_usuario VARCHAR(100)
    )
BEGIN
	UPDATE usuarios
		SET
			estado = _estado
		WHERE _nombre_usuario = nombre_usuario;
END;

CREATE PROCEDURE sp_buscarusuarios_registrados(
IN _idtipodocumento INT ,
IN _idpersonanrodoc CHAR(11)
)
BEGIN
	SELECT 
        PER.idpersonanrodoc AS id,
        USU.idusuario AS iduser,
        USU.estado AS estado
        FROM personas PER
        INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
        LEFT JOIN usuarios USU ON USU.idpersona = PER.idpersonanrodoc
		WHERE PER.idtipodocumento = _idtipodocumento
        AND PER.idpersonanrodoc = _idpersonanrodoc;
END;

CREATE PROCEDURE spu_listar_usuarios()
BEGIN
    SELECT 
        p.idpersonanrodoc,
        pf.perfil,
        u.nombre_usuario,
        CASE u.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS 'Estado'
    FROM 
        usuarios u
    INNER JOIN 
        personas p ON u.idpersona = p.idpersonanrodoc
    INNER JOIN 
        perfiles pf ON u. idperfil = pf. idperfil;
END;

DROP PROCEDURE IF EXISTS sp_actualizar_contraseña;

CREATE PROCEDURE sp_actualizar_contraseña(
    IN _idusuario INT,
    IN _password_usuario VARCHAR(150)
)
BEGIN
    -- Declarar variables
    DECLARE _contraseña_actual VARCHAR(150);
    DECLARE _confirmar_password VARCHAR(150);
    
    -- Asignar la contraseña confirmada (esto puede venir de PHP o del frontend)
    -- Si la confirmación de la contraseña es el mismo valor que la nueva contraseña,
    -- puedes hacer esta asignación directamente en PHP o dentro del procedimiento
    SET _confirmar_password = _password_usuario;

    -- Validar si las contraseñas coinciden
    IF _password_usuario != _confirmar_password THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Las contraseñas no coinciden.';
    ELSE
        -- Obtener la contraseña actual del usuario
        SELECT password_usuario 
        INTO _contraseña_actual
        FROM usuarios
        WHERE idusuario = _idusuario;

        -- Verificar si la contraseña actual existe
        IF _contraseña_actual IS NOT NULL THEN
            -- Actualizar la contraseña del usuario
            UPDATE usuarios 
            SET password_usuario = _password_usuario,
                update_at =now()
            WHERE idusuario = _idusuario;
        ELSE
            -- Si el usuario no existe, manejar el caso con un mensaje
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Usuario no encontrado.';
        END IF;
    END IF;
END;