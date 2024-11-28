-- Active: 1732637704938@@127.0.0.1@3306@distribumax
USE distribumax;
SELECT * FROM DESPACHOS;
SELECT * FROM DESPACHO_ventas;
SELECT * FROM ventas;
-- --------------------------------------------------------------------------------------------------------------------------------
-- NOTA : ESTO SOLO SON PRUEBAS DE CONSULTAS
SELECT * FROM categorias;
SELECT * FROM despachos;
SELECT * FROM subcategorias;

SELECT * FROM productos;

SELECT * FROM proveedores;

SELECT * FROM marcas;

SELECT * FROM subcategorias;
select * from clientes;

SELECT * FROM unidades_medidas;

CALL getSubcategorias (5);

CALL sp_get_codigo_producto ('AJI-SZ-001');

SELECT codigo FROM productos WHERE codigo = '265580';


SELECT * FROM detalle_meto_pago;

SELECT * FROM despacho;

SELECT * FROM comprobantes;

SELECT * FROM tipo_comprobante_pago;

SELECT * FROM vehiculos;
select* from personas;
SELECT * FROM usuarios;
select * from productos;
select * from clientes;
SELECT * FROM departamentos;

SELECT * FROM provincias WHERE provincia = 'Chincha';
SELECT * FROM  despachos;
SELECT * FROM distritos;
select * from lotes;
select * from kardex;
select * from lotes;

SELECT * FROM marcas;

SELECT * FROM usuarios;
mysql -u root -p;
SELECT * FROM personas 
ORDER BY idpersonanrodoc DESC
limit 10;
SELECT host, user FROM mysql.user WHERE user = 'root';
SELECT * FROM empresas;

SELECT * FROM clientes;
call `sp_cliente_registrar` (null,20297868790, 'Empresa');

SELECT * FROM pedidos;
select * FROM kardex;

SELECT * FROM metodos_pago;

SELECT * FROM promociones;

SELECT * FROM detalle_promociones;

SELECT * FROM tipos_promociones;

SELECT * FROM detalle_pedidos;

SELECT * FROM personas WHERE idpersonanrodoc = '26558009';

SELECT * FROM perfil;

DELETE FROM usuarios WHERE idpersona = '26558000';

SELECT * FROM productos;

SELECT * FROM tipo_documento;

SELECT * FROM kardex;

SELECT * FROM detalle_productos;

vw_unidades_medidas;

SELECT * FROM vw_unidades_medidas;

CALL sp_cliente_registrar ('26558000');

SELECT * FROM clientes;

CALL getSubcategorias (6);

CALL sp_getMarcas (3);

CALL sp_search_proveedor ('proveedor');

SELECT * FROM MARCAS;
select *from personas;

SELECT * FROM productos;

SELECT * FROM PROVEEDORES;

SELECT KAR.idproducto, PRO.nombreproducto, KAR.numlote, KAR.stockactual, KAR.tipomovimiento
FROM kardex KAR
    LEFT JOIN productos PRO ON KAR.idproducto = PRO.idproducto
SELECT KAR.numlote, KAR.idproducto, MAX(KAR.stockactual)
FROM kardex KAR
GROUP BY
    idproducto,
    numlote;

SELECT KAR.idproducto, PRO.nombreproducto, KAR.numlote, KAR.stockactual, KAR.tipomovimiento
FROM
    kardex KAR
    INNER JOIN productos PRO ON KAR.idproducto = PRO.idproducto
    INNER JOIN (
        SELECT idproducto, numlote, MAX(stockactual) AS max_stock
        FROM kardex
        GROUP BY
            idproducto,
            numlote
    ) AS MaxKAR ON KAR.idproducto = MaxKAR.idproducto
    AND KAR.numlote = MaxKAR.numlote
    AND KAR.stockactual = MaxKAR.max_stock;

--  LISTAR PRODUCTOS CON STOCK ACTUAL POR IDPRODUCTO Y NUMLOTE
SELECT KAR.idproducto, PRO.nombreproducto, KAR.numlote, KAR.fecha_vencimiento, SUM(KAR.stockactual) AS stock_total, KAR.tipomovimiento
FROM kardex KAR
    LEFT JOIN productos PRO ON KAR.idproducto = PRO.idproducto
GROUP BY
    KAR.idproducto,
    KAR.numlote
ORDER BY KAR.idproducto, KAR.numlote;

