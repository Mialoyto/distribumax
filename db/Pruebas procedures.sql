 USE distribuMax;
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
 CALL spu_registrar_personas(
	1,           -- Tipo de documento (dni)
	'26558000',       -- Número de documento
	954,            -- ID del distrito
	'Ana',          -- Nombres
	'Martinez',     -- Apellido paterno
	'Lopez',        -- Apellido materno
	NULL,           -- Teléfono (NULL)
	'Calle Falsa 123' -- Dirección
);
 CALL spu_registrar_personas(
	1,           -- Tipo de documento (dni)
	'26558001',       -- Número de documento
	954,            -- ID del distrito
	'Juan',          -- Nombres
	'Levano',     -- Apellido paterno
	'Martinez',        -- Apellido materno
	NULL,           -- Teléfono (NULL)
	'Calle Falsa 123' -- Dirección
);

CALL sp_actualizar_persona (1,99,'Juan','Castilla','Maraví',null,'Av.Chacarita #123','26558000');
CALL sp_actualizar_persona (3,99,'Messi','Castilla','Maraví','910657765','Psj. Felicidad #420','26558001');

/****************************************************************************************************/

 
/**PRUEBAS PROCEDIMIENTOS OK ✔️  USUARIOS**/
-- CALL sp_registrar_usuario('26558000',1,'admin','admin');
-- CALL sp_registrar_usuario('26558001',1,'admin1','admin');
CALL sp_usuario_login ('admin');
CALL sp_desactivar_usuario(1,'admin');

/*****************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  EMPRESAS**/
-- REGISTRAR EMPRESA ️✔️
CALL sp_empresa_registrar(
	1,
	1,
    'JRC',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);

-- ACTUALIZAR EMPRESA ✔️
CALL sp_actualizar_empresa (1,1,'Dijisa','Panamericana #234','dijisa@gmail.com','932123029');

-- DESACTIVAR ESTADO EMPRESA ✔️
CALL sp_estado_empresa(0, 1);

/*************************************************************************************************/

 /**PRUEBAS PROCEDIMIENTOS OK ✔️  CLIENTES**/
-- REGISTRAR CLIENTES 
CALL sp_cliente_registrar(26558000,1,'Empresa');

-- ACTUALIZAR CLIENTES
CALL sp_actualizar_cliente(4,26558001,1,'Persona');

-- DESACTIVAR CLIENTES
CALL sp_estado_cliente(0, 3);

 /*************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PROOVEDORES**/
-- REISTRAR PROOVEDORES
CALL sp_proovedor_registrar(1,1,'Dkasa', 'José Carlos', '932143290', 'Av. el Porvenir', 'jose@gmail.com');

-- ACTUALIZAR PROOVEDORES
CALL sp_actualizar_proovedor(1,1,'Clorina','Jose Daniel', '973323783', 'Av. José Olaya', 'dani@gmail.com');

-- DESCTIVAR A UN PROOVEDOR
CALL sp_estado_proovedor(0, 1);

 /*************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PEDIDOS**/
-- REGISTRAR PEDIDOS
CALL sp_pedido_registrar(1, 1, 3, '2024-04-05 19:41:00', 'Pendiente');

-- ACTUALIZAR PEDIDOS
CALL sp_actualizar_pedido(1,1,3,'2024-04-05 19:41:00', 'Entregado');

-- DESACTIVAR PEDIDO ¿?
CALL sp_estado_pedido(0,1);
/****************************************************************************************************************/

/****Usuarios*********/
CALL sp_buscarpersonadoc (1,'87654321');

CALL sp_actualizar_usuario('usuario1','usuario1',3);
/****************************************************************************************************************/
  

