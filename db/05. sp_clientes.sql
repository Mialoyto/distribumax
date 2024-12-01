-- Active: 1732798376350@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR CLIENTES
CREATE PROCEDURE `sp_cliente_registrar`(
    IN _idpersona     CHAR(11),
    IN _idempresa     BIGINT,
    IN _tipo_cliente  CHAR(10)
)
BEGIN
    IF _tipo_cliente = 'Persona' THEN
        -- Insertar solo si _idpersona es no nulo
        IF _idpersona IS NOT NULL THEN
            INSERT INTO clientes (idpersona, idempresa, tipo_cliente) 
            VALUES (_idpersona, NULL, _tipo_cliente);
        END IF;
    ELSEIF _tipo_cliente = 'Empresa' THEN
        -- Insertar solo si _idempresa es no nulo
        IF _idempresa IS NOT NULL THEN
            INSERT INTO clientes (idpersona, idempresa, tipo_cliente) 
            VALUES (NULL, _idempresa, _tipo_cliente);
        END IF;
    END IF;
    SELECT LAST_INSERT_ID() AS idcliente;
END ;

-- ACTUALIZAR CLIENTES
DROP PROCEDURE IF EXISTS sp_actualizar_cliente;
CREATE PROCEDURE sp_actualizar_cliente(
IN _idcliente            INT,
IN _idpersonanrodoc      INT,
IN _idempresa            BIGINT,
IN _tipo_cliente         CHAR(10)
)
BEGIN
    IF _tipo_cliente = 'Persona'THEN
        IF _idpersonanrodoc IS NOT NULL AND _idempresa IS NULL THEN
            UPDATE clientes 
            SET 
            idpersonanrodoc = _idpersonanrodoc,
            idempresa = NULL,
            tipo_cliente = _tipo_cliente,
            update_at = now()
            WHERE idcliente = _idcliente;
        END IF;
    ELSEIF _tipo_cliente = 'Empresa'THEN
        IF _idempresa IS NOT NULL AND _idpersonanrodoc IS NULL THEN
            UPDATE clientes 
            SET 
            idpersonanrodoc = NULL,
            idempresa = _idempresa,
            tipo_cliente = _tipo_cliente,
            update_at = now()
            WHERE idcliente = _idcliente;
        END IF;
    END IF;
    UPDATE clientes
        SET 
            idpersonanrodoc = _idpersonanrodoc,
            idempresa = _idempresa,
            tipo_cliente = _tipo_cliente,
            update_at = NOW()
        WHERE idcliente = _idcliente;

        IF ROW_COUNT() > 0 THEN
            SELECT 1 AS estado, 'Cliente actualizado exitosamente' AS mensaje;
        ELSE
            SELECT 0 AS estado, 'No se encontró el cliente con el ID proporcionado' AS mensaje;
        END IF;
END;



DROP PROCEDURE IF EXISTS sp_estado_cliente;

CREATE PROCEDURE sp_estado_cliente(
IN  _estado 	CHAR(1),
IN  _idcliente 	CHAR(12)
)
BEGIN
	UPDATE clientes SET
        estado =_estado
        WHERE idcliente=_idcliente;
END;

call sp_estado_cliente('1',1);
select * from clientes;
-- BUSCAR CLIENTE POR DNI O RUC
DROP PROCEDURE IF EXISTS `sp_buscar_cliente`;
CREATE PROCEDURE `sp_buscar_cliente` (
    IN _nro_documento CHAR(12)
)
BEGIN
    -- Declarar variables locales para el manejo de mensajes
    DECLARE _mensaje VARCHAR(255);
    DECLARE _tiene_pedidos INT;

    -- Verificar si el cliente tiene pedidos pendientes
    SELECT COUNT(*) INTO _tiene_pedidos
    FROM pedidos P
    INNER JOIN clientes C ON C.idcliente = P.idcliente
    WHERE (C.idpersona = _nro_documento OR C.idempresa = _nro_documento)
      AND P.estado = 'Pendiente';

    -- Si tiene pedidos pendientes, retornar el mensaje
    IF _tiene_pedidos > 0 THEN
        SET _mensaje = 'El cliente ya tiene un pedido pendiente.';
    ELSE
        SET _mensaje = 'Cliente encontrado, puede registrar un nuevo pedido.';
    END IF;

    -- Retornar el mensaje y los datos del cliente
    SELECT
        CLI.idcliente,
        CLI.tipo_cliente,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        EMP.razonsocial,
        EMP.email,
        DIS.iddistrito,
        DIS.distrito,
        PER.telefono,
        CASE 
            WHEN CLI.idpersona IS NOT NULL THEN PER.direccion
            WHEN CLI.idempresa IS NOT NULL THEN EMP.direccion
        END AS direccion_cliente,
        CLI.estado,
        _mensaje AS mensaje
    FROM clientes CLI 
    LEFT JOIN personas PER ON CLI.idpersona = PER.idpersonanrodoc
    LEFT JOIN empresas EMP ON CLI.idempresa = EMP.idempresaruc
    LEFT JOIN distritos DIS ON DIS.iddistrito = PER.iddistrito
    LEFT JOIN provincias PRO ON PRO.idprovincia = DIS.idprovincia
    LEFT JOIN departamentos DEP ON DEP.iddepartamento = PRO.iddepartamento
    WHERE (CLI.idpersona = _nro_documento OR CLI.idempresa = _nro_documento)
      AND CLI.estado = '1';
