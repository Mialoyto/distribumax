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
('Invitado');




-- Insertar productos en la categoría Alimentos (idcategoria = 1)
-- Subcategoría Conservas (idsubcategoria = 1)
-- Marca Nestlé (idmarca = 9)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(9, 1, 'Atún Nestlé en Aceite', 'Lata de atún en aceite vegetal 170g', 8.50, 'AL001CON'),
(9, 1, 'Sardinas Nestlé en Tomate', 'Lata de sardinas en salsa de tomate 240g', 6.00, 'AL002CON');

-- Subcategoría Cereales (idsubcategoria = 2)
-- Marca Nestlé (idmarca = 9)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(9, 2, 'Avena Nestlé Instantánea', 'Avena instantánea de 500g', 5.00, 'AL001CER'),
(9, 2, 'Quinua Orgánica Nestlé', 'Bolsa de quinua orgánica 500g', 12.00, 'AL002CER');

-- Insertar productos en la categoría Bebidas (idcategoria = 2)
-- Subcategoría Bebidas Gaseosas (idsubcategoria = 5)
-- Marca Coca Cola (idmarca = 1)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(1, 5, 'Coca Cola 500ml', 'Bebida gaseosa Coca Cola en botella de 500ml', 3.50, 'BEV001GAS'),
(1, 5, 'Coca Cola 2L', 'Bebida gaseosa Coca Cola en botella de 2L', 8.00, 'BEV002GAS');

-- Marca Inca Kola (idmarca = 2)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(2, 5, 'Inca Kola 500ml', 'Bebida gaseosa Inca Kola en botella de 500ml', 3.50, 'BEV003GAS'),
(2, 5, 'Inca Kola 2L', 'Bebida gaseosa Inca Kola en botella de 2L', 8.00, 'BEV004GAS');

-- Insertar productos en la categoría Limpieza y Hogar (idcategoria = 3)
-- Subcategoría Detergentes (idsubcategoria = 8)
-- Marca Ariel (idmarca = 3) y Ace (idmarca = 4)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(3, 8, 'Detergente Ariel 1kg', 'Detergente en polvo Ariel 1kg', 15.00, 'LH001DET'),
(4, 8, 'Detergente líquido Ace 900ml', 'Detergente líquido para ropa blanca y color 900ml', 12.00, 'LH002DET');

-- Insertar productos en la categoría Cuidado Personal (idcategoria = 4)
-- Subcategoría Cuidado del Cabello (idsubcategoria = 10)
-- Marca Pantene (idmarca = 5)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(5, 10, 'Shampoo Pantene 400ml', 'Shampoo para todo tipo de cabello', 10.00, 'CP001CAB'),
(5, 10, 'Acondicionador Pantene 350ml', 'Acondicionador hidratante para cabello seco', 9.00, 'CP002CAB');

-- Marca Sedal (idmarca = 6)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(6, 10, 'Shampoo Sedal 400ml', 'Shampoo revitalizante para cabello graso', 8.50, 'CP003CAB'),
(6, 10, 'Acondicionador Sedal 350ml', 'Acondicionador para cabello liso y brillante', 7.50, 'CP004CAB');

-- Insertar productos en la categoría Mascotas (idcategoria = 6)
-- Subcategoría Alimento para Perros (idsubcategoria = 17)
-- Marca Dog Chow (idmarca = 7)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(7, 17, 'Dog Chow Adultos 4kg', 'Alimento balanceado para perros adultos', 60.00, 'MASC001PER'),
(7, 17, 'Dog Chow Cachorros 2kg', 'Alimento para cachorros', 35.00, 'MASC002PER');

-- Subcategoría Alimento para Gatos (idsubcategoria = 18)
-- Marca Pedigree (idmarca = 8)
INSERT INTO productos (idmarca, idsubcategoria, nombreproducto, descripcion, preciounitario, codigo) VALUES 
(8, 18, 'Pedigree Gatos Adultos 3kg', 'Alimento completo para gatos adultos', 50.00, 'MASC001GAT'),
(8, 18, 'Pedigree Gatos Cachorros 1.5kg', 'Alimento nutritivo para gatitos', 25.00, 'MASC002GAT');


INSERT INTO tipos_promociones (tipopromocion, descripcion)
VALUES ('Descuento de Temporada', 'Descuento especial aplicado durante la temporada de invierno.');

-- Registrando 2 metodos de pago
INSERT INTO metodos_pago (metodopago, estado)
VALUES
    ('Tarjeta de Crédito', 1),   -- Primer método de pago
    ('Transferencia Bancaria', 1); -- Segundo método de pago


-- Registrando vehiculos (2 vehiculos)
INSERT INTO vehiculos (idusuario, marca_vehiculo, modelo, placa, capacidad, condicion, estado)
VALUES
    (1, 'Toyota', 'Corolla', 'ABC123', 5, 'operativo', 'Activo'),
    (1, 'Honda', 'Civic', 'XYZ789', 5, 'operativo', 'Activo');

-- Registrando ventas (2 ventas)
INSERT INTO ventas (idpedido,idmetodopago,idtipocomprobante,fecha_venta,subtotal,descuento,igv,total_venta,create_at,update_at,estado) 
VALUES
	(1,1,1,NOW(),100.00,10.00,18.00,108.00,NOW(),NULL,1),
	(2,2,2,NOW(),200.00,20.00,36.00,216.00,NOW(),NULL,1);
