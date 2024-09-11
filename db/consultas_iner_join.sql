SELECT 
	TDOC.documento,
    PER.idpersonanrodoc,
    DIST.distrito,
    PER.nombres,
    PER.appaterno,
    PER.apmaterno,
    PER.telefono,
    PER.direccion
FROM personas PER
INNER JOIN tipo_documento TDOC  ON PER.idtipodocumento = TDOC.idtipodocumento
INNER JOIN distritos DIST ON PER.iddistrito = DIST.iddistrito;
    