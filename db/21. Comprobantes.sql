USE distribumax;

-- REGISTRAR COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_comprobantes_registrar(
    IN _idventa 		INT-- 	1: EMITIDO 	0: CANCELADO
)
BEGIN
    INSERT INTO comprobantes (idventa) 
    VALUES (_idventa );
END$$


-- ACTUALIZAR COMPROBANTES 
DELIMITER $$
CREATE PROCEDURE sp_actualizar_comprobantes(
	IN _idcomprobante			INT,
	IN _estado					CHAR(1)
)
BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idcomprobante =_idcomprobante;
END$$