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