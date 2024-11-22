-- Active: 1726698325558@@127.0.0.1@3306@distribumax
USE distribumax;

-- REGISTRAR DESPACHO
DROP PROCEDURE IF EXISTS sp_despacho_registrar;


CREATE PROCEDURE sp_despacho_registrar(
    IN _idventa         INT,
    IN _idvehiculo       INT,
    IN _idusuario        INT,
    IN _fecha_despacho   DATE -- 1: pendiente, 0: despachado
)
BEGIN
    -- Insertar un nuevo despacho en la tabla despacho
    INSERT INTO despacho (idvehiculo, idventa, idusuario, fecha_despacho) 
    VALUES (_idvehiculo, _idventa, _idusuario, _fecha_despacho);
    
    -- Devolver el ID del último despacho insertado
    SELECT LAST_INSERT_ID() AS iddespacho;
END;

CREATE TRIGGER trg_actualizar_estado_venta
AFTER INSERT ON despacho
FOR EACH ROW
BEGIN
    UPDATE ventas
    SET condicion = 'despachado'
    WHERE idventa = NEW.idventa 
      AND condicion <> 'despachado';  
END;
-- ACTUALIZAR DESPACHO

CREATE PROCEDURE sp_actualizar_despacho(

	IN _iddespacho		INT,
	IN _idvehiculo 		INT,
    IN _fecha_despacho	DATE,
    IN _estado          CHAR(1)	-- 1 : pendiente	0: despachado
)
BEGIN
	UPDATE despacho
		SET
			iddespacho =_iddespacho,
            idvehiculo = _idvehiculo,
			fecha_despacho =_fecha_despacho,
            estado = _estado,
			update_at=now()
        WHERE iddespacho =_iddespacho;
END;


DROP PROCEDURE IF EXISTS sp_actualizar_estado;
CREATE PROCEDURE sp_actualizar_estado(

    IN  _iddespacho  INT,
    IN  _estado       CHAR(1)
)BEGIN
    UPDATE despacho SET estado=_estado
    WHERE iddespacho=_iddespacho;
END;

DROP PROCEDURE IF EXISTS sp_registrar_detalledespacho;
CREATE PROCEDURE sp_registrar_detalledespacho
(
    IN _idventa INT,
    IN _iddespacho INT
)
BEGIN
    -- Inserta los datos en la tabla despacho_ventas
    INSERT INTO despacho_ventas (iddespacho, idventa)
    VALUES (_iddespacho, _idventa);

    -- Devuelve el último ID insertado
    SELECT LAST_INSERT_ID() AS iddetalle_despacho;
END;


DROP PROCEDURE IF EXISTS sp_reporte_despacho_por_proveedor;


CREATE PROCEDURE sp_reporte_despacho_por_proveedor(IN _iddespacho INT)
BEGIN
    SELECT 
        Prove.proveedor,
        MAR.marca,
        PRO.nombreproducto,
        SUM(DP.cantidad_producto) AS total,
        DES.iddespacho,
        VEN.idventa,
        PRO.codigo
        
    FROM despacho_ventas DES
    INNER JOIN ventas VEN 
        ON DES.idventa = VEN.idventa
    LEFT JOIN pedidos PED 
        ON PED.idpedido = VEN.idpedido
    LEFT JOIN detalle_pedidos DP
        ON DP.idpedido = PED.idpedido
    LEFT JOIN productos PRO 
        ON PRO.idproducto = DP.idproducto
    LEFT JOIN marcas MAR 
        ON MAR.idmarca = PRO.idmarca
    LEFT JOIN proveedores Prove 
        ON Prove.idproveedor = PRO.idproveedor
    WHERE DES.iddespacho = _iddespacho
    GROUP BY Prove.proveedor, MAR.marca, PRO.nombreproducto
    ORDER BY Prove.proveedor, MAR.marca, PRO.nombreproducto;
END ;


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
     
--     FROM despacho DES INNER JOIN vehiculos VH
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
     
    FROM despacho DES INNER JOIN vehiculos VH
    ON VH.idvehiculo=DES.idvehiculo
    LEFT JOIN usuarios USU 
    ON USU.idusuario=VH.idusuario
    LEFT JOIN  perfiles PER 
    ON PER.idperfil=USU.idperfil
    LEFT JOIN personas PERS
    ON PERS.idpersonanrodoc=USU.idpersona;

END ;