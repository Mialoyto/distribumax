-- Active: 1728956418931@@127.0.0.1@3306@distribumax

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
        -- Verificar si el pedido tiene una venta asociada
        IF EXISTS (
            SELECT 1 FROM ventas WHERE idpedido = _idpedido
        ) AND _estado = 'Cancelado' THEN
            SET v_estado = 0;
            SET v_mensaje = 'No se puede cancelar un pedido con venta asociada.';
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
    END IF;

    -- Devolver el resultado
    SELECT v_estado AS estado, v_mensaje AS mensaje;

END;



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

DROP PROCEDURE IF EXISTS sp_listar_pedidos;

CREATE PROCEDURE sp_listar_pedidos()
BEGIN
	SELECT 
    pe.idpedido,
    cl.tipo_cliente,
    
    
    CASE 
        WHEN cl.tipo_cliente = 'Empresa' THEN cl.idempresa
        WHEN cl.tipo_cliente = 'Persona' THEN cl.idpersona
    END AS documento,
    CASE 
        WHEN cl.tipo_cliente = 'Empresa' THEN emp.razonsocial
        WHEN cl.tipo_cliente = 'Persona' THEN concat(per.appaterno,' ', per.nombres) 
    END AS cliente,
    
    pe.estado,
    pe.create_at
FROM pedidos pe 
INNER JOIN clientes cl ON cl.idcliente = pe.idcliente
LEFT JOIN personas per ON per.idpersonanrodoc=cl.idpersona
LEFT JOIN empresas emp ON emp.idempresaruc=cl.idempresa;

END;


DROP PROCEDURE IF EXISTS sp_obtener_pedido;

CREATE PROCEDURE sp_obtener_pedido (IN _idpedido VARCHAR(80))
BEGIN
    SELECT 
        cl.idcliente,
        cl.tipo_cliente,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        EMP.razonsocial,
        EMP.email,
        DIS.iddistrito,
        DIS.distrito,
        PER.telefono,
        CASE 
            WHEN cl.tipo_cliente = "Empresa" THEN EMP.idempresaruc
            WHEN cl.tipo_cliente = "Persona" THEN PER.idpersonanrodoc
        END AS documento,
        CASE 
            WHEN CL.idpersona IS NOT NULL THEN PER.direccion
            WHEN CL.idempresa IS NOT NULL THEN EMP.direccion
        END AS direccion_cliente,
        CL.estado,
        pe.idpedido,
        pr.codigo, 
        pr.idproducto, 
        pr.nombreproducto,
        dp.cantidad_producto,
        dp.unidad_medida,
        dp.precio_unitario,
        dp.subtotal,
        pe.estado
    FROM pedidos pe
    INNER JOIN detalle_pedidos dp ON dp.idpedido = pe.idpedido
    LEFT JOIN productos pr ON pr.idproducto = dp.idproducto
    LEFT JOIN clientes cl ON cl.idcliente = pe.idcliente
    LEFT JOIN personas PER ON CL.idpersona = PER.idpersonanrodoc
    LEFT JOIN empresas EMP ON CL.idempresa = EMP.idempresaruc
    LEFT JOIN distritos DIS ON DIS.iddistrito = PER.iddistrito
    LEFT JOIN provincias PRO ON PRO.idprovincia = DIS.idprovincia
    LEFT JOIN departamentos DEP ON DEP.iddepartamento = PRO.iddepartamento
    WHERE pe.idpedido = _idpedido
      AND pe.estado = 'pendiente';
END;




-- //?todo piola hola que hace
-- DROP TRIGGER IF EXISTS trg_actualizar_kardex_pedido

-- CREATE TRIGGER trg_actualizar_kardex_pedido
-- AFTER UPDATE ON pedidos
-- FOR EACH ROW
-- BEGIN
--     DECLARE _idproducto INT;
--     DECLARE _idlote INT;
--     DECLARE _cantidad INT;
--     DECLARE done INT DEFAULT 0;

--     -- Cursor para iterar sobre los productos del pedido
--     DECLARE cur CURSOR FOR
--     SELECT 
--         pr.idproducto,
--         dp.cantidad_producto,
--         lt.idlote
--     FROM detalle_pedidos dp
--     LEFT JOIN productos pr ON pr.idproducto = dp.idproducto
--     LEFT JOIN lotes lt ON lt.idproducto = pr.idproducto
--     WHERE dp.idpedido = NEW.idpedido;

--     -- Handler para controlar el fin del cursor
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

--     -- Verificar si el cambio es entre 'Pendiente' y 'Cancelado'
--     IF (OLD.estado = 'Pendiente' AND NEW.estado = 'Cancelado') OR 
--        (OLD.estado = 'Cancelado' AND NEW.estado = 'Pendiente') THEN
--         -- Abrir el cursor
--         OPEN cur;

--         -- Iterar sobre los productos del pedido
--         read_loop: LOOP
--             FETCH cur INTO _idproducto, _cantidad, _idlote;

--             -- Salir del bucle si no hay más filas
--             IF done = 1 THEN
--                 LEAVE read_loop;
--             END IF;

--             -- Registrar movimientos en el kardex según la transición
--             IF NEW.estado = 'Cancelado' THEN
--                 -- Registrar ingreso en el kardex
--                 CALL sp_registrarmovimiento_kardex(
--                     NEW.idusuario, 
--                     _idproducto,
--                     _idlote,
--                     'Ingreso',
--                     _cantidad,
--                     'Pedido Cancelado'
--                 );
--             ELSEIF NEW.estado = 'Pendiente' THEN
--                 -- Registrar salida en el kardex
--                 CALL sp_registrarmovimiento_kardex(
--                     NEW.idusuario, 
--                     _idproducto,
--                     _idlote,
--                     'Salida',
--                     _cantidad,
--                     'Pedido Pendiente'
--                 );
--             END IF;
--         END LOOP;

--         -- Cerrar el cursor
--         CLOSE cur;
--     END IF;

-- END ;


-- CALL sp_update_estado_pedido ('PED-000000006', 'Cancelado');