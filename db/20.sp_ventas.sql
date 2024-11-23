-- Active: 1728956418931@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR VENTAS
DROP PROCEDURE IF EXISTS `sp_registrar_venta`;

CREATE PROCEDURE `sp_registrar_venta`(
    IN _idpedido            VARCHAR(15),
    IN _idtipocomprobante   INT,
    IN _fecha_venta         DATETIME,
    IN _subtotal            DECIMAL(10, 2),
    IN _descuento           DECIMAL(10, 2),
    IN _igv                 DECIMAL(10, 2),
    IN _total_venta         DECIMAL(10, 2)

)
BEGIN
    INSERT INTO ventas 
    (idpedido, idtipocomprobante,fecha_venta, subtotal, descuento, igv,total_venta) 
    VALUES
    (_idpedido,_idtipocomprobante,_fecha_venta,_subtotal, _descuento,_igv,_total_venta);
    SELECT  last_insert_id() AS idventa;
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


-- ESTADO VENTAS
DROP PROCEDURE IF EXISTS `sp_estado_venta`;

CREATE PROCEDURE `sp_estado_venta`(
    IN _estado CHAR(1),
    IN _idventa INT
)
BEGIN
    -- Actualizar el estado de la venta
    UPDATE ventas SET
        estado = _estado,
        update_at = NOW()
    WHERE idventa = _idventa;

    -- Verificar si el estado de la venta es '0' (cancelado)
    IF _estado = '0' THEN
        -- Actualizar el estado del pedido relacionado a 'Cancelado'
        UPDATE pedidos SET
            estado = 'Cancelado',
            update_at = NOW()
       WHERE idpedido = (SELECT idpedido FROM ventas WHERE idventa = _idventa);
    END IF;
END;

-- Trigger que devolvera los productos al kardex

DROP TRIGGER IF EXISTS after_cancelar_venta;

-- CREATE TRIGGER after_cancelar_venta
-- AFTER UPDATE ON ventas
-- FOR EACH ROW
-- BEGIN
--     DECLARE done INT DEFAULT 0;
--     DECLARE _idproducto INT;
--     DECLARE _idusuario  INT,
--     DECLARE _cantidad INT;

--     -- Declara el cursor
--     DECLARE cur CURSOR FOR 
--         SELECT idproducto, cantidad_producto
--         FROM detalle_pedidos
--         WHERE idpedido = NEW.idpedido;

--     -- Manejo del final del cursor
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

--     -- Solo ejecuta si el estado es cancelado
--     IF NEW.estado = '0' THEN
--         OPEN cur;

--         read_loop: LOOP
--             FETCH cur INTO _idproducto, _cantidad;
--             IF done THEN
--                 LEAVE read_loop;
--             END IF;

--             -- Llama al procedimiento para registrar el movimiento
--             CALL sp_registrarmovimiento_kardex(1, _idproducto, 0,'', 'Ingreso', _cantidad, 'Venta Cancelada');
--         END LOOP;

--         CLOSE cur;
--     END IF;
-- END ;
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



-- GENERAR REPORTE
DROP PROCEDURE IF EXISTS `sp_generar_reporte`;

CREATE PROCEDURE `sp_generar_reporte` ( 
    IN _idventa INT
)
BEGIN
    SELECT 
        ve.idventa,
        ve.fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        pr.codigo,
        ve.igv,
        ve.total_venta,
        ve.subtotal as sub_venta,
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

    WHERE p.estado = 'Enviado' AND ve.idventa = _idventa;
END;


select * from detalle_pedidos;
select * from ventas;
select * from unidades_medidas;

-- LISTAR VENTAS DEL DIA
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
        em.idempresaruc
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
	AND ve.estado='1'
        -- AND DATE(ve.fecha_venta) = CURDATE()  -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END ;

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
        ve.estado
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



DROP PROCEDURE IF EXISTS `sp_getById_venta`;

CREATE PROCEDURE `sp_getById_venta`
(
	IN _idventa   INT
)
BEGIN 
SELECT 
    ve.idventa,
    pr.nombreproducto,
    dp.cantidad_producto,
    dp.unidad_medida,
    cl.tipo_cliente,
   CONCAT( per.nombres,' ',per.appaterno ) AS datos,
    em.razonsocial
