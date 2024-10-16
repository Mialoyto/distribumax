USE distribumax;

-- REGISTRAR PROOVEDORES
DELIMITER $$
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
    ( idempresa, proveedor, contacto_principal, telefono_contacto, direccion, email) 
    VALUES 
    ( _idempresa, _proveedor, _contacto_principal, _telefono_contacto, _direccion, _email);
END$$

-- ACTUALIZAR PROVEEDORES
DELIMITER $$
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
END$$

-- ELIMINAR PROOVEDOR
DELIMITER $$
CREATE PROCEDURE sp_estado_proovedor(
IN  _estado         BIT,
IN  _idproveedor    INT 
)
BEGIN
	UPDATE proveedores SET
      estado=_estado
      WHERE idproveedor =_idproveedor;
END$$

/* MODIFICACION DE SOTO */
