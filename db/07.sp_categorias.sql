-- Active: 1726698325558@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR
DROP PROCEDURE IF EXISTS sp_registrar_categoria;
CREATE PROCEDURE sp_registrar_categoria
( IN _categoria  VARCHAR(150)) 
BEGIN
    DECLARE v_categoria VARCHAR(150);
    DECLARE v_idcategoria INT;
    DECLARE v_mensaje VARCHAR(100);

    SELECT categoria INTO v_categoria
    FROM categorias
    WHERE UPPER(categoria) = UPPER(_categoria);

    IF v_categoria IS NOT NULL THEN
        SET v_idcategoria = -1;
        SET v_mensaje = 'La categoria ya existe';

    ELSE
        INSERT INTO categorias (categoria)
        VALUES (UPPER(_categoria));

        SET v_idcategoria = LAST_INSERT_ID();
        SET v_mensaje = 'Categoria registrada correctamente';
    END IF;

    SELECT v_idcategoria AS idcategoria, v_mensaje AS mensaje;
END;

CALL sp_registrar_categoria('Carnes');
SELECT * FROM categorias;



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
END;

-- ELIMINAR 

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
END;


CREATE PROCEDURE sp_listar_categorias
()
BEGIN
    SELECT
        CAT.idcategoria,
        CAT.categoria
    FROM categorias CAT
    WHERE CAT.estado = 1
    ORDER BY CAT.categoria ASC;
END;


-- LISTAR CATEGORIAS
DROP VIEW IF EXISTS vw_listar_categorias;
CREATE VIEW `vw_listar_categorias` AS
    SELECT
        CAT.idcategoria AS id,
        CAT.categoria,
        CASE CAT.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS 'estado'
    FROM categorias CAT
    ORDER BY CAT.categoria ASC;

SELECT * FROM vw_listar_categorias;