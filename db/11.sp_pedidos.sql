-- Active: 1728548966539@@127.0.0.1@3306@distribumax

USE distribumax;
--  REGISTRAR PEDIDOS

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
END;

-- ACTUALIZAR PEDIDOS SOLO LOS DATOS PERO NO EL ESTADO

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
END;

-- ACTUALIZAR EL PEDIDO  ('Pendiente', 'Enviado', 'Cancelado', 'Entregado')

CREATE PROCEDURE sp_estado_pedido(
    IN  _estado         BIT,
    IN  _idpedido       CHAR(15) 
)
BEGIN
    UPDATE pedidos SET
        estado = _estado
    WHERE idpedido = _idpedido;
END;

-- buscador para pedidos por id

DROP PROCEDURE IF EXISTS sp_buscar_pedido;

CREATE PROCEDURE sp_buscar_pedido(
    IN _idpedido CHAR(100)
)
BEGIN
    SELECT 
        pd.idpedido,
        COALESCE(CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno), em.razonsocial) AS nombre_o_razonsocial
    FROM  
        pedidos pd
    INNER JOIN clientes cl ON pd.idcliente = cl.idcliente
    LEFT JOIN personas pe ON pe.idpersonanrodoc = cl.idpersona
    LEFT JOIN empresas em ON em.idempresaruc = cl.idempresa
    WHERE 
        (pd.idpedido LIKE CONCAT('%', _idpedido, '%')  OR
        CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno) LIKE CONCAT('%', _idpedido, '%') OR
        em.razonsocial LIKE CONCAT('%', _idpedido, '%'))
        AND pd.estado = 'Pendiente'
        ORDER BY pd.idpedido DESC
        LIMIT 5;

    UPDATE pedidos 
    SET estado = 'Enviado'
    WHERE 
        idpedido = _idpedido
        AND estado = 'Pendiente';
END;


-- insertar id antes de insertar los datos

CREATE TRIGGER before_insert_pedidos
BEFORE INSERT ON pedidos
FOR EACH ROW
BEGIN
    DECLARE nuevo_id CHAR(15); 
    SET nuevo_id = CONCAT('PED-', LPAD((SELECT COUNT(*) + 1 FROM pedidos), 9, '0'));
    SET NEW.idpedido = nuevo_id;
END;

-- LISTAR PEDIDOS

SELECT * FROM kardex;