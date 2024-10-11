-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;
-- TABLAS NECESARIAS PARA REGISTRAR PERSONAS
-- TIPO DE DOCUMENTOS
CALL sp_registrar_tipo_documento ('DNI');
CALL sp_registrar_tipo_documento ('RUC');
CALL sp_registrar_tipo_documento ('PASAPORTE');
CALL sp_registrar_tipo_documento ('CARNET DE EXTRANJERÍA');

/* REGISTRAR EMPRESAS */
CALL sp_empresa_registrar (
    20100085063,
    1,
    'Ajinomoto del Perú S.A.C',
    'Av. José Larco 812, Miraflores',
    'contacto@ajinomoto.com.pe',
    '01 619 9999'
);

CALL sp_empresa_registrar (
    20100055237,
    1,
    'Alicorp S.A.A',
    'Av. José Larco 812, Miraflores',
    'contacto@alicorp.com.pe',
    '01 630 8888'
);

CALL sp_empresa_registrar (
    20266352337,
    1,
    'Softys Perú S.A.C',
    'Av. José Larco 812, Miraflores',
    'contacto@softys.com.pe',
    '01 730 8888'
);

/* REGISTRAR PROVEEDORES */
CALL sp_proovedor_registrar (
    20100085063,
    'Proveedor Ajinomoto',
    'Carlos López',
    '01 619 9999',
    'Av. José Larco 812, Miraflores',
    'proveedor@ajinomoto.com.pe'
);

CALL sp_proovedor_registrar (
    20100055237,
    'Proveedor Alicorp',
    'María Gómez',
    '01 630 8888',
    'Av. José Larco 812, Miraflores',
    'proveedor@alicorp.com.pe'
);

CALL sp_proovedor_registrar (
    20266352337,
    'Proveedor Softys',
    'Ricardo Morales',
    '01 730 8888',
    'Av. José Larco 812, Miraflores',
    'proveedor@softys.com.pe'
);

/* REGISTRAR MARCAS */
-- Registrar las marcas
CALL sp_registrar_marca (1, 'Ajinomoto');

CALL sp_registrar_marca (1, 'Ajino-men');

CALL sp_registrar_marca (1, 'Ajino-mix');

CALL sp_registrar_marca (2, 'Primor');

CALL sp_registrar_marca (2, 'Casino');

CALL sp_registrar_marca (2, 'Glacitas');

CALL sp_registrar_marca (3, 'Elite');

CALL sp_registrar_marca (3, 'Babysec');

CALL sp_registrar_marca (3, 'Ladysoft');

/* REGISTRAR CATEGORIAS  */

-- ajinomoto
CALL sp_registrar_categoria ('Sazonadores');

CALL sp_registrar_categoria ('Comida Instantánea');
-- alicorp

CALL sp_registrar_categoria ('Aceites');

CALL sp_registrar_categoria ('Dulces y Golosinas');

CALL sp_registrar_categoria ('Conservas');
-- softys
CALL sp_registrar_categoria ('Higiene Personal');

/*  REGISTRAR SUBCATERIAS */
-- ajinomoto

CALL sp_registrar_subcategoria (1, 'Sazonadores en polvo');

CALL sp_registrar_subcategoria (2, 'Sopas instantáneas');

-- alicorp

CALL sp_registrar_subcategoria (3, 'Aceite de oliva');

CALL sp_registrar_subcategoria (3, 'Aceite vegetal');

CALL sp_registrar_subcategoria (4, 'Galletas');

CALL sp_registrar_subcategoria (5, 'atún');

-- softys
CALL sp_registrar_subcategoria (6, 'Papel higiénico');

CALL sp_registrar_subcategoria (6, 'Toallas higiénicas');

CALL sp_registrar_subcategoria (6, 'Pañales');

-- INSERT ROLES
CALL sp_registrar_roles ('Administrador');

CALL sp_registrar_roles ('Usuario');

CALL sp_registrar_roles ('Conductor');

CALL sp_registrar_roles ('Vendedor');

-- INSERT TIPO DE COMPROBANTES DE PAGO
CALL sp_tipo_comprobantes_registrar ('Factura');

CALL sp_tipo_comprobantes_registrar ('Boleta');

-- INSERT METODOS DE PAGO
CALL sp_metodo_pago_registrar ('Efectivo');

CALL sp_metodo_pago_registrar ('Transferencia');

CALL sp_metodo_pago_registrar ('Yape');

CALL sp_metodo_pago_registrar ('Plin');

-- INSERT UNIDADES MEDIDAS
CALL sp_registrar_unidades ('Unidad');

CALL sp_registrar_unidades ('Caja');

CALL sp_registrar_unidades ('Paquete');

CALL sp_registrar_unidades ('Bolsa');


/* INSERTAR PRODUCTOS */

/* Ajinomoto */
CALL sp_registrar_producto(
    1,    -- idproveedor: Ajinomoto
    1,
    1,              -- idsubcategoria: Sazonadores básicos
    'Ajinomoto Sazonador Umami', -- nombreproducto
    4,              -- idunidadMedida: BOLSA
    24,             -- cantidadPresentacion: 24 UND
    '27 GR',       -- pesoUnitario
    'AJI-SZ-001',   -- codigo
    10.50,          -- precioCompra
    15.00,          -- precioMinorista
    13.03           -- precioMayorita
);

