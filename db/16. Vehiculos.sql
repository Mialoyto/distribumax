USE distribumax;

-- REGISTRAR VEHICULOS
DELIMITER $$
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
END$$

-- ACTUALIZAR VEHICULOS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_vehiculo(
    IN _idvehiculo INT,
    IN _idusuario INT,
    IN _marca_vehiculo VARCHAR(100),
    IN _modelo VARCHAR(100),
    IN _placa VARCHAR(20),
    IN _capacidad SMALLINT,
    IN _condicion ENUM('operativo', 'taller', 'averiado')
)
BEGIN
    UPDATE vehiculos
    SET idusuario = _idusuario,
        marca_vehiculo = _marca_vehiculo,
        modelo = _modelo,
        placa = _placa,
        capacidad = _capacidad,
        condicion = _condicion,
        update_at = NOW()
    WHERE idvehiculo = _idvehiculo;
END$$



-- lista vehiculos
DROP PROCEDURE IF EXISTS `sp_listar_vehiculo`;
DELIMITER //
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
END//


-- buscador de usuarios, para el rol conductor
DROP PROCEDURE IF EXISTS `sp_buscar_conductor`;
DELIMITER //
CREATE PROCEDURE `sp_buscar_conductor`(
    IN _item VARCHAR(80)
)
BEGIN
    SELECT 
        us.idusuario,
        rl.idrol,
        rl.rol,
        pe.nombres,
        CONCAT(pe.appaterno, ' ', pe.apmaterno) AS apellidos,  -- Concatenación de apellidos
        us.estado AS estado_usuario,
        rl.estado AS estado_rol
    FROM 
        usuarios us
    INNER JOIN 
        roles rl ON us.idrol = rl.idrol
    INNER JOIN 
        personas pe ON pe.idpersonanrodoc = us.idpersona
    WHERE 
        us.estado = '1' 
        AND rl.estado = '1' 
        AND rl.rol = 'Conductor'
        AND (pe.nombres LIKE CONCAT('%', _item, '%') OR 
             CONCAT(pe.appaterno, ' ', pe.apmaterno) LIKE CONCAT('%', _item, '%'));  -- Filtrar por nombres o apellidos concatenados
END //

DROP PROCEDURE IF EXISTS `sp_buscar_vehiculos`;
DELIMITER //
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
END //

CALL `sp_buscar_vehiculos`('r')

