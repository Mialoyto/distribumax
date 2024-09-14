USE distribumax;

-- REGISTRAR DESPACHO
DELIMITER $$
CREATE PROCEDURE sp_despacho_registrar(
    IN _idvehiculo 		INT,
    IN _idusuario 		INT,
    IN _fecha_despacho	DATE,
	IN _estado          BIT	-- 1 : pendiente	0: despachado
)
BEGIN
    INSERT INTO despacho (idvehiculo, idusuario,fecha_despacho, estado) 
    VALUES (_idvehiculo, _idusuario, _fecha_despacho, _estado);
END$$

-- ACTUALIZAR DESPACHO
DELIMITER $$
CREATE PROCEDURE sp_actualizar_despacho(
	IN _iddespacho		INT,
	IN _idvehiculo 		INT,
    IN _fecha_despacho	DATE,
    IN _estado          BIT	-- 1 : pendiente	0: despachado
)
BEGIN
	UPDATE despacho
		SET
			iddespacho =_iddespacho,
            idvehiculo = _idvehiculo,
			fecha_despacho =_fecha_despacho,
            estado = _estado,
			update_at=now()
        WHERE iddespacho =_iddespacho;
END$$