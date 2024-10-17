-- Active: 1726698325558@@127.0.0.1@3306@distribumax
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

CREATE PROCEDURE sp_actualizar_proovedor(
	IN _idproveedor 			INT,
    IN _idempresa 				BIGINT,
    IN _proveedor				VARCHAR(50),
    IN _contacto_principal		VARCHAR(50),
    IN _telefono_contacto		CHAR(9),
    IN _direccion				VARCHAR(100),
    IN _email               	VARCHAR(100)
)
BEGIN
	UPDATE proveedores
		SET 
			idempresa =_idempresa,
			proveedor =_proveedor,
			contacto_principal =_contacto_principal,
            telefono_contacto = _telefono_contacto,
            direccion = _direccion,
            email = _email,
			update_at=now()
        WHERE idproveedor =_idproveedor;
END;

-- ELIMINAR PROOVEDOR

CREATE PROCEDURE sp_estado_proovedor(
IN  _estado         BIT,
IN  _idproveedor    INT 
)
BEGIN
	UPDATE proveedores SET
      estado=_estado
      WHERE idproveedor =_idproveedor;
END;


-- BUSCAR PROVEEDOR
DROP PROCEDURE IF EXISTS sp_search_proveedor;
CREATE PROCEDURE sp_search_proveedor(
    IN _searchProveedor VARCHAR(100)
)
BEGIN
    SELECT 
        PROV.idproveedor,
        PROV.idempresa,
        PROV.proveedor,
        PROV.contacto_principal,
        PROV.telefono_contacto,
        PROV.direccion,
        PROV.email
    FROM proveedores PROV
    WHERE (PROV.proveedor LIKE CONCAT('%',_searchProveedor,'%') OR PROV.idempresa LIKE CONCAT('%',_searchProveedor,'%'))
    AND PROV.estado = '1';
END;
