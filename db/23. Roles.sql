USE distribumax;

CREATE VIEW vw_listar_roles AS
    SELECT idrol, rol FROM roles
    WHERE estado = "1"
    ORDER BY rol ASC;

SELECT * FROM vw_listar_roles;