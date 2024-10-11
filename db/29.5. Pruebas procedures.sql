-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribuMax;
/**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558000', -- Número de documento
    1, -- ID del distrito
    'Miguel', -- Nombres
    'Loyola', -- Apellido paterno
    'Torres', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 123' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558001', -- Número de documento
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

CALL sp_registrar_usuario(26558000,2,'admin','admin');
CALL sp_actualizar_usuario
(
'admin',
'$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
1
);

INSERT INTO vehiculos (idusuario, marca_vehiculo, modelo, placa, capacidad, condicion)
VALUES
    (1, 'Toyota', 'Corolla', 'ABC123', 5, 'operativo' ),
    (1, 'Honda', 'Civic', 'XYZ789', 5, 'operativo' );


-- -------------------------------------------------
-- REGISTRAR EMPRESAS

CALL sp_empresa_registrar (
    20123456780,
    954,
    'Dijisa',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);


CALL sp_empresa_registrar (
    20123456781,
    954,
    'Archor',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);

CALL sp_actualizar_empresa (
    20123456782,
    1834,
    'Alicorp',
    'Panamericana #234',
    'dijisa@gmail.com',
    '932123029'
);


/* PROCEDIMIENTOS DE CLIENTES ✔️*/ 
-- REGISTRAR CLIENTES
CALL sp_cliente_registrar (26558000, NULL, 'Persona');
CALL sp_cliente_registrar (NULL, 20123456781, 'Empresa');


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
	20123456782,
	954,
    'JRCA',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
);



-- detalle idos

CALL sp_registrarmovimiento_kardex(1, 1,'2023-10-05','LOT002','Ingreso', 100, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 2,'2023-10-05','LOT002','Ingreso', 125, 'Ingreso de productos para venta');
CALL sp_registrarmovimiento_kardex(1, 3,'2023-10-05','LOT002','Ingreso', 150, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 4,'2023-10-05','LOT002','Ingreso', 200, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 5,'2023-10-05','LOT002','Ingreso', 225, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 6,'2023-10-05','LOT002','Ingreso', 250, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 7,'2023-10-05','LOT002','Ingreso', 300, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 8,'2023-10-05','LOT002','Ingreso', 325, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 9,'2023-10-05','LOT002','Ingreso', 350, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 10,'2023-10-05','LOT002','Ingreso',400, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 11,'2023-10-05','LOT002','Ingreso',425, 'Ingreso de productos adicionales');