END;

CALL sp_buscar_cliente('73217990');

-- LISTAR CLIENTES
DROP PROCEDURE IF EXISTS sp_listar_clientes;
CREATE PROCEDURE sp_listar_clientes()
BEGIN
    SELECT 
        CLI.idcliente,
        CASE cli.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE cli.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`,
        CASE
            WHEN CLI.tipo_cliente = 'Persona' THEN CLI.idpersona
            WHEN CLI.tipo_cliente = 'Empresa' THEN CLI.idempresa
        END AS nro_doc,
        CLI.tipo_cliente,
        CASE
            WHEN CLI.tipo_cliente = 'Persona' THEN CONCAT(PER.nombres, ' ', PER.appaterno, ' ', PER.apmaterno)
            WHEN CLI.tipo_cliente = 'Empresa' THEN EMP.razonsocial
        END AS cliente,
        CASE CLI.estado
        WHEN '1' THEN 'Activo'
        WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE CLI.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS status
    FROM 
        clientes CLI
    LEFT JOIN personas PER ON CLI.idpersona = PER.idpersonanrodoc
    LEFT JOIN empresas EMP ON CLI.idempresa = EMP.idempresaruc
    LEFT JOIN distritos DIS ON DIS.iddistrito=PER.iddistrito
    LEFT JOIN provincias PROV ON PROV.idprovincia=DIS.idprovincia
    LEFT JOIN distritos DIST ON DIST.iddistrito=EMP.iddistrito
    ORDER BY CLI.idcliente DESC;
END;

CALL sp_listar_clientes ();

DROP PROCEDURE IF EXISTS sp_getClienteById;
CREATE PROCEDURE sp_getClienteById
(IN _idcliente INT)
BEGIN
SELECT
    CLI.idcliente,
    CLI.tipo_cliente,
    CLI.idpersona,
    CLI.idempresa
FROM clientes CLI
WHERE CLI.idcliente = _idcliente;
END;


DROP PROCEDURE IF EXISTS sp_update_estado_cliente;
CREATE PROCEDURE sp_update_estado_cliente(
    IN _idcliente INT,
    IN _estado CHAR(1)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;
    IF _estado = '0' THEN
        UPDATE clientes
        SET estado = _estado
        WHERE idcliente = _idcliente;
        IF ROW_COUNT() > 0 THEN
            SET v_estado = 1;
            SET v_mensaje = 'Cliente desactivado exitosamente';
        ELSE
            SET v_estado = 0;
            SET v_mensaje = 'No se encontró el cliente con el ID proporcionado';
        END IF;

    ELSEIF _estado = '1' THEN
        UPDATE clientes
        SET estado = _estado
        WHERE idcliente = _idcliente;
        IF ROW_COUNT() > 0 THEN
            SET v_estado = 1;
            SET v_mensaje = 'Cliente activado exitosamente';
        ELSE
            SET v_estado = 0;
            SET v_mensaje = 'No se encontró el cliente con el ID proporcionado';
        END IF;

    ELSE
        SET v_estado = 0;
        SET v_mensaje = 'El estado proporcionado no es válido';
    END IF;
    SELECT v_estado AS estado, v_mensaje AS mensaje;
END;
select * from clientes;
CALL sp_update_estado_cliente(1, '0');