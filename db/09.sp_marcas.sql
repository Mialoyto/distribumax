USE distribumax;

-- REGISTRAR MARCAS

DROP PROCEDURE IF EXISTS sp_registrar_marca;
CREATE PROCEDURE sp_registrar_marca(
    IN _idproveedor INT,
    IN _marca       VARCHAR(150),
    IN _idcategoria INT
)
BEGIN
    INSERT INTO marcas (idproveedor,marca,idcategoria) 
    VALUES (_idproveedor,_marca,_idcategoria);
END;

-- ACTUALIZAR MARCAS


CREATE PROCEDURE sp_actualizar_marca(
    IN _idmarca INT,
    IN _marca 	VARCHAR(150)
)
BEGIN
    UPDATE marcas
    SET marca = _marca,
        update_at = NOW()
    WHERE idmarca = _idmarca;
END;

-- ELIMINAR MARCAS


CREATE PROCEDURE sp_eliminar_marca(
    IN _idmarca INT,
    IN _estado 	CHAR(1)
)
BEGIN
    UPDATE marcas
    SET 
        estado = _estado
    WHERE idmarca = _idmarca;
END;

DROP PROCEDURE IF EXISTS sp_getMarcas;
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
CREATE VIEW vw_listar_marcas AS
SELECT idmarca, marca
FROM marcas
WHERE
    estado = '1'
ORDER BY marca ASC;