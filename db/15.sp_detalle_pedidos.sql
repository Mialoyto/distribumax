-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR DETALLE PEDIDOS
DROP PROCEDURE IF EXISTS sp_detalle_pedido;

CREATE PROCEDURE sp_detalle_pedido(
    IN _idpedido            CHAR(15),
    IN _idproducto          INT,
    IN _cantidad_producto   INT,
    IN _unidad_medida       CHAR(20),
    IN _precio_unitario     DECIMAL(10, 2)
)
BEGIN
    DECLARE _subtotal               DECIMAL(10, 2);
    DECLARE v_descuento_unitario    DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_descuento             DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_subtotal              DECIMAL(10, 2) DEFAULT 0.00;

    SELECT IFNULL(descuento, 0) INTO v_descuento_unitario
    FROM detalle_promociones
    WHERE idproducto = _idproducto
    LIMIT 1;
    SET v_descuento = (_cantidad_producto * _precio_unitario) * (v_descuento_unitario /100);

SET
    _subtotal = (
        _cantidad_producto * _precio_unitario
    ) - v_descuento;

INSERT INTO
    detalle_pedidos (
        idpedido,
        idproducto,
        cantidad_producto,
        unidad_medida,
        precio_unitario,
        precio_descuento,
        subtotal
    )
VALUES (
        _idpedido,
        _idproducto,
        _cantidad_producto,
        _unidad_medida,
        _precio_unitario,
        v_descuento,
        _subtotal
    );

SELECT LAST_INSERT_ID() AS iddetallepedido;

END;

-- ACTUALIZAR EL STOCK

DROP TRIGGER IF EXISTS trg_registrar_salida_pedido;

CREATE TRIGGER trg_registrar_salida_pedido
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_idusuario INT;
    
    -- Obtener el idusuario desde la tabla pedidos
    SELECT p.idusuario INTO v_idusuario
    FROM pedidos p
    WHERE p.idpedido = NEW.idpedido;

    -- Llamar al SP con el idusuario obtenido de pedidos
    CALL sp_registrar_salida_pedido(
        v_idusuario, 
        NEW.idproducto, 
        NEW.cantidad_producto, 
        'Venta por pedido'
    );
END;

-- ACTUALIZAR DETALLE PEDIDOS
/** Se puede actualizar algun campo del proceso de actualizar PROBAR SI SE PUEDE ACTUALIZAR EL PRECIO UNITARIO**/

CREATE PROCEDURE sp_actualizar_detalle_pedido(
    IN _idpedido          CHAR(15),
    IN _idproducto        INT,
    IN _cantidad_producto INT,
    IN _iddetallepedido   INT
)
BEGIN
    UPDATE detalle_pedidos
        SET 
            idpedido            = _idpedido,
            idproducto          = _idproducto,
            cantidad_producto   = _cantidad_producto,
            update_at           = now()
        WHERE iddetallepedido   = _iddetallepedido;
END;

-- ESTADO DETALLE PEDIDOS
/** Debe de poder eliminar el pedido **/

CREATE PROCEDURE sp_estado_detalle_pedido(
    IN  _estado           CHAR(1),
    IN  _iddetallepedido  INT 
)
BEGIN
    UPDATE detalle_pedidos SET
        estado = _estado
        WHERE iddetallepedido = _iddetallepedido;
END;

-- buscar productos por nombre o codigo y dependiendo del numero de ruc o dni del cliente cambia los precios
DROP PROCEDURE IF EXISTS ObtenerPrecioProducto;

