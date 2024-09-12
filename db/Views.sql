USE distribuMax;

CREATE VIEW view_tipos_documentos  AS
	SELECT idtipodocumento,documento
        FROM tipo_documento ORDER BY documento ASC;

CREATE VIEW view_distritos  AS
	SELECT iddistrito,distrito
        FROM distritos ORDER BY distrito ASC;
        
SELECT * FROM view_distritos
   --     select * from view_tipos_documentos
/**
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

drop PROCEDURE sp_distritos (IN _idprovincia  INT)
BEGIN
	SELECT 
		DIST.iddistrito, 
		DIST.distrito 
		FROM distritos DIST
        WHERE _idprovincia = idprovincia
        ORDER BY distrito ASC;
END $$

 CALL sp_distritos(99)
**/
         -- CREATE VIEW AS