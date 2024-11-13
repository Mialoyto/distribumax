-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;
-- Registrar 

CREATE PROCEDURE sp_registrar_usuario(
   IN   _idpersona          VARCHAR(11),
   IN   _idperfil           INT,
   IN   _nombre_usuario     VARCHAR(100),
   IN   _password_usuario   VARCHAR(150)  
)
BEGIN
	INSERT INTO usuarios 
    (idpersona, idperfil, nombre_usuario, password_usuario) 
    VALUES (_idpersona, _idperfil, _nombre_usuario, _password_usuario);
    
    SELECT LAST_INSERT_ID() AS idusuario;
END;

select * FROM usuarios;

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

select * FROM usuarios;
select * FROM perfiles;
-- Actualizar 
CALL sp_usuario_login('administrador');

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

CALL spu_listar_usuarios();