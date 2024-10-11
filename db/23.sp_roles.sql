USE distribumax;

DROP PROCEDURE IF EXISTS sp_registrar_roles;
CREATE PROCEDURE sp_registrar_roles(
    IN _rol     VARCHAR(100)
)
BEGIN
    INSERT INTO roles (rol)
        VALUES (_rol);
END;


CREATE VIEW vw_listar_roles AS
    SELECT idrol, rol FROM roles
    WHERE estado = "1"
    ORDER BY rol ASC;

