-- Active: 1728956418931@@127.0.0.1@3306@distribumax
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
        CLI.create_at AS fecha_creacion,
        CLI.estado AS estado_cliente,
        CASE
            WHEN CLI.tipo_cliente = 'Persona' THEN CONCAT(DIS.distrito,' |',PROV.provincia)
            WHEN CLI.tipo_cliente = 'Empresa' THEN CONCAT(DIST.distrito,'| ',PROV.provincia)
        END AS provincia
        
    FROM 
        clientes CLI
    LEFT JOIN personas PER ON CLI.idpersona = PER.idpersonanrodoc
    LEFT JOIN empresas EMP ON CLI.idempresa = EMP.idempresaruc
    LEFT JOIN distritos DIS ON DIS.iddistrito=PER.iddistrito
    LEFT JOIN provincias PROV ON PROV.idprovincia=DIS.idprovincia
    LEFT JOIN distritos DIST ON DIST.iddistrito=EMP.iddistrito
    ORDER BY CLI.idcliente DESC;
END;

/* CALL sp_listar_clientes (); */
CALL sp_listar_clientes ();
SELECT * FROM empresas WHERE estado = '0';

--  DROP PROCEDURE IF EXISTS sp_listar_clientes;

-- CREATE PROCEDURE `sp_listar_clientes`(
--     IN p_start INT,
--     IN p_length INT,
--     IN p_search VARCHAR(255),
--     IN p_orderColumn VARCHAR(50),
--     IN p_orderDir VARCHAR(4)
-- )
-- BEGIN
--     SET @sql = CONCAT(
--         'SELECT DISTINCT c.idcliente, c.idpersona,c.idempresa, c.tipo_cliente, c.create_at, c.estado
--                         FROM clientes c
--                         WHERE c.estado = 1 AND (c.idcliente LIKE ? OR c.idpersona LIKE ? OR c.idempresa LIKE ?)
--                         ORDER BY ', p_orderColumn, ' ', p_orderDir, ' 
--                         LIMIT ?, ?');

--     PREPARE stmt FROM @sql;
--     SET @search_param = CONCAT('%', p_search, '%');
--     EXECUTE stmt USING @search_param, @search_param, p_start, p_length;
--     DEALLOCATE PREPARE stmt;
-- END;

-- DELIMITER;

-- CALL sp_listar_clientes (  0, 10, '26', 'idcliente', 'DESC' );


DROP PROCEDURE IF EXISTS sp_obtener_cliente;

CREATE PROCEDURE sp_obtener_cliente(
    IN _idcliente INT
)
BEGIN
    SELECT 
        CLI.idcliente,
        CLI.tipo_cliente,
        CASE
            WHEN CLI.tipo_cliente = 'Persona' THEN PER.idpersonanrodoc
            WHEN CLI.tipo_cliente = 'Empresa' THEN EMP.idempresaruc
        END AS nro_doc,
        CASE
            WHEN CLI.tipo_cliente = 'Persona' THEN CONCAT(PER.nombres, ' ', PER.appaterno, ' ', PER.apmaterno)
            WHEN CLI.tipo_cliente = 'Empresa' THEN EMP.razonsocial
        END AS cliente,
        CLI.estado AS estado_cliente,
        CASE
            WHEN CLI.tipo_cliente = 'Persona' THEN PER.direccion
            WHEN CLI.tipo_cliente = 'Empresa' THEN EMP.direccion
        END AS direccion_cliente,
        CASE
            WHEN CLI.tipo_cliente = 'Persona' THEN PER.telefono
            WHEN CLI.tipo_cliente = 'Empresa' THEN EMP.telefono
        END AS telefono_cliente,
        EMP.email
    FROM clientes CLI
    LEFT JOIN personas PER ON CLI.idpersona = PER.idpersonanrodoc
    LEFT JOIN empresas EMP ON CLI.idempresa = EMP.idempresaruc
    WHERE CLI.idcliente = _idcliente
    AND CLI.estado = '1';
END;



 CREATE VIEW vw_listar_clientes_activos AS
 SELECT  count(*) AS cli_activos FROM clientes WHERE estado=1;
 

