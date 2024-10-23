-- Active: 1728956418931@@127.0.0.1@3306@distribumax
USE distribumax;

-- --------------------------------------------------------------------------------------------------------------------------------
-- NOTA : ESTO SOLO SON PRUEBAS DE CONSULTAS
select * from categorias;
SELECT * FROM subcategorias;
SELECT * from productos;
SELECT * FROM proveedores;
SELECT * FROM marcas;
SELECT * FROM subcategorias;
SELECT * FROM unidades_medidas;
CALL getSubcategorias(5);
CALL sp_get_codigo_producto('AJI-SZ-001');
select codigo from productos where codigo = '265580';
SELECT * FROM ventas;
SELECT * FROM detalle_meto_pago;
SELECT * FROM despacho;
SELECT * FROM comprobantes;
SELECT * FROM tipo_comprobante_pago;
select * from vehiculos;
SELECT * FROM usuarios;
select * from departamentos;
select * from provincias where provincia = 'Chincha';
select * from distritos;
select * from marcas;
select * from usuarios;
select * from personas;
SELECT * FROM empresas;
select * from clientes;
select * from pedidos;
select * from metodos_pago;
select * from promociones;
SELECT * from detalle_promociones;
select * from tipos_promociones;
SELECT * FROM detalle_pedidos;
select * from personas where idpersonanrodoc = '26558009';
select * from roles;
delete from usuarios where idpersona = '26558000';
SELECT * FROM productos;
SELECT * FROM  tipo_documento;
SELECT * FROM kardex;
SELECT * FROM detalle_productos;vw_unidades_medidas;
SELECT * FROM vw_unidades_medidas;

call sp_cliente_registrar('26558000');
select * from clientes;
CALL getSubcategorias (6);
CALL sp_getMarcas(3);
CALL sp_search_proveedor('proveedor');
SELECT * FROM MARCAS;
SELECT * FROM productos;
SELECT * FROM PROVEEDORES;

SELECT 
    KAR.idproducto,
    PRO.nombreproducto,
    KAR.numlote,
    KAR.stockactual,
    KAR.tipomovimiento
FROM kardex KAR
    LEFT JOIN productos PRO ON KAR.idproducto = PRO.idproducto
    SELECT KAR.numlote,KAR.idproducto, MAX(KAR.stockactual) 
    FROM kardex KAR
    GROUP BY idproducto, numlote
;


SELECT 
    KAR.idproducto,
    PRO.nombreproducto,
    KAR.numlote,
    KAR.stockactual,
    KAR.tipomovimiento
FROM kardex KAR
INNER JOIN productos PRO ON KAR.idproducto = PRO.idproducto
INNER JOIN (
    SELECT idproducto, numlote, MAX(stockactual) AS max_stock 
    FROM kardex 
    GROUP BY idproducto, numlote
) AS MaxKAR ON KAR.idproducto = MaxKAR.idproducto 
            AND KAR.numlote = MaxKAR.numlote 
            AND KAR.stockactual = MaxKAR.max_stock;





--  LISTAR PRODUCTOS CON STOCK ACTUAL POR IDPRODUCTO Y NUMLOTE
SELECT 
    KAR.idproducto,
    PRO.nombreproducto,
    KAR.numlote,
    KAR.fecha_vencimiento,
    SUM(KAR.stockactual ) AS stock_total,
    KAR.tipomovimiento
FROM kardex KAR
LEFT JOIN productos PRO ON KAR.idproducto = PRO.idproducto
GROUP BY KAR.idproducto, KAR.numlote
ORDER BY KAR.idproducto, KAR.numlote;

SELECT
    SUM(
        CASE 
            WHEN KAR.tipomovimiento = 'Ingreso' THEN KAR.cantidad
            WHEN KAR.tipomovimiento = 'Salida' THEN -KAR.cantidad
            ELSE 0
        END
        
        ) AS stock_total
    FROM kardex KAR
    WHERE KAR.idproducto = 1;


    
CREATE VIEW vw_stock_total AS
SELECT 
    KAR.idproducto,
    PRO.nombreproducto,
    KAR.numlote,
    KAR.fecha_vencimiento,
    SUM(CASE 
        WHEN KAR.tipomovimiento = 'Ingreso' THEN KAR.cantidad
        WHEN KAR.tipomovimiento = 'Salida' THEN -KAR.cantidad
        ELSE 0
    END) AS stock_total
FROM kardex KAR
INNER JOIN productos PRO ON KAR.idproducto = PRO.idproducto
GROUP BY KAR.idproducto, PRO.nombreproducto, KAR.numlote, KAR.fecha_vencimiento;

DROP VIEW IF EXISTS vw_stock_total;
SELECT * FROM vw_stock_total;


SELECT * FROM PRODUCTOS;
select * from kardex;
SELECT * FROM proveedores;
SHOW COLUMNS FROM tipos_promociones;

