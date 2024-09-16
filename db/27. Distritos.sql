USE distribumax;

DELIMITER $$
CREATE PROCEDURE sp_buscardistrito(
IN _distrito VARCHAR(100)
)
BEGIN
IF TRIM(_distrito) <> '' THEN
SELECT
	d.iddistrito AS iddistrito,
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
    d.distrito LIKE  CONCAT('%', TRIM(_distrito),'%');
END IF;
END$$

call sp_buscardistrito('chincha');

CREATE VIEW view_distritos  AS
	SELECT iddistrito,distrito
        FROM distritos ORDER BY distrito ASC;