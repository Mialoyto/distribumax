-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;
-- REGISTRAR  ✔️ 
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
END ;

-- ACTUALIZAR  ✔️ 

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
END;


-- ELIMINAR PERSONA ✔️

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
END;


-- BUSCAR PERSONA POR DOCUMENTO ✔️

CREATE PROCEDURE sp_buscarpersonadoc(
    IN _idtipodocumento INT,
    IN _idpersonanrodoc CHAR(11)
)
BEGIN
    DECLARE _persona_count INT DEFAULT 0;

    -- Verificar si la persona existe
    SELECT COUNT(*)
    INTO _persona_count
    FROM personas PER
    WHERE PER.idpersonanrodoc = _idpersonanrodoc
    AND PER.idtipodocumento = _idtipodocumento
    AND PER.estado = '1';

    -- Si no existe la persona, devolver 'No data'
    IF _persona_count = 0 THEN
        SELECT 'No data' AS estado;

    -- Si existe, devolver los detalles
    ELSE
        SELECT 
            DIST.iddistrito,
            DIST.distrito,
            PER.nombres,
            PER.appaterno,
            PER.apmaterno,
            PER.telefono,
            PER.direccion,
            PER.idpersonanrodoc,
            USU.idusuario,
            PER.estado,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM clientes CLI 
                    WHERE CLI.idpersona = PER.idpersonanrodoc
                ) THEN 'Registrado'
                ELSE 'No registrado'
            END AS estado
        FROM personas PER
        INNER JOIN distritos DIST ON PER.iddistrito = DIST.iddistrito
        INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
        LEFT JOIN usuarios USU ON USU.idpersona = PER.idpersonanrodoc
        WHERE PER.idtipodocumento = _idtipodocumento
        AND PER.idpersonanrodoc = _idpersonanrodoc 
        AND PER.estado = '1';
    END IF;
END;


CREATE PROCEDURE sp_listar_personas()
BEGIN
    SELECT 
        td.documento AS tipo_documento,
        p.idpersonanrodoc AS nro_documento,
        p.nombres,
        p.appaterno,
        p.apmaterno,
        d.distrito,
        p.estado
    FROM personas p
    INNER JOIN tipo_documento td ON p.idtipodocumento = td.idtipodocumento
    INNER JOIN distritos d ON p.iddistrito = d.iddistrito;
END;