-- Active: 1728058749643@@127.0.0.1@3306@distribumax
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
DROP PROCEDURE IF EXISTS sp_registrarmovimiento_kardex;
DELIMITER $$
CREATE PROCEDURE sp_registrarmovimiento_kardex (
    IN _idusuario           INT,
    IN _idproducto          INT,
    IN _fecha_vencimiento   DATE,
    IN _numlote             VARCHAR(60),
    IN _tipomovimiento      ENUM('Ingreso', 'Salida'),
    IN _cantidad            INT, -- Cambiado a INT si debe ser entero
    IN _motivo              VARCHAR(255)
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

    INSERT INTO kardex (idusuario, idproducto,fecha_vencimiento,numlote, stockactual, tipomovimiento, cantidad, motivo)
    VALUES (_idusuario, _idproducto,_fecha_vencimiento,_numlote, _nuevo_stock_actual, _tipomovimiento, _cantidad, _motivo);
END$$



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

DROP PROCEDURE IF EXISTS spu_listar_kardex;
DELIMITER $$
CREATE PROCEDURE spu_listar_kardex()
BEGIN
    SELECT p.nombreproducto, k.fecha_vencimiento,
           k.numlote, k.stockactual, k.tipomovimiento, k.cantidad, k.motivo,k.estado
    FROM kardex k
    JOIN productos p ON k.idproducto = p.idproducto;
END $$

CALL spu_listar_kardex();

-- detalle idos

CALL sp_registrarmovimiento_kardex(1, 1,'2023-10-05','LOT002','Ingreso', 100, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 2,'2023-10-05','LOT002','Ingreso', 125, 'Ingreso de productos para venta');
CALL sp_registrarmovimiento_kardex(1, 3,'2023-10-05','LOT002','Ingreso', 150, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 4,'2023-10-05','LOT002','Ingreso', 200, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 5,'2023-10-05','LOT002','Ingreso', 225, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 6,'2023-10-05','LOT002','Ingreso', 250, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 7,'2023-10-05','LOT002','Ingreso', 300, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 8,'2023-10-05','LOT002','Ingreso', 325, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 9,'2023-10-05','LOT002','Ingreso', 350, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 10,'2023-10-05','LOT002','Ingreso',400, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 11,'2023-10-05','LOT002','Ingreso',425, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 17,'2023-10-05','LOT002','Ingreso',10, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 18,'2023-10-05','LOT002','Ingreso',10, 'Ingreso de productos adicionales');


SELECT * FROM kardex;
SELECT * FROM productos;
SELECT * FROM empresas;
DELETE FROM kardex
WHERE idkardex = 15;

-- Consulta de producto específico
SELECT k.idkardex, k.stockactual, p.idproducto, p.nombreproducto 
FROM kardex k
INNER JOIN productos p ON k.idproducto = p.idproducto
WHERE p.idproducto = 1;
