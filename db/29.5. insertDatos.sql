-- Active: 1726291702198@@localhost@3306@distribumax
USE distribumax;
-- TABLAS NECESARIAS PARA REGISTRAR PERSONAS
INSERT INTO tipo_documento (documento, descripcion) VALUES
('DNI', 'Documento Nacional de Identidad'),
('RUC', 'Registro Único de Contribuyentes'),
('CE', 'Carné de Extranjería'),
('PTP', 'Permiso Temporal de Permanencia'),
('PAS', 'Pasaporte');

--
INSERT INTO categorias (categoria) VALUES 
('Alimentos'),
('Bebidas'),
('Limpieza y Hogar'),
('Cuidado Personal'),
('Higiene y Salud'),
('Mascotas'),
('Embalaje y Descartables'),
('Electrodomésticos Pequeños'),
('Ferretería y Herramientas'),
('Oficina y Papelería');

INSERT INTO subcategorias (idcategoria, subcategoria) VALUES 
(1, 'Conservas'),
(1, 'Cereales'),
(1, 'Frutos Secos'),
(1, 'Aceites'),
(2, 'Bebidas Gaseosas'),
(2, 'Aguas Saborizadas'),
(2, 'Jugos y Néctares'),
(3, 'Detergentes'),
(3, 'Suavizantes'),
(4, 'Cuidado del Cabello'),
(4, 'Cuidado de la Piel'),
(5, 'Papel Higiénico'),
(6, 'Alimento para Perros'),
(6, 'Alimento para Gatos'),
(7, 'Bolsas Plásticas'),
(8, 'Licuadoras'),
(9, 'Tornillos y Clavos'),
(10, 'Papel');

-- Insertar marcas
INSERT INTO marcas (marca) VALUES
('Coca Cola'),
('Inca Kola'),
('Ariel'),
('Ace'),
('Pantene'),
('Sedal'),
('Dog Chow'),
('Pedigree'),
('Nestlé'),
('Gloria'),
('Colgate'),
('Huggies');

INSERT INTO roles (rol) VALUES 
('Administrador'), 
('Usuario'), 
('Moderador'), 
('Invitado'),
('Conductor'),
('Vendedor');

INSERT INTO tipo_comprobante_pago (comprobantepago) VALUES 
('Factura'), 
('Boleta');

INSERT INTO unidades_medidas (unidadmedida)
VALUES
    ('Unidad'),
    ('Caja'),
    ('Paquete');


INSERT INTO metodos_pago (metodopago)VALUES('Efectivo'),('Transferencia');

-- Insertar productos en la categoría Alimentos (idcategoria = 1)
-- Subcategoría Conservas (idsubcategoria = 1)
-- Marca Nestlé (idmarca = 9)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(9, 1, 'Atún Nestlé en Aceite', 'Lata de atún en aceite vegetal 170g',  'AL001CON'),
(9, 1, 'Sardinas Nestlé en Tomate', 'Lata de sardinas en salsa de tomate 240g', 'AL002CON');

-- Subcategoría Cereales (idsubcategoria = 2)
-- Marca Nestlé (idmarca = 9)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(9, 2, 'Avena Nestlé Instantánea', 'Avena instantánea de 500g', 'AL001CER'),
(9, 2, 'Quinua Orgánica Nestlé', 'Bolsa de quinua orgánica 500g', 'AL002CER');

-- Insertar productos en la categoría Bebidas (idcategoria = 2)
-- Subcategoría Bebidas Gaseosas (idsubcategoria = 5)
-- Marca Coca Cola (idmarca = 1)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(1, 5, 'Coca Cola 500ml', 'Bebida gaseosa Coca Cola en botella de 500ml', 'BEV001GAS'),
(1, 5, 'Coca Cola 2L', 'Bebida gaseosa Coca Cola en botella de 2L', 'BEV002GAS');

-- Marca Inca Kola (idmarca = 2)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(2, 5, 'Inca Kola 500ml', 'Bebida gaseosa Inca Kola en botella de 500ml','BEV003GAS'),
(2, 5, 'Inca Kola 2L', 'Bebida gaseosa Inca Kola en botella de 2L','BEV004GAS');

-- Insertar productos en la categoría Limpieza y Hogar (idcategoria = 3)
-- Subcategoría Detergentes (idsubcategoria = 8)
-- Marca Ariel (idmarca = 3) y Ace (idmarca = 4)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(3, 8, 'Detergente Ariel 1kg', 'Detergente en polvo Ariel 1kg', 'LH001DET'),
(4, 8, 'Detergente líquido Ace 900ml', 'Detergente líquido para ropa blanca y color 900ml', 'LH002DET');

-- Insertar productos en la categoría Cuidado Personal (idcategoria = 4)
-- Subcategoría Cuidado del Cabello (idsubcategoria = 10)
-- Marca Pantene (idmarca = 5)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(5, 10, 'Shampoo Pantene 400ml', 'Shampoo para todo tipo de cabello', 'CP001CAB'),
(5, 10, 'Acondicionador Pantene 350ml', 'Acondicionador hidratante para cabello seco', 'CP002CAB');

