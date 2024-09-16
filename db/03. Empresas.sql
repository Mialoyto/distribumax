USE distribumax;
-- REGISTRAR EMPRESAS 
DELIMITER $$
CREATE PROCEDURE sp_empresa_registrar(
	IN _idempresaruc 	INT,
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
IN _idempresaruc 		INT,
IN _iddistrito         	INT,
IN _razonsocial  		VARCHAR(100),
IN _direccion 			VARCHAR(100),
IN _email 				VARCHAR(100),
IN _telefono 			CHAR(9)
)
BEGIN
	UPDATE empresas
		SET 
			iddistrito =_iddistrito,
			razonsocial =_razonsocial,
			direccion =_direccion,
			email =_email,
			telefono =_telefono,
			update_at=now()
        WHERE idempresaruc=_idempresaruc;
END$$

-- Eliminar
DELIMITER $$
CREATE PROCEDURE sp_estado_empresa(
	IN  _estado 		CHAR(1),
	IN  _idempresaruc 	INT 
)
BEGIN
	UPDATE empresas SET
      estado=_estado
      WHERE idempresaruc=_idempresaruc;
END$$

DELIMITER $$
CREATE PROCEDURE sp_filtrar_empresas_por_estado(
    IN _estado CHAR(1)  -- 'A' para activas, 'I' para inactivas
)
BEGIN
    SELECT 
        E.idempresaruc, 
        E.razonsocial, 
        E.direccion, 
        E.email, 
        E.telefono, 
        D.iddistrito, 
        D.distrito,
        CASE 
            WHEN E.estado = '1' THEN 'Activo'
            WHEN E.estado = '0' THEN 'Inactivo'
         
        END AS estado
    FROM 
        empresas E
    INNER JOIN 
        distritos D ON E.iddistrito = D.iddistrito
    WHERE 
        E.estado = _estado
    ORDER BY 
        E.razonsocial ASC;
END$$
DELIMITER ;

CALL sp_filtrar_empresas_por_estado(1);
SELECT * FROM empresas WHERE idempresaruc='1234567891' ;

CREATE VIEW view_empresas AS
SELECT E.idempresaruc, E.razonsocial, E.direccion,E.email,E.telefono, D.iddistrito,D.distrito
FROM empresas E
INNER JOIN  distritos D ON E.iddistrito=D.iddistrito
ORDER BY razonsocial ASC;