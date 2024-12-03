-- Active: 1728956418931@@127.0.0.1@3306@distribumax
USE distribumax;

-- TODO: PROCEDIMIENTO PARA REGISTRAR UN DESPACHO;
DROP PROCEDURE IF EXISTS sp_despacho_registrar;


DROP PROCEDURE IF EXISTS sp_despacho_registrar;

CREATE PROCEDURE sp_despacho_registrar(
    IN _idvehiculo       INT,
    IN _idusuario        INT,
    IN _fecha_despacho   DATE,
    IN _idjefe_mercaderia INT
    )
    BEGIN
    INSERT INTO despachos (idvehiculo, idusuario, fecha_despacho, idjefe_mercaderia) 
    VALUES (_idvehiculo, _idusuario, _fecha_despacho, _idjefe_mercaderia);
    SELECT LAST_INSERT_ID() AS iddespacho;
END;

-- CALL sp_despacho_registrar (1, 1, '2024-12-01');

-- TODO: TRIGGER PARA VERIFICAR LA FECHA DE DESPACHO

/* DROP TRIGGER IF EXISTS trg_verificar_fecha_despacho;
CREATE TRIGGER trg_verificar_fecha_despacho
BEFORE INSERT ON despachos
FOR EACH ROW
BEGIN
DECLARE fecha_actual DATE;
SET fecha_actual = CURDATE();
IF NEW.fecha_despacho < fecha_actual THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'La fecha de despacho no puede ser menor a la fecha actual';
END IF;
END; */

-- TODO: TRIGGER PARA ACTUALIZAR EL ESTADO DE LA VENTA (despachado)
DROP TRIGGER IF EXISTS trg_actualizar_estado_venta;

CREATE TRIGGER trg_actualizar_estado_venta
AFTER INSERT ON despacho_ventas
FOR EACH ROW
BEGIN
-- Primero actualiza el estado de la venta a "despachado"
    UPDATE ventas
    SET condicion = 'despachado'
    WHERE idventa = NEW.idventa
    AND condicion <> 'despachado';  

-- Luego actualiza el estado del pedido a "Entregado"
    UPDATE pedidos
    SET estado = 'Entregado'
    WHERE idpedido = (
        SELECT idpedido 
        FROM ventas 
        WHERE idventa = NEW.idventa
    )
    AND estado <> 'Entregado';
END;

SELECT * from ventas;
-- actualizar el estado del pedido de enviado a entregado cuando se registre el despacho
DROP TRIGGER IF EXISTS  trg_actualizar_estado_pedido_despacho;

CREATE TRIGGER trg_actualizar_estado_pedido_despacho
AFTER INSERT ON despachos
FOR EACH ROW
BEGIN
    -- Variable temporal para almacenar idpedido
    DECLARE _idpedido INT;

    -- Obtener el idpedido relacionado con la idventa de la tabla despacho_ventas
    SELECT idpedido INTO _idpedido
    FROM despacho_ventas pv
    INNER JOIN despachos des ON des.iddespacho = pv.iddespacho
    LEFT JOIN ventas ve ON ve.idventa = pv.idventa
    WHERE pv.iddespacho = NEW.iddespacho;  -- Asegúrate de que usamos el iddespacho de NEW

    -- Verificar si se encontró un idpedido válido
    IF _idpedido IS NOT NULL THEN
        -- Actualizar el estado del pedido a 'Entregado' si aún no está marcado como tal
        UPDATE pedidos
        SET estado = 'Entregado'
        WHERE idpedido = _idpedido
          AND estado <> 'Entregado';
    END IF;
END;


-- ACTUALIZAR DESPACHO

-- TODO: PROCEDIMIENTO PARA ACTUALIZAR UN DESPACHO
CREATE PROCEDURE sp_actualizar_despacho(
	IN _iddespacho		INT,
		IN _idvehiculo 		INT,
    IN _fecha_despacho	DATE,
    IN _estado          CHAR(1)	-- 1 : pendiente	0: despachado
)
BEGIN
	UPDATE despachos
		SET
			iddespacho =_iddespacho,
            idvehiculo = _idvehiculo,
			fecha_despacho =_fecha_despacho,
            estado = _estado,
			update_at=now()
        WHERE iddespacho =_iddespacho;
END;

-- TODO: PROCEDIMIENTO PARA ACTUALIZAR EL ESTADO DE UN DESPACHO
DROP PROCEDURE IF EXISTS sp_actualizar_estado;

CREATE PROCEDURE sp_actualizar_estado(

    IN  _iddespacho  INT,
    IN  _estado       CHAR(1)
)BEGIN
    UPDATE despachos SET estado=_estado
    WHERE iddespacho=_iddespacho;
END;

--  TODO: PROCEDIMIENTO PARA REGISTRAR DETALLES DEL DESPACHO
DROP PROCEDURE IF EXISTS sp_registrar_detalledespacho;


CREATE PROCEDURE sp_registrar_detalledespacho
(
    IN _iddespacho  INT,
    IN _idventa     INT,
    IN _idproducto  INT
)
BEGIN
    -- Inserta los datos en la tabla despacho_ventas
    INSERT INTO despacho_ventas (iddespacho, idventa, idproducto)
    VALUES (_iddespacho, _idventa, _idproducto);

    -- Devuelve el último ID insertado
    SELECT LAST_INSERT_ID() AS iddetalle_despacho;
END;
-- CALL sp_registrar_detalledespacho(1, 1, 1);

-- // TODO: PROCEDIMIENTO PARA LISTAR LOS DETALLES DE UN DESPACHO
DROP PROCEDURE IF EXISTS sp_reporte_despacho_por_proveedor;

