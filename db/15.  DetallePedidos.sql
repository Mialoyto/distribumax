-- Active: 1726291702198@@localhost@3306@distribumax
USE distribumax;

-- REGISTRAR DETALLE PEDIDOSDELIMITER $$
DROP PROCEDURE IF EXISTS sp_detalle_pedido;
DELIMITER $$
CREATE PROCEDURE sp_detalle_pedido(
    IN _idpedido            CHAR(15),
    IN _idproducto          INT,
    IN _cantidad_producto   INT,
    IN _unidad_medida       CHAR(20),
    IN _precio_unitario     DECIMAL(10, 2)
)
BEGIN
    DECLARE _subtotal               DECIMAL(10, 2);
    DECLARE v_descuento_unitario    DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_descuento             DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_subtotal              DECIMAL(10, 2) DEFAULT 0.00;


    SELECT IFNULL(descuento, 0) INTO v_descuento_unitario
    FROM detalle_promociones
    WHERE idproducto = _idproducto
    LIMIT 1;
    SET v_descuento = (_cantidad_producto * _precio_unitario) * (v_descuento_unitario / 100);
    SET _subtotal = (_cantidad_producto * _precio_unitario) - v_descuento;
    INSERT INTO detalle_pedidos 
    (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, precio_descuento, subtotal) 
    VALUES
    (_idpedido, _idproducto, _cantidad_producto, _unidad_medida, _precio_unitario, v_descuento, _subtotal);
    SELECT LAST_INSERT_ID() AS iddetallepedido;
END$$


-- ACTUALIZAR EL STOCK
drop TRIGGER trg_actualizar_stock;
DELIMITER $$
CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    DECLARE v_stock_actual          INT;
    DECLARE v_idusuario             INT;
    DECLARE v_fecha_vencimiento     DATE;
    DECLARE v_numlote               VARCHAR(60);

    SELECT stockactual INTO v_stock_actual
    FROM kardex
    WHERE idproducto = NEW.idproducto
    LIMIT 1;

    SELECT idusuario INTO v_idusuario
    FROM pedidos
    WHERE idpedido = NEW.idpedido
    LIMIT 1;

    SELECT fecha_vencimiento, numlote INTO v_fecha_vencimiento, v_numlote
    FROM kardex
    WHERE idproducto = NEW.idproducto
    AND  stockactual > 0
    ORDER BY fecha_vencimiento ASC
    LIMIT 1;

    IF v_stock_actual >= NEW.cantidad_producto THEN
        CALL sp_registrarmovimiento_kardex
        (v_idusuario, NEW.idproducto,v_fecha_vencimiento,v_numlote, 'Salida', NEW.cantidad_producto, 'Venta de producto');
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para esta operación';
    END IF;
END$$



-- ACTUALIZAR DETALLE PEDIDOS
/** Se puede actualizar algun campo del proceso de actualizar PROBAR SI SE PUEDE ACTUALIZAR EL PRECIO UNITARIO**/
DELIMITER $$
CREATE PROCEDURE sp_actualizar_detalle_pedido(
    IN _idpedido          CHAR(15),
    IN _idproducto        INT,
    IN _cantidad_producto INT,
    IN _iddetallepedido   INT
)
BEGIN
    UPDATE detalle_pedidos
        SET 
            idpedido            = _idpedido,
            idproducto          = _idproducto,
            cantidad_producto   = _cantidad_producto,
            update_at           = now()
        WHERE iddetallepedido   = _iddetallepedido;
END$$

-- ESTADO DETALLE PEDIDOS
/** Debe de poder eliminar el pedido **/
DELIMITER $$
CREATE PROCEDURE sp_estado_detalle_pedido(
    IN  _estado           CHAR(1),
    IN  _iddetallepedido  INT 
)
BEGIN
    UPDATE detalle_pedidos SET
        estado = _estado
        WHERE iddetallepedido = _iddetallepedido;
END$$



-- buscar productos por nombre o codigo y dependiendo del numero de ruc o dni del cliente cambia los precios
DELIMITER $$
CREATE PROCEDURE ObtenerPrecioProducto(
    IN _cliente_id       BIGINT,
    IN _item  VARCHAR(255)
)
BEGIN
    SELECT 
        PRO.idproducto,
        PRO.codigo,
        PRO.nombreproducto,
        DET.descuento,
        UNDM.unidadmedida,
        CASE 
            WHEN LENGTH(CLI.idpersona) = 8 THEN DETP.precio_venta_minorista
            WHEN LENGTH(CLI.idempresa) = 11 THEN DETP.precio_venta_mayorista
        END 
        AS precio_venta,
        kAR.stockactual
    FROM  productos PRO
        LEFT JOIN detalle_promociones DET ON PRO.idproducto = DET.idproducto
        LEFT JOIN detalle_productos DETP ON PRO.idproducto = DETP.idproducto
        INNER JOIN unidades_medidas UNDM ON UNDM.idunidadmedida = DETP.idunidadmedida
        INNER JOIN clientes CLI ON CLI.idempresa = _cliente_id OR CLI.idpersona = _cliente_id
        -- kardex
        INNER JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
        AND KAR.idkardex = (SELECT MAX(K2.idkardex) FROM kardex K2 WHERE K2.idproducto = PRO.idproducto)
    WHERE (codigo LIKE CONCAT ('%',_item, '%') OR nombreproducto LIKE CONCAT('%', _item, '%'))
    AND PRO.estado = '1' 
    AND KAR.stockactual > 0;
END $$


-- Obtener el Id del pedido y completar la tabla en ventas
/* ESTO MODIFICO LOYOLA */
DROP PROCEDURE IF EXISTS sp_getById_pedido;
DELIMITER $$
CREATE PROCEDURE sp_getById_pedido(
    IN _idpedido CHAR(15)
) 
BEGIN
    SELECT 
        cli.idpersona,
        cli.idempresa,
        cli.tipo_cliente,
        pe.nombres,
        pe.appaterno,
        pe.apmaterno,
        COALESCE(pe.direccion, em.direccion) AS direccion, -- Selecciona la dirección de persona o empresa
        em.razonsocial,
        dp.id_detalle_pedido,
        pr.nombreproducto,
        dp.precio_unitario,
        dp.cantidad_producto,
        dp.unidad_medida,
        dp.precio_descuento,
        dp.subtotal,
        tp.idtipocomprobante,
        tp.comprobantepago
    FROM pedidos p
        LEFT JOIN detalle_pedidos dp       ON p.idpedido = dp.idpedido
        INNER JOIN productos pr             ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli             ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe               ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em               ON em.idempresaruc = cli.idempresa
        LEFT JOIN ventas ve                 ON ve.idpedido = p.idpedido
        LEFT JOIN tipo_comprobante_pago tp  ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE p.idpedido = _idpedido
      AND ve.idventa IS NULL;
END $$

/* CALL sp_getById_pedido('PED-000000047');
select * from detalle_pedidos;
select * from pedidos;  */