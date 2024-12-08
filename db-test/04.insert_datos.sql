USE distribumax;

-- TIPOS DE DOCUMENTO
CALL sp_registrar_tipo_documento('DNI');
CALL sp_registrar_tipo_documento('RUC');

-- REGISTRAR EMPRESAS
CALL sp_empresa_registrar(2, 20100085063, 1, 'Ajinomoto del Perú S.A.C', 'Av. José Larco 812, Miraflores', 'contacto@ajinomoto.com.pe', '016199999');
CALL sp_empresa_registrar(2, 20100055237, 1, 'Alicorp S.A.A', 'Av. José Larco 812, Miraflores', 'contacto@alicorp.com.pe', '016388888');
CALL sp_empresa_registrar(2, 20266352337, 1, 'Softys Perú S.A.C', 'Av. José Larco 812, Miraflores', 'contacto@softys.com.pe', '017308888');

-- REGISTRAR PROVEEDORES
CALL sp_proovedor_registrar(20100085063, 'Proveedor Ajinomoto', 'Carlos López', '0161999999', 'Av. José Larco 812, Miraflores', 'proveedor@ajinomoto.com.pe');
CALL sp_proovedor_registrar(20100055237, 'Proveedor Alicorp', 'María Gómez', '0163088888', 'Av. José Larco 812, Miraflores', 'proveedor@alicorp.com.pe');
CALL sp_proovedor_registrar(20266352337, 'Proveedor Softys', 'Ricardo Morales', '0173088888', 'Av. José Larco 812, Miraflores', 'proveedor@softys.com.pe');

-- REGISTRAR CATEGORÍAS
CALL sp_registrar_categoria('Sazonadores');
CALL sp_registrar_categoria('Comida Instantánea');
CALL sp_registrar_categoria('Aceites');
CALL sp_registrar_categoria('Dulces y Golosinas');
CALL sp_registrar_categoria('Conservas');
CALL sp_registrar_categoria('Higiene Personal');
CALL sp_registrar_categoria('Pastas');
CALL sp_registrar_categoria('Harina');
CALL sp_registrar_categoria('Salsas');

-- REGISTRAR SUBCATEGORÍAS
CALL sp_registrar_subcategoria(1, 'Sazonadores en polvo');
CALL sp_registrar_subcategoria(2, 'Sopas instantáneas');
CALL sp_registrar_subcategoria(3, 'Aceite de oliva');
CALL sp_registrar_subcategoria(3, 'Aceite vegetal');
CALL sp_registrar_subcategoria(4, 'Galletas');
CALL sp_registrar_subcategoria(6, 'Papel higiénico');
CALL sp_registrar_subcategoria(6, 'Toallas higiénicas');
CALL sp_registrar_subcategoria(6, 'Pañales');

-- REGISTRAR MARCAS
CALL sp_registrar_marca(1, 'Ajinomoto');
CALL sp_registrar_marca(1, 'Ajino-men');
CALL sp_registrar_marca(1, 'Ajino-mix');
CALL sp_registrar_marca(2, 'Primor');
CALL sp_registrar_marca(2, 'Casino');
CALL sp_registrar_marca(2, 'Glacitas');
CALL sp_registrar_marca(3, 'Elite');
CALL sp_registrar_marca(3, 'Babysec');
CALL sp_registrar_marca(3, 'Ladysoft');


-- REGISTRAR DETALLES DE MARCA Y CATEGORÍA
CALL sp_registrar_detalle(1, 1); -- ajinomoto → Sazonadores
CALL sp_registrar_detalle(2, 1); -- ajino-men → Sazonadores
CALL sp_registrar_detalle(3, 1); -- ajino-mix → Sazonadores
CALL sp_registrar_detalle(4, 3); -- primor → Aceites
CALL sp_registrar_detalle(5, 4); -- casino → Dulces y Golosinas
CALL sp_registrar_detalle(6, 4); -- glacitas → Dulces y Golosinas
CALL sp_registrar_detalle(7, 6); -- elite → Higiene Personal
CALL sp_registrar_detalle(8, 6); -- babysec → Higiene Personal


CALL sp_tipo_comprobantes_registrar('Factura');
CALL sp_tipo_comprobantes_registrar('Boleta');

-- REGISTRAR MÉTODOS DE PAGO
CALL sp_metodo_pago_registrar('Efectivo');
CALL sp_metodo_pago_registrar('Transferencia');
CALL sp_metodo_pago_registrar('Yape');
CALL sp_metodo_pago_registrar('Plin');

-- REGISTRAR UNIDADES DE MEDIDA
CALL sp_registrar_unidades('Unidad');
CALL sp_registrar_unidades('Caja');
CALL sp_registrar_unidades('Paquete');
CALL sp_registrar_unidades('Bolsa');

-- REGISTRAR PRODUCTOS
-- Ajinomoto

CALL sp_registrar_producto(1, 1, 1, 'Ajinomoto Sazonador Umami', 4, 24, '27 GR', 'AJI-SZ-001', 10.50, 13.03, 15.00);
CALL sp_registrar_producto(1, 1, 1, 'Ajinomoto Sazonador de Pollo', 4, 12, '12 GR', 'AJI-SZ-002', 10.80, 12.00, 13.30);
CALL sp_registrar_producto(1, 2, 2, 'Ajino-men gallina', 4, 12, '80 GR', 'AJI-RM-001', 10.50, 12.50, 14.50);
CALL sp_registrar_producto(1, 2, 2, 'Ajino-men carne', 4, 24, '80 GR', 'AJI-RM-002', 28.00, 30.00, 31.50);

-- Alicorp
CALL sp_registrar_producto(2, 4, 3, 'Primor Aceite vegetal clásico', 2, 12, '900 ML', 'PRI-AO-001', 95.00, 100.00, 105.00);
CALL sp_registrar_producto(2, 4, 3, 'Primor Aceite Vegetal premium', 2, 12, '900 ML', 'PRI-AO-002', 100.00, 105.00, 115.00);
CALL sp_registrar_producto(2, 5, 5, 'Galletas Casino', 2, 8, '200 GR', 'CAS-GA-001', 32.00, 35.20, 38.80);
CALL sp_registrar_producto(2, 6, 5, 'Glacitas Toffee', 2, 8, '192 GR', 'GLA-GA-002', 32.20, 35.20, 38.80);

-- Softys
CALL sp_registrar_producto(3, 7, 6, 'Elite Papel Higiénico doble hoja', 3, 48, '15 m', 'ELI-PH-001', 35.00, 36.50, 37.00);
CALL sp_registrar_producto(3, 7, 6, 'Elite clásico Doble Hoja', 3, 40, '18 m', 'ELI-PH-002', 14.00, 17.00, 18.00);
CALL sp_registrar_producto(3, 8, 6, 'Babysec Pañales Super Premium talla XXG', 3, 58, '', 'BBS-PN-001', 30.00, 35.00, 38.00);
CALL sp_registrar_producto(3, 8, 6, 'BABYSEC Premium XXG', 3, 72, '', 'BBS-PN-002', 32.00, 37.00, 40.00);

-- REGISTRAR TIPOS DE COMPROBANTES DE PAGO

