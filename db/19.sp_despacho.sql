-- Active: 1728549444267@@127.0.0.1@3306@distribumax
USE distribumax;

-- TODO: PROCEDIMIENTO PARA REGISTRAR UN DESPACHO;
DROP PROCEDURE IF EXISTS sp_despacho_registrar;


DROP PROCEDURE IF EXISTS sp_despacho_registrar;
CREATE PROCEDURE sp_despacho_registrar(
    IN _idventa         INT,
    IN _idvehiculo      INT,
    IN _idusuario       INT,
    IN _fecha_despacho  DATE
)
BEGIN
    -- Verificar si la venta está activa
    IF EXISTS (
        SELECT 1 
        FROM ventas 
        WHERE idventa = _idventa AND estado = 1
    ) THEN
        -- Insertar un nuevo despacho en la tabla despacho
        INSERT INTO despacho (idvehiculo, idventa, idusuario, fecha_despacho) 
        VALUES (_idvehiculo, _idventa, _idusuario, _fecha_despacho);
        
        -- Devolver el ID del último despacho insertado
        SELECT LAST_INSERT_ID() AS iddespacho;
    ELSE
        -- Enviar un mensaje de error si la venta no está activa
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La venta no está activa o no existe.';
    END IF;
END;



-- actualizar el estado de la venta de pendiente a despachado
CREATE TRIGGER trg_actualizar_estado_venta
AFTER INSERT ON despachos
FOR EACH ROW
BEGIN
    UPDATE ventas
    SET condicion = 'despachado'
    AND condicion <> 'despachado';  
END;

-- actualizar el estado del pedido de enviado a entregado cuando se registre el despacho
DROP TRIGGER IF EXISTS  trg_actualizar_estado_pedido;

CREATE TRIGGER trg_actualizar_estado_pedido_despacho
AFTER INSERT ON despacho
FOR EACH ROW
BEGIN
    -- Variable temporal para almacenar idpedido
    DECLARE _idpedido INT;

    -- Obtener el idpedido relacionado con la idventa
    SELECT idpedido INTO _idpedido 
    FROM ventas 
    WHERE idventa = NEW.idventa;

    -- Verificar si se encontró un idpedido válido
    IF _idpedido IS NOT NULL THEN
        -- Actualizar el estado del pedido
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
    IN _idventa INT,
    IN _iddespacho INT
)
BEGIN
    -- Verificar si la venta está activa (estado = 1)
    IF EXISTS (
        SELECT 1 
        FROM ventas 
        WHERE idventa = _idventa AND estado = 1
    ) THEN
        -- Insertar los datos en la tabla despacho_ventas
        INSERT INTO despacho_ventas (iddespacho, idventa)
        VALUES (_iddespacho, _idventa);

        -- Retornar el ID del detalle registrado
        SELECT    LAST_INSERT_ID() AS iddetalle_despacho;
    ELSE
        -- Enviar un mensaje indicando que la venta no está activa
        SELECT 'La venta no está activa' AS mensaje;
    END IF;
END;



DROP PROCEDURE IF EXISTS sp_reporte_despacho_por_proveedor;

CREATE PROCEDURE sp_reporte_despacho_por_proveedor(IN _iddespacho INT)
BEGIN
    SELECT 
        Prove.proveedor,
        upper(MAR.marca) AS marca,
        PRO.nombreproducto,
        SUM(DP.cantidad_producto) AS total,
        DESP.iddespacho,
        VEN.idventa,
        PRO.codigo,
        UM.unidadmedida,
        PER.perfil,
        VH.placa,
        VH.modelo,
        VH.marca_vehiculo,
        CONCAT (P.nombres,' ',P.appaterno ) AS datos
    FROM despacho_ventas DESP
    INNER JOIN despachos DESPA 
		ON    DESPA.iddespacho=DESP.iddespacho
    INNER JOIN ventas VEN 
        ON DESP.idventa = VEN.idventa
    LEFT JOIN pedidos PED 
        ON PED.idpedido = VEN.idpedido
    LEFT JOIN detalle_pedidos DP
        ON DP.idpedido = PED.idpedido
    LEFT JOIN productos PRO 
        ON PRO.idproducto = DP.idproducto
	LEFT  JOIN unidades_medidas UM
		ON UM.idunidadmedida=PRO.idunidadmedida
    LEFT JOIN marcas MAR 
        ON MAR.idmarca = PRO.idmarca
    LEFT JOIN proveedores Prove 
        ON Prove.idproveedor = PRO.idproveedor
    LEFT JOIN vehiculos VH 
        ON VH.idvehiculo = DESPA.idvehiculo
    LEFT JOIN usuarios USU 
        ON USU.idusuario = DESPA.idusuario
    LEFT JOIN perfiles PER 
        ON PER.idperfil = USU.idperfil
    LEFT JOIN personas P 
		ON P.idpersonanrodoc=USU.idpersona
    WHERE DESP.iddespacho = _iddespacho

    GROUP BY Prove.proveedor, MAR.marca, PRO.nombreproducto, DESP.iddespacho, VEN.idventa, PRO.codigo, PER.perfil
    ORDER BY Prove.proveedor, MAR.marca, PRO.nombreproducto;
END;

DROP PROCEDURE IF EXISTS sp_listar_detalle_despacho;

CREATE PROCEDURE sp_listar_detalle_despacho(IN _iddespacho INT)
BEGIN
 SELECT 
  DES.iddespacho,
  VEN.idventa,
  VEN.idpedido
 FROM despacho_ventas DES 
 INNER JOIN ventas VEN
 ON VEN.idventa=DES.idventa
 WHERE iddespacho=_iddespacho;
END;

DROP PROCEDURE IF EXISTS sp_listar_despacho;

-- CREATE PROCEDURE sp_listar_despacho()
-- BEGIN
--     SELECT
--      DES.iddespacho,
--      DES.fecha_despacho,
--      PER.perfil,
--      CASE DES.estado
--             WHEN '1' THEN 'Activo'
--             WHEN '0' THEN 'Inactivo'
--         END AS estado,
--         CASE DES.estado
--             WHEN '1' THEN '0'
--             WHEN '0' THEN '1'
--         END AS `status`
--      VH.idvehiculo,
--      CONCAT(VH.placa,' ',VH.modelo,' ',VH.marca_vehiculo) AS vehiculo,
--      USU.idusuario,
--      CONCAT(PERS.nombres,' ',PERS.appaterno,' ',PERS.apmaterno)AS datos
--     FROM despachos DES INNER JOIN vehiculos VH
--     ON VH.idvehiculo=DES.idvehiculo
--     LEFT JOIN usuarios USU
--     ON USU.idusuario=VH.idusuario
--     LEFT JOIN  perfiles PER
--     ON PER.idperfil=USU.idperfil
--     LEFT JOIN personas PERS
--     ON PERS.idpersonanrodoc=USU.idpersona
--     WHERE DES.estado='1' AND PER.perfil='Chofer';
-- END;


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
    ON PERS.idpersonanrodoc=USU.idpersona;

END ;