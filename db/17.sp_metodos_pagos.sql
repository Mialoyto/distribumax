USE distribumax;

-- REGISTRAR METODO DE PAGO

CREATE PROCEDURE sp_metodo_pago_registrar(
    IN _metodopago		VARCHAR(150)
)
BEGIN
    INSERT INTO metodos_pago (metodopago) 
    VALUES (_metodopago);
END;


-- ACTUALIZAR METODO DE PAGO

CREATE PROCEDURE sp_actualizar_metodo_pago(
	IN _idmetodopago			INT,
	IN _estado					BIT
)
BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idmetodopago =_idmetodopago;
END;


-- LISTAR METODO DE PAGO

CREATE PROCEDURE sp_listar_mePago()
BEGIN
	SELECT * FROM metodos_pago;
END;

