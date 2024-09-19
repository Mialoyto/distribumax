USE distribumax;
-- Registrar 
DELIMITER $$
CREATE PROCEDURE sp_registrar_usuario(
   IN   _idpersona			VARCHAR(11),
   IN 	_idrol				INT,
   IN   _nombre_usuario		VARCHAR(100),
   IN   _password_usuario	VARCHAR(150)	
)
BEGIN
	INSERT INTO usuarios 
    (idpersona, idrol, nombre_usuario, password_usuario) 
    VALUES (_idpersona, _idrol, _nombre_usuario, _password_usuario);
    SELECT LAST_INSERT_ID() AS idusuario;
END$$

-- Login 
DELIMITER $$
CREATE PROCEDURE sp_usuario_login(IN _nombre_usuario	VARCHAR(100))
BEGIN
SELECT
	USU.idusuario,
    PER.appaterno,
    PER.apmaterno,
    PER.nombres,
    ROL.rol,
    USU.nombre_usuario,
    USU.password_usuario
    FROM usuarios USU
	INNER JOIN personas PER ON USU.idpersona = PER.idpersonanrodoc
    INNER JOIN roles ROL	ON USU.idrol = ROL.idrol
    WHERE USU.nombre_usuario = _nombre_usuario AND USU.estado=1;
END$$

-- Actualizar 
DELIMITER $$
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
END$$

-- Eliminar
DELIMITER $$
CREATE PROCEDURE sp_desactivar_usuario(
	IN  _estado	CHAR(1),
    IN 	_nombre_usuario VARCHAR(100)
    )
BEGIN
	UPDATE usuarios
		SET
			estado = _estado
		WHERE _nombre_usuario = nombre_usuario;
END$$

DELIMITER $$
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
END $$