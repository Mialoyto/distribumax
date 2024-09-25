USE distribumax;

-- REGISTRAR DETALLE PEDIDOSDELIMITER $$
DELIMITER $$
CREATE PROCEDURE sp_detalle_pedido(
    IN _idpedido            CHAR(15),
    IN _idproducto          INT,
    IN _cantidad_producto   INT,
    IN _unidad_medida       CHAR(10),
    IN _precio_unitario     DECIMAL(10, 2)
)
BEGIN
    DECLARE _subtotal               DECIMAL(10, 2);
    DECLARE v_descuento_unitario    DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_descuento             DECIMAL(10, 2) DEFAULT 0.00;


    SELECT IFNULL(descuento, 0) INTO v_descuento_unitario
    FROM detalle_promociones
    WHERE idproducto = _idproducto
    LIMIT 1;

    SET v_descuento = _cantidad_producto * v_descuento_unitario;

    SET _subtotal = (_cantidad_producto * _precio_unitario) - v_descuento;

    INSERT INTO detalle_pedidos 
    (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, precio_descuento, subtotal) 
    VALUES
    (_idpedido, _idproducto, _cantidad_producto, _unidad_medida, _precio_unitario, v_descuento, _subtotal);
    SELECT LAST_INSERT_ID() AS iddetallepedido;
END$$

-- ACTUALIZAR EL STOCK
CREATE TRIGGER trg_actualizar_stock
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    DECLARE v_stock_actual          INT;
    DECLARE v_idusuario             INT;

    SELECT stockactual INTO v_stock_actual
    FROM kardex
    WHERE idproducto = NEW.idproducto
    LIMIT 1;

    SELECT idusuario INTO v_idusuario
    FROM pedidos
    WHERE idpedido = NEW.idpedido
    LIMIT 1;

    IF v_stock_actual >= NEW.cantidad_producto THEN
        CALL sp_registrarmovimiento_detallepedido(v_idusuario, NEW.idproducto, v_stock_actual, 'Salida', NEW.cantidad_producto, 'Venta de producto');
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para esta operación';
    END IF;
END



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

-- BUSCAR PRODUCTOS PARA LLENAR LA BASE DE DATOS
-- EL ID DEL PEDIDO SE CAPTURA CUANDO SE REGISTRA EL PEDIDO
DELIMITER $$
CREATE PROCEDURE sp_buscar_productos(
   IN _item VARCHAR(250)
)
BEGIN
    SELECT 
        PRO.idproducto,
        PRO.codigo,
        PRO.nombreproducto,
        PRO.preciounitario,
        DET.descuento
    FROM  productos PRO
        LEFT JOIN detalle_promociones DET ON PRO.idproducto = DET.idproducto
    WHERE (codigo LIKE CONCAT ('%',_item, '%') OR nombreproducto LIKE CONCAT('%', _item, '%')) 
    AND PRO.estado = '1';
END$$


-- Obtener el Id del pedido y completar la tabla en ventas
/* ESTO MODIFICO LOYOLA */
DELIMITER $$
CREATE PROCEDURE sp_getById_pedido(
	IN  _idpedido CHAR(15)
)BEGIN
	SELECT 
    cli.idpersona,
    cli.idempresa,
    pe.nombres,
    pe.appaterno,
    pe.apmaterno,
    em.razonsocial,
    dp.id_detalle_pedido,
    pr.nombreproducto,
    pr.preciounitario,
    dp.cantidad_producto,
    dp.unidad_medida,
    dp.precio_descuento,
    dp.subtotal
FROM pedidos p
    INNER JOIN detalle_pedidos dp ON p.idpedido = dp.idpedido
    INNER JOIN productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN  clientes cl ON cl.idcliente = p.idcliente  -- Asegúrate de que esta condición es correcta
    INNER JOIN clientes cli ON cli.idcliente = p.idcliente
    LEFT JOIN personas pe ON pe.idpersonanrodoc = cli.idpersona
    LEFT JOIN empresas em ON em.idempresaruc = cli.idempresa
    WHERE p.idpedido ='PED-000000001';
END$$

CALL sp_getById_pedido('PED-000000001');

select * from pedidos;