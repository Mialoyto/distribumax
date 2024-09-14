USE distribumax;

-- REGISTRAR METODO DE PAGO
DELIMITER $$
CREATE PROCEDURE sp_metodo_pago_registrar(
    IN _metodopago		VARCHAR(150)
)
BEGIN
    INSERT INTO metodos_pago (metodopago) 
    VALUES (_metodopago);
END$$

-- ACTUALIZAR METODO DE PAGO
DELIMITER $$
CREATE PROCEDURE sp_actualizar_metodo_pago(
	IN _idmetodopago			INT,
	IN _estado					BIT
)
BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idmetodopago =_idmetodopago;
END$$