USE distribumax;

CREATE VIEW view_tipos_documentos  AS
	SELECT idtipodocumento,documento
        FROM tipo_documento ORDER BY documento ASC;