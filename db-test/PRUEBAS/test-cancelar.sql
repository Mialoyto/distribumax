-- Active: 1732807506399@@127.0.0.1@3306@test
-- Create a test database
DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;

-- Create necessary tables (simplified for testing)
CREATE TABLE productos (
    idproducto INT PRIMARY KEY AUTO_INCREMENT,
    nombreproducto VARCHAR(250) NOT NULL,
    codigo CHAR(30) NOT NULL,
    precio_compra DECIMAL(10, 2) NOT NULL,
    precio_mayorista DECIMAL(10, 2) NOT NULL,
    precio_minorista DECIMAL(10, 2) NOT NULL,
    estado CHAR(1) NOT NULL DEFAULT "1"
) ENGINE = INNODB;

CREATE TABLE pedidos (
    idpedido CHAR(15) NOT NULL PRIMARY KEY,
    idusuario INT NOT NULL,
    idcliente INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT NOW(),
    create_at DATETIME NOT NULL DEFAULT NOW(),
    update_at DATETIME NULL,
    estado CHAR(10) NOT NULL DEFAULT 'Pendiente'
) ENGINE = INNODB;

CREATE TABLE detalle_pedidos (
    id_detalle_pedido INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idpedido CHAR(15) NOT NULL,
    idproducto INT NOT NULL,
    cantidad_producto INT NOT NULL,
    unidad_medida CHAR(20) NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    precio_descuento DECIMAL(10, 2) NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    create_at DATETIME NOT NULL DEFAULT NOW(),
    update_at DATETIME NULL,
    estado CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT fk_idpedido_det_ped FOREIGN KEY (idpedido) REFERENCES pedidos (idpedido),
    CONSTRAINT fk_idproducto_det_ped FOREIGN KEY (idproducto) REFERENCES productos (idproducto)
) ENGINE = INNODB;

-- Insert test data
INSERT INTO productos (nombreproducto, codigo, precio_compra, precio_mayorista, precio_minorista)
VALUES ('Galletas', 'GAL123', 10.00, 12.00, 15.00),
       ('Cafe', 'CAF123', 20.00, 25.00, 30.00);

INSERT INTO pedidos (idpedido, idusuario, idcliente)
VALUES ('PED001', 1, 1);

INSERT INTO detalle_pedidos (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, subtotal)
VALUES ('PED001', 1, 10, 'caja', 15.00, 150.00),
       ('PED001', 2, 5, 'caja', 30.00, 150.00);

-- Update order to cancel specific quantities
UPDATE detalle_pedidos
SET cantidad_producto = cantidad_producto - 3, subtotal = (cantidad_producto - 3) * precio_unitario
WHERE idpedido = 'PED001' AND idproducto = 1;

UPDATE detalle_pedidos
SET cantidad_producto = cantidad_producto - 1, subtotal = (cantidad_producto - 1) * precio_unitario
WHERE idpedido = 'PED001' AND idproducto = 2;

-- Verify updates
SELECT * FROM detalle_pedidos WHERE idpedido = 'PED001';

-- Expected output:
-- id_detalle_pedido | idpedido | idproducto | cantidad_producto | unidad_medida | precio_unitario | precio_descuento | subtotal | create_at | update_at | estado
-- 1                 | PED001   | 1          | 7                 | caja          | 15.00           | NULL             | 105.00   | ...       | ...       | 1
-- 2                 | PED001   | 2          | 4                 | caja          | 30.00           | NULL             | 120.00   | ...       | ...       | 1