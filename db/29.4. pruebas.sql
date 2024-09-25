-- Active: 1726291702198@@localhost@3306@distribumax
USE distribumax;

-- --------------------------------------------------------------------------------------------------------------------------------
-- NOTA : ESTO SOLO SON PRUEBAS DE CONSULTAS
SELECT * FROM subcategorias;
SELECT * FROM ventas;
SELECT * FROM despacho;
SELECT * FROM comprobantes;
SELECT * FROM tipo_comprobante_pago;
select * from vehiculos;
SELECT * FROM usuarios;
select * from departamentos;
select * from provincias where provincia = 'Chincha';
select * from distritos;
select * from marcas;
select * from categorias;
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
call sp_detalle_pedido ('PED-000000002',1,8,'und',8.50);
SELECT  * FROM pedidos ORDER BY idpedido DESC LIMIT 5;
SELECT * FROM detalle_pedidos ORDER BY id_detalle_pedido DESC LIMIT 5;
SELECT * FROM kardex ORDER BY idkardex DESC LIMIT 5;
SELECT * from kardex where idproducto = 2;


    SELECT 
        PRO.idproducto,
        PRO.codigo,
        PRO.nombreproducto,
        PRO.preciounitario,
        DET.iddetallepromocion,
        DET.descuento
    FROM  productos PRO
        LEFT JOIN detalle_promociones DET ON PRO.idproducto = DET.idproducto
    WHERE nombreproducto  = "Atún Nestlé en Aceite"
    AND PRO.estado = '1';