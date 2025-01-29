-- Active: 1732807506399@@127.0.0.1@3306@distribumax
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


DROP PROCEDURE IF EXISTS sp_actualizar_persona;
CREATE PROCEDURE sp_actualizar_persona(
    IN _idpersonanrodoc CHAR(11),
    IN _idtipodocumento INT,
    IN _nombres VARCHAR(80),
    IN _appaterno VARCHAR(80),
    IN _apmaterno VARCHAR(80),
    IN _telefono CHAR(9),
    IN _direccion VARCHAR(250),
    IN _distrito VARCHAR(250) -- Nombre del distrito
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);        -- Mensaje de resultado
    DECLARE v_telefono CHAR(9);            -- Teléfono de la persona
    DECLARE v_estado INT;                  -- Estado de la operación
    DECLARE v_iddistrito INT;              -- ID del distrito

    -- Buscar el ID del distrito por nombre
    SELECT iddistrito INTO v_iddistrito
    FROM distritos
    WHERE distrito = _distrito
    LIMIT 1;

    -- Si no se encuentra el distrito, mostrar mensaje de error
    IF v_iddistrito IS NULL THEN
        SET v_mensaje = 'Distrito no encontrado';
        SET v_estado = 0;
    ELSE
        -- Verificar si el teléfono ya está registrado
        SELECT telefono INTO v_telefono
        FROM personas
        WHERE telefono = _telefono AND idpersonanrodoc != _idpersonanrodoc;

        IF v_telefono = _telefono THEN
            -- Si el teléfono ya existe, enviamos un mensaje de error
            SET v_mensaje = 'El teléfono ya está registrado';
            SET v_estado = 0;
        ELSE
            -- Si todo es correcto, actualizar los datos de la persona
            UPDATE personas
            SET 
                nombres = UPPER(_nombres),
                appaterno = UPPER(_appaterno),
                apmaterno = UPPER(_apmaterno),
                telefono = _telefono,          -- No convertir teléfono a mayúsculas
                direccion = UPPER(_direccion),
                iddistrito = v_iddistrito,     -- Actualizar el ID del distrito
                update_at = NOW()
            WHERE idpersonanrodoc = _idpersonanrodoc;

            SET v_mensaje = 'Datos de la persona actualizados correctamente';
            SET v_estado = 1;
        END IF;
    END IF;

    -- Devolver el mensaje y el ID de la persona actualizada
    SELECT v_mensaje AS mensaje, _idpersonanrodoc AS idpersonanrodoc, v_estado AS estado;
END;


-- OBTENER PERSONA PARA EDITAR EN EL MODAL
DROP PROCEDURE IF EXISTS sp_getPersona;

CREATE PROCEDURE sp_getPersona(
    IN _idpersonanrodoc CHAR(11)
)
BEGIN
    SELECT
        PER.idpersonanrodoc,
        PER.idtipodocumento,
        TDOC.documento,                  -- Agregado el campo 'documento' de la tabla 'tipo_documento'
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        PER.telefono,
        PER.direccion,
        DIST.iddistrito,
        DIST.distrito
    FROM personas PER
    INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
    INNER JOIN distritos DIST ON PER.iddistrito = DIST.iddistrito
    WHERE PER.idpersonanrodoc = _idpersonanrodoc;
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
        p.idpersonanrodoc AS id,         -- ID de la persona
        p.nombres,                        -- Nombres de la persona
        p.appaterno,                      -- Apellido paterno
        p.apmaterno,                      -- Apellido materno
        p.telefono,                       -- Teléfono de la persona
        p.direccion,
        d.distrito,                       -- Dirección de la persona
        CASE p.estado                      -- Estado de la persona (Activo/Inactivo)
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
            ELSE 'Desconocido'           -- Valor por defecto si el estado no es '0' o '1'
        END AS estado,
        CASE p.estado                      -- Cambiar el estado (Activo a Inactivo y viceversa)
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
            ELSE p.estado                  -- Mantener el estado si no es '0' o '1'
        END AS status
    FROM personas p
    INNER JOIN distritos d ON p.iddistrito = d.iddistrito;
END;


