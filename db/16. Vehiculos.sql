USE distribumax;

-- REGISTRAR VEHICULOS
DELIMITER $$
CREATE PROCEDURE sp_registrar_vehiculo(
    IN _idusuario INT,
    IN _marca_vehiculo VARCHAR(100),
    IN _modelo VARCHAR(100),
    IN _placa VARCHAR(20),
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

-- REGISTRAR BUSQUEDAS DE VEHICULOS
DELIMITER $$
CREATE PROCEDURE sp_buscar_vehiculos(
    IN _marca_vehiculo VARCHAR(100),
    IN _modelo VARCHAR(100)
)
BEGIN
    SELECT * FROM vehiculos
    WHERE (marca_vehiculo = _marca_vehiculo OR _marca_vehiculo IS NULL)
      AND (modelo = _modelo OR _modelo IS NULL);
END$$