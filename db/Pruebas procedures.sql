 USE distribuMax;
 
 /**PRUEBAS PROCEDIMIENTOS OK ✔️**/

-- REGISTRAR EMPRESAS
CALL sp_empresa_registrar(
	1,
	1,
    'JRC',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);

SELECT * FROM clientes;
SELECT * FROM personas;
SELECT * FROM empresas;
-- ACTUALIZAR EMPRESA
CALL sp_actualizar_empresa (1,1,'Dijisa','Panamericana #234','dijisa@gmail.com','932123029');

-- REGISTRAR CLIENTES 
CALL sp_cliente_registrar(12345678,1,'Empresa');

-- ACTUALIZAR CLIENTES
CALL sp_actualizar_cliente(4,12345678,1,'Persona');

 


-- REISTRAR PROOVEDORES
CALL sp_proovedor_registrar(1,1,'Dkasa', 'José Carlos', '932143290', 'Av. el Porvenir', 'jose@gmail.com');

SELECT * FROM proveedores;
-- Segundo insert utilizando el procedimiento almacenado
CALL spu_registrar_personas(
		1,           -- Tipo de documento (dni)
		'87654321',       -- Número de documento
		954,            -- ID del distrito
		'Ana',          -- Nombres
		'Martinez',     -- Apellido paterno
		'Lopez',        -- Apellido materno
		NULL,           -- Teléfono (NULL)
		'Calle Falsa 123' -- Dirección
);

CALL sp_actualizar_persona (1,99,'Juan','Castilla','Maraví',null,'Av.Chacarita #123','73217990');
CALL sp_actualizar_persona (3,99,'Messi','Castilla','Maraví','910657765','Psj. Felicidad #420',87654321);
select * from personas;
CALL sp_desactivar_persona(0,'23456789');



/****Usuarios*********/

CALL sp_registrar_usuario(12345678,'Usuario1','Usuario1');
CALL sp_actualizar_usuario('usuario1','usuario1',3);
/****************************************************************************************************************/
  
