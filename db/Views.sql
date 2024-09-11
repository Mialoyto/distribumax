USE distribuMax;

CREATE VIEW view_tipos_documentos  AS
	SELECT idtipodocumento,documento
        FROM tipo_documento ORDER BY documento ASC;
        
   --     select * from view_tipos_documentos
   /*
DELIMITER $$
CREATE PROCEDURE sp_provincias( IN _iddepartamento  INT)
BEGIN
SELECT 
	PRO.idprovincia,
	PRO.provincia
    FROM provincias PRO
    WHERE _iddepartamento = iddepartamento 
    ORDER BY provincia ASC;
END$$
-- CALL sp_provincias(11);

DELIMITER $$
CREATE PROCEDURE sp_distritos (IN _idprovincia  INT)
BEGIN
	SELECT 
		DIST.iddistrito, 
		DIST.distrito 
		FROM distritos DIST
        WHERE _idprovincia = idprovincia
        ORDER BY distrito ASC;
END $$

-- CALL sp_distritos(99);

SELECT
    d.distrito AS distrito,
    p.provincia AS provincia,
    dep.departamento AS departamento
FROM
    distritos d
JOIN
    provincias p ON d.idprovincia = p.idprovincia
JOIN
    departamentos dep ON p.iddepartamento = dep.iddepartamento
WHERE
    d.distrito = 'Chincha Alta';

      
         -- CREATE VIEW AS*/