SELECT SUM(
        CASE
            WHEN KAR.tipomovimiento = 'Ingreso' THEN KAR.cantidad
            WHEN KAR.tipomovimiento = 'Salida' THEN - KAR.cantidad
            ELSE 0
        END
    ) AS stock_total
FROM kardex KAR
WHERE
    KAR.idproducto = 1;

CREATE VIEW vw_stock_total AS
SELECT KAR.idproducto, PRO.nombreproducto, KAR.numlote, KAR.fecha_vencimiento, SUM(
        CASE
            WHEN KAR.tipomovimiento = 'Ingreso' THEN KAR.cantidad
            WHEN KAR.tipomovimiento = 'Salida' THEN - KAR.cantidad
            ELSE 0
        END
    ) AS stock_total
FROM kardex KAR
    INNER JOIN productos PRO ON KAR.idproducto = PRO.idproducto
GROUP BY
    KAR.idproducto,
    PRO.nombreproducto,
    KAR.numlote,
    KAR.fecha_vencimiento;

DROP VIEW IF EXISTS vw_stock_total;

SELECT * FROM vw_stock_total;

SELECT * FROM PRODUCTOS;

SELECT * FROM kardex;

SELECT * FROM proveedores;

SHOW COLUMNS FROM tipos_promociones;

DELETE FROM usuarios WHERE idpersona = '26558000';

SELECT * FROM vw_listar_perfil;
-- CONSULTAS
SELECT * FROM provincias WHERE provincia = 'Chincha';

SELECT count(distrito) FROM distritos WHERE idprovincia = 97;

SELECT
    idprovincia,
    iddepartamento,
    provincia
FROM provincias
WHERE
    iddepartamento = 11;

SELECT
    iddistrito,
    idprovincia,
    distrito
FROM distritos
WHERE
    idprovincia = 99;

SELECT count(nombre_usuario) AS usuario
FROM usuarios
WHERE
    nombre_usuario = 'alex';

SELECT 1 AS usuario
FROM Usuarios
WHERE
    nombre_usuario = 'juan'
LIMIT 1;

CALL sp_buscarusuarios_registrados (1, '26558000');

CALL VerificarUsuarioUnico ('alex', @resultado);

SELECT @resultado AS unico
    /* --------------------------------------------------- */

DELIMITER / /

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

DELIMITER;

-- AGREGAR DETALLE PEDIDO
CALL sp_detalle_pedido ( 'PED-000000011', 1, 1, 'caja', 8.50 );

SELECT * FROM pedidos ORDER BY idpedido DESC LIMIT 20;

SELECT * FROM detalle_pedidos ORDER BY id_detalle_pedido DESC;

SELECT idproducto, stockactual
FROM kardex
WHERE
    idproducto = 1
ORDER BY idkardex DESC
LIMIT 1;

SELECT idproducto, stockactual
FROM kardex
WHERE
    idproducto = 2
ORDER BY idkardex DESC
LIMIT 1;

SELECT idproducto, stockactual
FROM kardex
WHERE
    idproducto = 3
ORDER BY idkardex DESC
LIMIT 1;

SELECT idproducto, stockactual
FROM kardex
WHERE
    idproducto = 4
ORDER BY idkardex DESC
LIMIT 1;

SELECT * FROM detalle_pedidos WHERE idpedido = 'PED-000000053';

SELECT * FROM detalle_promociones;

UPDATE detalle_promociones
SET
    descuento = 5
WHERE
    iddetallepromocion = 1;

DROP PROCEDURE IF EXISTS ObtenerPrecioProducto;

CALL ObtenerPrecioProducto (26558000, 'a');

SELECT * FROM productos;

-- ELIMINAR DESPUES
DROP PROCEDURE IF EXISTS ObtenerPrecioProducto;

CALL ObtenerPrecioProducto (, 'a');

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

CALL getSubcategorias (3);
/* FIN DE LA PRUEBA */
SELECT * FROM categorias;

UPDATE categorias SET estado = 1 WHERE idcategoria = 1;

SELECT * FROM subcategorias;

UPDATE subcategorias SET estado = 1 WHERE idsubcategoria = 1;

SELECT * FROM detalle_promociones;

SELECT *
FROM kardex
WHERE
    idproducto = 2
    AND stockactual = 0
ORDER BY idkardex DESC;

SELECT * FROM proveedores;

