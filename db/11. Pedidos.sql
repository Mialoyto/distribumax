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

-- buscador para pedidos por id
DELIMITER $$
CREATE PROCEDURE sp_buscar_pedido(
   IN _idpedido INT
)
BEGIN
    SELECT 
        idpedido
    FROM  pedidos 
    WHERE idpedido LIKE CONCAT ('%', _idpedido, '%') 
      AND estado = 'Pendiente';  -- Filtra para no mostrar pedidos "Enviados"
      
    -- Actualizar el estado del pedido si se encuentra
    UPDATE pedidos 
    SET estado = ''  
    WHERE idpedido = _idpedido
      AND estado = 'Enviado';  -- Asegúrate de que solo se actualicen los pedidos que no están "Enviados"
END$$






-- insertar id antes de insertar los datos
DELIMITER $$
CREATE TRIGGER before_insert_pedidos
BEFORE INSERT ON pedidos
FOR EACH ROW
BEGIN
    DECLARE nuevo_id CHAR(15); 
    SET nuevo_id = CONCAT('PED-', LPAD((SELECT COUNT(*) + 1 FROM pedidos), 9, '0'));
    SET NEW.idpedido = nuevo_id;
END$$



CREATE VIEW vw_listar_productos AS
SELECT * FROM productos;

