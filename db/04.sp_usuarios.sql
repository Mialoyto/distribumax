-- Active: 1732798376350@@127.0.0.1@3306@distribumax
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

DROP PROCEDURE IF EXISTS sp_estado_usuario;
CREATE PROCEDURE sp_estado_usuario(
    IN _idusuario INT,      -- Parámetro de entrada para el ID del usuario
    IN _estado CHAR(1)      -- Parámetro de entrada para el nuevo estado del usuario ('0' = Inactivo, '1' = Activo)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);  -- Variable para almacenar el mensaje de salida
    DECLARE v_estado INT;            -- Variable para almacenar el estado de la operación (1 = éxito, 0 = error)

    -- Verifica si el estado es '0' (Inactivo)
    IF _estado = '0' THEN
        UPDATE usuarios
        SET estado = _estado
        WHERE idusuario = _idusuario;
        
        -- Si la actualización fue exitosa, establece los valores de mensaje y estado
        SET v_estado = 1;
        SET v_mensaje = 'Usuario desactivado correctamente';

    -- Verifica si el estado es '1' (Activo)
    ELSEIF _estado = '1' THEN 
        UPDATE usuarios
        SET estado = _estado
        WHERE idusuario = _idusuario;
        
        -- Si la actualización fue exitosa, establece los valores de mensaje y estado
        SET v_estado = 1;
        SET v_mensaje = 'Usuario activado correctamente';

    -- Si el estado no es válido ('0' o '1')
    ELSE
        SET v_estado = 0;
        SET v_mensaje = 'El estado es incorrecto';
    END IF;

    -- Devuelve el estado y el mensaje de la operación
    SELECT v_estado AS estado, v_mensaje AS mensaje;
END;


CALL sp_estado_usuario(1,'0');
SELECT * FROM usuarios;

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


DROP PROCEDURE IF EXISTS spu_listar_usuarios;
CREATE PROCEDURE spu_listar_usuarios()
BEGIN
    SELECT 
        u.idusuario AS id,                         -- ID del usuario
        pf.perfil,                                  -- Perfil del usuario
        u.nombre_usuario,                           -- Nombre de usuario
        p.nombres,                                  -- Nombres de la persona
        p.appaterno,                                -- Apellido paterno de la persona
        p.apmaterno,                                -- Apellido materno de la persona
        CASE u.estado
            WHEN '1' THEN 'Activo'                 -- Si el estado es '1', mostrar 'Activo'
            WHEN '0' THEN 'Inactivo'               -- Si el estado es '0', mostrar 'Inactivo'
        END AS 'estado',                           -- Estado del usuario
        CASE u.estado
            WHEN '1' THEN '0'                     -- Si está activo, cambiar estado a inactivo ('0')
            WHEN '0' THEN '1'                     -- Si está inactivo, cambiar estado a activo ('1')
        END AS 'status'                            -- Valor para cambiar el estado
    FROM 
        usuarios u                                 -- Tabla de usuarios
    INNER JOIN 
        personas p ON u.idpersona = p.idpersonanrodoc    -- Unir con la tabla personas (para obtener los nombres y apellidos)
    INNER JOIN 
        perfiles pf ON u.idperfil = pf.idperfil;           -- Unir con la tabla perfiles (para obtener el perfil del usuario)
END;


CALL spu_listar_usuarios;


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