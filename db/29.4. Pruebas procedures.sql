-- Active: 1728058749643@@127.0.0.1@3306@distribumax
USE distribuMax;
/**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558001', -- Número de documento
    1, -- ID del distrito
    'Miguel', -- Nombres
    'Loyola', -- Apellido paterno
    'Torres', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558000', -- Número de documento
    1, -- ID del distrito
    'pepito', -- Nombres
    'Levano', -- Apellido paterno
    'Martinez', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558002', -- Número de documento
    2, -- ID del distrito
    'pepito', -- Nombres
    'Levano', -- Apellido paterno
    'Martinez', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);
CALL sp_actualizar_persona (
    1,
    2,
    'Juan',
    'Castilla',
    'Maraví',
    null,
    'Av.Chacarita #123',
    '26558000'
);

CALL sp_actualizar_persona (
    1,
    2,
    'Messi',
    'Castilla',
    'Maraví',
    '910657765',
    'Psj. Felicidad #420',
    '26558001'
);


CALL sp_desactivar_persona (1, '26558000');

CALL sp_buscarpersonadoc (1, '26558000');

/**PRUEBAS PROCEDIMIENTOS OK ✔️  USUARIOS**/


SELECT * FROM usuarios;
CALL sp_registrar_usuario(26558000,2,'admin','admin');
CALL sp_actualizar_usuario
(
'admin',
'$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
1
);


CALL sp_usuario_login ('admin');

CALL sp_desactivar_usuario (1, 'admin');

-- -------------------------------------------------
-- REGISTRAR EMPRESAS

CALL sp_empresa_registrar (
    20123456782,
    954,
    'Dijisaaa',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);

CALL sp_actualizar_empresa (
    20123456782,
    1834,
    'Dijisaa',
    'Panamericana #234',
    'dijisa@gmail.com',
    '932123029'
);


-- ACTUALIZAR EMPRESA

/* PROCEDIMIENTOS DE CLIENTES ✔️*/ 
-- REGISTRAR CLIENTES
CALL sp_cliente_registrar (26558001, NULL, 'Persona');
CALL sp_cliente_registrar (NULL, 20123456781, 'Empresa');
select * from clientes;
--  No debe de registrar a un cliente con dni y ruc
-- CALL sp_cliente_registrar (26558000, 20123456781,'Empresa'); 
-- ACTUALIZAR CLIENTES
-- CALL sp_actualizar_cliente (NULL,20123456781,'Empresa',2);
-- REISTRAR PROOVEDORES
CALL sp_proovedor_registrar (
    20123456782,
    1,
    'José Carlos',
    '932143290',
    'Av. el Porvenir',
    'jose@gmail.com'
);

 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
CALL sp_empresa_registrar(
	20123456784,
	954,
    'JRCA',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);
CALL sp_actualizar_empresa (12345678901,954,'Dijisa','Panamericana #234','dijisa@gmail.com','932123029');

select * from usuarios;
/****************************************************************************************************************/
select * from empresas;
select * from clientes;
select * from personas;

insert into clientes (idpersona,idempresa,tipo_cliente) VALUES(26558000,null,'Persona');
insert into clientes (idpersona,idempresa,tipo_cliente) VALUES(null,'20123456783','Empresa');
insert into pedidos(idusuario,idcliente,fecha_pedido)VALUES(1,1,'2024/09/22');
select * from pedidos;

select * from detalle_pedidos;
-- Insertar detalles del pedido
INSERT INTO detalle_pedidos (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, precio_descuento, subtotal) VALUES
('PED-00000009', 2, 5, 'unidad', 2.00, 1.00, 10.00),
('PED-00000009', 2, 6, 'unidad', 10.00, 2.00, 90.00);

-- Llamar al procedimiento para registrar el movimiento correspondiente




select * from detalle_pedidos;
select * from pedidos;
select * from usuarios;
select * from personas;
select * from clientes;
select * from productos;
select * from kardex;
select * from ventas;
call sp_buscardistrito ('chincha');
CALL sp_pedido_registrar (2, 21);



CALL sp_pedido_registrar (1, 1);
select * from pedidos;

CALL sp_detalle_pedido ('PED-000000001',1,1,'und',8.50);

SELECT * FROM detalle_pedidos;