-- Active: 1731562917822@@127.0.0.1@3306@distribumax
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

-- CREATE PROCEDURE sp_actualizar_marca(
--     IN _idmarca INT,
--     IN _marca 	VARCHAR(150)
-- )
-- BEGIN
--     UPDATE marcas
--     SET marca = _marca,
--         update_at = NOW()
--     WHERE idmarca = _idmarca;
-- END;

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

-- DROP PROCEDURE IF EXISTS sp_getMarcas;

CREATE PROCEDURE sp_getMarcas (
    IN _idproveedor   VARCHAR(100)
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
        PRO.proveedor,
        PRO.contacto_principal,
        MAR.marca,
        CASE MAR.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado_marca
    FROM 
        marcas MAR
    INNER JOIN proveedores PRO ON MAR.idproveedor = PRO.idproveedor
    ORDER BY PRO.proveedor ASC;
END;

CALL sp_listar_marcas();