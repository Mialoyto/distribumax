-- Active: 1732807506399@@127.0.0.1@3306@distribumax

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
-- CALL sp_pedido_registrar(1, 1);

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
LEFT JOIN empresas emp ON emp.idempresaruc=cl.idempresa
 ORDER BY pe.idpedido DESC;

END;

DROP PROCEDURE IF EXISTS sp_obtener_pedido;

CREATE PROCEDURE sp_obtener_pedido (IN _idpedido VARCHAR(80))
BEGIN
    SELECT 
    -- DATOS DEL CLIENTE
        CL.idcliente,
        CL.tipo_cliente,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        EMP.razonsocial,
        EMP.email,
        DIS.iddistrito,
        DIS.distrito,
        PER.telefono,
        CASE 
            WHEN CL.tipo_cliente = "Empresa" THEN EMP.idempresaruc
            WHEN CL.tipo_cliente = "Persona" THEN PER.idpersonanrodoc
        END AS documento,
        CASE 
            WHEN CL.idpersona IS NOT NULL THEN PER.direccion
            WHEN CL.idempresa IS NOT NULL THEN EMP.direccion
        END AS direccion_cliente,
        CL.estado,
        -- DATOS DEL DEL DETALLE DEL PEDIDO
        pe.idpedido,
		dp.id_detalle_pedido AS iddetallepedido, 
        PROD.idproducto, 
        KAR.idlote,
        PROD.codigo, 
        CONCAT(PROD.nombreproducto,'-',um.unidadmedida,' ',PROD.cantidad_presentacion, 'X', PROD.peso_unitario) AS nombreproducto,
        KAR.cantidad,
        um.unidadmedida,
        DP.precio_unitario,
        DP.precio_descuento AS descuento,
        (DP.cantidad_producto * DP.precio_unitario) AS subtotal,
        PE.estado
    FROM pedidos PE
		INNER JOIN detalle_pedidos DP 	ON DP.idpedido = PE.idpedido
		LEFT JOIN productos PROD 		ON PROD.idproducto = DP.idproducto
		LEFT JOIN unidades_medidas um 	ON um.idunidadmedida = PROD.idunidadmedida
		LEFT JOIN clientes CL 			ON CL.idcliente = PE.idcliente
		LEFT JOIN personas PER 			ON CL.idpersona = PER.idpersonanrodoc
		LEFT JOIN empresas EMP 			ON CL.idempresa = EMP.idempresaruc
		LEFT JOIN distritos DIS 		ON DIS.iddistrito = PER.iddistrito
		LEFT JOIN provincias PRO 		ON PRO.idprovincia = DIS.idprovincia
		LEFT JOIN departamentos DEP 	ON DEP.iddepartamento = PRO.iddepartamento
        LEFT JOIN kardex KAR 			ON KAR.idpedido = PE.idpedido
    WHERE PE.idpedido = _idpedido
    AND PE.estado = 'pendiente';
END;

CREATE PROCEDURE sp_contar_pedidos()
BEGIN
    SELECT 
        SUM(CASE WHEN estado = 'Enviado' THEN 1 ELSE 0 END) AS enviados,
        SUM(CASE WHEN estado = 'Pendiente' THEN 1 ELSE 0 END) AS pendientes,
        SUM(CASE WHEN estado='Cancelado'  THEN 1 ELSE 0 END)AS cancelados
    FROM pedidos
    WHERE DATE(fecha_pedido) = CURDATE();
END ;

CREATE PROCEDURE sp_listado_pedidos_provincias()
BEGIN
SELECT 
	d.distrito,
    pr.provincia,
    -- YEARWEEK(p.fecha_pedido, 1) AS semana,
    COUNT(p.idpedido) AS total_pedidos
FROM 
    pedidos p
INNER JOIN 
    clientes c ON p.idcliente = c.idcliente
LEFT JOIN 
    personas pe ON c.idpersona = pe.idpersonanrodoc
LEFT JOIN 
    empresas e ON c.idempresa = e.idempresaruc
INNER JOIN 
    distritos d ON (pe.iddistrito = d.iddistrito OR e.iddistrito = d.iddistrito)
INNER JOIN 
    provincias pr ON d.idprovincia = pr.idprovincia
    WHERE p.estado='Entregado'
GROUP BY 
    pr.provincia, YEARWEEK(p.fecha_pedido, 1)
