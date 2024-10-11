-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

-- --------------------------------------------------------------------------------------------------------------------------------
-- NOTA : ESTO SOLO SON PRUEBAS DE CONSULTAS
select * from categorias;
SELECT * FROM subcategorias;
SELECT * from productos;
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
SELECT * FROM detalle_productos;

call sp_cliente_registrar('26558000');
select * from clientes;
CALL getSubcategorias (6);
CALL getMarcas(20266352337);
CALL sp_search_proveedor('proveedor');
SELECT * FROM MARCAS;
SELECT * FROM productos;
SELECT * FROM PROVEEDORES;


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