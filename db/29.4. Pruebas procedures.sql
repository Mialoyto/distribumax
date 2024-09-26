USE distribuMax;
/**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558000', -- Número de documento
    954, -- ID del distrito
    'Miguel', -- Nombres
    'Loyola', -- Apellido paterno
    'Torres', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558001', -- Número de documento
    954, -- ID del distrito
    'pepito', -- Nombres
    'Levano', -- Apellido paterno
    'Martinez', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);

CALL sp_actualizar_persona (
    1,
    99,
    'Juan',
    'Castilla',
    'Maraví',
    null,
    'Av.Chacarita #123',
    '26558000'
);

CALL sp_actualizar_persona (
    1,
    99,
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
CALL sp_registrar_usuario ( '26558000', 1, 'admin', 'admin' );

CALL sp_actualizar_usuario (
    'admin',
    '$2y$10$qpFRvOWayRS8rcvHQvuNeu2V3YoMEfCBLaBp9Dccs35nyqd1hyZkK',
    1
);

CALL sp_usuario_login ('admin');

CALL sp_desactivar_usuario (1, 'admin');

-- -------------------------------------------------
-- REGISTRAR EMPRESAS
CALL sp_empresa_registrar (
    20123456781,
    954,
    'JRC',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);

CALL sp_empresa_registrar (
    20123456782,
    954,
    'Dijisaa',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);

CALL sp_actualizar_empresa (
    20123456782,
    955,
    'Dijisaa',
    'Panamericana #234',
    'dijisa@gmail.com',
    '932123029'
);


-- ACTUALIZAR EMPRESA

/* PROCEDIMIENTOS DE CLIENTES ✔️*/ 
-- REGISTRAR CLIENTES
CALL sp_cliente_registrar (26558000, NULL, 'Persona');
CALL sp_cliente_registrar (NULL, 20123456781, 'Empresa');
--  No debe de registrar a un cliente con dni y ruc
CALL sp_cliente_registrar (26558000, 20123456781,'Empresa'); 
-- ACTUALIZAR CLIENTES
CALL sp_actualizar_cliente (NULL,20123456781,'Empresa',2);

-- REISTRAR PROOVEDORES
CALL sp_proovedor_registrar (
    20123456781,
    1,
    'José Carlos',
    '932143290',
    'Av. el Porvenir',
    'jose@gmail.com'
);

 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
CALL sp_empresa_registrar(
	20123456783,
	954,
    'JRCA',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);
CALL sp_actualizar_empresa (12345678901,954,'Dijisa','Panamericana #234','dijisa@gmail.com','932123029');


/****************************************************************************************************************/
insert into clientes(idpersona,idempresa,tipo_cliente)VALUES(26558000, 20123456781,'Empresa');
insert into pedidos(idusuario,idcliente,fecha_pedido)VALUES(2,1,'2024/09/22');
insert into detalle_pedidos(idpedido,idproducto,cantidad_producto,unidad_medida,precio_unitario,precio_descuento,subtotal)VALUES
('PED-000000002',1,10,'unidad',2,1,10),
('PED-000000002',2,20,'unidad',10,2,90);

select * from detalle_pedidos;
select * from pedidos;
select * from clientes;
select * from productos;
select * from kardex;
select * from ventas;
call sp_buscardistrito ('chincha');
CALL sp_pedido_registrar (2, 21);



CALL sp_pedido_registrar (1, 2);
select * from pedidos;

CALL sp_detalle_pedido ('PED-000000001',1,100,'und',8.50);

SELECT * FROM detalle_pedidos;