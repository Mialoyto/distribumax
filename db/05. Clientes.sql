USE distribumax;

-- REGISTRAR CLIENTES
DROP PROCEDURE IF EXISTS `sp_cliente_registrar`;
DELIMITER //
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
END //
DELIMITER ;

 
 CALL sp_cliente_registrar('26558000',null,'Persona')
 select * from clientes
 select * from empresas
  select * from personas
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
DROP PROCEDURE IF EXISTS `sp_buscar_cliente`;
DELIMITER $$
CREATE PROCEDURE`sp_buscar_cliente` (
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
        EMP.email,
       DIS.distrito,DIS.iddistrito,PRO.provincia,DEP.departamento,
        CASE 
            WHEN CLI.idpersona IS NOT NULL THEN PER.direccion
            WHEN CLI.idempresa IS NOT NULL THEN EMP.direccion
        END AS direccion_cliente
        
        FROM clientes CLI 
        LEFT JOIN personas PER ON CLI.idpersona= PER.idpersonanrodoc
        LEFT JOIN empresas EMP ON CLI.idempresa= EMP.idempresaruc
        LEFT JOIN distritos DIS ON DIS.iddistrito=PER.iddistrito
        LEFT JOIN provincias PRO ON PRO.idprovincia=DIS.idprovincia
        LEFT JOIN departamentos DEP ON DEP.iddepartamento=PRO.iddepartamento
        WHERE CLI.idpersona = _nro_documento OR CLI.idempresa =_nro_documento;
END$$

DROP PROCEDURE IF EXISTS `sp_buscar_prospectos`;
DELIMITER //

CREATE PROCEDURE `sp_buscar_prospectos`(
    IN _item VARCHAR(50),
    IN _tipo_cliente VARCHAR(10) -- Nuevo parámetro para filtrar el tipo de cliente ('Persona', 'Empresa' o 'Todos')
)
BEGIN
    -- Condicional para personas
    IF _tipo_cliente = 'Persona' OR _tipo_cliente = 'Todos' THEN
        -- Consulta para personas
        SELECT 
            'Persona' AS tipo_cliente,
            PER.idpersonanrodoc AS identificador,
            PER.appaterno AS nombre_razon_social,
            PER.apmaterno AS apellido_direccion,
            PER.nombres AS nombres,
            PER.direccion AS direccion,
            NULL AS email, -- columna vacía para personas
            DIS.distrito,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM clientes CLI 
                    WHERE CLI.idpersona = PER.idpersonanrodoc
                ) THEN 'Registrado'
                ELSE 'No registrado'
            END AS estado
        FROM personas PER
        INNER JOIN distritos DIS ON DIS.iddistrito = PER.iddistrito
        WHERE PER.idpersonanrodoc LIKE _item;
    END IF;

    -- Condicional para empresas
    IF _tipo_cliente = 'Empresa' OR _tipo_cliente = 'Todos' THEN
        -- Consulta para empresas
        SELECT 
            'Empresa' AS tipo_cliente,
            EMP.idempresaruc AS identificador,
            EMP.razonsocial AS nombre_razon_social,
            NULL AS apellido_direccion, -- columna vacía para empresas
            NULL AS nombres,
            EMP.direccion AS direccion,
            EMP.email,
            DIS.distrito,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM clientes CLI 
                    WHERE CLI.idempresa = EMP.idempresaruc
                ) THEN 'Registrado'
                ELSE 'No registrado'
            END AS estado
        FROM empresas EMP
        INNER JOIN distritos DIS ON DIS.iddistrito = EMP.iddistrito
        WHERE EMP.idempresaruc LIKE _item;
    END IF;
END //

CALL sp_buscar_prospectos ('20123456789','Empresa')





CALL sp_buscar_prospectos ('26558007');'20123456784'
select * from clientes
select * from personas
SELECT * FROM EMPRESAS
-- LISTAR CLIENTES
DELIMITER $$
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
END $$
DELIMITER ;