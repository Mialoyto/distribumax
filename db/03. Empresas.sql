USE distribumax;
-- REGISTRAR EMPRESAS
DROP PROCEDURE IF EXISTS sp_empresa_registrar;
DELIMITER $$
CREATE PROCEDURE sp_empresa_registrar(
    IN _idempresaruc   BIGINT,
    IN _iddistrito     INT,
    IN _razonsocial     VARCHAR(100),
    IN _direccion       VARCHAR(100),
    IN _email           VARCHAR(100),
    IN _telefono        CHAR(9)
)
BEGIN
    INSERT INTO empresas 
    (idempresaruc, iddistrito, razonsocial, direccion, email, telefono) 
    VALUES 
    (_idempresaruc, _iddistrito, _razonsocial, _direccion, _email, _telefono);
    
      SELECT _idempresaruc AS idempresas;
END $$



CALL sp_empresa_registrar (
    20123466819,
    954,
    'Arch5royrws',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);
-- ACTUALIZAR EMPRESAS
DELIMITER $$
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
END$$


-- Eliminar
DELIMITER $$
CREATE PROCEDURE sp_estado_empresa(
	IN  _estado 		CHAR(1),
	IN  _idempresaruc 	BIGINT 
)
BEGIN
	UPDATE empresas SET
      estado=_estado
      WHERE idempresaruc=_idempresaruc;
END$$


-- buscador de empresas
DROP PROCEDURE IF EXISTS sp_buscar_empresa;
DELIMITER //
CREATE PROCEDURE sp_buscar_empresa
(
    IN _ruc BIGINT
)
BEGIN
    DECLARE _empresa_count INT DEFAULT 0;

    -- Verificar si la empresa existe
    SELECT COUNT(*)
    INTO _empresa_count
    FROM empresas EMP
    WHERE EMP.idempresaruc = _ruc
    AND EMP.estado = '1';

    -- Si no existe la empresa, devolver 'No data'
    IF _empresa_count = 0 THEN
        SELECT 'No data' AS estado;
    
    -- Si existe, devolver los detalles
    ELSE
        SELECT 
            'Empresa' AS tipo_cliente,
            EMP.idempresaruc,
            EMP.razonsocial,
            EMP.direccion, 
            EMP.email,
            EMP.telefono,
            DIS.distrito,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM clientes CLI 
                    WHERE CLI.idempresa = EMP.idempresaruc
                ) THEN 'Registrado'
                ELSE 'No registrado'
            END AS estado
        FROM empresas EMP
        INNER JOIN distritos DIS ON DIS.iddistrito = EMP.iddistrito
        WHERE EMP.idempresaruc = _ruc
        AND EMP.estado = '1';
    END IF;
END //

-- LISTAR EMPRESAS
CREATE VIEW view_empresas AS
SELECT E.idempresaruc, E.razonsocial, E.direccion,E.email,E.telefono, D.iddistrito,D.distrito
FROM empresas E
INNER JOIN  distritos D ON E.iddistrito=D.iddistrito
ORDER BY razonsocial ASC;