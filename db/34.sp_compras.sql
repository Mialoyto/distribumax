-- OBTENER PRODUCTOS POR PROVEEDOR
DROP PROCEDURE IF EXISTS sp_get_productos_proveedor;

CREATE PROCEDURE sp_get_productos_proveedor(
    IN _idproveedor INT,
    IN _producto VARCHAR(100)
)
BEGIN
    SELECT
        PRO.idproducto,
        PRO.nombreproducto AS producto,
        UNM.unidadmedida
    FROM productos PRO
        INNER JOIN unidades_medidas UNM ON PRO.idunidadmedida = UNM.idunidadmedida
    WHERE PRO.idproveedor = _idproveedor
    AND PRO.nombreproducto LIKE CONCAT('%',_producto,'%')
    AND _producto <> ''
    AND PRO.estado = '1'
    ORDER BY PRO.nombreproducto ASC;
END;

-- CALL sp_get_productos_proveedor(1,'a');
