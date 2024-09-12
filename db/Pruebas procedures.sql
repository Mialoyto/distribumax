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
CALL sp_pedido_registrar(2, 1, 3, '2024-04-05 19:41:00', 'Pendiente');

-- ACTUALIZAR PEDIDOS
CALL sp_actualizar_pedido(1,1,3,'2024-04-05 19:41:00', 'Entregado');

-- DESACTIVAR PEDIDO ¿?
CALL sp_estado_pedido(0,1);
/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PROMOCIONES**/
-- REGISTRAR PROMOCIONES
CALL sp_promocion_registrar(1,1, 'Promoción de Verano', '2024-09-10 00:00:00', '2024-09-20 23:59:59', 20.00, 1);

-- ACTUALIZAR PROMOCIONES
CALL sp_actualizar_promocion(1,1,'Promoción de Invierno', '2024-09-12 00:00:00', '2024-09-21',21.00,1);

-- DESACTIVAR PROMOCION
CALL sp_estado_promocion(1,0);

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  TIPO DE PROMOCIONES**/
-- REGISTRAR TIPOS DE PROMOCIONES
CALL sp_tipo_promocion_registrar('Descuento de Invierno', 'Descuento especial para la temporada de invierno.', 1);

-- ACTUALIZAR TIPOS DE PROMOCIONES
CALL sp_actualizar_tipo_promocion(1,'Descuento de Verano', 'Descuento para temporada de verano',0);

-- DESACTIVAR TIPO DE PROMOCIONES
CALL sp_estado_tipo_promocion(0, 2);

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  DESPACHOS**/ -- EL ACTUALIZAR DESPACHO NO LO ACTUALIZA CORRECTAMENTE
-- REGISTRAR DESPACHOS
CALL sp_despacho_registrar(9,1,'2024-09-11',1);

-- ACTUALIZAR DESPACHO
CALL sp_actualizar_despacho(9,1,'2024-09-10',0);

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  TIPO COMPROBANTE DE PAGO**/
-- REGISTRAR TIPO COMPROBANTE DE PAGO
CALL sp_tipo_comprobantes_registrar('Factura Electrónica',1);
-- ACTUALIZAR TIPO COMPROBANTE DE PAGO
CALL sp_actualizar_tipo_comprobantes(2,'Factura Electrònica',0);

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  COMPROBANTE **/
-- REGISTRAR COMPROBANTES
CALL sp_comprobantes_registrar(5,0);

-- ACTUALIZAR COMPROBANTES
CALL sp_actualizar_comprobantes(2,0);

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  METODO DE PAGO **/
-- REGISTRAR METODO DE PAGO
CALL sp_metodo_pago_registrar('Grettel');

CALL sp_actualizar_metodo_pago();

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  MARCA **/
-- REGISTRAR MARCA
CALL sp_registrar_marca('Field');

-- ACTUALIZAR MARCA
CALL sp_actualizar_marca(1, 'Lays');

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  SUBCATEGORIA **/
-- REGISTRAR SUBCATEGORIA
CALL sp_registrar_subcategoria(1, 'Limpieza');

-- ACTUALIZAR SUBCATEGORIA
CALL sp_actualizar_subcategoria(1, 1, 'Conserva');

/****************************************************************************************************************/
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  MARCA **/


CALL sp_actualizar_metodo_pago();


/****Usuarios*********/
CALL sp_buscarpersonadoc (1,'87654321');

CALL sp_actualizar_usuario('usuario1','usuario1',3);
/****************************************************************************************************************/
  

