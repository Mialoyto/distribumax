-- Active: 1732807506399@@127.0.0.1@3306@distribumax
USE distribumax;
-- REGISTRAR VEHICULOS

CREATE PROCEDURE sp_registrar_vehiculo(
    IN _idusuario INT,
    IN _marca_vehiculo VARCHAR(100),
    IN _modelo VARCHAR(100),
    IN _placa VARCHAR(7),
    IN _capacidad SMALLINT,
    IN _condicion ENUM('operativo', 'taller', 'averiado')
    )
    BEGIN
        INSERT INTO vehiculos (idusuario, marca_vehiculo, modelo, placa, capacidad, condicion)
        VALUES (_idusuario, _marca_vehiculo, _modelo, _placa, _capacidad, _condicion);
END;

-- ACTUALIZAR VEHICULOS
DROP PROCEDURE IF EXISTS sp_actualizar_vehiculo;

CREATE PROCEDURE sp_actualizar_vehiculo(
    IN _idvehiculo INT,
    IN _marca_vehiculo VARCHAR(100),
    IN _modelo VARCHAR(100),
    IN _placa VARCHAR(20),
    IN _capacidad SMALLINT,
    IN _condicion ENUM('operativo', 'taller', 'averiado'))
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_idvehiculo INT;
    DECLARE v_placa VARCHAR(20);
    DECLARE v_estado INT;
    -- Verificar si el vehículo con la misma placa ya existe
    SELECT placa INTO  v_placa
    FROM vehiculos
    WHERE placa = _placa AND idvehiculo != _idvehiculo;

    IF v_placa = _placa THEN
        -- Si la placa ya existe, enviamos un mensaje de error
        SET v_mensaje = 'La placa ya está registrada';
        SET v_idvehiculo = -1;
        SET v_estado = 0;
    ELSE
        -- Si no existe, actualizamos los datos del vehículo
        UPDATE vehiculos
        SET 
            marca_vehiculo = UPPER(_marca_vehiculo),
            modelo = _modelo,
            placa = _placa,
            capacidad = _capacidad,
            condicion = _condicion,
            update_at = NOW()
        WHERE idvehiculo = _idvehiculo;

        SET v_idvehiculo = _idvehiculo;
        SET v_mensaje = 'Datos del vehículo actualizados correctamente';
        SET v_estado = 1;
    END IF;
    -- Devolver el mensaje y el ID del vehículo actualizado
    SELECT v_mensaje AS mensaje, v_idvehiculo AS idvehiculo, v_estado AS estado;
END;

-- OBTENER VEHICULO PARA EDITAR EN EL MODAL
DROP PROCEDURE IF EXISTS sp_getVehiculo;

CREATE PROCEDURE sp_getVehiculo(
    IN _idvehiculo INT
)
BEGIN
    SELECT
        VEH.idvehiculo,
        US.idusuario,
        US.nombre_usuario AS usuario, -- deberia de editarse
        VEH.marca_vehiculo AS marca,
        VEH.modelo,
        VEH.placa,
        VEH.capacidad,
        VEH.condicion
    FROM vehiculos  VEH
        INNER JOIN usuarios US ON VEH.idusuario = US.idusuario
    WHERE VEH.idvehiculo = _idvehiculo;
END;

-- LISTAR VEHICULOS
DROP PROCEDURE IF EXISTS `sp_listar_vehiculo`;

CREATE PROCEDURE `sp_listar_vehiculo`()
BEGIN
    SELECT 
        vh.idvehiculo,
        vh.marca_vehiculo,
        vh.modelo,
        vh.placa,
        vh.capacidad,
        vh.condicion,
        CONCAT(pe.appaterno, ' ', pe.nombres) AS datos,
        CASE vh.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE vh.estado
            WHEN '1' THEN '0'  -- Si el estado es 'Activo' (1), el 'status' será '0' (Inactivo)
            WHEN '0' THEN '1'  -- Si el estado es 'Inactivo' (0), el 'status' será '1' (Activo)
        END AS status
    FROM vehiculos vh
    INNER JOIN usuarios us ON vh.idusuario = us.idusuario
    INNER JOIN personas pe ON pe.idpersonanrodoc = us.idpersona
    ORDER BY vh.idvehiculo DESC;
END;

-- buscador de usuarios, para el rol conductor
DROP PROCEDURE IF EXISTS `sp_buscar_conductor`;

CREATE PROCEDURE `sp_buscar_conductor`(
    IN _item VARCHAR(80)
    )
    BEGIN
        SELECT 
            us.idusuario,
            rl.idperfil,
            
            pe.nombres,
            CONCAT(pe.appaterno, ' ', pe.apmaterno) AS apellidos,  -- Concatenación de apellidos
            us.estado AS estado_usuario,
            rl.estado AS estado_rol
        FROM 
            usuarios us
        INNER JOIN 
            perfiles rl ON us.idperfil = rl.idperfil
        INNER JOIN 
            personas pe ON pe.idpersonanrodoc = us.idpersona
        WHERE 
            us.estado = '1' 
            AND rl.estado = '1' 
            AND rl.perfil = 'Chofer'
            AND (pe.nombres LIKE CONCAT('%', _item, '%') OR 
                CONCAT(pe.appaterno, ' ', pe.apmaterno) LIKE CONCAT('%', _item, '%'));  -- Filtrar por nombres o apellidos concatenados
END;


DROP PROCEDURE IF EXISTS `sp_buscar_vehiculos`;
CREATE PROCEDURE `sp_buscar_vehiculos`(	
    IN _item VARCHAR(50)
)
BEGIN	
    -- Solo ejecutar si el parámetro no está vacío después de TRIM
    IF TRIM(_item) <> '' THEN
        SELECT 
            VH.idvehiculo,
            US.idusuario,
            PER.perfil,
            CONCAT(COALESCE(PE.appaterno, ''), ' ', 
                    COALESCE(PE.apmaterno, ''), ' ', 
                    COALESCE(PE.nombres, '')) AS conductor,
            VH.marca_vehiculo,
            VH.modelo,
            VH.placa,
            VH.capacidad
        FROM vehiculos VH
        INNER JOIN usuarios US ON US.idusuario = VH.idusuario
        INNER JOIN perfiles PER ON US.idperfil = PER.idperfil
        INNER JOIN personas PE ON US.idpersona = PE.idpersonanrodoc
        WHERE PER.nombrecorto = 'CHF'
        AND VH.placa LIKE CONCAT('%', TRIM(_item), '%')
        AND VH.placa IS NOT NULL;
    END IF;
END;
call sp_buscar_vehiculos("");

DROP PROCEDURE IF EXISTS sp_update_estado_vehiculo;

CREATE PROCEDURE sp_update_estado_vehiculo
(
    IN _idvehiculo INT,
    IN _estado     CHAR(10)
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_estado INT;

    IF _estado = '0' THEN
        UPDATE vehiculos
        SET estado = _estado
        WHERE idvehiculo = _idvehiculo;
        SET v_estado = 1;
        SET v_mensaje = "Vehiculo desactivado correctamente";
    ELSEIF _estado = '1' THEN
        UPDATE vehiculos
        SET estado = _estado
        WHERE idvehiculo = _idvehiculo;
        SET v_estado = 1;
        SET v_mensaje = 'Vehiculo activado correctamente';
    ELSE
        SET v_estado = 0;
        SET v_mensaje = 'El estado es incorecto';
    END IF;

    SELECT v_estado AS estado, v_mensaje AS mensaje;
END;

CALL sp_update_estado_vehiculo (2, '0');