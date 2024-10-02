USE distribuMax;
-- Procedimiento para obtener el último stock
DROP PROCEDURE IF EXISTS getultimostock;
DELIMITER $$
CREATE PROCEDURE getultimostock (
    IN _idproducto      INT,
    OUT stock_actual    INT
)
BEGIN
    SELECT stockactual INTO stock_actual
    FROM kardex
    WHERE idproducto = _idproducto
    ORDER BY create_at DESC
    LIMIT 1;
END $$


-- Procedimiento para registrar movimiento de detalle de pedido

DROP PROCEDURE IF EXISTS sp_registrarmovimiento_detallepedido;
DELIMITER $$
CREATE PROCEDURE sp_registrarmovimiento_detallepedido (
    IN _idusuario INT,
    IN _idproducto INT,
    IN _stock_actual INT,
    IN _tipomovimiento ENUM('Ingreso', 'Salida'),
    IN _cantidad INT, -- Cambiado a INT si debe ser entero
    IN _motivo VARCHAR(255)
)
BEGIN
    DECLARE _ultimo_stock_actual INT DEFAULT 0;
    DECLARE _nuevo_stock_actual INT;

    CALL getultimostock(_idproducto, _ultimo_stock_actual);

    IF _ultimo_stock_actual IS NULL THEN
        SET _ultimo_stock_actual = 0;
    END IF;

    IF _tipomovimiento = 'Ingreso' THEN
        SET _nuevo_stock_actual = _ultimo_stock_actual + _cantidad;
    ELSEIF _tipomovimiento = 'Salida' THEN
        IF _ultimo_stock_actual >= _cantidad THEN
            SET _nuevo_stock_actual = _ultimo_stock_actual - _cantidad;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para esta operación';
        END IF;
    END IF;

    INSERT INTO kardex (idusuario, idproducto, stockactual, tipomovimiento, cantidad, motivo)
    VALUES (_idusuario, _idproducto, _nuevo_stock_actual, _tipomovimiento, _cantidad, _motivo);
END $$


-- Procedimiento para reporte de producto
DROP PROCEDURE IF EXISTS spu_producto_reporte;
DELIMITER $$
CREATE PROCEDURE spu_producto_reporte (
    IN _idproducto INT
)
BEGIN
    SELECT 
        MAR.marca,
        TPRO.tipoproducto,
        PRO.modelo,
        PRO.descripcion,
        KAR.cantidad,
        KAR.tipomovimiento,
        KAR.stockactual,
        KAR.create_at,
        COL.nomusuario
    FROM kardex KAR
    INNER JOIN productos PRO ON PRO.idproducto = KAR.idproducto
    INNER JOIN marcas MAR ON MAR.idmarca = PRO.idmarca
    INNER JOIN tipoProductos TPRO ON TPRO.idtipoproducto = PRO.idtipoproducto
    INNER JOIN colaboradores COL ON COL.idcolaborador = KAR.idcolaborador
    WHERE KAR.idproducto = _idproducto;
END $$
-- detalle idos

CALL sp_registrarmovimiento_detallepedido(1, 1, 0,'Ingreso', 200, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 2, 0,'Ingreso', 100, 'Ingreso de productos para venta');
CALL sp_registrarmovimiento_detallepedido(1, 3, 0,'Ingreso', 200, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 4, 0,'Ingreso', 50, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 5, 0,'Ingreso', 150, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 6, 0,'Ingreso', 200, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 7, 0,'Ingreso', 250, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 8, 0,'Ingreso', 275, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 9, 0,'Ingreso', 300, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_detallepedido(1, 10, 0,'Ingreso', 325, 'Ingreso de productos adicionales');


SELECT * FROM kardex;
SELECT * FROM productos;
SELECT * FROM empresas;

-- Consulta de producto específico
SELECT k.idkardex, k.stockactual, p.idproducto, p.nombreproducto 
FROM kardex k
INNER JOIN productos p ON k.idproducto = p.idproducto
WHERE p.idproducto = 1;