CALL sp_listar_categorias ();

CALL getSubcategorias (3);

CALL sp_registrar_producto (
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

CALL ObtenerPrecioProducto (2655800, 'Galletas Casino');

SELECT *
FROM kardex
WHERE (idproducto, stockactual) IN (
        SELECT idproducto, MAX(stockactual)
        FROM kardex
        GROUP BY
            idproducto
    );

SELECT *
FROM kardex k1
    JOIN (
        SELECT idproducto, MAX(create_at) AS last_fecha
        FROM kardex
        GROUP BY
            idproducto
    ) AS k2 ON k1.idproducto = k2.idproducto
    AND k1.create_at = k2.last_fecha;

SELECT * FROM clientes;

SELECT * FROM productos;

SELECT * FROM clientes;

SELECT * FROM PERSONAS;

CALL sp_listar_clientes ();

CALL sp_estado_cliente (1, 1);

SELECT * FROM clientes;

SELECT * FROM vehiculos;

CALL spu_listar_producto_kardex (1);

SELECT * FROM ventas;

SELECT * FROM detalle_meto_pago;

SELECT * FROM pedidos;

SELECT * FROM detalle_pedidos;

SELECT * FROM detalle_pedidos;

SELECT * FROM detalle_meto_pago;

SELECT * FROM metodos_pago;

SELECT * FROM tipo_comprobante_pago;

CALL sp_listar_comprobate ();

CALL sp_buscar_pedido ('em');

SELECT VEN.idventa, MET.metodopago, DETP.monto
FROM
    detalle_meto_pago DETP
    INNER JOIN ventas VEN ON DETP.idventa = VEN.idventa
    INNER JOIN metodos_pago MET ON DETP.idmetodopago = MET.idmetodopago
WHERE
    VEN.idventa = 35
    AND DETP.estado = 1;

SELECT * FROM empresas;

SELECT * FROM clientes;

SELECT * FROM personas SELECT * FROM getClientes ();

CALL sp_listar_clientes_datatables (
    10,
    0,
    'Miguel',
    'cliente',
    'ASC'
);

CALL sp_listar_clientes (10, 0, 'miguel', 0, 'ASC');

CALL sp_listar_clientes (10, 1, 'Juan', 1, 'ASC', 2);

CALL sp_listar_clientes (10, 0, 'cliente', 0, 'ASC');

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp-listar-cli`;
DELIMITER $$
DELIMITER $$

CREATE PROCEDURE `sp-listar-cli`(
    IN _search VARCHAR(255),
    IN _start INT,
    IN _length INT,
    IN _order_column VARCHAR(50),
    IN _order_dir VARCHAR(4),
    OUT _total_records INT,
    OUT _filtered_records INT
)
BEGIN
    -- Inicializar las variables
    SET @sql = '';
    SET @search_param = CONCAT('%', _search, '%');
    
    -- Contar el total de registros sin aplicar búsqueda
    SELECT COUNT(*) INTO _total_records FROM clientes;

    -- Contar registros filtrados si hay búsqueda
    IF _search != '' THEN
        SELECT COUNT(*) INTO _filtered_records
        FROM clientes
        WHERE cliente LIKE @search_param OR tipo_cliente LIKE @search_param;
    ELSE
        SET _filtered_records = _total_records;
    END IF;

    -- Construcción de la consulta dinámica
    SET @sql = CONCAT(
        'SELECT id_cliente, tipo_cliente, cliente, fecha_creacion, estado 
         FROM clientes 
         WHERE cliente LIKE ? OR tipo_cliente LIKE ? 
         ORDER BY ', _order_column, ' ', _order_dir, ' 
         LIMIT ?, ?'
    );

    -- Preparar la consulta
    PREPARE stmt FROM @sql;

    -- Ejecutar la consulta con los parámetros
    EXECUTE stmt USING @search_param, @search_param, _start, _length;

    -- Liberar la consulta preparada
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;

UPDATE productos
    set precio_mayorista = 7.20, precio_minorista = 7.80 WHERE
    idproducto = 1;


SELECT * FROM clientes;
SELECT * FROM empresas;
SELECT * FROM proveedores;

SELECT * from provincias;
call sp_buscardistrito('pueblo nuevo');

select * from ventas;
UPDATE ventas set estado=1 WHERE idventa=2;
SELECT * FROM pedidos;