delete from usuarios where idpersona = '26558000';
select * from vw_listar_roles;
-- CONSULTAS
select * from provincias where provincia = 'Chincha';
select count(distrito) from distritos where idprovincia = 97;
select idprovincia, iddepartamento,  provincia from provincias where iddepartamento =11;
select iddistrito,idprovincia, distrito from distritos where idprovincia = 99;

select count(nombre_usuario) as usuario from usuarios where nombre_usuario = 'alex';
SELECT 1 as usuario FROM Usuarios WHERE nombre_usuario = 'juan' LIMIT 1;

    

call sp_buscarusuarios_registrados (1, '26558000');
call VerificarUsuarioUnico ('alex', @resultado);
select @resultado AS unico

/* --------------------------------------------------- */
DELIMITER //
CREATE PROCEDURE VerificarUsuarioUnico(
    IN _nombre_usuario VARCHAR(50),
    OUT _unico TINYINT
)
BEGIN
    -- Inicializa la variable de salida
    SET _unico = 1; -- Suponemos que es único por defecto

    -- Verificamos si el nombre de usuario ya existe
    IF EXISTS (SELECT 1 FROM usuarios WHERE nombre_usuario = _nombre_usuario) THEN
        SET _unico = 0; -- No es único
    END IF;
END //
DELIMITER ;


-- AGREGAR DETALLE PEDIDO
call sp_detalle_pedido ('PED-000000011',1,1,'caja',8.50);
SELECT  * FROM pedidos ORDER BY idpedido DESC LIMIT 20;
SELECT * FROM detalle_pedidos ORDER BY id_detalle_pedido DESC;
SELECT idproducto,stockactual from kardex WHERE idproducto = 1 ORDER BY idkardex DESC LIMIT 1;
SELECT idproducto,stockactual FROM kardex WHERE idproducto = 2 ORDER BY idkardex DESC LIMIT 1;
SELECT idproducto,stockactual FROM kardex WHERE idproducto = 3 ORDER BY idkardex DESC LIMIT 1;
SELECT idproducto,stockactual FROM kardex WHERE idproducto = 4 ORDER BY idkardex DESC LIMIT 1;

SELECT * FROM detalle_pedidos where idpedido = 'PED-000000053';
SELECT * from detalle_promociones;
UPDATE detalle_promociones SET descuento = 5 WHERE iddetallepromocion = 1;

DROP PROCEDURE IF EXISTS ObtenerPrecioProducto;


CALL ObtenerPrecioProducto(26558000, 'a');
SELECT * FROM productos;

-- ELIMINAR DESPUES
DROP PROCEDURE IF EXISTS ObtenerPrecioProducto;

CALL ObtenerPrecioProducto(, 'a');
CALL sp_estado_producto ('1', 1);



/* PRUEBAS*/
DELIMITER $$
CREATE PROCEDURE getSubcategorias(
    IN _idsubcategoria INT
)
BEGIN
SELECT 
    SUB.idsubcategoria,
    SUB.subcategoria
    FROM categorias CAT
    RIGHT JOIN subcategorias SUB ON CAT.idcategoria = SUB.idcategoria
    WHERE CAT.idcategoria = _idsubcategoria
    AND CAT.estado = 1 AND SUB.estado = 1
    ORDER BY SUB.idsubcategoria ASC;
END $$




CALL getSubcategorias(3);
/* FIN DE LA PRUEBA */
SELECT * FROM categorias;
UPDATE categorias SET estado = 1 WHERE idcategoria = 1;
SELECT * FROM subcategorias;
UPDATE subcategorias SET estado = 1 WHERE idsubcategoria = 1;

SELECT * FROM detalle_promociones;

select * from kardex WHERE idproducto = 2 and stockactual =0 ORDER BY idkardex DESC ;
SELECT * from proveedores;
CALL sp_listar_categorias();

CALL getSubcategorias(3);


CALL sp_registrar_producto(
    2, 
    5, 
    5, 
    'Galleta Casino tres leches',
    2, 
    12,
    '200 GR',
    'CAS-0000002',
    3.60,
    5.10,
    4.60
);

CALL ObtenerPrecioProducto(2655800, 'Galletas Casino');


SELECT * FROM kardex 
WHERE (idproducto,stockactual) IN(
    SELECT idproducto, MAX(stockactual) 
    FROM kardex
    GROUP BY idproducto
);

SELECT *
FROM kardex k1
JOIN (
    SELECT idproducto, MAX(create_at) AS last_fecha
    FROM kardex
    GROUP BY idproducto
) AS k2 ON k1.idproducto = k2.idproducto AND k1.create_at = k2.last_fecha;

select * from clientes;
SELECT * FROM productos;

select * from clientes;
SELECT * FROM PERSONAS;
CALL sp_listar_clientes();
CALL sp_estado_cliente(1, 1);
select * from clientes;
SELECT * from vehiculos;

call spu_listar_producto_kardex(1);

SELECT * FROM ventas;
SELECT * FROM detalle_meto_pago;

CALL sp_search_proveedor("A")

select * from categorias;