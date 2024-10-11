-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_promocion_registrar(
	IN _idpromocion      	INT,
    IN _idtipopromocion       INT,
    IN _descripcion       	  VARCHAR(250),
    IN _fechaincio    		  DATETIME,
    IN _fechafin			  DATETIME,
    IN _valor_descuento  	  DECIMAL(8, 2),
    IN _estado				  BIT
)
BEGIN
    INSERT INTO promociones
    (idpromocion,idtipopromocion, descripcion, fechaincio, fechafin, valor_descuento, estado) 
    VALUES 
    (_idpromocion,_idtipopromocion, _descripcion, _fechaincio, _fechafin, _valor_descuento, _estado);
END$$

-- ACTUALIZAR PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_promocion(
	IN _idpromocion      	INT,
	IN _idtipopromocion    	INT,
	IN _descripcion      	VARCHAR(250),
    IN _fechaincio			DATETIME,
    IN _fechafin			DATETIME,
	IN _valor_descuento  	DECIMAL(8, 2),
	IN _estado					BIT
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
END$$

-- DESACTIVAR PROMOCIÓN
DELIMITER $$
CREATE PROCEDURE sp_estado_promocion(
IN  _estado 		CHAR(1),
IN  _idpromocion 	INT 
)
BEGIN
	UPDATE promociones SET
      estado=_estado
      WHERE idpromocion =_idpromocion;
END$$

-- PROCEDIMIENTO PARA LISTAR PROMOCIONES
DELIMITER $$
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
END $$
DELIMITER ;