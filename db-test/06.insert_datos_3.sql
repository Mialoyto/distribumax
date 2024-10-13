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
CALL sp_registrar_usuario ( 26558000, 1, 'administrador', 'admin' );

CALL sp_registrar_usuario ( 26558001, 2, 'usuario', 'admin' );

CALL sp_registrar_usuario ( 26558002, 3, 'conductor', 'admin' );

CALL sp_registrar_usuario ( 26558003, 4, 'vendedor', 'admin' );

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

CALL sp_cliente_registrar (NULL, 20100055237, 'Empresa');

-- PRROMOCIONES
CALL sp_tipo_promocion_registrar (
    'Descuento',
    'Se aplicará un porcentaje de descuento al producto'
);

CALL sp_promocion_registrar (
    1,
    "Descuento en productos seleccionados",
    '2024-10-20',
    '2024-10-31',
    5
);

CALL sp_promocion_registrar (
    1,
    "Descuento en productos en galletas Casino",
    '2024-10-20',
    '2024-10-31',
    5
);

CALL sp_detalle_promociones_registrar (2, 7, 5);
CALL sp_detalle_promociones_registrar (2,1, 5);
CALL sp_detalle_promociones_registrar (2,4, 5);
CALL sp_detalle_promociones_registrar (2,12, 5);
CALL sp_detalle_promociones_registrar (2,10, 5);
/* CALL sp_detalle_promociones_registrar (2,18, 5);
CALL sp_detalle_promociones_registrar (2,19, 5);
CALL sp_detalle_promociones_registrar (2,20, 5);  */
