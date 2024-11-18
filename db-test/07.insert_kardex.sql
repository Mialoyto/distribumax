-- Active: 1731562917822@@127.0.0.1@3306
USE distribumax;
CALL sp_registrar_lote(1, 'LOT001', '2025-10-05');
CALL sp_registrar_lote(1, 'LOT002', '2024-11-21');
CALL sp_registrar_lote(1, 'LOT003', '2024-11-21');
CALL sp_registrar_lote(2, 'LOT002', '2025-10-06');
CALL sp_registrar_lote(3, 'LOT003', '2025-10-07');
CALL sp_registrar_lote(4, 'LOT004', '2025-10-08');
CALL sp_registrar_lote(5, 'LOT005', '2025-10-09');
CALL sp_registrar_lote(6, 'LOT006', '2025-10-10');
CALL sp_registrar_lote(7, 'LOT007', '2025-10-11');
CALL sp_registrar_lote(8, 'LOT008', '2025-10-12');
CALL sp_registrar_lote(9, 'LOT009', '2024-11-21');
CALL sp_registrar_lote(10, 'LOT010','2025-10-14');
CALL sp_registrar_lote(11, 'LOT011','2025-10-15');
CALL sp_registrar_lote(12, 'LOT012','2025-10-16');
CALL sp_registrar_lote(7, 'LOT012','2024-11-19');


CALL sp_registrarmovimiento_kardex(1, 1,1,'Ingreso', 100, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 1,2,'Ingreso', 100, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 1,3,'Ingreso', 100, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 2,4,'Ingreso', 125, 'Ingreso de productos para venta');
CALL sp_registrarmovimiento_kardex(1, 3,5,'Ingreso', 150, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 4,6,'Ingreso', 200, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 5,7,'Ingreso', 225, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 6,8,'Ingreso', 250, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 7,9,'Ingreso', 300, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 8,10,'Ingreso', 325, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 9,11,'Ingreso', 350, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 10,12,'Ingreso',400, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 11,13,'Ingreso',425, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 12,14,'Ingreso',100, 'Ingreso de productos adicionales');
CALL sp_registrarmovimiento_kardex(1, 7,15,'Ingreso',150, 'Ingreso de productos adicionales');
-- CALL sp_registrarmovimiento_kardex(1, 7,9,'Salida',1, 'pedido');

SELECT * FROM kardex;
SELECT 
    idkardex,
    idusuario,
    idproducto,
    idlote,
    tipomovimiento,
    cantidad,
    stockactual,
    motivo
FROM kardex WHERE idproducto = 7 ORDER BY idkardex DESC LIMIT 10;

SELECT * FROM lotes WHERE idproducto = 7;
select * from kardex;
SELECT * FROM LOTES;
-- SE HIZO UN PEDIDO DE 150 UNIDADES DEL PRODUCTO 7 Y EL STOCK ACTUAL DEBE DE SER 299
CALL spu_buscar_lote(7);
-- select * from lotes where idproducto = 7;
CALL sp_registrar_salida_pedido(1, 7, 1, 'Venta por pedido');

SELECT * from categorias;