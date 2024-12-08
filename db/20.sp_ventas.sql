-- Active: 1732807506399@@127.0.0.1@3306@distribumax
USE distribumax;

-- todo reade papeto
DROP PROCEDURE IF EXISTS sp_registrar_venta;

CREATE PROCEDURE sp_registrar_venta(
    IN _idpedido            VARCHAR(15),
    IN _idusuario           INT,
    IN _idtipocomprobante   INT,
    IN _fecha_venta         DATETIME,
    IN _subtotal            DECIMAL(10, 2),
    IN _descuento           DECIMAL(10, 2),
    IN _igv                 DECIMAL(10, 2),
    IN _total_venta         DECIMAL(10, 2)
)
BEGIN
    DECLARE siguiente_comprobante VARCHAR(50);

    -- Validar la existencia de idpedido y idtipocomprobante
    IF NOT EXISTS (
        SELECT 1 FROM pedidos WHERE idpedido = _idpedido
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pedido proporcionado no existe.';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM tipo_comprobante_pago WHERE idtipocomprobante = _idtipocomprobante
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de comprobante proporcionado no existe.';
    END IF;

    -- Obtener el siguiente número de comprobante y almacenarlo en una variable local
    CALL obtener_siguiente_comprobante(_idtipocomprobante, siguiente_comprobante);

    -- Insertar la venta con el número de comprobante generado
    INSERT INTO ventas (
        idpedido, idusuario, idtipocomprobante, fecha_venta, 
        subtotal, descuento, igv, total_venta, numero_comprobante
    ) 
    VALUES (
        _idpedido, _idusuario, _idtipocomprobante, _fecha_venta, 
        _subtotal, _descuento, _igv, _total_venta, siguiente_comprobante
    );

    -- Devolver el ID de la venta insertada
    SELECT last_insert_id() AS idventa;
END;

-- ACTUALIZAR VENTAS

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
END;

SELECT * FROM ventas;
-- Nos permite ocultar las ventas ya que han sido realizadas
DROP PROCEDURE IF EXISTS sp_estado_venta;

CREATE PROCEDURE sp_estado_venta (
    IN _estado CHAR(1),
    IN _idventa INT
)
BEGIN
		DECLARE v_mensaje VARCHAR(50);
    -- Verificar si la venta tiene la condición 'Despachado'
    IF (SELECT condicion FROM ventas WHERE idventa = _idventa) = 'Despachado' THEN
        -- Actualizar el estado de la venta
        UPDATE ventas 
        SET estado = _estado,
            update_at = NOW()
        WHERE idventa = _idventa;

    END IF;

END;

-- TRIGGER PARA ACTUALIZAR EL ESTADO DE LA VENTA CUANDO SE CANCELA
DROP TRIGGER IF EXISTS after_venta_cancelada;

CREATE TRIGGER before_venta_cancelada
BEFORE UPDATE ON ventas
FOR EACH ROW
BEGIN
    -- Verificar si la condición de la venta es 'Cancelado' y la condición anterior no lo era
    IF NEW.condicion = 'Cancelado' AND OLD.condicion <> 'Cancelado' THEN
        -- Cambiar el estado a '0' antes de que se haga el UPDATE
        SET NEW.estado = '0';
    END IF;
END;

-- TRIGGER PARA ACTUALIZAR EL ESTADO DEL PEDIDO
DROP TRIGGER IF EXISTS trg_actualizar_estado_pedido;

CREATE TRIGGER trg_actualizar_estado_pedido
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET estado = 'Enviado',
       create_at=now()
    WHERE idpedido = NEW.idpedido 
      AND estado <> 'Enviado';  
END;

DROP PROCEDURE IF EXISTS sp_generar_reporte;

CREATE PROCEDURE sp_generar_reporte (
    IN _idventa INT
)
BEGIN
    -- Primera consulta: Detalles de la venta y productos
    SELECT 
        ve.idventa,
        ve.fecha_venta,
        ve.numero_comprobante,
        ve.igv,
        ve.total_venta,
        ve.subtotal AS sub_venta,
        tcp.comprobantepago,
        dp.precio_descuento,
        dp.cantidad_producto,
        dp.precio_unitario,
        dp.subtotal,
        pr.codigo,
        vh.marca_vehiculo,
        vh.placa,
        vh.modelo,
        per.perfil,
        us.idusuario,
        
        -- Concatenación para descripción detallada del producto
        CONCAT(pr.nombreproducto, ' ', dp.unidad_medida, ' ', pr.cantidad_presentacion, 'X', pr.peso_unitario) AS nombreproducto,
        cli.tipo_cliente,
        
        -- Cliente
        CASE 
            WHEN cli.tipo_cliente = 'empresa' THEN em.idempresaruc
            WHEN cli.tipo_cliente = 'persona' THEN pe.idpersonanrodoc
            ELSE 'Sin documento'
        END AS documento_cliente,
        CASE 
            WHEN cli.tipo_cliente = 'empresa' THEN UPPER(em.razonsocial)
            WHEN cli.tipo_cliente = 'persona' THEN UPPER(CONCAT(pe.appaterno, ' ', pe.apmaterno, ' ', pe.nombres))
            ELSE 'SIN DATOS'
        END AS nombre_cliente,
        CASE 
            WHEN cli.tipo_cliente = 'empresa' THEN em.direccion
            WHEN cli.tipo_cliente = 'persona' THEN pe.direccion
        END AS direccion,
        
        -- Datos de ubicación
        dis.distrito,
        pro.provincia,
        
        -- Información del chofer (persona asociada al chofer)
        CONCAT(pchofer.appaterno, ' ', pchofer.apmaterno, ' ', pchofer.nombres) AS chofer,
        pchofer.idpersonanrodoc AS documento_chofer

    FROM ventas ve
    INNER JOIN pedidos p ON p.idpedido = ve.idpedido
    INNER JOIN detalle_pedidos dp ON dp.idpedido = p.idpedido
    INNER JOIN productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN clientes cli ON cli.idcliente = p.idcliente
    LEFT JOIN personas pe ON pe.idpersonanrodoc = cli.idpersona
    LEFT JOIN empresas em ON em.idempresaruc = cli.idempresa
    LEFT JOIN distritos dis ON (pe.iddistrito = dis.iddistrito OR em.iddistrito = dis.iddistrito)
    LEFT JOIN provincias pro ON dis.idprovincia = pro.idprovincia
    LEFT JOIN tipo_comprobante_pago tcp ON tcp.idtipocomprobante = ve.idtipocomprobante
    LEFT JOIN despacho_ventas dv ON dv.idventa = ve.idventa
    LEFT JOIN despachos d ON d.iddespacho = dv.iddespacho
    LEFT JOIN vehiculos vh ON vh.idvehiculo = d.idvehiculo
    LEFT JOIN usuarios us ON us.idusuario = vh.idusuario
    LEFT JOIN perfiles per ON per.idperfil = us.idperfil
    LEFT JOIN personas pchofer ON pchofer.idpersonanrodoc = us.idpersona -- Relación del chofer con personas
    WHERE ve.idventa = _idventa
    AND ve.condicion = 'despachado'
    AND per.perfil = 'Chofer'
    GROUP BY pr.nombreproducto;
END ;

-- ?todo reade papeto
DROP PROCEDURE IF EXISTS `sp_listar_ventas`;

CREATE PROCEDURE `sp_listar_ventas`()
BEGIN
    SELECT 
        ve.idventa,
        ve.numero_comprobante,
        DATE(ve.fecha_venta)fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        cli.idpersona,
        cli.tipo_cliente,
        pr.nombreproducto,
        dp.cantidad_producto,
        dp.subtotal,
        CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno) AS datos,
        pe.idpersonanrodoc,
        em.razonsocial,
        em.idempresaruc,
        p.estado,
        CASE ve.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`,
        CASE 
            WHEN ve.condicion = 'Pendiente' THEN 'Pendiente'
            WHEN ve.condicion = 'Despachado' THEN 'Despachado'
            -- Puedes agregar más condiciones si es necesario
        END AS venta_estado,
        CASE 
            WHEN ve.condicion = 'Pendiente' THEN 'Cancelado'
            WHEN ve.condicion = 'Cancelado' THEN 'Pendiente'
            ELSE ve.condicion  -- Si no es Pendiente ni Cancelado, mantiene el valor actual
        END AS `status_venta`
    FROM 
        ventas ve
    INNER JOIN 
        pedidos p ON p.idpedido = ve.idpedido
    INNER JOIN 
        detalle_pedidos dp ON p.idpedido = dp.idpedido
    INNER JOIN 
        productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN 
        clientes cli ON cli.idcliente = p.idcliente
    LEFT JOIN 
        personas pe ON pe.idpersonanrodoc = cli.idpersona
    LEFT JOIN 
        empresas em ON em.idempresaruc = cli.idempresa
    LEFT JOIN 
        tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE 
        (p.estado = 'Enviado' OR p.estado = 'Entregado')
        AND (ve.condicion = 'Pendiente' OR ve.condicion='Despachado') -- Se filtra por ventas pendientes
        AND ve.estado = '1'  -- Solo ventas con estado 1
        AND DATE(ve.fecha_venta) = CURDATE()  -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END;

-- Todo reade papeto
DROP PROCEDURE IF EXISTS `sp_listar_fecha`;

CREATE PROCEDURE `sp_listar_fecha`(IN _fecha_venta DATE)
BEGIN
    SELECT 
        ve.idventa,
        ve.numero_comprobante,
        DATE(ve.fecha_venta)fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        cli.idpersona,
        cli.tipo_cliente,
        pr.nombreproducto,
        dp.cantidad_producto,
        dp.subtotal,
        CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno) AS datos,
        pe.idpersonanrodoc,
        em.razonsocial,
        em.idempresaruc,
         CASE ve.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`,
        CASE 
            WHEN ve.condicion = 'Pendiente' THEN 'Pendiente'
            WHEN ve.condicion = 'Despachado' THEN 'Despachado'
            -- Puedes agregar más condiciones si es necesario
        END AS venta_estado,
        CASE 
            WHEN ve.condicion = 'Pendiente' THEN 'Cancelado'
            WHEN ve.condicion = 'Cancelado' THEN 'Pendiente'
            ELSE ve.condicion  -- Si no es Pendiente ni Cancelado, mantiene el valor actual
        END AS `status_venta`
    FROM 
        ventas ve
    INNER JOIN 
        pedidos p ON p.idpedido = ve.idpedido
    INNER JOIN 
        detalle_pedidos dp ON p.idpedido = dp.idpedido
    INNER JOIN 
        productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN 
        clientes cli ON cli.idcliente = p.idcliente
    LEFT JOIN 
        personas pe ON pe.idpersonanrodoc = cli.idpersona
    LEFT JOIN 
        empresas em ON em.idempresaruc = cli.idempresa
    LEFT JOIN 
        tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE 
        (p.estado = 'Enviado' OR p.estado = 'Entregado' OR ve.condicion='Pendiente') -- Agrupamos con paréntesis
    AND 
        ve.estado = '1'
    AND 
        DATE(ve.fecha_venta) = _fecha_venta -- Comparar solo fechas
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END;

