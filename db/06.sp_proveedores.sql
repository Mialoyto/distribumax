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
DROP PROCEDURE IF EXISTS sp_actualizar_proveedor;
CREATE PROCEDURE sp_actualizar_proveedor(
    IN _idproveedor           INT,
    IN _proveedor             VARCHAR(50)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_proveedor_existente VARCHAR(50);
    DECLARE v_idproveedor INT;

    -- Verificar si ya existe un proveedor con el mismo nombre
    SELECT proveedor INTO v_proveedor_existente
    FROM proveedores
    WHERE proveedor = _proveedor AND idproveedor != _idproveedor;

    IF v_proveedor_existente = _proveedor THEN
        SET v_mensaje = 'Este proveedor ya existe';
        SET v_idproveedor = -1;
    ELSE
        -- Actualizar los datos del proveedor
        UPDATE proveedores
        SET 
            proveedor = UPPER(_proveedor),
            update_at = NOW()
        WHERE idproveedor = _idproveedor;

        SET v_idproveedor = _idproveedor;
        SET v_mensaje = 'Datos actualizados correctamente';
    END IF;

    -- Retornar el mensaje y el ID del proveedor
    SELECT v_mensaje AS mensaje, v_idproveedor AS idproveedor;
END;

SELECT * FROM proveedores;
CALL sp_actualizar_proveedor(1,'hola');

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

CALL sp_estado_proveedor(3,'1');


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

CALL sp_search_proveedor ('');

DROP PROCEDURE IF EXISTS sp_listar_proveedor;

CREATE PROCEDURE sp_listar_proveedor()
BEGIN
    SELECT
        proveedores.idproveedor,
        empresas.idempresaruc,
        empresas.razonsocial,
        proveedores.proveedor,
        proveedores.contacto_principal,
        proveedores.telefono_contacto,
        proveedores.direccion,
        proveedores.email,
        CASE proveedor.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE proveedor.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
            END AS `status`
    FROM proveedores
    INNER JOIN empresas ON empresas.idempresaruc = proveedores.idempresa
    WHERE proveedores.estado = 1
    ORDER BY proveedores.proveedor ASC;
END;

CALL sp_listar_proveedor;