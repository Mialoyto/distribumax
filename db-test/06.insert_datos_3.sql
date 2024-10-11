USE distribuMax;
/**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
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
    '26558002', -- Número de documento
    2, -- ID del distrito
    'pepito', -- Nombres
    'Levano', -- Apellido paterno
    'Martinez', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);
CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558003', -- Número de documento
    2, -- ID del distrito
    'pepito', -- Nombres
    'Levano', -- Apellido paterno
    'Martinez', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);
/**PRUEBAS PROCEDIMIENTOS OK ✔️  USUARIOS**/
CALL sp_registrar_usuario(26558000,1,'administrador','admin');
CALL sp_registrar_usuario(26558001,2,'usuario','admin');
CALL sp_registrar_usuario(26558002,3,'conductor','admin');
CALL sp_registrar_usuario(26558003,4,'vendedor','admin');
CALL sp_actualizar_usuario
(
'administrador',
'$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
1
);
CALL sp_actualizar_usuario
(
'usuario',
'$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
2
);
CALL sp_actualizar_usuario
(
'conductor',
'$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
3
);
CALL sp_actualizar_usuario
(
'vendedor',
'$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
4
);

-- -------------------------------------------------


-- ACTUALIZAR EMPRESA

/* PROCEDIMIENTOS DE CLIENTES ✔️*/ 
-- REGISTRAR CLIENTES
-- CALL sp_cliente_registrar (26558000, NULL, 'Persona');
-- CALL sp_cliente_registrar (NULL, 20123456782, 'Empresa');
-- select * from clientes;
--  No debe de registrar a un cliente con dni y ruc
-- CALL sp_cliente_registrar (26558000, 20123456781,'Empresa'); 
-- ACTUALIZAR CLIENTES
-- CALL sp_actualizar_cliente (NULL,20123456781,'Empresa',2);
-- REISTRAR PROOVEDORES
/* CALL sp_proovedor_registrar (
    20123456782,
    1,
    'José Carlos',
    '932143290',
    'Av. el Porvenir',
    'jose@gmail.com'
);
 */
 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
/* CALL sp_empresa_registrar(
	20123456782,
	954,
    'JRCA',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
); */
-- CALL sp_actualizar_empresa (12345678901,954,'Dijisa','Panamericana #234','dijisa@gmail.com','932123029');