-- listar ventas historial
DROP PROCEDURE IF EXISTS `sp_historial_ventas`;

CREATE PROCEDURE `sp_historial_ventas`()
BEGIN
    SELECT 
        ve.idventa,
        ve.numero_comprobante,
        DATE(ve.fecha_venta)fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        cli.idpersona,
        cli.tipo_cliente,
        pr.nombreproducto,
        dp.cantidad_producto,
        dp.subtotal,
        CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno) AS datos,
        pe.idpersonanrodoc,
        em.razonsocial,
        em.idempresaruc,
        CASE ve.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        ve.condicion
    FROM 
        ventas ve
    INNER JOIN 
        pedidos p ON p.idpedido = ve.idpedido
    INNER JOIN 
        detalle_pedidos dp ON p.idpedido = dp.idpedido
    INNER JOIN 
        productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN 
        clientes cli ON cli.idcliente = p.idcliente
    LEFT JOIN 
        personas pe ON pe.idpersonanrodoc = cli.idpersona
    LEFT JOIN 
        empresas em ON em.idempresaruc = cli.idempresa
    LEFT JOIN 
        tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE 
        
          ve.estado='0'
        
       -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END ;

--  TODO: PROCEDIMIENTO PARA OBTENER UNA VENTA POR ID
DROP PROCEDURE IF EXISTS `sp_getById_venta`;