CREATE PROCEDURE sp_reporte_despacho_por_proveedor(IN _iddespacho INT)
BEGIN
    SELECT 
        DESPA.fecha_despacho, 
        DATE(VEN.fecha_venta) AS fecha_venta,
        Prove.proveedor,
        Prove.idempresa,
        UPPER(MAR.marca) AS marca,
        PRO.codigo,
        PRO.nombreproducto,
        UM.unidadmedida,
        SUM(DP.cantidad_producto) AS total,
        VH.placa,
        VH.modelo,
        VH.marca_vehiculo,
        PER.perfil,
        CONCAT(P.nombres, ' ', P.appaterno) AS datos, -- Persona que registró el despacho
        P.idpersonanrodoc,
        CONCAT(Pmer.nombres, ' ', Pmer.appaterno, ' ', Pmer.apmaterno) AS encargado_mercaderia -- Jefe de mercadería

    FROM despacho_ventas DESP
    INNER JOIN despachos DESPA ON DESPA.iddespacho = DESP.iddespacho
    INNER JOIN ventas VEN ON DESP.idventa = VEN.idventa
    LEFT JOIN pedidos PED ON PED.idpedido = VEN.idpedido
    LEFT JOIN detalle_pedidos DP ON DP.idpedido = PED.idpedido
    LEFT JOIN productos PRO ON PRO.idproducto = DP.idproducto
    LEFT JOIN unidades_medidas UM ON UM.idunidadmedida = PRO.idunidadmedida
    LEFT JOIN marcas MAR ON MAR.idmarca = PRO.idmarca
    LEFT JOIN proveedores Prove ON Prove.idproveedor = PRO.idproveedor
    LEFT JOIN vehiculos VH ON VH.idvehiculo = DESPA.idvehiculo
    LEFT JOIN usuarios USU ON USU.idusuario = DESPA.idusuario -- Usuario que registró el despacho
    LEFT JOIN perfiles PER ON PER.idperfil = USU.idperfil
    LEFT JOIN personas P ON P.idpersonanrodoc = USU.idpersona
    LEFT JOIN usuarios JMER ON JMER.idusuario = DESPA.idjefe_mercaderia -- Relación con jefe de mercadería
    LEFT JOIN personas Pmer ON Pmer.idpersonanrodoc = JMER.idpersona -- Datos del jefe de mercadería
    WHERE DESP.iddespacho = _iddespacho
    GROUP BY 
        Prove.proveedor,
        MAR.marca,
        PRO.codigo,
        PRO.nombreproducto,
        UM.unidadmedida,
        VH.placa,
        VH.modelo,
        VH.marca_vehiculo,
        P.nombres,
        P.appaterno,
        PER.perfil,
        Pmer.nombres,
        Pmer.appaterno,
        Pmer.apmaterno
    ORDER BY 
        Prove.proveedor,
        MAR.marca,
        PRO.nombreproducto;
END ;

-- TODO: PROCEDIMIENTO PARA LISTAR LOS DETALLES DE UN DESPACHO
DROP PROCEDURE IF EXISTS sp_listar_detalle_despacho;

CREATE PROCEDURE sp_listar_detalle_despacho(IN _iddespacho INT)
BEGIN
    SELECT 
        DES.iddespacho,
        VEN.idventa,
        VEN.idpedido
    FROM despacho_ventas DES 
        INNER JOIN ventas VEN ON VEN.idventa=DES.idventa
    WHERE iddespacho=_iddespacho
    GROUP BY VEN.idventa;
END;

-- TODO: PROCEDIMIENTO PARA LISTAR LOS DESPACHOS
DROP PROCEDURE IF EXISTS sp_listar_despacho;

CREATE PROCEDURE sp_listar_despacho()
BEGIN
    SELECT  
        DES.iddespacho,
        DES.fecha_despacho,
        PER.perfil,
        CASE DES.estado
            WHEN '1' THEN 'Activo'
            WHEN '0' THEN 'Inactivo'
        END AS estado,
        CASE DES.estado
            WHEN '1' THEN '0'
            WHEN '0' THEN '1'
        END AS `status`,
        VH.idvehiculo,
        CONCAT(VH.placa,' ',VH.modelo,' ',VH.marca_vehiculo) AS vehiculo,
        USU.idusuario,
        CONCAT(PERS.nombres,' ',PERS.appaterno,' ',PERS.apmaterno)AS datos
    FROM despachos DES INNER JOIN vehiculos VH
    ON VH.idvehiculo=DES.idvehiculo
    LEFT JOIN usuarios USU 
    ON USU.idusuario=VH.idusuario
    LEFT JOIN  perfiles PER 
    ON PER.idperfil=USU.idperfil
    LEFT JOIN personas PERS
    ON PERS.idpersonanrodoc=USU.idpersona ;
END ;


DROP  PROCEDURE IF EXISTS sp_buscar_jefe_mercaderia;
CREATE PROCEDURE sp_buscar_jefe_mercaderia(IN _item VARCHAR(50))
BEGIN
	SELECT 
		u.idusuario,
        p.perfil,
        pe.nombres,
        CONCAT(pe.appaterno,' ',pe.apmaterno) AS apellidos, 
        pe.idpersonanrodoc,
        u.estado
    FROM usuarios u 
    inner join perfiles p ON p.idperfil=u.idperfil 
	INNER JOIN personas pe ON pe.idpersonanrodoc=u.idpersona
    WHERE p.perfil='Jefe de Mercaderia' AND u.estado='1'
    AND  (pe.nombres LIKE CONCAT('%', _item, '%') OR 
                CONCAT(pe.appaterno, ' ', pe.apmaterno) LIKE CONCAT('%', _item, '%')); 
END;