USE distribumax;


CREATE PROCEDURE sp_registrar_tipo_documento(
    IN _documento		VARCHAR(150)
)
BEGIN
    INSERT INTO tipo_documento (documento) 
    VALUES (_documento);
END;



DROP VIEW IF EXISTS vw_tipos_documentos;
CREATE VIEW vw_tipos_documentos  AS
	SELECT idtipodocumento,documento
        FROM tipo_documento ORDER BY documento ASC;