CREATE PROCEDURE `sp_getById_venta` (IN _idventa   INT)
BEGIN 
	SELECT 
			ve.idventa,
			pr.nombreproducto,
			dp.cantidad_producto,
			dp.unidad_medida,
			cl.tipo_cliente,
            ve.subtotal,
	CONCAT( per.nombres,' ',per.appaterno ) AS datos,
			em.razonsocial
	FROM ventas ve
	INNER JOIN pedidos pe ON pe.idpedido = ve.idpedido
	LEFT JOIN clientes cl ON  cl.idcliente=pe.idcliente 
	LEFT JOIN personas per ON per.idpersonanrodoc=cl.idpersona
	LEFT JOIN empresas em ON em.idempresaruc=cl.idempresa
	LEFT JOIN  detalle_pedidos dp ON dp.idpedido = pe.idpedido
	LEFT JOIN productos pr ON pr.idproducto = dp.idproducto
	WHERE ve.idventa = _idventa;
END;

-- buscar un pedido o seleccionar todos
DROP PROCEDURE IF EXISTS sp_buscar_venta;

CREATE PROCEDURE sp_buscar_venta(IN _item INT)
BEGIN
    SELECT 
        VE.idventa,
        VE.idpedido,
        VE.fecha_venta,
        VE.subtotal,
        PO.nombreproducto,
        DP.cantidad_producto,
        DP.unidad_medida,
        DP.precio_unitario,
        VE.descuento,
        VE.total_venta,
        VE.igv,
        VE.estado
    FROM ventas VE
    LEFT JOIN pedidos PE ON PE.idpedido = VE.idventa
    LEFT JOIN detalle_pedidos DP ON DP.idpedido = VE.idpedido
    LEFT JOIN productos PO ON PO.idproducto = DP.idproducto
    WHERE 
        (VE.idpedido LIKE CONCAT('%', _item, '%') OR 
        PE.idpedido LIKE CONCAT('%', _item, '%'))
    AND DATE(VE.fecha_venta) = CURDATE() 
    AND VE.estado = '1';
