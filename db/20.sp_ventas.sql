-- Active: 1726698325558@@127.0.0.1@3306@distribumax
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

-- aun falta el idlote, ya que cuando tiene dos lotes hace
-- realiza una duplicida.
DROP PROCEDURE IF EXISTS `sp_estado_venta`;

CREATE PROCEDURE `sp_estado_venta`(
    IN _estado CHAR(1),
    IN _idventa INT
)
BEGIN
    -- Declarar las variables necesarias
    DECLARE _idproducto INT;
    DECLARE _idlote INT;
    DECLARE _cantidad INT;
    DECLARE _idusuario INT;
    DECLARE done INT DEFAULT 0;
    DECLARE _idpedido CHAR(15);

    -- Declarar el cursor para iterar sobre los productos del pedido relacionado con la venta
    DECLARE cur CURSOR FOR
    SELECT 
        pr.idproducto,
        dp.cantidad_producto,
        ve.idusuario,
        lt.idlote
    FROM detalle_pedidos dp
    LEFT JOIN pedidos p ON dp.idpedido = p.idpedido
    LEFT JOIN ventas ve ON ve.idpedido = p.idpedido
    LEFT JOIN productos pr ON pr.idproducto = dp.idproducto
    LEFT JOIN lotes lt ON lt.idproducto = pr.idproducto
    WHERE p.idpedido = _idpedido;

			-- Declarar un handler para controlar el fin del cursor
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

			-- Asignar el idpedido relacionado con la venta (esto va al principio)
			SELECT idpedido INTO _idpedido
			FROM ventas
			WHERE idventa = _idventa;

			-- Actualizar el estado de la venta
			UPDATE ventas SET
					estado = _estado,
					update_at = NOW()
			WHERE idventa = _idventa;

    -- Si el estado es "pendiente"
    IF _estado = '1' THEN
        -- Actualizar el pedido relacionado a "Enviado"
        UPDATE pedidos SET
            estado = 'Enviado',
            update_at = NOW()
        WHERE idpedido = _idpedido;

        -- Abrir el cursor
        OPEN cur;

        -- Iterar sobre los productos del pedido
        read_loop: LOOP
            FETCH cur INTO _idproducto, _cantidad, _idusuario, _idlote;

            -- Salir del bucle si no hay más filas
            IF done = 1 THEN
                LEAVE read_loop;
            END IF;

            -- Registrar el movimiento en el kardex para retirar los productos
            CALL sp_registrarmovimiento_kardex(
                _idusuario,
                _idproducto,
                _idlote,
                'Salida',
                _cantidad,
                'Venta Enviada'
            );
        END LOOP;

        -- Cerrar el cursor
        CLOSE cur;
    END IF;

			-- Si el estado es "cancelado"
			IF _estado = '0' THEN
					-- Actualizar el pedido relacionado a "Cancelado"
					UPDATE pedidos SET
							estado = 'Cancelado',
							update_at = NOW()
					WHERE idpedido = _idpedido;

					-- Abrir el cursor
					OPEN cur;

					-- Iterar sobre los productos del pedido
					read_loop: LOOP
							FETCH cur INTO _idproducto, _cantidad, _idusuario, _idlote;

							-- Salir del bucle si no hay más filas
							IF done = 1 THEN
									LEAVE read_loop;
							END IF;

            -- Registrar el movimiento en el kardex para ingresar los productos
            CALL sp_registrarmovimiento_kardex(
                _idusuario,
                _idproducto,
                _idlote,
                'Ingreso',
                _cantidad,
                'Venta Cancelada'
            );
        END LOOP;

					-- Cerrar el cursor
					CLOSE cur;
			END IF;
END;


-- TRIGGER PARA ACTUALIZAR EL ESTADO DEL PEDIDO
CREATE TRIGGER trg_actualizar_estado_pedido
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET estado = 'Enviado'
    WHERE idpedido = NEW.idpedido 
      AND estado <> 'Enviado';  
END;


