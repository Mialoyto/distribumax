-- Active: 1733577930028@@127.0.0.1@3306@distribumax
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
    INSERT INTO proveedores(idempresa,proveedor,contacto_principal,telefono_contacto,direccion, email) 
    VALUES (_idempresa,_proveedor,_contacto_principal,_telefono_contacto,_direccion, _email);
END;

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

call `sp_getProveedor`(1);

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


-- BUSCAR PROVEEDOR
DROP PROCEDURE IF EXISTS sp_buscar_proveedor;
CREATE PROCEDURE sp_buscar_proveedor(
    IN _item VARCHAR(100)
)
BEGIN
    IF LENGTH(TRIM(_item)) > 0 THEN
        SELECT 
            PRO.idproveedor,
            PRO.idempresa,
            PRO.proveedor,
            PRO.contacto_principal,
            PRO.telefono_contacto,
            PRO.direccion,
            PRO.email
        FROM proveedores PRO
        WHERE 
            (PRO.proveedor LIKE CONCAT('%', _item, '%') OR 
             PRO.idempresa LIKE CONCAT('%', _item, '%')) 
            AND PRO.estado = '1';
        
        IF NOT EXISTS (
            SELECT 1
            FROM proveedores PRO
            WHERE 
                (PRO.proveedor LIKE CONCAT('%', _item, '%') OR 
                 PRO.idempresa LIKE CONCAT('%', _item, '%'))
                AND PRO.estado = '1'
        ) THEN
            SELECT 'Proveedor no encontrado' AS mensaje;
        ELSE
            SELECT 'Proveedor(s) encontrado(s)' AS mensaje;
        END IF;

    ELSE
        SELECT 'Por favor ingrese un término de búsqueda válido' AS mensaje;
    END IF;
END;
CALL sp_buscar_proveedor ('dkdkd');

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
DROP PROCEDURE IF EXISTS sp_actualizar_proovedor;
CREATE PROCEDURE sp_actualizar_proovedor(
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

CREATE PROCEDURE spu_get_proveedor_by_ruc(
    IN _idempresa BIGINT
)
BEGIN
    SELECT emp.idtipodocumento,
    pvr.email,
    pvr.direccion,
    pvr.telefono_contacto,
    pvr.contacto_principal,
    pvr.proveedor,
    emp.iddistrito,
    idempresa
    FROM proveedores pvr 
    INNER JOIN empresas emp ON pvr.idempresa = emp.idempresaruc
    WHERE idempresa = _idempresa;
END;


CALL sp_actualizar_proovedor(
    1,
    20100085063,
    'Elite',
    'Loyola',
    '987654321',
    'Calle San Martin',
    'juan@xyz.com'
);
