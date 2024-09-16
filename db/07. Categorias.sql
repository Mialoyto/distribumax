USE distribumax;

DELIMITER $$

-- REGISTRAR
CREATE PROCEDUERE sp_registrar_categoria
( IN _categoria  VARCHAR(150)) 
BEGIN
    INSERT INTO categorias (categoria)
        VALUES (_categoria)
END $$

-- ACTUALIZAR
CREATE PROCEDUERE sp_actualizar_categoria
( 
    IN _categoria  VARCHAR(150),
    IN _idcategoria INT
) 
BEGIN
    UPDATE categorias
    SET
        categoria = _categoria
        update_at = NOW()
    WHERE idcategoria = _idcategoria;
END $$

-- ELIMINAR 
CREATE PROCEDUERE sp_desactivar_categoria
( 
    IN _estado CHAR(1)
    IN _idcategoria INT
) 
BEGIN
    UPDATE categorias
    SET
        estado = _estado
    WHERE idcategoria = _idcategoria;
END $$


-- LISTAR CATEGORIAS
CREATE VIEW vw_listar_categorias
    SELECT categoria FROM categorias
    ORDER BY categoria ASC
    WHERE estado = '1';