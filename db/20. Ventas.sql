-- Active: 1726291702198@@localhost@3306@distribumax
USE distribumax;

-- REGISTRAR VENTAS
DELIMITER $$
CREATE PROCEDURE sp_registrar_venta(
    IN _idpedido            CHAR(15),
    IN _idmetodopago        INT,
    IN _idtipocomprobante   INT,
    IN _fecha_venta         DATETIME,
    IN _subtotal            DECIMAL(10, 2),
    IN _descuento           DECIMAL(10, 2),
    IN _igv                 DECIMAL(10, 2),
    IN _total_venta         DECIMAL(10, 2)  
)
BEGIN
    INSERT INTO ventas 
    (idpedido, idmetodopago, idtipocomprobante,fecha_venta, subtotal, descuento, igv,total_venta) 
    VALUES
    (_idpedido, _idmetodopago, _idtipocomprobante,_fecha_venta, _subtotal, _descuento, _igv,_total_venta); 
END$$

CALL sp_registrar_venta('PED-000000009', 1, 1, NOW(), 100.00, 10.00, 18.00, 108.00);
SELECT * FROM ventas INNER JOIN  pedidos  on ventas.idpedido=pedidos.idpedido;
-- ACTUALIZAR VENTAS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_venta(
    IN _idpedido CHAR(15),
    IN _idmetodopago INT,
    IN _idtipocomprobante INT,
    IN _subtotal DATE,
    IN _descuento DECIMAL(8, 2),
    IN _igv DECIMAL(10, 2),
    IN _total_venta INT
)
BEGIN
    UPDATE ventas
        SET
            idcliente=_idcliente,
            idusuario=_idusuario,
            idpedido=_idpedido,
            fecha_venta=_fecha_venta,
            total_venta=_total_venta,
            estado=_estado,
            update_at=now()
        WHERE idventa=_idventa; 
END$$

-- ESTADO VENTAS

CREATE PROCEDURE sp_estado_venta(
    IN  _estado CHAR(1),
    IN  _idventa INT 
)
BEGIN
    UPDATE ventas SET
        estado=_estado
        WHERE idventa=_idventa;
END$$ 

-- Cambiar el estado del pedido al registrarlo
DELIMITER $$
CREATE TRIGGER trg_actualizar_estado_pedido
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET estado = 'Enviado'
    WHERE idpedido = NEW.idpedido 
      AND estado <> 'Enviado';  
END$$

