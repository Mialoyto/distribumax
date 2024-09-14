USE distribumax;

-- REGISTRAR CLIENTES
DELIMITER $$
CREATE PROCEDURE sp_cliente_registrar(
	IN _idpersona 		INT,
    IN _idempresa 		INT,
    IN _tipo_cliente    ENUM('Persona', 'Empresa')
)
BEGIN
    INSERT INTO clientes 
    (idpersona, idempresa, tipo_cliente) 
    VALUES 
    (_idpersona, _idempresa, _tipo_cliente);
END$$

-- ACTUALIZAR CLIENTES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_cliente(
IN _idcliente 		INT,
IN _idpersona       INT,
IN _idempresa       INT,
IN _tipo_cliente    ENUM('Persona', 'Empresa')
)
BEGIN
	UPDATE clientes
		SET 
			idcliente =_idcliente,
			idpersona =_idpersona,
			idempresa =_idempresa,
			tipo_cliente =_tipo_cliente,
			update_at=now()
        WHERE idcliente=_idcliente;
END$$

-- ELIMINAR CLIENTE
DELIMITER $$
CREATE PROCEDURE sp_estado_cliente(
IN  _estado 	CHAR(1),
IN  _idcliente 	INT 
)
BEGIN
	UPDATE clientes SET
      estado=_estado
      WHERE idcliente=_idcliente;
END$$

