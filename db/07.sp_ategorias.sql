USE distribumax;

-- REGISTRAR
DELIMITER $$
CREATE PROCEDURE sp_registrar_categoria
( IN _categoria  VARCHAR(150)) 
BEGIN
    INSERT INTO categorias (categoria)
        VALUES (_categoria);
END $$

-- ACTUALIZAR
CREATE PROCEDURE sp_actualizar_categoria
( 
    IN _categoria  VARCHAR(150),
    IN _idcategoria INT
) 
BEGIN
    UPDATE categorias
    SET
        categoria = _categoria,
        update_at = NOW()
    WHERE idcategoria = _idcategoria;
END $$

-- ELIMINAR 
DELIMITER $$
CREATE PROCEDURE sp_desactivar_categoria
( 
    IN _estado CHAR(1),
    IN _idcategoria INT
) 
BEGIN
    UPDATE categorias
    SET
        estado = _estado
    WHERE idcategoria = _idcategoria;
END $$


-- LISTAR CATEGORIAS
DELIMITER $$
DROP VIEW IF EXISTS `vw_listar_categorias`;
CREATE VIEW `vw_listar_categorias` AS
    SELECT
        CAT.categoria,
        CAT.create_at,
        CAT.estado
    FROM categorias CAT
    WHERE CAT.estado = 1;
END $$