-- Marca Sedal (idmarca = 6)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(6, 10, 'Shampoo Sedal 400ml', 'Shampoo revitalizante para cabello graso', 'CP003CAB'),
(6, 10, 'Acondicionador Sedal 350ml', 'Acondicionador para cabello liso y brillante', 'CP004CAB');

-- Insertar productos en la categoría Mascotas (idcategoria = 6)
-- Subcategoría Alimento para Perros (idsubcategoria = 17)
-- Marca Dog Chow (idmarca = 7)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(7, 17, 'Dog Chow Adultos 4kg', 'Alimento balanceado para perros adultos', 'MASC001PER'),
(7, 17, 'Dog Chow Cachorros 2kg', 'Alimento para cachorros', 'MASC002PER');

-- Subcategoría Alimento para Gatos (idsubcategoria = 18)
-- Marca Pedigree (idmarca = 8)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, codigo) VALUES 
(8, 18, 'Pedigree Gatos Adultos 3kg', 'Alimento completo para gatos adultos', 'MASC001GAT'),
(8, 18, 'Pedigree Gatos Cachorros 1.5kg', 'Alimento nutritivo para gatitos', 'MASC002GAT');

CALL sp_empresa_registrar (
    20123456783,
    954,
    'JRC',
    'Av. Bancarios ',
    'santafe@gmail.com',
    '987654321'
); 
select * from proveedores;

-- Insertar un registro en la tabla proveedores
INSERT INTO proveedores (idempresa, proveedor, contacto_principal, telefono_contacto, direccion, email)
VALUES 
(20123456783, 'Proveedor Ejemplo', 'Juan Pérez', '987654321', 'Av. Principal 123, Ciudad', 'contacto@proveedorejemplo.com');

select * from proveedores;
select * from unidades_medidas;
-- Insertar registros en detalle_productos sin las columnas create_at y estado
INSERT INTO detalle_productos (idproveedor, idproducto, idunidadmedida, precio_compra, precio_venta_minorista, precio_venta_mayorista)
VALUES
    (2, 1, 1, 2.50, 3.50, 3.00),  -- Producto 1: Atún en lata
    (2, 2, 1, 1.20, 1.50, 1.30),  -- Producto 2: Leche evaporada
    (2, 3, 2, 0.80, 1.20, 1.00),  -- Producto 3: Coca Cola 500ml
    (2, 4, 2, 1.00, 1.50, 1.20),  -- Producto 4: Inca Kola 1L
    (2, 5, 3, 5.00, 7.50, 6.50),  -- Producto 5: Detergente Ariel
    (2, 6, 3, 4.80, 7.00, 6.00),  -- Producto 6: Detergente Ace
    (2, 7, 1, 3.20, 4.50, 4.00),  -- Producto 7: Shampoo Pantene
    (2, 8, 1, 2.90, 4.00, 3.50),  -- Producto 8: Acondicionador Sedal
    (2, 9, 3, 15.00, 20.00, 18.00),  -- Producto 9: Dog Chow Adultos
    (2, 10, 3, 12.00, 17.00, 15.00);  -- Producto 10: Pedigree Cachorros

-- select * from detalle_productos

INSERT INTO tipos_promociones (tipopromocion, descripcion)
VALUES ('Descuento de Temporada', 'Descuento especial aplicado durante la temporada de invierno.');
INSERT INTO tipos_promociones (tipopromocion, descripcion)
VALUES ('Porcentaje', 'Se aplica un porcentaje de descuento por und.');

SELECT * FROM tipos_promociones;
SELECT * FROM promociones;
SELECT * FROM detalle_promociones;
-- Registrando 2 metodos de pago
 -- Segundo método de pago

INSERT INTO promociones (idtipopromocion, descripcion, fechainicio, fechafin, valor_descuento)
VALUES
    (1, 'Descuento de Temporada', '2024-06-01', '2024-06-30', 5.00);
INSERT INTO promociones (idtipopromocion, descripcion, fechainicio, fechafin, valor_descuento)
VALUES
    (2, 'Descuento del 5% por und', '2021-06-01', '2021-06-30', 5);

INSERT INTO detalle_promociones (idpromocion, idproducto, descuento)
VALUES (1, 1, 5.00);
select * from promociones;
select * from detalle_promociones;
INSERT INTO detalle_promociones (idpromocion, idproducto, descuento)
VALUES (2, 2, 5.00);
-- Registrando vehiculos (2 vehiculos)
INSERT INTO vehiculos (idusuario, marca_vehiculo, modelo, placa, capacidad, condicion)
VALUES
    (1, 'Toyota', 'Corolla', 'ABC123', 5, 'operativo' ),
    (1, 'Honda', 'Civic', 'XYZ789', 5, 'operativo' );

SELECT * FROM vehiculos;
