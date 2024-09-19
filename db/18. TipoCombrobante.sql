USE distribumax;

-- REGISTRAR TIPO DE COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_tipo_comprobantes_registrar(
    IN _comprobantepago		VARCHAR(150),
	IN _estado					BIT
)
BEGIN
    INSERT INTO tipo_comprobante_pago (comprobantepago, estado) 
    VALUES (_comprobantepago, _estado);
END$$

-- ACTUALIZAR TIPO DE COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_comprobantes(
	IN _idtipocomprobante			INT,
	IN _comprobantepago		VARCHAR(150),
	IN _estado					BIT
)
BEGIN
	UPDATE tipo_comprobante_pago
		SET
			idtipocomprobante =_idtipocomprobante,
            comprobantepago = _comprobantepago,
            estado = _estado,
			update_at=now()
        WHERE idtipocomprobante =_idtipocomprobante;
END$$