USE distribumax;

-- REGISTRAR DETALLE PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_detalle_pedido(
    IN _idpedido INT,
    IN _idproducto INT,
    IN _cantidad_producto INT,
    IN _unidad_medida INT,
    IN _precio_unitario DECIMAL(8, 2),
    IN _precio_descuento DECIMAL(8, 2),
    IN _subtotal DECIMAL(8, 2)
)
BEGIN
    INSERT INTO detalle_pedidos 
    (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, precio_descuento, subtotal) 
    VALUES
    (_idpedido, _idproducto, _cantidad_producto, _unidad_medida, _precio_unitario, _precio_descuento, _subtotal);
END$$

-- ACTUALIZAR DETALLE PEDIDOS
/** Se puede actualizar algun campo del proceso de actualizar**/
DELIMITER $$
CREATE PROCEDURE sp_actualizar_detalle_pedido(
    IN _idpedido          INT,
    IN _idproducto        INT,
    IN _cantidad_producto INT,
    IN _unidad_medida     INT,
    IN _precio_unitario   DECIMAL(8, 2),
    IN _precio_descuento  DECIMAL(8, 2),
    IN _subtotal          DECIMAL(8, 2),
    IN _iddetallepedido   INT
)
BEGIN
    UPDATE detalle_pedidos
        SET 
            idpedido=           _idpedido,
            idproducto=         _idproducto,
            cantidad_producto=  _cantidad_producto,
            unidad_medida=      _unidad_medida,
            precio_unitario=    _precio_unitario,
            precio_descuento=   _precio_descuento,
            subtotal=           _subtotal,
            update_at=          now()
        WHERE iddetallepedido=  _iddetallepedido;
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
        estado=_estado
        WHERE iddetallepedido=_iddetallepedido;
END$$