CALL sp_registrar_producto(
    1,    -- idproveedor: Ajinomoto
    1,
    1,              -- idsubcategoria: Sazonadores básicos
    'Ajinomoto Sazonador de Pollo', -- nombreproducto
    4,              -- idunidadMedida: PAQUETE
    12,             -- cantidadPresentacion: 120 gramos
    '12 GR',        -- pesoUnitario
    'AJI-SZ-002',   -- codigo
    10.80,           -- precioCompra
    12.00,            -- precioMayorita
    13.30           -- precioMinorista
);

/* Ajinomoto - Sopas instantáneas */
CALL sp_registrar_producto(
    1,    -- idproveedor: Ajinomoto
    2,
    2,              -- idsubcategoria: Sopas instantáneas
    'Ajino-men gallina', -- nombreproducto
    4,              -- idunidadMedida: BOLSA
    12,             -- cantidadPresentacion: 12 UND
    '80 GR',        -- pesoUnitario
    'AJI-RM-001',   -- codigo
    10.50,          -- precioCompra
    12.50,           -- precioMayorita
    14.50          -- precioMinorista
);

CALL sp_registrar_producto(
    1,    -- idproveedor: Ajinomoto
    2,
    2,              -- idsubcategoria: Sopas instantáneas
    'Ajino-men carne', -- nombreproducto
    4,              -- idunidadMedida: BOLSA
    24,             -- cantidadPresentacion: 24 UND
    '80 GR',        -- pesoUnitario
    'AJI-RM-002',   -- codigo
    28.00,          -- precioCompra
    31.50,          -- precioMinorista
    30.00           -- precioMayorita
);

/* Alicorp - Aceite de Oliva */
CALL sp_registrar_producto(
    2,    -- idproveedor: Alicorp
    3,
    3,              -- idsubcategoria: Aceite de oliva
    'Primor Aceite vegetal clásico', -- nombreproducto
    2,              -- idunidadMedida: CAJA
    12,             -- cantidadPresentacion: 12 UND
    '900 ML',       -- pesoUnitario
    'PRI-AO-001',   -- codigo
    95.00,          -- precioCompra
    100.00,          -- precioMinorista
    105.00           -- precioMayorita
);

CALL sp_registrar_producto(
    2,    -- idproveedor: Alicorp
    3,
    3,              -- idsubcategoria: Aceite de oliva
    'Primor Aceite Vegetal premium', -- nombreproducto
    2,              -- idunidadMedida: caja
    12,             -- cantidadPresentacion: 12 UND
    '900 ML',       -- pesoUnitario
    'PRI-AO-002',   -- codigo
    100.00,           -- precioCompra
    105.00,          -- precioMayorita
    115.00          -- precioMinorista
);

/* Alicorp - Galletas */
CALL sp_registrar_producto(
    2,    -- idproveedor: Alicorp
    4,
    4,              -- idsubcategoria: Galletas
    'Galletas Casino', -- nombreproducto
    2,              -- idunidadMedida: CAJA
    8,              -- cantidadPresentacion: 8 SIXPACK O 48 UND
    '200 GR',       -- pesoUnitario
    'CAS-GA-001',   -- codigo
    32.00,           -- precioCompra
    35.20,           -- precioMayorista
    38.80            -- precioMinorista
);

CALL sp_registrar_producto(
    2,    -- idproveedor: Alicorp
    5,
    4,              -- idsubcategoria: Galletas
    'Glacitas Toffee', -- nombreproducto
    2,              -- idunidadMedida: caja
    8,              -- cantidadPresentacion: sic pack
    '192 GR',      -- pesoUnitario
    'GLA-GA-002',   -- codigo
    32.20,           -- precioCompra
    35.20,          -- precioMayorista
    38.80            -- precioMinorista
);

/* Softys - Papel Higiénico */
CALL sp_registrar_producto(
    3,    -- idproveedor: Softys
    7,
    6,              -- idsubcategoria: Papel higiénico
    'Elite Papel Higiénico doble hoja', -- nombreproducto
    3,              -- idunidadMedida: Paquete
    48,              -- cantidadPresentacion: UND
    '15 m',       -- pesoUnitario
    'ELI-PH-001',   -- codigo
    35.00,           -- precioCompra
    36.50,            -- precioMayorista
    37.00           -- precioMinorista
);

CALL sp_registrar_producto(
    3,    -- idproveedor: Softys
    7,
    6,              -- idsubcategoria: Papel higiénico
    'Elite clásico Doble Hoja', -- nombreproducto
    3,              -- idunidadMedida: Paquete
    40,              -- cantidadPresentacion: und
    '18 m',       -- pesoUnitario
    'ELI-PH-002',   -- codigo
    14.00,          -- precioCompra
    18.00,          -- precioMinorista
    17.00           -- precioMayorista
);

/* Softys - Pañales */
CALL sp_registrar_producto(
    3,    -- idproveedor: Softys
    8,
    6,              -- idsubcategoria: Pañales
    'Babysec Pañales Super preium talla XXG', -- nombreproducto
    3,              -- idunidadMedida: Paquete
    58,             -- cantidadPresentacion: UND
    '',       -- pesoUnitario
    'BBS-PN-001',   -- codigo
    30.00,          -- precioCompra
    38.00,          -- precioMinorista
    35.00           -- precioMayorista
);

CALL sp_registrar_producto(
    3,    -- idproveedor: Softys
    8,
    6,              -- idsubcategoria: Pañales
    'BABYSEC Premium XXG', -- nombreproducto
    3,              -- idunidadMedida: Paquete
    72,             -- cantidadPresentacion: 30 pañales
    '',       -- pesoUnitario
    'BBS-PN-002',   -- codigo
    32.00,          -- precioCompra
    40.00,          -- precioMinorista
    37.00           -- precioMayorista
);
