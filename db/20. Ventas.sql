-- Active: 1726291702198@@localhost@3306@distribumax
USE distribumax;

-- REGISTRAR VENTAS
DELIMITER $$
CREATE PROCEDURE sp_registrar_venta(
    IN _idpedido            VARCHAR(15),
    IN _idmetodopago        INT,
    IN _idtipocomprobante   INT,
    IN _fecha_venta         DATETIME,
    IN _subtotal            DECIMAL(10, 2),
    IN _descuento           DECIMAL(10, 2),
    IN _igv                 DECIMAL(10, 2),
    IN _total_venta         DECIMAL(10, 2)  
)
BEGIN
    INSERT INTO ventas 
    (idpedido, idmetodopago, idtipocomprobante,fecha_venta, subtotal, descuento, igv,total_venta) 
    VALUES
    (_idpedido, _idmetodopago, _idtipocomprobante,_fecha_venta, _subtotal, _descuento, _igv,_total_venta); 
END$$


-- CALL sp_registrar_venta('PED-000000009', 1, 1, NOW(), 100.00, 10.00, 18.00, 108.00);
-- SELECT * FROM ventas INNER JOIN  pedidos  on ventas.idpedido=pedidos.idpedido;
-- ACTUALIZAR VENTAS
DELIMITER $$
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
END$$


-- ESTADO VENTAS
DROP PROCEDURE IF EXISTS `sp_estado_venta`;
DELIMITER //
CREATE PROCEDURE `sp_estado_venta`(
    IN  _estado CHAR(1),
    IN  _idventa INT 
)
BEGIN
    UPDATE ventas SET
        estado=_estado,
        update_at=now()
        WHERE idventa=_idventa;
END//


-- Cambiar el estado del pedido al registrarlo
DELIMITER $$
CREATE TRIGGER trg_actualizar_estado_pedido
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET estado = 'Enviado'
    WHERE idpedido = NEW.idpedido 
      AND estado <> 'Enviado';  
END$$



-- GENERAR REPORTE
DELIMITER //
CREATE PROCEDURE sp_generar_reporte ( 
	IN _idventa INT
)
BEGIN
    -- Input validation can be added here if needed
    SELECT 
        ve.idventa,
        ve.fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        cli.idpersona,
        cli.idempresa,
        cli.tipo_cliente,
        pe.nombres,
        pe.appaterno,
        pe.apmaterno,
        em.razonsocial,
        us.idusuario,
        us.nombre_usuario,
        pr.nombreproducto ,
      --  GROUP_CONCAT(pr.preciounitario SEPARATOR ', ') AS precios_unitarios,
        dp.cantidad_producto,
        dp.unidad_medida,
        dp.precio_descuento,
        GROUP_CONCAT(dp.subtotal SEPARATOR ', ') AS subtotales
    FROM ventas ve
        INNER JOIN pedidos p ON p.idpedido = ve.idpedido
        INNER JOIN detalle_pedidos dp ON p.idpedido = dp.idpedido
        INNER JOIN productos pr ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em ON em.idempresaruc = cli.idempresa
        LEFT JOIN usuarios us ON us.idusuario=pe.idpersonanrodoc
          LEFT JOIN 
        tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE p.estado = 'Enviado' AND ve.idventa = _idventa
    
    GROUP BY p.idpedido, cli.idpersona, cli.idempresa, cli.tipo_cliente, pe.nombres, pe.appaterno, pe.apmaterno, em.razonsocial;
END//


-- LISTAR VENTAS DEL DIA
DROP PROCEDURE IF EXISTS `sp_listar_ventas`;
DELIMITER //
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
        AND DATE(ve.fecha_venta) = CURDATE()  -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END //


-- listar ventas historial 
DROP PROCEDURE IF EXISTS `sp_historial_ventas`;
DELIMITER //
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
        p.estado = 'Enviado' AND ve.estado='0'
        
       -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END //

select * from  ventas;

DROP PROCEDURE IF EXISTS `sp_getById_venta`;
DELIMITER //
CREATE PROCEDURE `sp_getById_venta`
(
	IN _idventa   INT
)
BEGIN 
SELECT 
    ve.idventa,
    pr.nombreproducto,
    dp.cantidad_producto,
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
WHERE ve.idventa=_idventa;

END //


