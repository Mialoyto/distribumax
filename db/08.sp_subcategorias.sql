-- Active: 1730318322772@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR SUBCATEGORIAS

CREATE PROCEDURE sp_registrar_subcategoria(
    IN _idcategoria 	INT,
    IN _subcategoria 	VARCHAR(150)
)
BEGIN
    INSERT INTO subcategorias (idcategoria, subcategoria)
    VALUES (_idcategoria, _subcategoria);
END;

-- ACTUALIZAR SUBCATEGORIAS

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
END;

-- ELIMINAR SUBCATEGORIAS

CREATE PROCEDURE sp_eliminar_subcategoria(
    IN _idsubcategoria 	INT,
    IN _estado          CHAR(1)
)
BEGIN
    UPDATE subcategorias
        SET 
            estado = _estado
        WHERE idsubcategoria = _idsubcategoria;
END;


CREATE PROCEDURE getSubcategorias (
    IN _idcategoria INT
    ) 
BEGIN
SELECT 
    SUB.idsubcategoria, 
    SUB.subcategoria
FROM
    categorias CAT
    RIGHT JOIN subcategorias SUB ON CAT.idcategoria = SUB.idcategoria
WHERE
    CAT.idcategoria = _idcategoria
    AND CAT.estado = 1
    AND SUB.estado = 1
ORDER BY SUB.idsubcategoria ASC;
END;


--  GET SUBCATEGORIAS

/* CREATE PROCEDURE getSubcategorias(
    IN _idsubcategoria INT
)
BEGIN
SELECT 
    SUB.idsubcategoria,
    SUB.subcategoria
    FROM 
        categorias CAT
        RIGHT JOIN subcategorias SUB ON CAT.idcategoria = SUB.idcategoria
    WHERE 
        CAT.idcategoria = _idsubcategoria
        AND CAT.estado = 1 AND SUB.estado = 1
        ORDER BY SUB.idsubcategoria ASC;
END;
 */
-- LISTAR SUBCATEGORIASDROP PROCEDURE IF EXISTS sp_listar_subcategorias;
DROP PROCEDURE IF EXISTS sp_listar_subcategorias;

CREATE PROCEDURE sp_listar_subcategorias()
BEGIN
    SELECT 
        CA.categoria,
        SUB.subcategoria,
        CASE SUB.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado
    FROM categorias AS CA
    JOIN subcategorias AS SUB ON CA.idcategoria = SUB.idcategoria;
END;

CALL sp_listar_subcategorias();