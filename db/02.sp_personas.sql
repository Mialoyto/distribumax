-- Active: 1732798376350@@127.0.0.1@3306@distribumax
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
        SELECT _idpersonanrodoc AS idpersona;
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

DROP PROCEDURE IF EXISTS sp_estado_persona;
CREATE PROCEDURE sp_estado_persona(
    IN  _idpersonanrodoc  CHAR(11),
    IN  _estado            CHAR(1) 
    )
BEGIN
    DECLARE v_mensaje VARCHAR(100);   -- Mensaje de resultado
    DECLARE v_estado INT;             -- Estado de la operación

    -- Verificar si el estado es '0' (Inactivo)
    IF _estado = '0' THEN
        UPDATE personas
        SET estado = _estado  -- Actualizar el estado a '0'
        WHERE idpersonanrodoc = _idpersonanrodoc;
        SET v_estado = 1;              -- Operación exitosa
        SET v_mensaje = "Persona desactivada correctamente";  -- Mensaje de éxito

    -- Verificar si el estado es '1' (Activo)
    ELSEIF _estado = '1' THEN
        UPDATE personas
        SET estado = _estado  -- Actualizar el estado a '1'
        WHERE idpersonanrodoc = _idpersonanrodoc;
        SET v_estado = 1;              -- Operación exitosa
        SET v_mensaje = 'Persona activada correctamente';  -- Mensaje de éxito

    -- Si el estado es incorrecto
    ELSE
        SET v_estado = 0;              -- Operación fallida
        SET v_mensaje = 'El estado es incorrecto';  -- Mensaje de error
    END IF;

    -- Seleccionar el resultado
    SELECT v_estado AS estado, v_mensaje AS mensaje;
END;

CALL sp_estado_persona('26558000','0');
SELECT * FROM personas;

-- BUSCAR PERSONA POR DOCUMENTO ✔️
DROP PROCEDURE IF EXISTS sp_buscarpersonadoc;
CREATE PROCEDURE sp_buscarpersonadoc(
    IN _idtipodocumento INT,
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
            PER.idpersonanrodoc,
            USU.idusuario,
            PER.estado
        FROM personas PER
        INNER JOIN distritos DIST ON PER.iddistrito = DIST.iddistrito
        INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
        LEFT JOIN usuarios USU ON USU.idpersona = PER.idpersonanrodoc
        WHERE PER.idtipodocumento = _idtipodocumento
        AND PER.idpersonanrodoc = _idpersonanrodoc 
        AND PER.estado = '1';
END;

-- Buscar persona que ya esta o no como cliente
CREATE PROCEDURE sp_buscar_persona_cliente(
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

-- LISTAR PERSONAS ✔️
DROP PROCEDURE IF EXISTS sp_listar_personas;
CREATE PROCEDURE sp_listar_personas()
BEGIN
    SELECT 
        td.documento AS tipo_documento,  -- Nombre del tipo de documento
        p.idpersonanrodoc AS id,         -- ID de la persona
        p.nombres,                        -- Nombres de la persona
        p.appaterno,                      -- Apellido paterno
        p.apmaterno,                      -- Apellido materno
        d.distrito,                       -- Distrito
        CASE p.estado                      -- Estado de la persona (Activo/Inactivo)
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS 'estado',
        CASE p.estado                      -- Cambiar el estado (Activo a Inactivo y viceversa)
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS 'status'
    FROM personas p
    INNER JOIN tipo_documento td ON p.idtipodocumento = td.idtipodocumento
    INNER JOIN distritos d ON p.iddistrito = d.iddistrito 
    ORDER BY p.create_at DESC;  -- Ordenar por fecha de creación en orden descendente
END;

call sp_listar_personas();
