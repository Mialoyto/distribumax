-- Active: 1728548966539@@127.0.0.1@3306@distribumax
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

-- ACTUALIZAR
DROP PROCEDURE IF EXISTS sp_actualizar_categoria;

CREATE PROCEDURE sp_actualizar_categoria
( 
    IN _idcategoria INT,
    IN _categoria  VARCHAR(150)
) 
BEGIN
    DECLARE v_categoria VARCHAR(150);
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado BIT;

    SELECT categoria INTO v_categoria
    FROM categorias
    WHERE UPPER(categoria) = UPPER(_categoria);

    IF v_categoria = _categoria THEN

        SET v_estado = 0;
        SET v_mensaje = 'La categoria ya existe';
    ELSE
        UPDATE categorias
        SET
            categoria = UPPER(_categoria),
            update_at = NOW()
        WHERE idcategoria = _idcategoria;

        SET v_estado =  1;
        SET v_mensaje = 'Categoria actualizada correctamente';
    END IF;
    SELECT  v_estado AS estado ,v_mensaje AS mensaje;
END;

-- ELIMINAR
DROP PROCEDURE IF EXISTS sp_update_estado_categoria;

CREATE PROCEDURE sp_update_estado_categoria
( 
    IN _idcategoria INT,
    IN _estado CHAR(1)
) 
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;

    IF _estado = '0' THEN
        UPDATE categorias
        SET estado = _estado
        WHERE idcategoria = _idcategoria;
        SET v_estado = 1;
        SET v_mensaje = 'Categoria desactivada correctamente';
    ELSEIF _estado = '1' THEN
        UPDATE categorias
        SET estado = _estado
        WHERE idcategoria = _idcategoria;
        SET v_estado = 1;
        SET v_mensaje = 'Categoria activada correctamente';
    ELSE
        SET v_estado = 0;
        SET v_mensaje = 'El estado es incorrecto';
    END IF;

    SELECT v_estado AS estado, v_mensaje AS mensaje;

END;
-- SELECT * FROM categorias;
CALL sp_desactivar_categoria (0, 1);

DROP PROCEDURE IF EXISTS sp_listar_categorias;

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
    END AS 'estado',
    CASE CAT.estado
        WHEN '1' THEN '0'
        WHEN '0' THEN '1'
    END AS 'status'
FROM categorias CAT
ORDER BY CAT.categoria ASC;

SELECT * FROM vw_listar_categorias;

-- getCategoria
DROP PROCEDURE IF EXISTS sp_getCategoria;

CREATE PROCEDURE sp_getCategoria
( IN _idcategoria INT)
BEGIN
    SELECT
        CAT.idcategoria,
        CAT.categoria
    FROM categorias CAT
    WHERE CAT.idcategoria = _idcategoria;
END;

CALL sp_getCategoria (1);