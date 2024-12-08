USE distribumax;

DROP PROCEDURE IF EXISTS sp_buscardistrito;

CREATE PROCEDURE sp_buscardistrito(IN _distrito VARCHAR(100)) BEGIN IF TRIM(_distrito) <> '' THEN
SELECT
    d.iddistrito AS iddistrito,
    d.distrito AS distrito,
    p.provincia AS provincia,
    dep.departamento AS departamento
FROM
    distritos d
    JOIN provincias p ON d.idprovincia = p.idprovincia
    JOIN departamentos dep ON p.iddepartamento = dep.iddepartamento
WHERE
    d.distrito LIKE CONCAT('%', TRIM(_distrito), '%')
    AND d.estado = '1'
LIMIT
    4;

END IF;

END;

DROP PROCEDURE IF EXISTS sp_buscardistrito_por_id;

CREATE PROCEDURE sp_buscardistrito_por_id(IN _iddistrito INT)
BEGIN
    IF _iddistrito IS NOT NULL THEN
        SELECT
            d.iddistrito AS iddistrito,
            CONCAT(d.distrito, ', ', p.provincia, ', ', dep.departamento) AS resultado
        FROM
            distritos d
            JOIN provincias p ON d.idprovincia = p.idprovincia
            JOIN departamentos dep ON p.iddepartamento = dep.iddepartamento
        WHERE
            d.iddistrito = _iddistrito
            AND d.estado = '1'
        LIMIT
            1;
    END IF;
END;

-- LISTAR DISTRITOS
CREATE VIEW view_distritos AS
SELECT
    iddistrito,
    distrito
FROM
    distritos
ORDER BY
    distrito ASC;