-- DROP TRIGGER IF EXISTS trg_verificar_fecha_despacho;
-- CREATE TRIGGER trg_verificar_fecha_despacho
-- BEFORE INSERT ON despachos
-- FOR EACH ROW
-- BEGIN
--     DECLARE fecha_actual DATE;
--     SET fecha_actual = CURDATE();

--     IF NEW.fecha_despacho < fecha_actual THEN
--         SIGNAL SQLSTATE '45000'
--         SET MESSAGE_TEXT = 'La fecha de despacho no puede ser menor a la fecha actual';
--     END IF;
-- END;

-- GENERAR REPORTE
DROP PROCEDURE IF EXISTS  `sp_generar_reporte`;

CREATE PROCEDURE `sp_generar_reporte` ( 
    IN _idventa INT
)
BEGIN
    SELECT   ve.idventa,
        ve.fecha_venta,
        ve.numero_comprobante,
        p.idpedido,
        tp.comprobantepago,
        pr.codigo,
        ve.igv,
        ve.total_venta,
        ve.subtotal AS sub_venta,

        -- Tipo de cliente
        cli.tipo_cliente AS cliente,

        -- Documento del cliente dependiendo del tipo
        CASE 
            WHEN cli.tipo_cliente = 'empresa' THEN em.idempresaruc
            WHEN cli.tipo_cliente = 'persona' THEN pe.idpersonanrodoc
            ELSE 'Sin documento'
        END AS documento_cliente,

        -- Nombre del cliente con mayúsculas
        CASE 
            WHEN cli.tipo_cliente = 'empresa' THEN UPPER(em.razonsocial)
            WHEN cli.tipo_cliente = 'persona' THEN UPPER(CONCAT(pe.appaterno, ' ', pe.apmaterno, ' ', pe.nombres))
            ELSE 'SIN DATOS'
        END AS nombre_cliente,

        CASE 
            WHEN cli.tipo_cliente = 'empresa' THEN em.direccion
            WHEN cli.tipo_cliente = 'persona' THEN pe.direccion
        END AS direccion,    

        -- Detalle del producto
        pr.nombreproducto,
        dp.precio_unitario,
        dp.cantidad_producto,

        -- Modificación en la unidad de medida
        CASE 
            WHEN dp.unidad_medida = 'caja' THEN 'cj'
            WHEN dp.unidad_medida = 'bolsa' THEN 'bl'
            WHEN dp.unidad_medida = 'unidad' THEN 'un'
            WHEN dp.unidad_medida = 'paquete' THEN 'pq'
            ELSE dp.unidad_medida  -- En caso de que haya una unidad no reconocida
        END AS unidad_medida,

        dp.precio_descuento,
        dp.subtotal

    FROM ventas ve
        INNER JOIN pedidos p ON p.idpedido = ve.idpedido
        INNER JOIN detalle_pedidos dp ON p.idpedido = dp.idpedido
        INNER JOIN productos pr ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em ON em.idempresaruc = cli.idempresa
        LEFT JOIN tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante

    WHERE ve.idventa = _idventa
    AND (p.estado = 'Enviado' OR p.estado = 'Entregado');
   
END;



-- ?todo reade papeto
DROP PROCEDURE IF EXISTS `sp_listar_ventas`;

CREATE PROCEDURE `sp_listar_ventas`()
BEGIN
    SELECT 
        ve.idventa,
        ve.fecha_venta,
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
        p.estado = 'Enviado'
    OR
        P.estado = 'Entregado'

    OR 
    ve.condicion ='Pendiente'
	AND 
    ve.estado='1'
    AND   
      DATE(ve.fecha_venta) = CURDATE()  -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END ;


-- Todo reade papeto
DROP PROCEDURE IF EXISTS `sp_listar_fecha`;
CREATE PROCEDURE `sp_listar_fecha`(IN _fecha_venta DATE)
BEGIN
    SELECT 
        ve.idventa,
        ve.fecha_venta,
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
        ve.fecha_venta,
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
        CASE ve.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`
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

CALL sp_getventas ('chincha');

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
    WHERE VE.condicion = 'pendiente'
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
CREATE PROCEDURE sp_VentasPorDia(IN _fecha DATE)
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