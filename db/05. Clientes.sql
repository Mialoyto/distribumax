USE distribumax;

-- REGISTRAR CLIENTES
DELIMITER $$

CREATE PROCEDURE sp_cliente_registrar(
	IN _idpersona 		CHAR(11),
    IN _idempresa 		BIGINT,
    IN _tipo_cliente    CHAR(10)
)
BEGIN
    IF _tipo_cliente = 'Persona'THEN
        IF _idpersona IS NOT NULL AND _idempresa IS NULL THEN
            INSERT INTO clientes 
            (idpersona, idempresa, tipo_cliente) 
            VALUES 
            (_idpersona, NULL, _tipo_cliente);
        END IF;
    ELSEIF _tipo_cliente = 'Empresa'THEN
        IF _idempresa IS NOT NULL AND _idpersona IS NULL THEN
            INSERT INTO clientes 
            (idpersona, idempresa, tipo_cliente) 
            VALUES 
            (NULL, _idempresa, _tipo_cliente);
        END IF;
    END IF;
END$$

-- ACTUALIZAR CLIENTES
DELIMITER $$

CREATE PROCEDURE sp_actualizar_cliente(
IN _idpersona       INT,
IN _idempresa       BIGINT,
IN _tipo_cliente    CHAR(10),
IN _idcliente 		INT
)
BEGIN
    IF _tipo_cliente = 'Persona'THEN
        IF _idpersona IS NOT NULL AND _idempresa IS NULL THEN
            UPDATE clientes 
            SET 
            idpersona = _idpersona,
            idempresa = NULL,
            tipo_cliente = _tipo_cliente,
            update_at = now()
            WHERE idcliente = _idcliente;
        END IF;
    ELSEIF _tipo_cliente = 'Empresa'THEN
        IF _idempresa IS NOT NULL AND _idpersona IS NULL THEN
            UPDATE clientes 
            SET 
            idpersona = NULL,
            idempresa = _idempresa,
            tipo_cliente = _tipo_cliente,
            update_at = now()
            WHERE idcliente = _idcliente;
        END IF;
    END IF;
    UPDATE clientes
        SET 
            idpersona = _idpersona,
            idempresa = _idempresa,
            tipo_cliente = _tipo_cliente,
            update_at = NOW()
        WHERE idcliente = _idcliente;
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

-- BUSCAR CLIENTE POR DNI O RUC
DELIMITER $$
CREATE PROCEDURE sp_buscar_cliente(
    IN _nro_documento CHAR(12)
)
BEGIN
    SELECT
        CLI.idcliente,
        CLI.tipo_cliente,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        EMP.razonsocial,
        CASE 
            WHEN CLI.idpersona IS NOT NULL THEN PER.direccion
            WHEN CLI.idempresa IS NOT NULL THEN EMP.direccion
        END AS direccion_cliente
        
        FROM clientes CLI 
        LEFT JOIN personas PER ON CLI.idpersona= PER.idpersonanrodoc
        LEFT JOIN empresas EMP ON CLI.idempresa= EMP.idempresaruc
        WHERE CLI.idpersona = _nro_documento OR CLI.idempresa =_nro_documento;
END$$

