USE distribumax;
-- REGISTRAR DETALLE PROMOCIONES

CREATE PROCEDURE sp_detalle_promociones_registrar(
    IN _idpromocion INT,
    IN _descuento DECIMAL(10, 2)
)
BEGIN
    INSERT INTO detalle_promociones
    (idpromocion, descuento)
    VALUES
    (_idpromocion, _descuento);
END;
