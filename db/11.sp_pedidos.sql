-- Active: 1731562917822@@127.0.0.1@3306@distribumax

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

DROP PROCEDURE IF EXISTS sp_update_estado_pedido;
CREATE PROCEDURE sp_update_estado_pedido
(
    IN _idpedido CHAR(15),
    IN _estado CHAR(10)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;

    -- Validar si el estado proporcionado es válido
    IF _estado NOT IN ('Pendiente', 'Enviado', 'Cancelado', 'Entregado') THEN
        SET v_estado = 0;
        SET v_mensaje = 'El estado proporcionado no es válido.';
    ELSE
        -- Actualizar el estado del pedido
        UPDATE pedidos
        SET estado = _estado,
            update_at = NOW()
        WHERE idpedido = _idpedido;

        -- Verificar si se actualizó correctamente
        IF ROW_COUNT() > 0 THEN
            SET v_estado = 1;
            SET v_mensaje = CONCAT('Pedido ', _idpedido, ' actualizado a estado: ', _estado);
        ELSE
            SET v_estado = 0;
            SET v_mensaje = 'No se encontró el pedido con el ID proporcionado.';
        END IF;
    END IF;

    -- Devolver el resultado
    SELECT v_estado AS estado, v_mensaje AS mensaje;
END;

CALL sp_update_estado_pedido('PED-000000001','Cancelado');
-- NO MOVER NADA DEL PROCEDIMIENTO , FALTA TERMINAR DE IMPLEMENTARLO

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