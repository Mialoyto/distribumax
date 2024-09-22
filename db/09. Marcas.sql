USE distribumax;

-- REGISTRAR MARCAS
DELIMITER $$
CREATE PROCEDURE sp_registrar_marca(
    IN _marca VARCHAR(150)
)
BEGIN
    INSERT INTO marcas (marca) 
    VALUES (_marca);
END$$

-- ACTUALIZAR MARCAS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_marca(
    IN _idmarca INT,
    IN _marca 	VARCHAR(150)
)
BEGIN
    UPDATE marcas
    SET marca = _marca,
        update_at = NOW()
    WHERE idmarca = _idmarca;
END$$

-- ELIMINAR MARCAS
DELIMITER $$
CREATE PROCEDURE sp_eliminar_marca(
    IN _idmarca INT,
    IN _estado 	CHAR(1)
)
BEGIN
    UPDATE marcas
    SET 
        estado = _estado
    WHERE idmarca = _idmarca;
END$$

-- LISTAR MARCAS
CREATE VIEW vw_listar_marcas AS
SELECT idmarca,marca FROM marcas
    WHERE estado = '1'
    ORDER BY marca ASC;