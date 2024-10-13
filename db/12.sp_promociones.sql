-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISDTRAR PROMOCIONES
DROP PROCEDURE IF EXISTS sp_promocion_registrar;

CREATE PROCEDURE sp_promocion_registrar(
    IN _idtipopromocion       INT,
    IN _descripcion       	  VARCHAR(250),
    IN _fechainicio    		  DATE,
    IN _fechafin			  DATE,
    IN _valor_descuento  	  DECIMAL(8, 2)
)
BEGIN

    IF _fechainicio < CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de inicio debe ser mayor o igual a la fecha actual';
    END IF;

    -- Validar que fechafin sea mayor a la fecha actual
    IF _fechafin <= CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de finalización debe ser mayor a la fecha actual';
    END IF;

    -- Validar que fechafin sea mayor que fechainicio
    IF _fechafin <= _fechainicio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La fecha de finalización debe ser mayor que la fecha de inicio';
    END IF;

    INSERT INTO promociones
    (
    idtipopromocion, 
    descripcion, 
    fechainicio, 
    fechafin, 
    valor_descuento) 
    VALUES 
    (
    _idtipopromocion,
    _descripcion,
    _fechainicio,
    _fechafin,
    _valor_descuento);
END;

-- ACTUALIZAR PROMOCIONES

CREATE PROCEDURE sp_actualizar_promocion(
	IN _idpromocion      	INT,
	IN _idtipopromocion    	INT,
	IN _descripcion      	VARCHAR(250),
    IN _fechaincio			DATETIME,
    IN _fechafin			DATETIME,
	IN _valor_descuento  	DECIMAL(8, 2),
	IN _estado				CHAR(1)
)
BEGIN
	UPDATE promociones
		SET 
			idpromocion =_idpromocion,
			idtipopromocion =_idtipopromocion,
			descripcion =_descripcion,
			fechaincio =_fechaincio,
            fechafin = _fechafin,
            valor_descuento = _valor_descuento,
            estado = _estado,
			update_at=now()
        WHERE idpromocion =_idpromocion;
END;

-- DESACTIVAR PROMOCIÓN

CREATE PROCEDURE sp_estado_promocion(
IN  _estado 		CHAR(1),
IN  _idpromocion 	INT 
)
BEGIN
	UPDATE promociones SET
        estado=_estado
        WHERE idpromocion =_idpromocion;
END;

-- PROCEDIMIENTO PARA LISTAR PROMOCIONES

CREATE PROCEDURE sp_listar_promociones()
BEGIN
    SELECT 
        tp.tipopromocion,
        p.descripcion,
        p.fechainicio,
        p.fechafin,
        p.valor_descuento
    FROM 
        promociones p
    INNER JOIN 
        tipos_promociones tp ON p.idtipopromocion = tp.idtipopromocion
    ORDER BY 
        p.fechainicio DESC;
END ;