-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR SUBCATEGORIAS
DROP PROCEDURE IF EXISTS sp_registrar_subcategoria;
CREATE PROCEDURE sp_registrar_subcategoria(
    IN _idcategoria 	INT,
    IN _subcategoria 	VARCHAR(150)
)
BEGIN
    INSERT INTO subcategorias (idcategoria, subcategoria)
    VALUES (_idcategoria, UPPER(_subcategoria));
END;
CALL sp_registrar_subcategoria(1, 'Subcategoria 10');
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
CALL sp_eliminar_subcategoria(1, '0');

DROP PROCEDURE IF EXISTS getSubcategorias;
CREATE PROCEDURE getSubcategorias (
    IN _idsubcategoria INT
    ) 
BEGIN
SELECT 
    SUB.idsubcategoria, 
    CAT.categoria,
    SUB.subcategoria
FROM
    subcategorias SUB
    INNER JOIN categorias CAT ON CAT.idcategoria = SUB.idcategoria
WHERE
    SUB.idsubcategoria = _idsubcategoria
    AND CAT.estado = 1
ORDER BY SUB.idsubcategoria ASC;
END;
call getSubcategorias(2);


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
        SUB.idsubcategoria AS id,
        CAT.categoria,
        SUB.subcategoria,
        CASE SUB.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado
    FROM categorias AS CAT
    JOIN subcategorias AS SUB ON CAT.idcategoria = SUB.idcategoria
    WHERE CAT.estado = 1
    ORDER BY CAT.categoria ASC;
END;

CALL sp_listar_subcategorias();
