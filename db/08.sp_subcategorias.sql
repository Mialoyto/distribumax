-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR SUBCATEGORIAS
DROP PROCEDURE IF EXISTS sp_registrar_subcategoria;

CREATE PROCEDURE sp_registrar_subcategoria(
    IN _idcategoria 	INT,
    IN _subcategoria 	VARCHAR(150)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_subcategoria VARCHAR(150);
    DECLARE v_idsubcategoria INT;

    SELECT subcategoria INTO v_subcategoria
    FROM subcategorias
    WHERE subcategoria = _subcategoria;

    IF v_subcategoria = _subcategoria THEN
        SET v_mensaje = 'Esta subcategoria ya existe';
        SET v_idsubcategoria = -1;
    ELSE   
        INSERT INTO subcategorias (idcategoria, subcategoria)
        VALUES (_idcategoria, UPPER(_subcategoria));
        SET v_idsubcategoria = LAST_INSERT_ID();
        SET v_mensaje = CONCAT('Subcategoria ', UPPER(_subcategoria) ,' registrada correctamente');
    END IF;
    SELECT v_mensaje AS mensaje, v_idsubcategoria AS idsubcategoria;
END;

-- ACTUALIZAR SUBCATEGORIAS
DROP PROCEDURE IF EXISTS sp_actualizar_subcategoria;

CREATE PROCEDURE sp_actualizar_subcategoria(
    IN _idsubcategoria 	INT,
    IN _subcategoria 	VARCHAR(150)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_subcategoria VARCHAR(150);
    DECLARE v_idsubcategoria INT;

    SELECT subcategoria INTO v_subcategoria
    FROM subcategorias
    WHERE subcategoria = _subcategoria;

    IF v_subcategoria = _subcategoria THEN
        SET v_mensaje = 'Esta subcategoria ya existe';
        SET v_idsubcategoria = -1;
    ELSE 
    UPDATE subcategorias
    SET 
        subcategoria = UPPER(_subcategoria),
        update_at = NOW()
    WHERE idsubcategoria = _idsubcategoria;
    

    SET v_idsubcategoria = _idsubcategoria;
    SET v_mensaje = 'Datos actualizados correctamente';
    END IF;

    SELECT v_mensaje AS mensaje, v_idsubcategoria AS idsubcategoria;
END;

-- DESACTIVAR SUBCATEGORIAS
DROP PROCEDURE IF EXISTS sp_update_estado_subcategoria;

CREATE PROCEDURE sp_update_estado_subcategoria(
    IN _idsubcategoria 	INT,
    IN _estado          CHAR(1)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;
    IF _estado = '0' THEN
    UPDATE subcategorias
        SET 
            estado = _estado
        WHERE idsubcategoria = _idsubcategoria;
        SET v_estado = 1;
    SET v_mensaje = 'La subcategoria se ha desactivado correctamente';
    ELSEIF _estado = '1' THEN
    UPDATE subcategorias
        SET 
            estado = _estado
        WHERE idsubcategoria = _idsubcategoria;
    SET v_estado = 1;
    SET v_mensaje = 'La subcategoria se ha activado correctamente';
    ELSE 
    SET v_estado = 0;
    SET v_mensaje = 'Error al actualizar el estado de la subcategoria';
    END IF;

    SELECT v_mensaje AS mensaje, v_estado AS estado;
END;


-- NOT TOCAR
DROP PROCEDURE IF EXISTS getSubcategorias;

CREATE PROCEDURE getSubcategorias (
    IN _idcategoria INT) 
BEGIN
    SELECT 
        SUB.idsubcategoria,
        SUB.subcategoria
    FROM
        subcategorias SUB
        INNER JOIN categorias CAT ON CAT.idcategoria = SUB.idcategoria
    WHERE
        CAT.idcategoria = _idcategoria
        AND CAT.estado = 1
    ORDER BY SUB.idsubcategoria ASC;
END;


-- LISTAR SUBCATEGORIASDROP PROCEDURE IF EXISTS sp_listar_subcategorias;
DROP PROCEDURE IF EXISTS sp_getSubcategoria;
CREATE PROCEDURE sp_getSubcategoria(
    IN _idsubcategoria INT  
)
BEGIN
    SELECT 
        CAT.categoria,
        SUB.subcategoria
    FROM
        subcategorias SUB
        INNER JOIN categorias CAT ON CAT.idcategoria = SUB.idcategoria
    WHERE
        SUB.idsubcategoria = _idsubcategoria;
END;

CREATE PROCEDURE sp_listar_subcategorias()
BEGIN
    SELECT 
        SUB.idsubcategoria AS id,
        CAT.categoria,
        SUB.subcategoria,
        CASE SUB.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE SUB.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`

    FROM subcategorias AS SUB
    JOIN categorias AS CAT ON CAT.idcategoria = SUB.idcategoria
    WHERE CAT.estado = 1
    ORDER BY SUB.subcategoria ASC;
END;