END;

-- TODO: PROCEDIMIENTO PARA OBTENER LAS VENTAS POR PROVINCIA (ZONA DE DISTRIBUCIÓN)

DROP PROCEDURE IF EXISTS sp_getventas;

CREATE PROCEDURE sp_getventas(IN _provincia VARCHAR(100))
BEGIN
    SELECT
        VE.idventa,
        VE.fecha_venta,
        PO.idproducto,
        PRO.idempresa,
        PO.codigo,
        CONCAT(PO.nombreproducto,'-',UNM.unidadmedida,' ',PO.cantidad_presentacion, 'X', PO.peso_unitario) AS producto,
        UNM.unidadmedida,
        SUM(DP.cantidad_producto) AS cantidad_producto,
        SUM(VE.total_venta) AS total_venta_producto,
        PROV.provincia AS zona,
        VE.condicion
    FROM ventas VE
    LEFT JOIN pedidos PE ON PE.idpedido = VE.idpedido
    LEFT JOIN detalle_pedidos DP ON DP.idpedido = PE.idpedido
    LEFT JOIN productos PO ON PO.idproducto = DP.idproducto
    LEFT JOIN unidades_medidas UNM ON UNM.idunidadmedida = PO.idunidadmedida
    LEFT JOIN clientes CLI ON CLI.idcliente = PE.idcliente
    LEFT JOIN personas PERS ON PERS.idpersonanrodoc = CLI.idpersona
    LEFT JOIN empresas EMP ON EMP.idempresaruc = CLI.idempresa
    LEFT JOIN distritos DIS ON DIS.iddistrito = COALESCE(PERS.iddistrito, EMP.iddistrito)
    LEFT JOIN provincias PROV ON PROV.idprovincia = DIS.idprovincia
    LEFT JOIN proveedores PRO ON PRO.idproveedor = PO.idproveedor
    WHERE (
        (_provincia IS NULL OR _provincia = '')
        OR PROV.provincia LIKE CONCAT('%', _provincia, '%')
    )
    AND VE.condicion = 'pendiente'
    GROUP BY 
        VE.idventa,
        PO.idproducto,
        PO.codigo,
        PO.nombreproducto,
        UNM.unidadmedida,
        PROV.provincia,
        VE.condicion
    ORDER BY 
        PROV.provincia,
        PO.nombreproducto;
END;

-- CALL sp_getventas ('chincha');

-- TODO: LISTAR LAS PROVINCIAS DONDE LAS VENTAS ESTE PENDIENTES

DROP PROCEDURE IF EXISTS sp_getListProvinciaVentas;

