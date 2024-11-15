/* USE distribumax;

-- Pedido 1
CALL sp_pedido_registrar(1, 2);
CALL sp_detalle_pedido ('PED-000000001',1,7,'Caja',8.50);


-- Pedido 2
CALL sp_pedido_registrar(2, 4);
CALL sp_detalle_pedido ('PED-000000002',1,1,'Caja',8.50);

-- Pedido 3
CALL sp_pedido_registrar(3, 1);
CALL sp_detalle_pedido ('PED-000000003',1,1,'Caja',8.50);

-- Pedido 4
CALL sp_pedido_registrar(2, 3);
CALL sp_detalle_pedido ('PED-000000004',1,1,'Caja',8.50);

-- Pedido 5
CALL sp_pedido_registrar(4, 1);
CALL sp_detalle_pedido ('PED-000000005',1,1,'Caja',8.50);

-- Pedido 6
CALL sp_pedido_registrar(3, 2);
CALL sp_detalle_pedido ('PED-000000006',1,1,'Caja',8.50);

-- Pedido 7
CALL sp_pedido_registrar(1, 4);
CALL sp_detalle_pedido ('PED-000000007',1,1,'Caja',8.50);

-- Pedido 8
CALL sp_pedido_registrar(4, 3);
CALL sp_detalle_pedido ('PED-000000008',1,1,'Caja',8.50);

-- Pedido 9
CALL sp_pedido_registrar(1, 2);
CALL sp_detalle_pedido ('PED-000000009',1,1,'Caja',8.50);

-- Pedido 10
CALL sp_pedido_registrar(3, 4);
CALL sp_detalle_pedido ('PED-000000010',1,1,'Caja',8.50);

-- Pedido 11
CALL sp_pedido_registrar(2, 1);
CALL sp_detalle_pedido ('PED-000000011',1,1,'Caja',8.50);

-- Pedido 12
CALL sp_pedido_registrar(4, 2);
CALL sp_detalle_pedido ('PED-000000012',1,1,'Caja',8.50);

-- Pedido 13
CALL sp_pedido_registrar(1, 3);
CALL sp_detalle_pedido ('PED-000000013',1,1,'Caja',8.50);

-- Pedido 14
CALL sp_pedido_registrar(3, 1);
CALL sp_detalle_pedido ('PED-000000014',1,1,'Caja',8.50);

-- Pedido 15
CALL sp_pedido_registrar(2, 4);
CALL sp_detalle_pedido ('PED-000000015',1,1,'Caja',8.50);

-- Pedido 16
CALL sp_pedido_registrar(1, 2);
CALL sp_detalle_pedido ('PED-000000016',1,1,'Caja',8.50);

-- Pedido 17
CALL sp_pedido_registrar(3, 1);
CALL sp_detalle_pedido ('PED-000000017',1,1,'Caja',8.50);

-- Pedido 18
CALL sp_pedido_registrar(2, 3);
CALL sp_detalle_pedido ('PED-000000018',1,1,'Caja',8.50);

-- Pedido 19
CALL sp_pedido_registrar(4, 2);
CALL sp_detalle_pedido ('PED-000000019',1,1,'Caja',8.50);

-- Pedido 20
CALL sp_pedido_registrar(1, 3);
CALL sp_detalle_pedido ('PED-000000020',1,1,'Caja',8.50);

-- Pedido 21
CALL sp_pedido_registrar(3, 1);
CALL sp_detalle_pedido ('PED-000000021', 1, 1, 'Caja', 8.50);

-- Pedido 22
CALL sp_pedido_registrar(2, 4);
CALL sp_detalle_pedido ('PED-000000022', 1, 1, 'Caja', 8.50);

-- Pedido 23
CALL sp_pedido_registrar(4, 2);
CALL sp_detalle_pedido ('PED-000000023', 1, 1, 'Caja', 8.50);

-- Pedido 24
CALL sp_pedido_registrar(1, 3);
CALL sp_detalle_pedido ('PED-000000024', 1, 1, 'Caja', 8.50);

-- Pedido 25
CALL sp_pedido_registrar(3, 1);
CALL sp_detalle_pedido ('PED-000000025', 1, 1, 'Caja', 8.50);

-- Pedido 26
CALL sp_pedido_registrar(2, 4);
CALL sp_detalle_pedido ('PED-000000026', 1, 1, 'Caja', 8.50);

-- Pedido 27
CALL sp_pedido_registrar(4, 2);
CALL sp_detalle_pedido ('PED-000000027', 1, 1, 'Caja', 8.50);

-- Pedido 28
CALL sp_pedido_registrar(1, 3);
CALL sp_detalle_pedido ('PED-000000028', 1, 1, 'Caja', 8.50);

-- Pedido 29
CALL sp_pedido_registrar(3, 1);
CALL sp_detalle_pedido ('PED-000000029', 1, 1, 'Caja', 8.50);

-- Pedido 30
CALL sp_pedido_registrar(2, 4);
CALL sp_detalle_pedido ('PED-000000030', 1, 1, 'Caja', 8.50); */

SELECT * FROM kardex
WHERE idproducto = 7
ORDER BY idkardex DESC;
SELECT * FROM lotes
WHERE idproducto = 7;

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
SELECT * from categorias;
select * from subcategorias;