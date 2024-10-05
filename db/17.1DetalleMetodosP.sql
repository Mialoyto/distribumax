USE distribumax ;

-- registrar mas de un metodo de pago en una venta
DROP PROCEDURE IF EXISTS `sp_registrar_detalleMetodo`;
DELIMITER //
CREATE PROCEDURE `sp_registrar_detalleMetodo`
(
	IN _idventa   INT,
    IN _idmetodopago INT,
    IN _monto        DECIMAL(10,2)
)BEGIN
	INSERT INTO detalle_meto_Pago(idventa,idmetodopago,monto)VALUES(_idventa,_idmetodopago,_monto);
END //

select * from ventas inner join detalle_meto_Pago;
SELECT * FROM detalle_meto_Pago;
CALL sp_registrar_detalleMetodo (1,1,100);
CALL sp_registrar_detalleMetodo (1,2,20);