CREATE PROCEDURE sp_getListProvinciaVentas()
BEGIN
    SELECT 
        PROV.provincia

    FROM ventas VE
    INNER JOIN pedidos PE ON PE.idpedido = VE.idpedido
    INNER JOIN detalle_pedidos DP ON DP.idpedido = PE.idpedido
    INNER JOIN productos PO ON PO.idproducto = DP.idproducto
    INNER JOIN clientes CLI ON CLI.idcliente = PE.idcliente
    INNER JOIN personas PERS ON PERS.idpersonanrodoc = CLI.idpersona
    INNER JOIN distritos DIS ON DIS.iddistrito = PERS.iddistrito
    INNER JOIN provincias PROV ON PROV.idprovincia = DIS.idprovincia
    WHERE VE.condicion = 'Pendiente'
      AND  VE.estado='1'
      AND CURDATE() = DATE(VE.fecha_venta)
    GROUP BY 
        PROV.provincia
    HAVING 
        COUNT(VE.idventa) > 0
    ORDER BY 
        PROV.provincia;
END;

CALL sp_getListProvinciaVentas ();

DROP PROCEDURE IF EXISTS sp_getListProvinciaVentas;

CREATE PROCEDURE sp_getListProvinciaVentas()
BEGIN
    SELECT 
        PROV.provincia
    FROM ventas VE
    INNER JOIN pedidos PE ON PE.idpedido = VE.idpedido
    INNER JOIN clientes CLI ON CLI.idcliente = PE.idcliente
    LEFT JOIN personas PERS ON PERS.idpersonanrodoc = CLI.idpersona
    LEFT JOIN empresas EMP ON EMP.idempresaruc = CLI.idempresa
    INNER JOIN distritos DIS ON DIS.iddistrito = COALESCE(PERS.iddistrito, EMP.iddistrito)
    INNER JOIN provincias PROV ON PROV.idprovincia = DIS.idprovincia
    WHERE VE.condicion = 'pendiente'
    AND  VE.estado='1'
    GROUP BY 
        PROV.provincia
    HAVING 
        COUNT(VE.idventa) > 0
    ORDER BY 
        PROV.provincia;
END;

DROP PROCEDURE IF EXISTS sp_Ventastotales;

CREATE PROCEDURE sp_Ventastotales()
BEGIN
    SELECT 
        DATE(ve.fecha_venta) AS fecha,
        COUNT(*) AS total_ventas_realizadas,
        SUM(ve.total_venta) AS monto_realizado
    FROM ventas ve
    WHERE ve.estado = '1'
    GROUP BY DATE(ve.fecha_venta);
END;

-- con filtro
DROP PROCEDURE IF EXISTS sp_VentasPorDia;

CREATE PROCEDURE sp_VentasPorDia(
    IN _fecha DATE
    )
BEGIN
    DECLARE _mensaje VARCHAR(50);
    DECLARE _total INT;

    -- Contar el número de registros para la fecha especificada
    SELECT COUNT(*) INTO _total
    FROM ventas ve
    WHERE DATE(ve.fecha_venta) = _fecha AND ve.estado = '1';

    -- Verificar si hay registros
    IF _total = 0 THEN
        SET _mensaje = 'No hay ventas de esta fecha';
        SELECT _mensaje AS mensaje;
    ELSE
        SELECT 
            DATE(ve.fecha_venta) AS fecha,
            COUNT(*) AS total_ventas_realizadas,
            SUM(ve.total_venta) AS monto_realizado
        FROM ventas ve
        WHERE DATE(ve.fecha_venta) = _fecha AND ve.estado = '1'
        GROUP BY DATE(ve.fecha_venta);
    END IF;
END ;

DROP PROCEDURE IF EXISTS sp_contar_ventas;

CREATE PROCEDURE sp_contar_ventas()
BEGIN
    SELECT 
        COALESCE(SUM(CASE WHEN condicion = 'despachado' THEN 1 ELSE 0 END),0) AS despachados,
        COALESCE((CASE WHEN condicion = 'Pendiente' THEN 1 ELSE 0 END),0) AS pendientes,
        COALESCE(SUM(CASE WHEN condicion='Cancelado'  THEN 1 ELSE 0 END),0) AS cancelados
    FROM ventas
    WHERE DATE(fecha_venta) = CURDATE();
END ;

-- -//REVIEW: --TODO     ESTOS PROCEDIMIENTOS CANCELAN UNA VENTA ESTS EN ETAPA DE DESARROLLO------------------------------------------------------

