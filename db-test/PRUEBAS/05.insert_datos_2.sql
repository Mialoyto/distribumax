-- Active: 1728548966539@@127.0.0.1@3306@distribumax


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
select * from productos;
SELECT * FROM despachos;
SELECT * FROM VEHICULOS;
select * from usuarios;
SELECT * FROM despacho_ventas;
SELECT * FROM ventas;
select * from despachos;

SELECT CURDATE();

CALL sp_despacho_registrar (1, 1, '2024-12-01');