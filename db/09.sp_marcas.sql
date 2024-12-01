-- Active: 1732798376350@@127.0.0.1@3306
USE distribumax;

-- REGISTRAR MARCAS

DROP PROCEDURE IF EXISTS sp_registrar_marca;
CREATE PROCEDURE sp_registrar_marca(
    IN _idproveedor INT,
    IN _marca       VARCHAR(150),
    IN _idcategoria INT
)
BEGIN
    DECLARE v_marca VARCHAR(150);
    DECLARE v_idcategoria INT;
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_idmarca INT;
    DECLARE v_categoria VARCHAR(150);

    SELECT marca , idcategoria INTO v_marca, v_idcategoria
    FROM marcas
    WHERE marca = _marca
    AND idcategoria = _idcategoria
    AND estado ='1';

    SELECT categoria INTO v_categoria
    FROM categorias
    WHERE idcategoria = _idcategoria
    AND estado = '1';
    
    IF v_marca = _marca AND v_idcategoria = _idcategoria THEN
        SET v_idmarca = -1;
        SET v_mensaje = CONCAT('La marca ',UPPER(_marca),', asociada a la categoria ',v_categoria,' ya se encuentra registrada');
    ELSE
        INSERT INTO marcas (idproveedor,marca,idcategoria) 
        VALUES (_idproveedor,LOWER(_marca),_idcategoria);
        SET v_idmarca = LAST_INSERT_ID();
        SET v_mensaje = CONCAT('La marca ',UPPER(_marca),', asociada a la categoria ',v_categoria,' fue registrada correctamente');
    END IF;
    SELECT v_idmarca AS idmarca , v_mensaje AS mensaje;
END;
-- CALL sp_registrar_marca(1,'Marca 2',5);

-- ACTUALIZAR MARCAS
DROP PROCEDURE IF EXISTS sp_actualizar_marca;
CREATE PROCEDURE sp_actualizar_marca(
    IN _idmarca INT,             
    IN _marca VARCHAR(255)       
)
BEGIN
    -- Actualizamos el nombre de la marca en la tabla 'marcas'
    UPDATE marcas
    SET marca = _marca
    WHERE idmarca = _idmarca;

    IF ROW_COUNT() > 0 THEN
        SELECT 1 AS estado, 'Marca actualizada exitosamente' AS mensaje;
    ELSE
        SELECT 0 AS estado, 'No se encontró la marca con el ID proporcionado' AS mensaje;
    END IF;
END;

CALL sp_actualizar_marca(1,'Ajinos');


-- -- ELIMINAR MARCAS

-- CREATE PROCEDURE sp_eliminar_marca(
--     IN _idmarca INT,
--     IN _estado 	CHAR(1)
-- )
-- BEGIN
--     UPDATE marcas
--     SET 
--         estado = _estado
--     WHERE idmarca = _idmarca;
-- END;

DROP PROCEDURE IF EXISTS sp_getMarcasEdit;
CREATE PROCEDURE sp_getMarcasEdit 
(IN    _idmarca INT)
BEGIN
SELECT 
    MAR.idmarca, 
    MAR.marca
FROM marcas MAR
WHERE MAR.idmarca = _idmarca;
END;

-- CALL sp_getMarcas(1);

DROP PROCEDURE IF EXISTS sp_getMarcas;
CREATE PROCEDURE sp_getMarcas
(
    IN _idproveedor         VARCHAR(100)
)
BEGIN
SELECT 
    MAR.idmarca,
    MAR.marca
FROM marcas MAR
    RIGHT JOIN proveedores PRO ON MAR.idproveedor = PRO.idproveedor
WHERE 
    PRO.idproveedor = _idproveedor
    AND MAR.estado = 1
ORDER BY MAR.marca ASC;
END;

call sp_getMarcas(1);
-- LISTAR MARCAS
-- CREATE VIEW vw_listar_marcas AS
-- SELECT idmarca, marca
-- FROM marcas
-- WHERE
--     estado = '1'
-- ORDER BY marca ASC;
DROP PROCEDURE IF EXISTS sp_listar_marcas;
CREATE PROCEDURE sp_listar_marcas()
BEGIN
    SELECT 
        MAR.idmarca AS id,
        MAR.marca,  -- Nombre de la marca
        MAR.idmarca,
        CASE MAR.estado
            WHEN '1' THEN 'Activo'   
            WHEN '0' THEN 'Inactivo'
        END AS 'estado',
        CASE MAR.estado 
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS 'status'
    FROM marcas MAR
    ORDER BY MAR.marca ASC;
END;

CALL sp_listar_marcas();



DROP PROCEDURE IF EXISTS sp_update_estado_marca;
CREATE PROCEDURE sp_update_estado_marca(
    IN _idmarca INT,       
    IN _estado CHAR(1)      
)
BEGIN
    DECLARE v_mensaje VARCHAR(100); 
    DECLARE v_estado INT;            
    IF _estado = '0' THEN
        UPDATE marcas
        SET estado = _estado
        WHERE idmarca = _idmarca;
        IF ROW_COUNT() > 0 THEN
            SET v_estado = 1;
            SET v_mensaje = 'Marca desactivada correctamente';
        ELSE
            SET v_estado = 0;
            SET v_mensaje = 'No se encontró la marca con el ID proporcionado';
        END IF;

    ELSEIF _estado = '1' THEN
        UPDATE marcas
        SET estado = _estado
        WHERE idmarca = _idmarca;
        IF ROW_COUNT() > 0 THEN
            SET v_estado = 1;
            SET v_mensaje = 'Marca activada correctamente';
        ELSE
            SET v_estado = 0;
            SET v_mensaje = 'No se encontró la marca con el ID proporcionado';
        END IF;

    ELSE
        SET v_estado = 0;
        SET v_mensaje = 'El estado proporcionado es incorrecto';
    END IF;
    SELECT v_estado AS estado, v_mensaje AS mensaje;
END;

CALL sp_update_estado_marca(3,'1');

DROP PROCEDURE IF EXISTS sp_getMarca;
CREATE PROCEDURE sp_getMarca
(IN _idmarca INT)
BEGIN 
    SELECT
        MAR.idmarca,
        MAR.marca
    FROM marcas MAR
    WHERE MAR.idmarca = _idmarca;
END;

CALL sp_getMarca(1);