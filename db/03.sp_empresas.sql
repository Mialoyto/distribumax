-- Active: 1732798376350@@127.0.0.1@3306@distribumax
USE distribumax;
-- REGISTRAR EMPRESAS

CREATE PROCEDURE sp_empresa_registrar(
    IN _idtipodoc       INT,
	IN _idempresaruc 	BIGINT,
    IN _iddistrito 		INT,
    IN _razonsocial 	VARCHAR(100),
    IN _direccion 		VARCHAR(100),
    IN _email 			VARCHAR(100),
    IN _telefono 		CHAR(9)
)
BEGIN
    INSERT INTO empresas 
    (idtipodocumento,idempresaruc, iddistrito, razonsocial, direccion, email, telefono) 
    VALUES 
    (_idtipodoc,_idempresaruc, _iddistrito, _razonsocial, _direccion, _email, _telefono);
    SELECT _idempresaruc AS idempresa;
END;

-- ACTUALIZAR EMPRESAS
DROP PROCEDURE IF EXISTS sp_actualizar_empresa;
CREATE PROCEDURE sp_actualizar_empresa(
    IN _idempresaruc     BIGINT,
    IN _razonsocial      VARCHAR(100),
    IN _direccion        VARCHAR(100),
    IN _email            VARCHAR(100),
    IN _telefono         CHAR(9)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;
    DECLARE v_razonsocial VARCHAR(100);

    -- VERIFICAR SI LA EMPRESA CON EL MISMO NOMBRE YA EXISTE
    SELECT razonsocial INTO v_razonsocial
    FROM empresas
    WHERE razonsocial = _razonsocial AND idempresaruc != _idempresaruc;

    -- Si la empresa ya existe, enviamos un mensaje de error
    IF v_razonsocial IS NOT NULL THEN
        SET v_mensaje = 'La empresa ya existe';
        SET v_estado = 0;
    ELSE
        -- Si no existe, actualizamos los datos de la empresa
        UPDATE empresas
        SET
            razonsocial = _razonsocial,
            direccion = _direccion,
            email = _email,
            telefono = _telefono,
            update_at = NOW()  -- Actualizamos la fecha y hora de la última actualización
        WHERE idempresaruc = _idempresaruc;

        SET v_mensaje = 'Empresa actualizada correctamente';
        SET v_estado = 1;
    END IF;

    -- RETORNAMOS EL MENSAJE Y ESTADO
    SELECT v_mensaje AS mensaje, _idempresaruc AS idempresaruc, v_estado AS estado;  
END;



SELECT * FROM empresas;
CALL sp_actualizar_empresa(20100085063,'JRC','Av. San Ignacio #247','jrc@gmail.com','983923290');


DROP PROCEDURE IF EXISTS sp_getEmpresasEdit;
CREATE PROCEDURE sp_getEmpresasEdit
(IN         _idempresaruc   BIGINT)
BEGIN
SELECT
        EMP.idempresaruc,
        EMP.razonsocial,
        EMP.direccion,
        EMP.email,
        EMP.telefono
FROM empresas EMP
WHERE EMP.idempresaruc = _idempresaruc;
END;

-- Eliminar
DROP PROCEDURE IF EXISTS sp_estado_empresa;
CREATE PROCEDURE sp_estado_empresa
(
    IN  _idempresaruc 	BIGINT,
	IN  _estado 		CHAR(1)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;

    IF _estado = '0' THEN
    UPDATE empresas
    SET estado = _estado
    WHERE idempresaruc = _idempresaruc;
    SET v_estado = 1;
    SET v_mensaje = "Empresa desactivada correctamente";
    ELSEIF _estado = '1' THEN 
        UPDATE empresas
        SET estado = _estado
        WHERE idempresaruc = _idempresaruc;
        SET v_estado = 1;
        SET v_mensaje = 'Empresa activada correctamente';
    ELSE
        SET v_estado = 0;
        SET v_mensaje = 'El estado es incorrecto';
    END IF;

    SELECT v_estado AS estado, v_mensaje AS mensaje;
END;

CALL sp_estado_empresa(20508891149,'1');
select * from empresas;

DROP PROCEDURE IF EXISTS sp_buscar_empresa;

CREATE PROCEDURE sp_buscar_empresa(
    IN _ruc BIGINT
)
BEGIN
        -- Si existe, devolver los detalles
        SELECT 
            EMP.idtipodocumento,
			'Empresa' AS tipo_cliente,
            DIST.iddistrito,
            DIST.distrito,
            EMP.idempresaruc,
            EMP.razonsocial,
            EMP.email,
            EMP.telefono,
            EMP.direccion,
            EMP.estado
        FROM empresas EMP
        INNER JOIN distritos DIST ON EMP.iddistrito = DIST.iddistrito
        WHERE EMP.idempresaruc = _ruc
        AND EMP.estado = '1';
END;

DROP PROCEDURE IF EXISTS sp_listar_empresas;
CREATE PROCEDURE sp_listar_empresas()
BEGIN
    SELECT
    EMP.idempresaruc AS id, 
    EMP.razonsocial,
    EMP.direccion,
    EMP.email,
    EMP.telefono,
    CASE EMP.estado
        WHEN '1' THEN 'Activo'
        WHEN '0' THEN 'Inactivo'
    END AS 'estado',
    CASE EMP.estado
        WHEN '1' THEN '0'
        WHEN '0' THEN '1'
    END AS 'status'
    FROM empresas EMP
    ORDER BY EMP.razonsocial ASC;
END;

CALL sp_listar_empresas();