-- Active: 1728548966539@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR CLIENTES

DROP PROCEDURE IF EXISTS sp_cliente_registrar;
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
END;
/* DROP PROCEDURE IF EXISTS sp_cliente_registrar;
CREATE PROCEDURE sp_cliente_registrar(
    IN _id CHAR(11)
)
BEGIN
    DECLARE _tipo_cliente CHAR(10);
    DECLARE _idempresa BIGINT;
    DECLARE _idpersona CHAR(8);  -- Cambiamos la variable para idpersona a CHAR(8)

    -- Determina el tipo de cliente según la longitud del ID
    IF LENGTH(_id) = 8 THEN
        SET _tipo_cliente = 'Persona';
        SET _idempresa = NULL;  -- Asegúrate de que idempresa sea NULL para persona
        SET _idpersona = _id;   -- Asigna el id a idpersona
    ELSEIF LENGTH(_id) = 11 THEN
        SET _tipo_cliente = 'Empresa';
        SET _idempresa = CAST(_id AS UNSIGNED);  -- Convierte _id a BIGINT
        SET _idpersona = NULL;  -- Asegúrate de que idpersona sea NULL para empresa
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ID inválido';
    END IF;

    -- Inserta el cliente en la tabla
    INSERT INTO clientes (idpersona, idempresa, tipo_cliente)
    VALUES (_idpersona, _idempresa, _tipo_cliente);
END; */



-- ACTUALIZAR CLIENTES


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
END;

-- ELIMINAR CLIENTE


CREATE PROCEDURE sp_estado_cliente(
IN  _estado 	CHAR(1),
IN  _idcliente 	INT 
)
BEGIN
	UPDATE clientes SET
      estado=_estado
      WHERE idcliente=_idcliente;
END;

-- BUSCAR CLIENTE POR DNI O RUC

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
END;


-- LISTAR CLIENTES

CREATE PROCEDURE sp_listar_clientes()
BEGIN
    SELECT 
        c.tipo_cliente,
        c.create_at AS fecha_creacion,
        c.update_at AS fecha_actualizacion,
        c.estado AS estado_cliente
    FROM 
        clientes c
    LEFT JOIN personas p ON c.idpersona = p.idpersonanrodoc
    LEFT JOIN empresas e ON c.idempresa = e.idempresaruc;
END ;
