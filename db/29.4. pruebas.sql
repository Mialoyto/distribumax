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
select * from personas;
select * from clientes;
select * from pedidos;
select * from metodos_pago;
select * from promociones;
select * from tipos_promociones;
select * from usuarios;
delete from usuarios where idpersona = '26558000';
SELECT * FROM productos;
SELECT * FROM  tipo_documento;
SELECT * FROM empresas;
SELECT * FROM proveedores;
SHOW COLUMNS FROM tipos_promociones;

delete from usuarios where idpersona = '26558000';

-- CONSULTAS
select * from provincias where provincia = 'Chincha';
select count(distrito) from distritos where idprovincia = 97;
select idprovincia, iddepartamento,  provincia from provincias where iddepartamento =11;
select iddistrito,idprovincia, distrito from distritos where idprovincia = 99;


