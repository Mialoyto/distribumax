-- Active: 1728956418931@@127.0.0.1@3306@distribumax
USE distribumax;
/**PRUEBAS PROCEDIMIENTOS OK ✔️  PERSONAS**/
CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558000', -- Número de documento
    1, -- ID del distrito
    'pepito', -- Nombres
    'Levano', -- Apellido paterno
    'Martinez', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 001' -- Dirección
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
    'Emely', -- Nombres
    'Rojas', -- Apellido paterno
    'De Castilla', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 666' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558003', -- Número de documento
    2, -- ID del distrito
    'Agripino', -- Nombres
    'Manrique', -- Apellido paterno
    'Avalos', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Falsa 035' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558004', -- Número de documento
    5, -- ID del distrito
    'Lucía', -- Nombres
    'García', -- Apellido paterno
    'Fernández', -- Apellido materno
    '123456789', -- Teléfono
    'Av. Siempre Viva 742' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558005', -- Número de documento
    8, -- ID del distrito
    'Carlos', -- Nombres
    'Pérez', -- Apellido paterno
    'Soto', -- Apellido materno
    '987654321', -- Teléfono
    'Jr. Los Sauces 123' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558006', -- Número de documento
    3, -- ID del distrito
    'Ana', -- Nombres
    'Rodríguez', -- Apellido paterno
    'Lopez', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Las Flores 678' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558007', -- Número de documento
    7, -- ID del distrito
    'Jorge', -- Nombres
    'Zapata', -- Apellido paterno
    'Ramírez', -- Apellido materno
    '321654987', -- Teléfono
    'Calle El Sol 999' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558008', -- Número de documento
    10, -- ID del distrito
    'Sofía', -- Nombres
    'Mendoza', -- Apellido paterno
    'Silva', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Av. Los Pinos 456' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558009', -- Número de documento
    12, -- ID del distrito
    'Gabriela', -- Nombres
    'Castro', -- Apellido paterno
    'Salazar', -- Apellido materno
    '998877665', -- Teléfono
    'Jr. Las Estrellas 321' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558010', -- Número de documento
    4, -- ID del distrito
    'Ricardo', -- Nombres
    'Vargas', -- Apellido paterno
    'Quispe', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Av. Las Palmeras 432' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558011', -- Número de documento
    6, -- ID del distrito
    'Isabel', -- Nombres
    'Torres', -- Apellido paterno
    'Villanueva', -- Apellido materno
    '999123456', -- Teléfono
    'Calle Los Robles 555' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558012', -- Número de documento
    9, -- ID del distrito
    'Marcos', -- Nombres
    'Fuentes', -- Apellido paterno
    'Paredes', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Jr. Los Tulipanes 876' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558013', -- Número de documento
    11, -- ID del distrito
    'Paola', -- Nombres
    'Cruz', -- Apellido paterno
    'Valverde', -- Apellido materno
    '987654310', -- Teléfono
    'Av. Las Rosas 234' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558014', -- Número de documento
    14, -- ID del distrito
    'Eduardo', -- Nombres
    'López', -- Apellido paterno
    'Ortiz', -- Apellido materno
    '912345678', -- Teléfono
    'Jr. Los Jazmines 102' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558015', -- Número de documento
    15, -- ID del distrito
    'Fernanda', -- Nombres
    'Ramírez', -- Apellido paterno
    'Guzmán', -- Apellido materno
    NULL, -- Teléfono (NULL)
    'Calle Los Olivos 753' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558016', -- Número de documento
    13, -- ID del distrito
    'Miguel', -- Nombres
    'Jiménez', -- Apellido paterno
    'Medina', -- Apellido materno
    '998654321', -- Teléfono
    'Av. Las Acacias 369' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558017', -- Número de documento
    13, -- ID del distrito
    'Miguel', -- Nombres
    'Jiménez', -- Apellido paterno
    'Medina', -- Apellido materno
    '998654321', -- Teléfono
    'Av. Las Acacias 369' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558018', -- Número de documento
    13, -- ID del distrito
    'Miguel', -- Nombres
    'Jiménez', -- Apellido paterno
    'Medina', -- Apellido materno
    '998654321', -- Teléfono
    'Av. Las Acacias 369' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558019', -- Número de documento
    13, -- ID del distrito
    'Miguel', -- Nombres
    'Jiménez', -- Apellido paterno
    'Medina', -- Apellido materno
    '998654321', -- Teléfono
    'Av. Las Acacias 369' -- Dirección
);

CALL spu_registrar_personas (
    1, -- Tipo de documento (dni)
    '26558020', -- Número de documento
    13, -- ID del distrito
    'Miguel', -- Nombres
    'Jiménez', -- Apellido paterno
    'Medina', -- Apellido materno
    '998654321', -- Teléfono
    'Av. Las Acacias 369' -- Dirección
);

/**PRUEBAS PROCEDIMIENTOS OK ✔️  USUARIOS**/
CALL sp_registrar_usuario ( 26558000, 1,'ADM', 'administrador', 'admin' );

CALL sp_registrar_usuario ( 26558001, 2,'ADM', 'usuario', 'admin' );

