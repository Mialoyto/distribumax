-- Active: 1732807506399@@127.0.0.1@3306@distribumax
USE distribumax;
CALL sp_registrar_lote(1, 'LOT001', '2025-02-17');
CALL sp_registrar_lote(1, 'LOT002', '2025-02-01');
CALL sp_registrar_lote(1, 'LOT003', '2025-02-17');
CALL sp_registrar_lote(2, 'LOT002', '2025-01-31');
CALL sp_registrar_lote(3, 'LOT003', '2025-02-01');
CALL sp_registrar_lote(4, 'LOT004', '2025-02-17');
CALL sp_registrar_lote(5, 'LOT005', '2025-02-17');
CALL sp_registrar_lote(6, 'LOT006', '2025-12-17');
CALL sp_registrar_lote(7, 'LOT007', '2025-02-17');
CALL sp_registrar_lote(8, 'LOT008', '2025-03-17');
CALL sp_registrar_lote(9, 'LOT009', '2025-04-17');
CALL sp_registrar_lote(10, 'LOT010','2025-02-17');
CALL sp_registrar_lote(11, 'LOT011','2025-03-17');
CALL sp_registrar_lote(12, 'LOT012','2025-04-17');
CALL sp_registrar_lote(7, 'LOT012','2025-12-18');


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
