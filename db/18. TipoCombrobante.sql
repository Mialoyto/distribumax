USE distribumax;

-- REGISTRAR TIPO DE COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_tipo_comprobaantes_registrar(
    IN _comprobantepago		VARCHAR(150)
)
BEGIN
    INSERT INTO tipo_comprobante_pago (comprobantepago) 
    VALUES (_comprobantepago);
END$$


-- ACTUALIZAR TIPO DE COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_comprobantes(
	IN _idtipocomprobante			INT,
	IN _comprobantepago		VARCHAR(150),
	IN _estado					CHAR(1)
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


-- LISTAR TIPO DE COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_listar_comprobate()
BEGIN
	SELECT * FROM tipo_comprobante_pago;
END$$
