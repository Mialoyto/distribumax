DROP PROCEDURE IF EXISTS sp_registrar_detalle;

CREATE PROCEDURE sp_registrar_detalle(
    IN _idmarca INT,
    IN _idcategoria INT
)
BEGIN
    DECLARE v_mensaje VARCHAR(255);
    DECLARE v_existente INT;
    DECLARE v_categoria VARCHAR(100);
    DECLARE v_estado    SMALLINT;
    -- Verificar si ya existe la combinación de marca y categoría
    SELECT COUNT(*), c.categoria INTO v_existente, v_categoria
    FROM detalle_cate_marca dcm
    INNER JOIN categorias c ON c.idcategoria = dcm.idcategoria
    WHERE dcm.idmarca = _idmarca AND dcm.idcategoria = _idcategoria;

    -- Si no existe, insertar
    IF v_existente = 0 THEN
        INSERT INTO detalle_cate_marca (idmarca, idcategoria)
        VALUES (_idmarca, _idcategoria);
        SET v_mensaje = CONCAT("La categoría  fue registrada exitosamente.");
       SET v_estado = 1 ;
    ELSE
        -- Si ya existe, devolver un mensaje
        SET v_mensaje = CONCAT("La categoría '", v_categoria, "' ya está registrada.");
        
         SET v_estado =0;
    END IF;

    -- Devolver el mensaje al usuario
	   SELECT v_estado AS estado , v_mensaje AS mensaje;
END;