-- -// FIXME : --!PROCEDIMIENTO PARA CANCELAR LA VENTA POR COMPLETO
DROP PROCEDURE IF EXISTS `sp_condicion_venta`;
CREATE PROCEDURE `sp_condicion_venta`(
    IN _condicion VARCHAR(50),  -- Recibe la nueva condición
    IN _idventa INT,
    IN _idpedido CHAR(15)           -- ID de la venta a modificar
)
BEGIN
    -- VARIBLES
    DECLARE v_mensaje VARCHAR(150);
    DECLARE v_estado_get BIT;

    -- Si la nueva condición es "cancelado"
    IF _condicion = 'Cancelado' THEN

        -- -//REVIEW  Esta funcion se encarga de obtener el detalle del pedido y almacenarlo en una tabla temporal y luego actualizar el stock de los productos
        CALL sp_cancelar_pedido_venta(_idpedido);

        -- Actualizar la condición de la venta
        UPDATE ventas
        SET condicion = _condicion,
            estado = 0,
            update_at = NOW()
        WHERE idventa = _idventa;

        SET v_mensaje = 'Venta cancelada correctamente';
        SET v_estado_get = 1;
    ELSE
        SET v_mensaje = 'La venta ya ha sido cancelada';
        SET v_estado_get = 0;
    END IF;

        -- Devolver el mensaje y el estado
        SELECT v_mensaje AS mensaje, v_estado_get AS estado;
END;

-- call sp_condicion_venta('Cancelado', 1, 'PED-000000001');

-- - //FIXME : -- TODO : PROCEDIMIENTO PARA CANCELAR UNA VENTA Y DEVOLVER LOS PRODUCTOS AL STOCK
DROP PROCEDURE IF EXISTS sp_cancelar_pedido_venta;
CREATE PROCEDURE sp_cancelar_pedido_venta(IN _idpedido CHAR(15))
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
    FROM temp_detalle_pedido_venta;

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
            update_at=now()
        WHERE idpedido = _idpedido AND estado != 'Cancelado';

    -- Llamar al procedimiento para obtener el detalle del pedido
    CALL sp_obtener_detalle_pedido_venta(_idpedido);

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
            update_at=now() 
        WHERE id_detalle_pedido = _id_detalle_pedido;
    

        -- Obtener el stock actual del producto
        SELECT COALESCE(SUM(LOT.stockactual), 0) INTO v_stock_actual
        FROM lotes LOT
        WHERE LOT.idproducto = _idproducto;

        -- SELECT v_stock_actual;


        INSERT INTO kardex (idusuario, idproducto, idpedido,idlote,stockactual,tipomovimiento,cantidad,motivo)
        VALUES (1, _idproducto, _idpedido, _idlote, v_stock_actual, 'Ingreso', _cantidad, 'Venta cancelada');
    
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;
        SET v_mensaje = 'Venta cancelada correctamente';
        SET v_estado_get = 1;
    END IF;
    -- Limpiar la tabla temporal
    DELETE FROM temp_detalle_pedido_venta WHERE idpedido = _idpedido;

    -- Devolver el mensaje
    -- SELECT v_mensaje AS mensaje, v_estado_get AS estado;
END;


-- -//REVIEW --TODO: CREAMOS UNA FUNCION PARA OBTENER EL DETALLE DEL PEDIDO
DROP PROCEDURE IF EXISTS sp_obtener_detalle_pedido_venta;
CREATE PROCEDURE sp_obtener_detalle_pedido_venta(
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
        INSERT INTO temp_detalle_pedido_venta (idpedido, id_detalle_pedido,idproducto, idlote, cantidad)
        VALUES (v_idpedido, _id_detalle_pedido, _idproducto,_idlote, _cantidad);
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;
END;

-- CALL sp_obtener_detalle_pedido_venta ('PED-000000002');

-- -//REVIEW : Crear una tabla temporal para almacenar los resultados
DROP TABLE IF EXISTS temp_detalle_pedido_venta;

CREATE TABLE temp_detalle_pedido_venta (
    idpedido CHAR(15),
    id_detalle_pedido INT,
    idproducto INT,
    idlote INT,
    cantidad INT
);

SELECT * FROM temp_detalle_pedido_venta;
-- call sp_cancelar_pedido_venta('PED-000000002');