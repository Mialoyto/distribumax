USE distribumax;
-- REGISTRAR EMPRESAS 

CREATE PROCEDURE sp_empresa_registrar(
	IN _idempresaruc 	BIGINT,
    IN _iddistrito 		INT,
    IN _razonsocial 	VARCHAR(100),
    IN _direccion 		VARCHAR(100),
    IN _email 			VARCHAR(100),
    IN _telefono 		CHAR(9)
)
BEGIN
    INSERT INTO empresas 
    (idempresaruc, iddistrito, razonsocial, direccion, email, telefono) 
    VALUES 
    (_idempresaruc, _iddistrito, _razonsocial, _direccion, _email, _telefono);
    SELECT _idempresaruc AS idempresas;
END;


-- ACTUALIZAR EMPRESAS

CREATE PROCEDURE sp_actualizar_empresa(
    IN _iddistrito       INT,
    IN _razonsocial      VARCHAR(100),
    IN _direccion        VARCHAR(100),
    IN _email            VARCHAR(100),
    IN _telefono         CHAR(9),
    IN _idempresaruc     BIGINT
)
BEGIN
    UPDATE empresas
    SET 
        iddistrito = _iddistrito,
        razonsocial = _razonsocial,
        direccion = _direccion,
        email = _email,
        telefono = _telefono,
        update_at = NOW()
    WHERE idempresaruc = _idempresaruc;
END;


-- Eliminar

CREATE PROCEDURE sp_estado_empresa(
	IN  _estado 		CHAR(1),
	IN  _idempresaruc 	BIGINT 
)
BEGIN
	UPDATE empresas SET
      estado=_estado
      WHERE idempresaruc=_idempresaruc;
END;
-- buscar empresa 
drop procedure if exists sp_buscar_empresa;
CREATE PROCEDURE sp_buscar_empresa(
    IN _ruc BIGINT
)
BEGIN
    DECLARE _empresa_count INT DEFAULT 0;

        -- Si existe, devolver los detalles
        SELECT 
			'Empresa' AS tipo_cliente,
            DIST.iddistrito,
            DIST.distrito,
            EMP.idempresaruc,
            EMP.razonsocial,
            EMP.email,
            EMP.telefono,
            EMP.direccion,
            EMP.estado,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM clientes CLI 
                    WHERE CLI.idempresa = EMP.idempresaruc
                ) THEN 'Registrado'
                ELSE 'No registrado'
            END AS estado
        FROM empresas EMP
        INNER JOIN distritos DIST ON EMP.iddistrito = DIST.iddistrito
        WHERE EMP.idempresaruc = _ruc
        AND EMP.estado = '1';
END;


CREATE PROCEDURE sp_listar_empresas()
BEGIN
    SELECT 
    razonsocial,
    direccion,
    email,
    telefono
    FROM empresas;
END;