ORDER BY 
    total_pedidos DESC
LIMIT 8;
END;

-- - //REVIEW : OBTENEMOS EL DETALLE DEL PEDIDO
-- TODO: CREAMOS UNA FUNCION PARA OBTENER EL DETALLE DEL PEDIDO
DROP PROCEDURE IF EXISTS sp_obtener_detalle_pedido;

CREATE PROCEDURE sp_obtener_detalle_pedido(
    IN _idpedido CHAR(15)
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_idpedido CHAR(15);
    DECLARE _id_detalle_pedido INT;
    DECLARE _idlote INT;
    DECLARE _cantidad INT;
    DECLARE _idproducto INT;

    -- Declarar el cursor para iterar sobre los resultados
    DECLARE cur CURSOR FOR
    SELECT 
        PED.idpedido,
        DEPED.id_detalle_pedido,
        KAR.idproducto,
        KAR.idlote,
        KAR.cantidad
    FROM kardex KAR
    INNER JOIN pedidos PED ON PED.idpedido = KAR.idpedido
    INNER JOIN detalle_pedidos DEPED ON DEPED.idpedido = KAR.idpedido
    WHERE KAR.idpedido = _idpedido;

    -- Declarar un handler para controlar el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Abrir el cursor
    OPEN cur;

    -- Iterar sobre los resultados
    read_loop: LOOP
        FETCH cur INTO v_idpedido, _id_detalle_pedido, _idproducto, _idlote, _cantidad;

        -- Salir del bucle si no hay más filas
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Aquí puedes procesar cada fila, por ejemplo, insertarla en una tabla temporal
        INSERT INTO temp_detalle_pedido (idpedido, id_detalle_pedido,idproducto, idlote, cantidad)
        VALUES (v_idpedido, _id_detalle_pedido, _idproducto,_idlote, _cantidad);
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;
END;

-- Crear una tabla temporal para almacenar los resultados
DROP TABLE IF EXISTS temp_detalle_pedido;

CREATE TABLE temp_detalle_pedido (
    idpedido CHAR(15),
    id_detalle_pedido INT,
    idproducto INT,
    idlote INT,
    cantidad INT
);

SELECT * FROM temp_detalle_pedido;

-- - //REVIEW : FUNCION PARA CANCELAR PEDIDOS/*  */
-- TODO: CREAMOS UNA FUNCION PARA CANCELAR EL PEDIDO EN EL LISTADO DE PEDIDOS Y OBTENER EL DETALLE DEL PEDIDO DE LA TABLA TEMPORAL
-- TODO: Crear una función para cancelar el pedido en el listado de pedidos y devolver los productos al stock actual de lotes
DROP PROCEDURE IF EXISTS sp_cancelar_pedido;

CREATE PROCEDURE sp_cancelar_pedido(IN _idpedido CHAR(15))
BEGIN
    -- Declarar variables
    DECLARE done INT DEFAULT 0;
    DECLARE _id_detalle_pedido INT;
    DECLARE _idproducto INT;
    DECLARE _idlote INT;
    DECLARE _cantidad INT;
    DECLARE v_stock_actual INT;
    DECLARE v_stock_lote INT;
    DECLARE v_estado VARCHAR(20);
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado_get  BIT;

    -- Declarar el cursor para iterar sobre los resultados
    DECLARE cur CURSOR FOR
    SELECT id_detalle_pedido, idproducto, idlote, cantidad
    FROM temp_detalle_pedido;

    -- Declarar un handler para controlar el fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    SELECT estado INTO v_estado
    FROM pedidos
    WHERE idpedido = _idpedido;

    IF(v_estado = 'Cancelado') THEN
        SET v_mensaje = 'El pedido ya ha sido cancelado';
        SET v_estado_get = 0;
    ELSE
        -- Actualizar el estado del pedido a 'cancelado' en la tabla de pedidos
        UPDATE pedidos
        SET estado = 'Cancelado'
        WHERE idpedido = _idpedido AND estado != 'Cancelado';

    -- Llamar al procedimiento para obtener el detalle del pedido
    CALL sp_obtener_detalle_pedido(_idpedido);

    -- Abrir el cursor
    OPEN cur;

    -- Iterar sobre los resultados de la tabla temporal y actualizar el stock de los productos
    read_loop: LOOP
        FETCH cur INTO _id_detalle_pedido, _idproducto, _idlote, _cantidad;

        IF done THEN
            LEAVE read_loop;
        END IF;


        -- Devolver los productos al stock actual de lotes
        UPDATE lotes
        SET stockactual = stockactual + _cantidad
        WHERE idlote = _idlote AND idproducto = _idproducto;

        -- ACTUALIZAR EL ESTADO DEL DETALLE DEL PEDIDO
        UPDATE detalle_pedidos
        SET estado = 0
        WHERE id_detalle_pedido = _id_detalle_pedido;
    

        -- Obtener el stock actual del producto
        SELECT COALESCE(SUM(LOT.stockactual), 0) INTO v_stock_actual
        FROM lotes LOT
        WHERE LOT.idproducto = _idproducto;

        -- SELECT v_stock_actual;


        INSERT INTO kardex (idusuario, idproducto, idpedido,idlote,stockactual,tipomovimiento,cantidad,motivo)
        VALUES (1, _idproducto, _idpedido, _idlote, v_stock_actual, 'Ingreso', _cantidad, 'Cancelación de pedido');
    
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;
        SET v_mensaje = 'Pedido cancelado correctamente';
        SET v_estado_get = 1;
    END IF;
    -- Limpiar la tabla temporal
    DELETE FROM temp_detalle_pedido WHERE idpedido = _idpedido;

    -- Devolver el mensaje
    SELECT v_mensaje AS mensaje, v_estado_get AS estado;
END;
-- -//REVIEW : -- TODO: FIN DE LA FUNCIÓN PARA CANCELR EL PEDIDO POR COMPLETO

-- -//FIXME --! Código en etapa de prueba 05-12-2024
-- TODO : ESTA FUNCIÓN DEBE DE CANCELAR UN ITEM DEL PEDIDO
/* DROP PROCEDURE IF EXISTS sp_cancelar_item_pedido;
CREATE PROCEDURE sp_cancelar_item_pedido(IN _id_detalle_pedido INT, IN _idpedido CHAR(15))
BEGIN
    DECLARE v_idproducto INT;
    DECLARE v_idlote INT;
    DECLARE v_cantidad INT;
    DECLARE v_estado_pedido VARCHAR(20);
    DECLARE v_stock_actual INT;
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado_get BIT;
    DECLARE v_items_activos INT;

    -- TODO: Validar el estado del pedido
    SELECT estado INTO v_estado_pedido
    FROM pedidos
    WHERE idpedido = _idpedido;

    IF (v_estado_pedido != 'Pendiente') THEN
        SET v_mensaje = 'No se puede cancelar un pedido que no esté en estado pendiente';
        SET v_estado_get = 0;
    ELSE
        SELECT DP.idproducto, KAR.idlote, KAR.cantidad
        INTO v_idproducto, v_idlote, v_cantidad
        FROM detalle_pedidos DP
        INNER JOIN kardex KAR ON KAR.idpedido = DP.idpedido AND KAR.idproducto =DP.idproducto
        WHERE DP.idpedido = _idpedido
        AND DP.id_detalle_pedido = _id_detalle_pedido
        AND DP.estado = 1;

        IF v_idproducto IS NULL THEN
            SET v_mensaje = 'No se encontró el item del pedido';
            SET v_estado_get = 0;
        ELSE
        -- -//REVIEW --TODO ACTUALIZAR STOCK DEL LOTE DEL PRODUCTO
            UPDATE lotes LT 
            SET stockactual = stockactual + v_cantidad
            WHERE idlote = v_idlote AND idproducto = v_idproducto;

            -- -//REVIEW --TODO : OBTENER STOCK ACTUAL DEL PRODUCTO
            SELECT COALESCE(SUM(stockactual), 0) INTO v_stock_actual
            FROM lotes
            WHERE idproducto = v_idproducto;

            -- -//REVIEW --TODO : REGISTRAR MOVIMIENTO DE KARDEX
            INSERT INTO kardex (idusuario, idproducto, idpedido, idlote, stockactual, tipomovimiento, cantidad, motivo)
            VALUES (1, v_idproducto, _idpedido, v_idlote, v_stock_actual, 'Ingreso', v_cantidad, 'Cancelación de item de pedido');

            -- -//REVIEW --TODO : ACTUALIZAR EL ESTADO DEL DETALLE DEL PEDIDO
            UPDATE detalle_pedidos
            SET estado = 0
            WHERE id_detalle_pedido = _id_detalle_pedido;

            -- -//REVIEW --TODO : VERIFICAR SI EL PEDIDO TIENE MÁS ITEMS ACTIVOS
            SELECT COUNT(*) INTO v_items_activos
            FROM detalle_pedidos
            WHERE idpedido = _idpedido
            AND estado = 1;

            -- -//REVIEW --TODO : SI NO HAY MÁS ITEMS ACTIVOS, CANCELAR EL PEDIDO
            IF v_items_activos = 0 THEN
                UPDATE pedidos
                SET estado = 'Cancelado'
                WHERE idpedido = _idpedido;

                SET v_mensaje = 'El pedido ha sido cancelado, porque no tiene productos por entregar';
            ELSE
                SET v_mensaje = 'EL producto ha sido cancelado correctamente';
            END IF;

            SET v_estado_get = 1;

        END IF;

    END IF;

    -- -//REVIEW --TODO : DEVOLVER EL MENSAJE
    SELECT v_mensaje AS mensaje, v_estado_get AS estado;

END; */

CALL sp_cancelar_item_pedido(3, 'PED-000000003');


DROP PROCEDURE IF EXISTS sp_cancelar_item_pedido;
CREATE PROCEDURE sp_cancelar_item_pedido(IN _id_detalle_pedido INT, IN _idpedido CHAR(15))
BEGIN
    DECLARE v_idproducto INT;
    DECLARE v_idlote INT;
    DECLARE v_cantidad INT;
    DECLARE v_estado_pedido VARCHAR(20);
    DECLARE v_stock_actual INT;
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado_get BIT;
    DECLARE v_items_activos INT;
    DECLARE done INT DEFAULT FALSE;

    -- Declarar cursor
    DECLARE cur_kardex CURSOR FOR 
        SELECT DP.idproducto, KAR.idlote, KAR.cantidad
        FROM detalle_pedidos DP
        INNER JOIN kardex KAR ON KAR.idpedido = DP.idpedido 
            AND KAR.idproducto = DP.idproducto
            AND KAR.tipomovimiento = 'Salida'
        WHERE DP.idpedido = _idpedido
        AND DP.id_detalle_pedido = _id_detalle_pedido
        AND DP.estado = 1;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Validar estado del pedido
    SELECT estado INTO v_estado_pedido
    FROM pedidos
    WHERE idpedido = _idpedido;

    IF (v_estado_pedido != 'Pendiente') OR (v_estado_pedido = 'Cancelado') THEN
        SET v_mensaje = 'No se puede cancelar un pedido que no esté en estado pendiente';
        SET v_estado_get = 0;
    ELSE
        -- Abrir cursor
        OPEN cur_kardex;
        
        read_loop: LOOP
            FETCH cur_kardex INTO v_idproducto, v_idlote, v_cantidad;
            
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Actualizar stock del lote
            UPDATE lotes LT 
            SET stockactual = stockactual + v_cantidad
            WHERE idlote = v_idlote AND idproducto = v_idproducto;

            -- Obtener stock actual
            SELECT COALESCE(SUM(stockactual), 0) INTO v_stock_actual
            FROM lotes
            WHERE idproducto = v_idproducto;

            -- Registrar en kardex
            INSERT INTO kardex (idusuario, idproducto, idpedido, idlote, stockactual, tipomovimiento, cantidad, motivo)
            VALUES (1, v_idproducto, _idpedido, v_idlote, v_stock_actual, 'Ingreso', v_cantidad, 'Cancelación de item de pedido');
            
        END LOOP;

        CLOSE cur_kardex;

        -- Actualizar estado del detalle
        UPDATE detalle_pedidos
        SET estado = 0
        WHERE id_detalle_pedido = _id_detalle_pedido;

        -- Verificar items activos
        SELECT COUNT(*) INTO v_items_activos
        FROM detalle_pedidos
        WHERE idpedido = _idpedido
        AND estado = 1;

        IF v_items_activos = 0 THEN
            UPDATE pedidos
            SET estado = 'Cancelado'
            WHERE idpedido = _idpedido;
            SET v_mensaje = 'El pedido ha sido cancelado, porque no tiene productos por entregar';
        ELSE
            SET v_mensaje = 'El producto ha sido cancelado correctamente';
        END IF;

        SET v_estado_get = 1;
    END IF;

    SELECT v_mensaje AS mensaje, v_estado_get AS estado;
END;