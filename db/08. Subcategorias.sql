USE distribumax;

-- REGISTRAR SUBCATEGORIAS
DELIMITER $$
CREATE PROCEDURE sp_registrar_subcategoria(
    IN _idcategoria 	INT,
    IN _subcategoria 	VARCHAR(150)
)
BEGIN
    INSERT INTO subcategorias (idcategoria, subcategoria)
    VALUES (_idcategoria, _subcategoria);
END$$

-- ACTUALIZAR SUBCATEGORIAS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_subcategoria(
    IN _idsubcategoria 	INT,
    IN _idcategoria 	INT,
    IN _subcategoria 	VARCHAR(150)
)
BEGIN
    UPDATE subcategorias
    SET idcategoria = _idcategoria,
        subcategoria = _subcategoria,
        update_at = NOW()
    WHERE idsubcategoria = _idsubcategoria;
END$$

-- ELIMINAR SUBCATEGORIAS
DELIMITER $$
CREATE PROCEDURE sp_eliminar_subcategoria(
    IN _idsubcategoria 	INT,
    IN _estado          CHAR(1)
)
BEGIN
    UPDATE subcategorias
        SET 
            estado = _estado
        WHERE idsubcategoria = _idsubcategoria
END$$

-- LISTAR SUBCATEGORIAS

CREATE VIEW vw_listar_subcategorias
    SELECT subcategoria FROM subcategoriaS
    ORDER BY subcategoria ASC
    WHERE estado = '1';