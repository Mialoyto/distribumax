USE distribumax;

-- REGISTRAR DETALLE PEDIDOS
DELIMITER $$

CREATE PROCEDURE sp_detalle_pedido(
    IN _idpedido            INT,
    IN _idproducto          INT,
    IN _cantidad_producto   INT,
    IN _unidad_medida       INT,
    IN _precio_unitario     DECIMAL(10, 2),
    IN _precio_descuento    DECIMAL(10, 2),
    IN _subtotal            DECIMAL(10, 2)
)
BEGIN
    INSERT INTO detalle_pedidos 
    (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, precio_descuento, subtotal) 
    VALUES
    (_idpedido, _idproducto, _cantidad_producto, _unidad_medida, _precio_unitario, _precio_descuento, _subtotal);
END$$

-- ACTUALIZAR DETALLE PEDIDOS
/** Se puede actualizar algun campo del proceso de actualizar PROBAR SI SE PUEDE ACTUALIZAR EL PRECIO UNITARIO**/
DELIMITER $$

CREATE PROCEDURE sp_actualizar_detalle_pedido(
    IN _idpedido          INT,
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
        idproducto,
        codigo,
        nombreproducto,
        preciounitario
    FROM  productos 
    WHERE (codigo LIKE CONCAT ('%',_item, '%') OR nombreproducto LIKE CONCAT('%', _item, '%')) 
    AND estado = '1';
END$$
select * from pedidos;
CALL sp_buscar_productos('AL00');