FROM 
    ventas ve
INNER JOIN 
    pedidos pe ON pe.idpedido = ve.idpedido
LEFT JOIN 
	clientes cl ON  cl.idcliente=pe.idcliente 
LEFT JOIN
	personas per ON per.idpersonanrodoc=cl.idpersona
LEFT JOIN 
	empresas em ON em.idempresaruc=cl.idempresa
LEFT JOIN  
    detalle_pedidos dp ON dp.idpedido = pe.idpedido
LEFT JOIN 
    productos pr ON pr.idproducto = dp.idproducto

-- Relaciona con la columna idproducto en detalle_pedidos
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
    FROM 
        ventas VE
    LEFT JOIN 
        pedidos PE ON PE.idpedido = VE.idventa
    LEFT JOIN 
        detalle_pedidos DP ON DP.idpedido = VE.idpedido
    LEFT JOIN 
        productos PO ON PO.idproducto = DP.idproducto
    WHERE 
        (VE.idpedido LIKE CONCAT('%', _item, '%') OR 
         PE.idpedido LIKE CONCAT('%', _item, '%'))
        AND DATE(VE.fecha_venta) = CURDATE() 
        AND VE.estado = '1';
END;

-- DROP PROCEDURE IF EXISTS sp_getventas;

-- CREATE PROCEDURE sp_getventas(IN _provincia VARCHAR(100))
-- BEGIN
--     -- Consulta con validación para el parámetro _provincia
--     SELECT VE.idventa, VE.idpedido, VE.fecha_venta, VE.subtotal,
--             CLI.idpersona, CLI.idempresa,
--            PO.nombreproducto, DP.cantidad_producto, DP.precio_unitario, VE.total_venta, 
--            VE.igv, VE.descuento, VE.estado,
--            PROV.provincia-- Provincia del cliente
--     FROM ventas VE
--     LEFT JOIN pedidos PE ON PE.idpedido = VE.idpedido
--     LEFT JOIN clientes CLI ON CLI.idcliente = PE.idcliente
--     LEFT JOIN personas PERS ON PERS.idpersonanrodoc = CLI.idpersona
--     LEFT JOIN distritos DIS ON DIS.iddistrito = PERS.iddistrito
--     LEFT JOIN provincias PROV ON PROV.idprovincia = DIS.idprovincia  -- Provincia del cliente
--     LEFT JOIN detalle_pedidos DP ON DP.idpedido = VE.idpedido
--     LEFT JOIN productos PO ON PO.idproducto = DP.idproducto
--     LEFT JOIN empresas EMP ON EMP.idempresaruc=CLI.idempresa
--     WHERE (   (_provincia IS NULL OR _provincia = '')  -- Si _provincia está vacío o es NULL, no aplicamos el filtro
--            OR PROV.provincia LIKE CONCAT('%', _provincia, '%') )  
--           AND VE.condicion = 'pendiente';
-- END;


DROP PROCEDURE IF EXISTS sp_getventas;
CREATE PROCEDURE sp_getventas(IN _provincia VARCHAR(100))
BEGIN
    -- Consulta para obtener ventas filtradas por provincia
    SELECT 
        DE.iddetalledespacho,
        DE.iddespacho,
        DE.idventa,
        DE.create_at,
        VE.fecha_venta,
        CL.tipo_cliente,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        DIS.distrito,
        PRO.provincia
    FROM despacho_ventas DE
    INNER JOIN ventas VE ON VE.idventa = DE.idventa
    LEFT JOIN pedidos PE ON PE.idpedido = VE.idpedido
    LEFT JOIN clientes CL ON CL.idcliente = PE.idcliente
    LEFT JOIN personas PER ON PER.idpersonanrodoc = CL.idpersona
    LEFT JOIN distritos DIS ON DIS.iddistrito = PER.iddistrito
    LEFT JOIN provincias PRO ON PRO.idprovincia = DIS.idprovincia
    WHERE PRO.provincia LIKE CONCAT('%', _provincia, '%')
    AND VE.condicion='pendiente';
END;





