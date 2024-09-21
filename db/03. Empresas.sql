USE distribumax;
-- REGISTRAR EMPRESAS 
DELIMITER $$
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
END$$

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

-- LISTAR EMPRESAS
CREATE VIEW view_empresas AS
SELECT E.idempresaruc, E.razonsocial, E.direccion,E.email,E.telefono, D.iddistrito,D.distrito
FROM empresas E
INNER JOIN  distritos D ON E.iddistrito=D.iddistrito
ORDER BY razonsocial ASC;