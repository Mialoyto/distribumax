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
	3,           -- Tipo de documento (dni)
	'26558002',       -- Número de documento
	954,            -- ID del distrito
	'pepito',          -- Nombres
	'Levano',     -- Apellido paterno
	'Martinez',        -- Apellido materno
	NULL,           -- Teléfono (NULL)
	'Calle Falsa 123' -- Dirección
);

CALL sp_actualizar_persona (1,99,'Juan','Castilla','Maraví',null,'Av.Chacarita #123','26558000');
CALL sp_actualizar_persona (3,99,'Messi','Castilla','Maraví','910657765','Psj. Felicidad #420','26558001');
delete from usuarios where idusuario = 1;
CALL sp_desactivar_persona(1,'26558000');
CALL sp_buscarpersonadoc (1,'26558000');

 
/**PRUEBAS PROCEDIMIENTOS OK ✔️  USUARIOS**/
CALL sp_registrar_usuario('26558000',1,'admin','admin');
CALL sp_registrar_usuario('26558001',1,'admin1','admin');
CALL sp_usuario_login ('admin');
CALL sp_desactivar_usuario(1,'admin');

 /**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
CALL sp_empresa_registrar(
	1,
	1,
    'JRC',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);
CALL sp_actualizar_empresa (1,1,'Dijisa','Panamericana #234','dijisa@gmail.com','932123029');
-- -------------------------------------------------
-- REGISTRAR EMPRESAS


SELECT * FROM clientes;
SELECT * FROM personas;
SELECT * FROM empresas;
-- ACTUALIZAR EMPRESA


-- REGISTRAR CLIENTES 
CALL sp_cliente_registrar(26558000,1,'Empresa');

-- ACTUALIZAR CLIENTES
CALL sp_actualizar_cliente(4,12345678,1,'Persona');


 


-- REISTRAR PROOVEDORES
CALL sp_proovedor_registrar(1,1,'Dkasa', 'José Carlos', '932143290', 'Av. el Porvenir', 'jose@gmail.com');

SELECT * FROM proveedores;
-- Segundo insert utilizando el procedimiento almacenado



select * from personas;




/****Usuarios*********/


CALL sp_actualizar_usuario('usuario1','usuario1',3);
/****************************************************************************************************************/
  call sp_buscardistrito ('chincha');

