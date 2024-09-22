-- Active: 1726291702198@@localhost@3306@distribumax
USE distribumax;
--  REGISTRAR PEDIDOS
DELIMITER $$
CREATE PROCEDURE sp_pedido_registrar(
    IN _idusuario       INT,
    IN _idcliente       INT
)
BEGIN
    INSERT INTO pedidos
    (idusuario, idcliente) 
    VALUES 
    ( _idusuario, _idcliente);
    SELECT idpedido FROM pedidos ORDER BY idpedido DESC LIMIT 1;
END$$

-- ACTUALIZAR PEDIDOS SOLO LOS DATOS PERO NO EL ESTADO
DELIMITER $$
CREATE PROCEDURE sp_actualizar_pedido(
    IN _idpedido        CHAR(15),
    IN _idusuario       INT,
    IN _idcliente       INT
)
BEGIN
    UPDATE pedidos
        SET 
            idusuario   = _idusuario,
            idcliente   = _idcliente,
            estado      = _estado,
            update_at   = now()
        WHERE idpedido  = _idpedido;
END$$

-- ACTUALIZAR EL PEDIDO  ('Pendiente', 'Enviado', 'Cancelado', 'Entregado')
DELIMITER $$
CREATE PROCEDURE sp_estado_pedido(
    IN  _estado         BIT,
    IN  _idpedido       CHAR(15) 
)
BEGIN
    UPDATE pedidos SET
        estado = _estado
    WHERE idpedido = _idpedido;
END$$

