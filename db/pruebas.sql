USE distribumax;

-- --------------------------------------------------------------------------------------------------------------------------------
-- NOTA : ESTO SOLO SON PRUEBAS DE CONSULTAS
SELECT * FROM subcategorias;
select * from departamentos;
select * from id prprovincias where provincia = 'Chincha';
select * from distritos;
select * from marcas;
select * from personas;
select * from clientes;
select * from pedidos;
select * from promociones;
select * from tipos_promociones;
select * from usuarios;
SELECT * FROM productos;
SELECT * FROM  tipo_documento;
SELECT * FROM empresas;
SELECT * FROM proveedores;
delete from personas where idpersonanrodoc = '';

-- CONSULTAS
select * from provincias where provincia = 'Chincha';
select count(distrito) from distritos where idprovincia = 97;
select idprovincia, iddepartamento,  provincia from provincias where iddepartamento =11;
select iddistrito,idprovincia, distrito from distritos where idprovincia = 99;


