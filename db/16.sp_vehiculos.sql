-- Active: 1731562917822@@127.0.0.1@3306@distribumax
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

-- CALL sp_actualizar_vehiculo(5,'Kia','Susuki','ABR-124',200,'taller');
-- ACTUALIZAR VEHICULOS
DROP PROCEDURE IF EXISTS sp_actualizar_vehiculo;
CREATE PROCEDURE sp_actualizar_vehiculo(
    IN _idvehiculo INT,
    IN _marca_vehiculo VARCHAR(100),
    IN _modelo VARCHAR(100),
    IN _placa VARCHAR(20),
    IN _capacidad SMALLINT,
    IN _condicion ENUM('operativo', 'taller', 'averiado')
)
BEGIN
    DECLARE v_mensaje VARCHAR(100);
    DECLARE v_vehiculo_existe INT;
    DECLARE v_idvehiculo INT;
    -- Verificar si el vehículo con la misma placa ya existe
    SELECT COUNT(*) INTO v_vehiculo_existe
    FROM vehiculos
    WHERE placa = _placa AND idvehiculo != v_idvehiculo;
    IF v_vehiculo_existe > 0 THEN
        -- Si la placa ya existe, enviamos un mensaje de error
        SET v_mensaje = 'La placa ya está registrada para otro vehículo';
        SET v_idvehiculo = -1;
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
    END IF;
    -- Devolver el mensaje y el ID del vehículo actualizado
    SELECT v_mensaje AS mensaje, v_idvehiculo AS idvehiculo;
END;




select * from usuarios;
CALL sp_actualizar_vehiculo(
    1, 
    'uuuu', 
    'SKS', 
    'OWP-122', 
    1, 
    'taller'
);
select * from vehiculos;

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
call sp_getVehiculo(1);







-- lista vehiculos
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
        CONCAT ( pe.appaterno,' ',pe.nombres) AS datos
        FROM vehiculos vh
        INNER JOIN usuarios us ON vh.idusuario=us.idusuario
        INNER JOIN personas pe ON pe.idpersonanrodoc=us.idpersona
        ORDER BY idvehiculo DESC;
END;

CALL sp_listar_vehiculo;

-- buscador de usuarios, para el rol conductor
DROP PROCEDURE IF EXISTS `sp_buscar_conductor`;

CREATE PROCEDURE `sp_buscar_conductor`(
    IN _item VARCHAR(80)
)
BEGIN
    SELECT 
        us.idusuario,
        rl. idperfil,
        
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

select * from vehiculos;
select * from usuarios;
select * from personas;
select * from usuarios;
select * from perfiles;

CREATE PROCEDURE `sp_buscar_vehiculos`
(	
	IN _item VARCHAR(50)
)
BEGIN	
	SELECT 
    VH.idvehiculo,VH.placa,VH.modelo,VH.marca_vehiculo,VH.capacidad,
    CONCAT(PE.appaterno,' ',PE.apmaterno,' ',PE.nombres)AS datos
    FROM vehiculos VH
    INNER JOIN usuarios US ON US.idusuario=VH.idusuario
    LEFT JOIN  personas PE ON PE.idpersonanrodoc=US.idpersona
    WHERE VH.placa LIKE CONCAT('%',_item,'%')
    OR VH.modelo  LIKE CONCAT('%',_item,'%')
    OR VH.marca_vehiculo LIKE  CONCAT('%',_item,'%');
END;
