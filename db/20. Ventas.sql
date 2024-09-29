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
END$$

-- ESTADO VENTAS

CREATE PROCEDURE sp_estado_venta(
    IN  _estado CHAR(1),
    IN  _idventa INT 
)
BEGIN
    UPDATE ventas SET
        estado=_estado
        WHERE idventa=_idventa;
END$$ 

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


-- View para listar tables 
DROP PROCEDURE IF EXISTS sp_generar_reporte;
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
        cli.idpersona,
        cli.idempresa,
        cli.tipo_cliente,
        pe.nombres,
        pe.appaterno,
        pe.apmaterno,
        em.razonsocial,
        us.idusuario,
        us.nombre_usuario,
        GROUP_CONCAT(pr.nombreproducto SEPARATOR ', ') AS productos,
        GROUP_CONCAT(pr.preciounitario SEPARATOR ', ') AS precios_unitarios,
        GROUP_CONCAT(dp.cantidad_producto SEPARATOR ', ') AS cantidades,
        GROUP_CONCAT(dp.unidad_medida SEPARATOR ', ') AS unidades_medida,
        GROUP_CONCAT(dp.precio_descuento SEPARATOR ', ') AS descuentos,
        GROUP_CONCAT(dp.subtotal SEPARATOR ', ') AS subtotales
    FROM ventas ve
        INNER JOIN pedidos p ON p.idpedido = ve.idpedido
        INNER JOIN detalle_pedidos dp ON p.idpedido = dp.idpedido
        INNER JOIN productos pr ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em ON em.idempresaruc = cli.idempresa
        LEFT JOIN usuarios us ON us.idusuario=pe.idpersonanrodoc
    WHERE p.estado = 'Enviado' AND ve.idventa = _idventa
    GROUP BY p.idpedido, cli.idpersona, cli.idempresa, cli.tipo_cliente, pe.nombres, pe.appaterno, pe.apmaterno, em.razonsocial;
END//

CALL sp_generar_reporte(3);

-- listar ventas
SELECT 
        ve.idventa,
        ve.fecha_venta,
        p.idpedido,
        cli.idpersona,
        cli.idempresa,
        cli.tipo_cliente,
        pe.nombres,
        pe.appaterno,
        pe.apmaterno,
        em.razonsocial,
        GROUP_CONCAT(pr.nombreproducto SEPARATOR ', ') AS productos,
        GROUP_CONCAT(pr.preciounitario SEPARATOR ', ') AS precios_unitarios,
        GROUP_CONCAT(dp.cantidad_producto SEPARATOR ', ') AS cantidades,
        GROUP_CONCAT(dp.unidad_medida SEPARATOR ', ') AS unidades_medida,
        GROUP_CONCAT(dp.precio_descuento SEPARATOR ', ') AS descuentos,
        GROUP_CONCAT(dp.subtotal SEPARATOR ', ') AS subtotales
    FROM ventas ve
        INNER JOIN pedidos p ON p.idpedido = ve.idpedido
        INNER JOIN detalle_pedidos dp ON p.idpedido = dp.idpedido
        INNER JOIN productos pr ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em ON em.idempresaruc = cli.idempresa
    WHERE p.estado = 'Enviado' 
    GROUP BY p.idpedido, cli.idpersona, cli.idempresa, cli.tipo_cliente, pe.nombres, pe.appaterno, pe.apmaterno, em.razonsocial;


DROP PROCEDURE IF EXISTS `sp_listar_ventas`
DELIMITER //
CREATE PROCEDURE `sp_listar_ventas`()
BEGIN
	SELECT 
    ve.idventa,
    ve.fecha_venta,
    p.idpedido,
    cli.idpersona,
    cli.tipo_cliente,
    GROUP_CONCAT(pr.nombreproducto SEPARATOR ', ') AS productos,
    GROUP_CONCAT(dp.cantidad_producto SEPARATOR ', ') AS cantidades,
    SUM(dp.subtotal) AS total_subtotal  -- Using SUM to calculate total
FROM ventas ve
    INNER JOIN pedidos p ON p.idpedido = ve.idpedido
    INNER JOIN detalle_pedidos dp ON p.idpedido = dp.idpedido
    INNER JOIN productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN clientes cli ON cli.idcliente = p.idcliente
WHERE p.estado = 'Enviado' 
GROUP BY ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
ORDER BY p.idpedido DESC;
END//

CALL sp_listar_ventas

    

