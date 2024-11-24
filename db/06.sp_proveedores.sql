-- Active: 1731562917822@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR PROOVEDORES

CREATE PROCEDURE sp_proovedor_registrar(
    IN _idempresa 				BIGINT,
    IN _proveedor		        VARCHAR(50),
    IN _contacto_principal		VARCHAR(50),
    IN _telefono_contacto		CHAR(9),
    IN _direccion				VARCHAR(100),
    IN _email               	VARCHAR(100)
)
BEGIN
    INSERT INTO proveedores
    ( 
        idempresa, 
    proveedor, 
    contacto_principal, 
    telefono_contacto, 
    direccion, 
    email
    ) 
    VALUES 
    ( 
        _idempresa, 
    _proveedor, 
    _contacto_principal, 
    _telefono_contacto, 
    _direccion, 
    _email
    );
END;

-- ACTUALIZAR PROVEEDORES
DROP PROCEDURE IF EXISTS sp_getProveedor;

CREATE PROCEDURE sp_getProveedor(
    IN _idproveedor           INT
)
BEGIN
    SELECT
        idproveedor,
        idempresa,
        proveedor,
        contacto_principal,
        telefono_contacto,
        direccion,
        email
    FROM proveedores
    WHERE idproveedor = _idproveedor;
END;


-- DESACTIVAR PROOVEDOR
DROP PROCEDURE IF EXISTS sp_estado_proveedor;

CREATE PROCEDURE sp_estado_proveedor(
    IN _idproveedor    INT,
    IN _estado         CHAR(1)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;
    IF _estado = '0' THEN
        -- Desactivar proveedor
        UPDATE proveedores
        SET estado = _estado
        WHERE idproveedor = _idproveedor;
        SET v_estado = 1;
        SET v_mensaje = 'El proveedor se ha desactivado correctamente';
    ELSEIF _estado = '1' THEN
        -- Activar proveedor
        UPDATE proveedores
        SET 
            estado = _estado
        WHERE idproveedor = _idproveedor;
        SET v_estado = 1;
        SET v_mensaje = 'El proveedor se ha activado correctamente';
    ELSE
        -- Estado inválido
        SET v_estado = 0;
        SET v_mensaje = 'Error: el estado proporcionado no es válido';
    END IF;
    -- Retornar el resultado
    SELECT v_mensaje AS mensaje, v_estado AS estado;
END;

CALL sp_estado_proveedor (3, '0');

-- BUSCAR PROVEEDOR
DROP PROCEDURE IF EXISTS sp_search_proveedor;

CREATE PROCEDURE sp_search_proveedor(
    IN _searchProveedor VARCHAR(100)
)
BEGIN
IF LENGTH(TRIM(_searchProveedor)) > 0 THEN
    SELECT 
        PROV.idproveedor,
        PROV.idempresa,
        PROV.proveedor,
        PROV.contacto_principal,
        PROV.telefono_contacto,
        PROV.direccion,
        PROV.email
    FROM proveedores PROV
    WHERE (PROV.proveedor LIKE CONCAT('%',_searchProveedor,'%') 
        OR PROV.idempresa LIKE CONCAT('%',_searchProveedor,'%'))
    AND PROV.estado = '1';
    END IF;
END;

CALL sp_search_proveedor (1);

DROP PROCEDURE IF EXISTS sp_listar_proveedor;
CREATE PROCEDURE sp_listar_proveedor()
BEGIN
    SELECT
        PRO.idproveedor,
        EMP.idempresaruc,
        EMP.razonsocial,
        PRO.proveedor,
        PRO.contacto_principal,
        PRO.telefono_contacto,
        PRO.direccion,
        PRO.email,
        CASE PRO.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE PRO.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
            END AS `status`
    FROM proveedores PRO
    INNER JOIN empresas EMP ON EMP.idempresaruc = PRO.idempresa
    ORDER BY PRO.proveedor ASC;
END;

-- OBTENER UN PROVEEDOR
DROP PROCEDURE IF EXISTS sp_get_proveedor;

CREATE PROCEDURE sp_get_proveedor(
    IN _proveedor VARCHAR(100)
)
BEGIN
    SELECT
        PRO.idproveedor,
        PRO.proveedor
    FROM proveedores PRO
    WHERE PRO.proveedor LIKE CONCAT('%',_proveedor,'%')
    AND PRO.estado = '1'
    AND _proveedor <> ''
    ORDER BY PRO.proveedor ASC;
END;

SELECT * FROM proveedores;
-- HE CREADO UN NUEVO PROCEDIMIENTO PARA ACTUALIZAR PROVEEDOR
DROP PROCEDURE IF EXISTS sp_actualizar_proveedor;
CREATE PROCEDURE sp_actualizar_proveedor(
    IN _idproveedor             INT,
    IN _idempresa               BIGINT(20),
    IN _proveedor               VARCHAR(100),
    IN _contacto_principal      VARCHAR(50),
    IN _telefono_contacto       CHAR(9),
    IN _direccion               VARCHAR(100),
    IN _email                   VARCHAR(100)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_idproveedor INT;
    DECLARE v_proveedor VARCHAR(100);
    DECLARE v_estado INT;

    -- Verificar si el proveedor con el mismo nombre ya existe
    SELECT proveedor INTO v_proveedor
    FROM proveedores
    WHERE proveedor = _proveedor AND idproveedor != _idproveedor;

    IF v_proveedor = _proveedor THEN
        -- Si el proveedor ya existe, enviamos un mensaje de error
        SET v_mensaje = 'El proveedor ya está registrado';
        SET v_idproveedor = -1;
        SET v_estado = 0;
    ELSE
        -- Si no existe, actualizamos los datos del proveedor
        UPDATE proveedores
        SET 
            idempresa = _idempresa,
            proveedor = UPPER(_proveedor),
            contacto_principal = _contacto_principal,
            telefono_contacto = _telefono_contacto,
            direccion = _direccion,
            email = _email,
            update_at = NOW()
        WHERE idproveedor = _idproveedor;

        SET v_idproveedor = _idproveedor;
        SET v_mensaje = 'Datos del proveedor actualizados correctamente';
        SET v_estado = 1;
    END IF;

    -- Devolver el mensaje y el ID del proveedor actualizado
    SELECT v_mensaje AS mensaje, v_idproveedor AS idproveedor, v_estado AS estado;
END;

select * from proveedores;
CALL sp_actualizar_proveedor(
    1,
    20100085063,
    'Ajinomoto',
    'Juan Pérez',
    '987654321',
    'Calle San Martin',
    'juan@xyz.com'
);