CREATE PROCEDURE ObtenerPrecioProducto(
    IN _cliente_id      BIGINT,
    IN _item            VARCHAR(255)
)
BEGIN
    SELECT 
        PRO.idproducto,
        PRO.codigo,
        PRO.nombreproducto,
        CONVERT(DET.descuento, DECIMAL(10, 2)) AS descuento,
        UNDM.unidadmedida,
        CONCAT(
            PRO.nombreproducto, ' ',        
            UNDM.unidadmedida, ' ',         
            PRO.cantidad_presentacion, 'X', 
            PRO.peso_unitario               
        ) AS descripcion,                   
        CASE 
            WHEN LENGTH(CLI.idempresa) = 11 THEN CONVERT(PRO.precio_mayorista , DECIMAL(10, 2))
            WHEN LENGTH(CLI.idpersona) = 8 THEN CONVERT(PRO.precio_minorista ,DECIMAL(10, 2))
        END AS precio_venta,
        
        -- Sumar el stock actual del último movimiento de cada lote
        SUM(CONVERT(LOTES.stockactual , UNSIGNED INT)) AS stockactual
    FROM productos PRO
        INNER JOIN detalle_promociones DET ON PRO.idproducto = DET.idproducto
        INNER JOIN unidades_medidas UNDM ON PRO.idunidadmedida = UNDM.idunidadmedida
        INNER JOIN clientes CLI ON CLI.idempresa = _cliente_id OR CLI.idpersona = _cliente_id
        INNER JOIN lotes LOTES ON LOTES.idproducto = PRO.idproducto
    WHERE 
        PRO.nombreproducto LIKE CONCAT('%', _item, '%')
        AND PRO.estado = '1' 
        AND LOTES.estado != 'Vencido'
    GROUP BY 
        PRO.idproducto, PRO.codigo, PRO.nombreproducto, DET.descuento, UNDM.unidadmedida
    HAVING 
        stockactual > 0;  -- Solo mostrar productos con stock actual positivo
END;

CALL ObtenerPrecioProducto ('26558000', 'casino');

SELECT * FROM lotes;

SELECT * FROM productos;

DROP PROCEDURE IF EXISTS sp_producto_proveedor;
CREATE PROCEDURE sp_producto_proveedor(
    IN _idproveedor INT,
    IN _producto VARCHAR(255)
)
BEGIN
    SELECT
        PRO.idproducto,
        PRO.nombreproducto as producto,
        UNM.unidadmedida,
        CONCAT(
            PRO.nombreproducto, ' ', 
            UNM.unidadmedida, ' ', 
            PRO.cantidad_presentacion, 'X', 
            PRO.peso_unitario
            ) AS descripcion
    FROM productos PRO
    INNER JOIN proveedores PROV ON PROV.idproveedor = PRO.idproveedor
    INNER JOIN unidades_medidas UNM ON UNM.idunidadmedida = PRO.idunidadmedida
    WHERE
        PRO.nombreproducto LIKE CONCAT('%', _producto, '%')
        AND PROV.idproveedor = _idproveedor;
END;
call sp_producto_proveedor(2, 'a');

-- select * from productos where idproveedor = 2;

-- Obtener el Id del pedido y completar la tabla en ventas
/* ESTO MODIFICO LOYOLA */
DROP PROCEDURE IF EXISTS sp_getById_pedido;

CREATE PROCEDURE sp_getById_pedido(
    IN _idpedido CHAR(15)
) 
BEGIN
    SELECT 
        cli.idpersona,
        cli.idempresa,
        cli.tipo_cliente,
        pe.nombres,
        pe.appaterno,
        pe.apmaterno,
        COALESCE(pe.direccion, em.direccion) AS direccion, -- Selecciona la dirección de persona o empresa
        em.razonsocial,
        dp.id_detalle_pedido,
        pr.nombreproducto,
        dp.precio_unitario,
        dp.cantidad_producto,
        dp.unidad_medida,
        dp.precio_descuento,
        dp.subtotal,
        tp.idtipocomprobante,
        tp.comprobantepago
    FROM pedidos p
        LEFT JOIN detalle_pedidos dp       ON p.idpedido = dp.idpedido
        INNER JOIN productos pr             ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli             ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe               ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em               ON em.idempresaruc = cli.idempresa
        LEFT JOIN ventas ve                 ON ve.idpedido = p.idpedido
        LEFT JOIN tipo_comprobante_pago tp  ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE p.idpedido = _idpedido
      AND ve.idventa IS NULL;
END ;