CALL sp_registrar_usuario ( 26558002, 3,'CHF', 'conductor', 'admin' );

CALL sp_registrar_usuario ( 26558003, 4, 'VND','vendedor', 'admin' );
CALL sp_registrar_usuario(26558015,3,'ALM','almacen','admin');


CALL sp_actualizar_usuario (
    'administrador',
    '$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
    1
);

CALL sp_actualizar_usuario (
    'usuario',
    '$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
    2
);

CALL sp_actualizar_usuario (
    'conductor',
    '$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
    3
);

CALL sp_actualizar_usuario (
    'vendedor',
    '$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm',
    4
);

-- -------------------------------------------------
CALL sp_cliente_registrar (26558000, NULL, 'Persona');

CALL sp_cliente_registrar (26558001, NULL, 'Persona');

CALL sp_cliente_registrar (26558002, NULL, 'Persona');

CALL sp_cliente_registrar (26558003, NULL, 'Persona');

CALL sp_cliente_registrar (26558004, NULL, 'Persona');

CALL sp_cliente_registrar (26558005, NULL, 'Persona');

CALL sp_cliente_registrar (26558006, NULL, 'Persona');

CALL sp_cliente_registrar (26558007, NULL, 'Persona');

CALL sp_cliente_registrar (26558008, NULL, 'Persona');

CALL sp_cliente_registrar (26558009, NULL, 'Persona');

CALL sp_cliente_registrar (26558010, NULL, 'Persona');

CALL sp_cliente_registrar (26558011, NULL, 'Persona');

CALL sp_cliente_registrar (26558012, NULL, 'Persona');

CALL sp_cliente_registrar (26558013, NULL, 'Persona');

CALL sp_cliente_registrar (26558014, NULL, 'Persona');

CALL sp_cliente_registrar (26558015, NULL, 'Persona');

CALL sp_cliente_registrar (26558016, NULL, 'Persona');

CALL sp_cliente_registrar (26558017, NULL, 'Persona');

CALL sp_cliente_registrar (26558018, NULL, 'Persona');

CALL sp_cliente_registrar (26558019, NULL, 'Persona');

CALL sp_cliente_registrar (26558020, NULL, 'Persona');

CALL sp_cliente_registrar (NULL, 20100055237, 'Empresa');

-- PRROMOCIONES
CALL sp_tipo_promocion_registrar (
    'Descuento',
    'Se aplicará un porcentaje de descuento al producto'
);

CALL sp_tipo_promocion_registrar (
    'Combo de Productos',
    'Promoción en la que se venden varios productos juntos a un precio reducido'
);

CALL sp_tipo_promocion_registrar (
    '2x1',
    'Por la compra de un producto, el cliente recibe otro gratis'
);

CALL sp_tipo_promocion_registrar (
    'Descuento por Volumen',
    'Descuento aplicable al comprar una gran cantidad de productos'
);

CALL sp_tipo_promocion_registrar (
    'Producto de Regalo',
    'Por la compra de ciertos productos, se ofrece otro producto de regalo'
);

CALL sp_tipo_promocion_registrar (
    'Descuento Estacional',
    'Promoción aplicable en temporadas específicas, como Navidad o Año Nuevo'
);

CALL sp_tipo_promocion_registrar (
    'Premio por Fidelidad',
    'Descuento especial para clientes habituales o suscriptores de la distribuidora'
);

CALL sp_promocion_registrar (
    1,
    "Descuento en productos seleccionados",
    '2024-12-20',
    '2024-12-31',
    5
);

CALL sp_promocion_registrar (
    1,
    "Descuento en productos en galletas Casino",
    '2024-12-20',
    '2024-12-31',
    5
);

CALL sp_detalle_promociones_registrar (2, 7, 5);

CALL sp_detalle_promociones_registrar (2, 1, 5);

CALL sp_detalle_promociones_registrar (2, 4, 5);

CALL sp_detalle_promociones_registrar (2, 12, 5);

CALL sp_detalle_promociones_registrar (2, 10, 5);
CALL sp_registrar_vehiculo (
    1, -- ID del usuario (reemplaza con el ID correcto)
    'Toyota', -- Marca del vehículo
    'Hilux', -- Modelo del vehículo
    'ABC-123', -- Placa del vehículo
    1500, -- Capacidad en Kg
    'operativo' -- Condición del vehículo ('operativo', 'taller', 'averiado')
);

CALL sp_registrar_vehiculo (
    2, -- ID del usuario (reemplaza con el ID correcto)
    'Gretell', -- Marca del vehículo
    'Confiable', -- Modelo del vehículo
    'ADR-123', -- Placa del vehículo
    1087, -- Capacidad en Kg
    'operativo' -- Condición del vehículo ('operativo', 'taller', 'averiado')
);

CALL sp_registrar_vehiculo (
    3, -- ID del usuario (reemplaza con el ID correcto)
    'Emely', -- Marca del vehículo
    'SEXO', -- Modelo del vehículo
    'AD3-123', -- Placa del vehículo
    1080, -- Capacidad en Kg
    'taller' -- Condición del vehículo ('operativo', 'taller', 'averiado')
);