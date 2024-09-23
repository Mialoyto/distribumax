USE distribumax;

-- REGISTRAR DETALLE PEDIDOS
DELIMITER $$
CREATE PROCEDURE sp_detalle_pedido(
    IN _idpedido            CHAR(15),
    IN _idproducto          INT,
    IN _cantidad_producto   INT,
    IN _unidad_medida       CHAR(10),
    IN _precio_unitario     DECIMAL(10, 2),
    IN _precio_descuento    DECIMAL(10, 2)
)
BEGIN
    DECLARE _subtotal DECIMAL(10, 2);
    SET _subtotal = (_cantidad_producto * _precio_unitario) - _precio_descuento;
    INSERT INTO detalle_pedidos 
    (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, precio_descuento, subtotal) 
    VALUES
    (_idpedido, _idproducto, _cantidad_producto, _unidad_medida, _precio_unitario, _precio_descuento, _subtotal);
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

DELIMITER $$
CREATE PROCEDURE sp_getById_pedido(
	IN  _idpedido CHAR(15)
)BEGIN
	SELECT 
    dp.id_detalle_pedido,
    pr.nombreproducto,
    pr.preciounitario,
    dp.cantidad_producto,
    dp.unidad_medida,
    dp.precio_descuento,
    dp.subtotal
FROM 
    pedidos p
INNER JOIN 
    detalle_pedidos dp ON p.idpedido = dp.idpedido
INNER JOIN 
    productos pr ON pr.idproducto = dp.idproducto
INNER JOIN  
    clientes cl ON cl.idcliente = p.idcliente  -- Asegúrate de que esta condición es correcta
WHERE 
    p.idpedido =_idpedido;
END$$

CALL sp_getById_pedido('PED-000000001');

select * from pedidos;