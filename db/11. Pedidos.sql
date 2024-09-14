USE distribumax;

--  REGISTRAR PEDIDOS
DELIMITER $$
CREATE PROCEDURE sp_pedido_registrar(
    IN _idpedido        INT,
    IN _idusuario       INT,
    IN _idcliente       INT,
    IN _fecha_pedido    DATETIME,
    IN _estado          ENUM('Pendiente', 'Enviado', 'Cancelado', 'Entregado')
)
BEGIN
    INSERT INTO pedidos
    (idpedido, idusuario, idcliente, fecha_pedido, estado) 
    VALUES 
    (_idpedido, _idusuario, _idcliente, _fecha_pedido, _estado);
END$$

-- ACTUALIZAR PEDIDOS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_pedido(
	IN _idpedido        INT,
    IN _idusuario       INT,
    IN _idcliente       INT,
    IN _fecha_pedido    DATETIME,
    IN _estado          ENUM('Pendiente', 'Enviado', 'Cancelado', 'Entregado')
)
BEGIN
	UPDATE pedidos
		SET 
			idpedido =_idpedido,
			idusuario =_idusuario,
			idcliente =_idcliente,
			fecha_pedido =_fecha_pedido,
            estado = _estado,
			update_at=now()
        WHERE idpedido =_idpedido;
END$$

-- ELIMINA PEDIDO  
DELIMITER $$
CREATE PROCEDURE sp_estado_pedido(
IN  _estado BIT,
IN  _idpedido INT 
)
BEGIN
	UPDATE pedidos SET
      estado=_estado
      WHERE idpedido =_idpedido;
END$$