USE distribumax;

-- REGISTRAR COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_comprobantes_registrar(
    IN _idventa 		INT,
	IN _estado          BIT-- 	1: EMITIDO 	0: CANCELADO
)
BEGIN
    INSERT INTO comprobantes (idventa, estado) 
    VALUES (_idventa , _estado);
END$$

-- ACTUALIZAR COMPROBANTES 
DELIMITER $$
CREATE PROCEDURE sp_actualizar_comprobantes(
	IN _idcomprobante			INT,
	IN _estado					BIT
)
BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idcomprobante =_idcomprobante;
END$$