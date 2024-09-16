USE distribuMax;

-- REGISTRAR  ✔️ 
DELIMITER $$
CREATE PROCEDURE spu_registrar_personas(
	IN  _idtipodocumento	INT,
    IN 	_idpersonanrodoc	CHAR(11),
    IN 	_iddistrito			INT,	
	IN  _nombres			VARCHAR(250),
	IN  _apellidoP			VARCHAR(250),
    IN  _apellidoM			VARCHAR(250),
    IN  _telefono			CHAR(9),
    IN  _direccion			VARCHAR(250)	
)
BEGIN
	INSERT INTO personas 
		(idtipodocumento,idpersonanrodoc,iddistrito,nombres,appaterno,apmaterno,telefono,direccion)
	VALUES(
		_idtipodocumento,
        _idpersonanrodoc,
        _iddistrito,
        _nombres,
        _apellidoP,
        _apellidoM,
        IF(_telefono = '' OR _telefono IS NULL, NULL, _telefono),
        _direccion
        );
        SELECT _idpersonanrodoc AS id;
END$$

-- ACTUALIZAR  ✔️ 
DELIMITER $$
CREATE PROCEDURE sp_actualizar_persona(
    IN  _idtipodocumento	INT,
    IN 	_iddistrito			INT,	
	IN  _nombres			VARCHAR(250),
	IN  _apellidoP			VARCHAR(250),
    IN  _apellidoM			VARCHAR(250),
    IN  _telefono			CHAR(9),
    IN  _direccion			VARCHAR(250),
    IN 	_idpersonanrodoc	CHAR(11)
)
BEGIN
	UPDATE personas
		SET
			idtipodocumento = _idtipodocumento,
			iddistrito = _iddistrito,
			nombres = _nombres,
			appaterno = _apellidoP,
			apmaterno = _apellidoM,
			telefono = IF(_telefono = '' OR _telefono IS NULL, NULL, _telefono),
			direccion = _direccion,
			update_at = NOW()
		WHERE idpersonanrodoc = _idpersonanrodoc;
END$$

-- ELIMINAR PERSONA ✔️
DELIMITER $$
CREATE PROCEDURE sp_desactivar_persona(
	IN  _estado				CHAR(1),
    IN 	_idpersonanrodoc 	CHAR(11)
)
BEGIN
	UPDATE personas
		SET
			estado = _estado
		WHERE idpersonanrodoc = _idpersonanrodoc;
        
        select row_count() as filas_afectadas;
END $$

-- BUSCAR PERSONA POR DOCUMENTO ✔️
DELIMITER $$
CREATE PROCEDURE sp_buscarpersonadoc(
IN _idtipodocumento INT ,
IN _idpersonanrodoc CHAR(11)
)
BEGIN
	SELECT 
		DIST.iddistrito,
		DIST.distrito,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        PER.telefono,
        PER.direccion,
        PER.idpersonanrodoc
        FROM personas PER
        INNER JOIN distritos DIST ON PER.iddistrito = DIST.iddistrito
        INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
		WHERE PER.idtipodocumento = _idtipodocumento
        AND PER.idpersonanrodoc = _idpersonanrodoc;
END $$