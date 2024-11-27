USE distribumax;

-- REGISTRAR TIPO DE COMPROBANTES

CREATE PROCEDURE sp_tipo_comprobantes_registrar(
    IN _comprobantepago		VARCHAR(150)
)
BEGIN
    INSERT INTO tipo_comprobante_pago (comprobantepago) 
    VALUES (_comprobantepago);
END;


-- ACTUALIZAR TIPO DE COMPROBANTES

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
END;


-- LISTAR TIPO DE COMPROBANTES

CREATE PROCEDURE sp_listar_comprobate()
BEGIN
	SELECT * FROM tipo_comprobante_pago;
END;



DROP PROCEDURE IF EXISTS obtener_siguiente_comprobante;
CREATE PROCEDURE obtener_siguiente_comprobante(
    IN _idtipocomprobante INT,
    OUT siguiente_comprobante VARCHAR(50)
)
BEGIN
    DECLARE _contador_actual INT DEFAULT 0;
    DECLARE tipo_comprobante VARCHAR(50);

    -- Verificar si el idtipocomprobante existe
    IF NOT EXISTS (
        SELECT 1 
        FROM tipo_comprobante_pago 
        WHERE idtipocomprobante = _idtipocomprobante
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de comprobante no existe.';
    END IF;

    -- Obtener el contador actual y el tipo de comprobante
    SELECT contador, comprobantepago INTO _contador_actual, tipo_comprobante
    FROM tipo_comprobante_pago
    WHERE idtipocomprobante = _idtipocomprobante
    FOR UPDATE;

    -- Incrementar el contador
    SET _contador_actual = _contador_actual + 1;

    -- Actualizar el contador y el campo update_at en la tabla
    UPDATE tipo_comprobante_pago
    SET contador = _contador_actual, update_at = NOW()
    WHERE idtipocomprobante = _idtipocomprobante;

    -- Formatear el siguiente número de comprobante
    SET siguiente_comprobante = CONCAT(tipo_comprobante, '-', LPAD(_contador_actual, 7, '0'));
    
END;

