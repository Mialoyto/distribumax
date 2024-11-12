-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 12-10-2024 a las 00:17:17
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `distribumax`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getultimostock` (IN `_idproducto` INT, OUT `stock_actual` INT)   BEGIN
    SELECT stockactual INTO stock_actual
    FROM kardex
    WHERE idproducto = _idproducto
    ORDER BY create_at DESC
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerPrecioProducto` (IN `_cliente_id` BIGINT, IN `_item` VARCHAR(255))   BEGIN
    SELECT 
        PRO.idproducto,
        PRO.codigo,
        PRO.nombreproducto,
        DET.descuento,
        UNDM.unidadmedida,
        CASE 
            WHEN LENGTH(CLI.idpersona) = 8 THEN DETP.precio_venta_minorista
            WHEN LENGTH(CLI.idempresa) = 11 THEN DETP.precio_venta_mayorista
        END 
        AS precio_venta,
        kAR.stockactual
    FROM  productos PRO
        LEFT JOIN detalle_promociones DET ON PRO.idproducto = DET.idproducto
        LEFT JOIN detalle_productos DETP ON PRO.idproducto = DETP.idproducto
        INNER JOIN unidades_medidas UNDM ON UNDM.idunidadmedida = DETP.idunidadmedida
        INNER JOIN clientes CLI ON CLI.idempresa = _cliente_id OR CLI.idpersona = _cliente_id
        -- kardex
        INNER JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
        AND KAR.idkardex = (SELECT MAX(K2.idkardex) FROM kardex K2 WHERE K2.idproducto = PRO.idproducto)
    WHERE (codigo LIKE CONCAT ('%',_item, '%') OR nombreproducto LIKE CONCAT('%', _item, '%'))
    AND PRO.estado = '1' 
    AND KAR.stockactual > 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_kardex` ()   BEGIN
    SELECT p.nombreproducto, k.fecha_vencimiento,
           k.numlote, k.stockactual, k.tipomovimiento, k.cantidad, k.motivo,k.estado
    FROM kardex k
    JOIN productos p ON k.idproducto = p.idproducto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_listar_usuarios` ()   BEGIN
    SELECT 
        p.idpersonanrodoc,
        r.rol AS nombre_rol,
        u.nombre_usuario,
        u.estado
    FROM 
        usuarios u
    JOIN 
        personas p ON u.idpersona = p.idpersonanrodoc
    JOIN 
        roles r ON u.idrol = r.idrol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_producto_reporte` (IN `_idproducto` INT)   BEGIN
    SELECT 
        MAR.marca,
        TPRO.tipoproducto,
        PRO.modelo,
        PRO.descripcion,
        KAR.cantidad,
        KAR.tipomovimiento,
        KAR.stockactual,
        KAR.create_at,
        COL.nomusuario
    FROM kardex KAR
    INNER JOIN productos PRO ON PRO.idproducto = KAR.idproducto
    INNER JOIN marcas MAR ON MAR.idmarca = PRO.idmarca
    INNER JOIN tipoProductos TPRO ON TPRO.idtipoproducto = PRO.idtipoproducto
    INNER JOIN colaboradores COL ON COL.idcolaborador = KAR.idcolaborador
    WHERE KAR.idproducto = _idproducto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `spu_registrar_personas` (IN `_idtipodocumento` INT, IN `_idpersonanrodoc` CHAR(11), IN `_iddistrito` INT, IN `_nombres` VARCHAR(250), IN `_apellidoP` VARCHAR(250), IN `_apellidoM` VARCHAR(250), IN `_telefono` CHAR(9), IN `_direccion` VARCHAR(250))   BEGIN
	INSERT INTO personas 
		(idtipodocumento,idpersonanrodoc,iddistrito,nombres,appaterno,apmaterno,telefono,direccion)
	VALUES(
		_idtipodocumento,
        _idpersonanrodoc,
        _iddistrito,
        _nombres,
        _apellidoP,
        _apellidoM,
        IF(_telefono = '' OR _telefono IS NULL, NULL, _telefono),
        _direccion
        );
        SELECT _idpersonanrodoc AS id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_categoria` (IN `_categoria` VARCHAR(150), IN `_idcategoria` INT)   BEGIN
    UPDATE categorias
    SET
        categoria = _categoria,
        update_at = NOW()
    WHERE idcategoria = _idcategoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_cliente` (IN `_idpersona` INT, IN `_idempresa` BIGINT, IN `_tipo_cliente` CHAR(10), IN `_idcliente` INT)   BEGIN
    IF _tipo_cliente = 'Persona'THEN
        IF _idpersona IS NOT NULL AND _idempresa IS NULL THEN
            UPDATE clientes 
            SET 
            idpersona = _idpersona,
            idempresa = NULL,
            tipo_cliente = _tipo_cliente,
            update_at = now()
            WHERE idcliente = _idcliente;
        END IF;
    ELSEIF _tipo_cliente = 'Empresa'THEN
        IF _idempresa IS NOT NULL AND _idpersona IS NULL THEN
            UPDATE clientes 
            SET 
            idpersona = NULL,
            idempresa = _idempresa,
            tipo_cliente = _tipo_cliente,
            update_at = now()
            WHERE idcliente = _idcliente;
        END IF;
    END IF;
    UPDATE clientes
        SET 
            idpersona = _idpersona,
            idempresa = _idempresa,
            tipo_cliente = _tipo_cliente,
            update_at = NOW()
        WHERE idcliente = _idcliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_comprobantes` (IN `_idcomprobante` INT, IN `_estado` CHAR(1))   BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idcomprobante =_idcomprobante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_despacho` (IN `_iddespacho` INT, IN `_idvehiculo` INT, IN `_fecha_despacho` DATE, IN `_estado` CHAR(1))   BEGIN
	UPDATE despacho
		SET
			iddespacho =_iddespacho,
            idvehiculo = _idvehiculo,
			fecha_despacho =_fecha_despacho,
            estado = _estado,
			update_at=now()
        WHERE iddespacho =_iddespacho;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_detalle_pedido` (IN `_idpedido` CHAR(15), IN `_idproducto` INT, IN `_cantidad_producto` INT, IN `_iddetallepedido` INT)   BEGIN
    UPDATE detalle_pedidos
        SET 
            idpedido            = _idpedido,
            idproducto          = _idproducto,
            cantidad_producto   = _cantidad_producto,
            update_at           = now()
        WHERE iddetallepedido   = _iddetallepedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_empresa` (IN `_iddistrito` INT, IN `_razonsocial` VARCHAR(100), IN `_direccion` VARCHAR(100), IN `_email` VARCHAR(100), IN `_telefono` CHAR(9), IN `_idempresaruc` BIGINT)   BEGIN
    UPDATE empresas
    SET 
        iddistrito = _iddistrito,
        razonsocial = _razonsocial,
        direccion = _direccion,
        email = _email,
        telefono = _telefono,
        update_at = NOW()
    WHERE idempresaruc = _idempresaruc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_marca` (IN `_idmarca` INT, IN `_marca` VARCHAR(150))   BEGIN
    UPDATE marcas
    SET marca = _marca,
        update_at = NOW()
    WHERE idmarca = _idmarca;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_metodo_pago` (IN `_idmetodopago` INT, IN `_estado` BIT)   BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idmetodopago =_idmetodopago;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_pedido` (IN `_idpedido` CHAR(15), IN `_idusuario` INT, IN `_idcliente` INT)   BEGIN
    UPDATE pedidos
        SET 
            idusuario   = _idusuario,
            idcliente   = _idcliente,
            estado      = _estado,
            update_at   = now()
        WHERE idpedido  = _idpedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_persona` (IN `_idtipodocumento` INT, IN `_iddistrito` INT, IN `_nombres` VARCHAR(250), IN `_apellidoP` VARCHAR(250), IN `_apellidoM` VARCHAR(250), IN `_telefono` CHAR(9), IN `_direccion` VARCHAR(250), IN `_idpersonanrodoc` CHAR(11))   BEGIN
	UPDATE personas
		SET
			idtipodocumento = _idtipodocumento,
			iddistrito = _iddistrito,
			nombres = _nombres,
			appaterno = _apellidoP,
			apmaterno = _apellidoM,
			telefono = IF(_telefono = '' OR _telefono IS NULL, NULL, _telefono),
			direccion = _direccion,
			update_at = NOW()
		WHERE idpersonanrodoc = _idpersonanrodoc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_promocion` (IN `_idpromocion` INT, IN `_idtipopromocion` INT, IN `_descripcion` VARCHAR(250), IN `_fechaincio` DATETIME, IN `_fechafin` DATETIME, IN `_valor_descuento` DECIMAL(8,2), IN `_estado` BIT)   BEGIN
	UPDATE promociones
		SET 
			idpromocion =_idpromocion,
			idtipopromocion =_idtipopromocion,
			descripcion =_descripcion,
			fechaincio =_fechaincio,
            fechafin = _fechafin,
            valor_descuento = _valor_descuento,
            estado = _estado,
			update_at=now()
        WHERE idpromocion =_idpromocion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_proovedor` (IN `_idproveedor` INT, IN `_idempresa` BIGINT, IN `_proveedor` VARCHAR(50), IN `_contacto_principal` VARCHAR(50), IN `_telefono_contacto` CHAR(9), IN `_direccion` VARCHAR(100), IN `_email` VARCHAR(100))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_subcategoria` (IN `_idsubcategoria` INT, IN `_idcategoria` INT, IN `_subcategoria` VARCHAR(150))   BEGIN
    UPDATE subcategorias
    SET idcategoria = _idcategoria,
        subcategoria = _subcategoria,
        update_at = NOW()
    WHERE idsubcategoria = _idsubcategoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_tipo_comprobantes` (IN `_idtipocomprobante` INT, IN `_comprobantepago` VARCHAR(150), IN `_estado` CHAR(1))   BEGIN
	UPDATE tipo_comprobante_pago
		SET
			idtipocomprobante =_idtipocomprobante,
            comprobantepago = _comprobantepago,
            estado = _estado,
			update_at=now()
        WHERE idtipocomprobante =_idtipocomprobante;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_tipo_promocion` (IN `_idtipopromocion` INT, IN `_tipopromocion` VARCHAR(150), IN `_descripcion` VARCHAR(250), IN `_estado` CHAR(1))   BEGIN
	UPDATE tipos_promociones
		SET
			idtipopromocion =_idtipopromocion,
            tipopromocion = _tipopromocion,
			descripcion =_descripcion,
            estado = _estado,
			update_at=now()
        WHERE idtipopromocion =_idtipopromocion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_usuario` (IN `_nombre_usuario` VARCHAR(100), IN `_password_usuario` VARCHAR(150), IN `_idusuario` INT)   BEGIN
	UPDATE usuarios
		SET
            nombre_usuario = _nombre_usuario,
            password_usuario = _password_usuario,
            update_at = NOW()
		WHERE idusuario = _idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_vehiculo` (IN `_idvehiculo` INT, IN `_idusuario` INT, IN `_marca_vehiculo` VARCHAR(100), IN `_modelo` VARCHAR(100), IN `_placa` VARCHAR(20), IN `_capacidad` SMALLINT, IN `_condicion` ENUM('operativo','taller','averiado'))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualizar_venta` (IN `_idpedido` CHAR(15), IN `_idmetodopago` INT, IN `_idtipocomprobante` INT, IN `_subtotal` DATE, IN `_descuento` DECIMAL(8,2), IN `_igv` DECIMAL(10,2), IN `_total_venta` INT)   BEGIN
    UPDATE ventas
        SET
            idcliente=_idcliente,
            idusuario=_idusuario,
            idpedido=_idpedido,
            fecha_venta=_fecha_venta,
            total_venta=_total_venta,
            estado=_estado,
            update_at=now()
        WHERE idventa=_idventa; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_actualziar_producto` (IN `_idmarca` INT, IN `_idsubcategoria` INT, IN `_nombreproducto` VARCHAR(250), IN `_descripcion` VARCHAR(250), IN `_codigo` CHAR(30), IN `_idproducto` INT)   BEGIN
	UPDATE productos
		SET 
			idmarca=_idmarca,
			idsubcategoria=_idsubcategoria,
			nombreproducto=_nombreproducto,
			descripcion=_descripcion,
			codigo=_codigo,
			update_at=now()
        WHERE idproducto=_idproducto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscardistrito` (IN `_distrito` VARCHAR(100))   BEGIN
IF TRIM(_distrito) <> '' THEN
SELECT
	d.iddistrito AS iddistrito,
    d.distrito AS distrito,
    p.provincia AS provincia,
    dep.departamento AS departamento
FROM
    distritos d
JOIN
    provincias p ON d.idprovincia = p.idprovincia
JOIN
    departamentos dep ON p.iddepartamento = dep.iddepartamento
WHERE
    d.distrito LIKE  CONCAT('%', TRIM(_distrito),'%');
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscarpersonadoc` (IN `_idtipodocumento` INT, IN `_idpersonanrodoc` CHAR(11))   BEGIN
	SELECT 
		DIST.iddistrito,
		DIST.distrito,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        PER.telefono,
        PER.direccion,
        PER.idpersonanrodoc,
        USU.idusuario,
        PER.estado
        FROM personas PER
        INNER JOIN distritos DIST ON PER.iddistrito = DIST.iddistrito
        INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
        LEFT JOIN usuarios USU ON USU.idpersona = PER.idpersonanrodoc
		WHERE PER.idtipodocumento = _idtipodocumento
        AND PER.idpersonanrodoc = _idpersonanrodoc AND PER.estado = "1";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscarusuarios_registrados` (IN `_idtipodocumento` INT, IN `_idpersonanrodoc` CHAR(11))   BEGIN
	SELECT 
        PER.idpersonanrodoc AS id,
        USU.idusuario AS iduser,
        USU.estado AS estado
        FROM personas PER
        INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
        LEFT JOIN usuarios USU ON USU.idpersona = PER.idpersonanrodoc
		WHERE PER.idtipodocumento = _idtipodocumento
        AND PER.idpersonanrodoc = _idpersonanrodoc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_cliente` (IN `_nro_documento` CHAR(12))   BEGIN
    SELECT
        CLI.idcliente,
        CLI.tipo_cliente,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        EMP.razonsocial,
        EMP.email,
       DIS.distrito,DIS.iddistrito,PRO.provincia,DEP.departamento,
        CASE 
            WHEN CLI.idpersona IS NOT NULL THEN PER.direccion
            WHEN CLI.idempresa IS NOT NULL THEN EMP.direccion
        END AS direccion_cliente
        
        FROM clientes CLI 
        LEFT JOIN personas PER ON CLI.idpersona= PER.idpersonanrodoc
        LEFT JOIN empresas EMP ON CLI.idempresa= EMP.idempresaruc
        LEFT JOIN distritos DIS ON DIS.iddistrito=PER.iddistrito
        LEFT JOIN provincias PRO ON PRO.idprovincia=DIS.idprovincia
        LEFT JOIN departamentos DEP ON DEP.iddepartamento=PRO.iddepartamento
        WHERE CLI.idpersona = _nro_documento OR CLI.idempresa =_nro_documento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_conductor` (IN `_item` VARCHAR(80))   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_pedido` (IN `_idpedido` CHAR(15))   BEGIN
    -- Selección de datos de los pedidos, mostrando los nombres o la razón social
    SELECT 
        pd.idpedido,
        COALESCE(CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno), em.razonsocial) AS nombre_o_razonsocial
    FROM  
        pedidos pd
    INNER JOIN 
        clientes cl ON pd.idcliente = cl.idcliente
    LEFT JOIN 
        personas pe ON pe.idpersonanrodoc = cl.idpersona
    LEFT JOIN 
        empresas em ON em.idempresaruc = cl.idempresa
    WHERE 
        pd.idpedido LIKE CONCAT( _idpedido, '%')  -- Búsqueda flexible por idpedido
        AND pd.estado = 'Pendiente';  -- Solo muestra pedidos pendientes

    -- Actualización del estado si el pedido se encuentra "Enviado"
    UPDATE pedidos 
    SET estado = ''  -- Cambia el estado a un valor significativo
    WHERE 
        idpedido = _idpedido
        AND estado = 'Enviado';  -- Solo actualiza si el pedido estaba "Enviado"
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_productos` (IN `_item` VARCHAR(250))   BEGIN
    SELECT 
        PRO.idproducto,
        PRO.nombreproducto,
        PRO.codigo,
        UME.unidadmedida,
        COALESCE(KAR.stockactual, 0) AS stockactual
    FROM productos PRO
        LEFT JOIN kardex KAR ON KAR.idproducto = PRO.idproducto
            AND KAR.idkardex = (SELECT MAX(K2.idkardex) 
            FROM kardex K2 WHERE K2.idproducto = PRO.idproducto) 
        INNER JOIN detalle_productos DET ON DET.idproducto = PRO.idproducto
        INNER JOIN unidades_medidas UME ON UME.idunidadmedida = DET.idunidadmedida
    WHERE (codigo LIKE CONCAT ('%',_item, '%') OR nombreproducto LIKE CONCAT('%', _item, '%')) 
    AND PRO.estado = '1'
        ORDER BY PRO.idproducto ASC ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_prospectos` (IN `_item` VARCHAR(50), IN `_tipo_cliente` VARCHAR(10))   BEGIN
    -- Condicional para personas
    IF _tipo_cliente = 'Persona' OR _tipo_cliente = 'Todos' THEN
        -- Consulta para personas
        SELECT 
            'Persona' AS tipo_cliente,
            PER.idpersonanrodoc AS identificador,
            PER.appaterno AS nombre_razon_social,
            PER.apmaterno AS apellido_direccion,
            PER.nombres AS nombres,
            PER.direccion AS direccion,
            NULL AS email, -- columna vacía para personas
            DIS.distrito,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM clientes CLI 
                    WHERE CLI.idpersona = PER.idpersonanrodoc
                ) THEN 'Registrado'
                ELSE 'No registrado'
            END AS estado
        FROM personas PER
        INNER JOIN distritos DIS ON DIS.iddistrito = PER.iddistrito
        WHERE PER.idpersonanrodoc LIKE _item;
    END IF;
    -- Condicional para empresas
    IF _tipo_cliente = 'Empresa' OR _tipo_cliente = 'Todos' THEN
        -- Consulta para empresas
        SELECT 
            'Empresa' AS tipo_cliente,
            EMP.idempresaruc AS identificador,
            EMP.razonsocial AS nombre_razon_social,
            NULL AS apellido_direccion, -- columna vacía para empresas
            NULL AS nombres,
            EMP.direccion AS direccion,
            EMP.email,
            DIS.distrito,
            CASE 
                WHEN EXISTS (
                    SELECT 1 
                    FROM clientes CLI 
                    WHERE CLI.idempresa = EMP.idempresaruc
                ) THEN 'Registrado'
                ELSE 'No registrado'
            END AS estado
        FROM empresas EMP
        INNER JOIN distritos DIS ON DIS.iddistrito = EMP.iddistrito
        WHERE EMP.idempresaruc LIKE _item;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_buscar_vehiculos` (IN `_item` VARCHAR(50))   BEGIN	
	SELECT 
    VH.idvehiculo,VH.placa,VH.modelo,VH.marca_vehiculo,VH.capacidad,
    CONCAT(PE.appaterno,' ',PE.apmaterno,' ',PE.nombres)AS datos
    FROM vehiculos VH
    INNER JOIN usuarios US ON US.idusuario=VH.idusuario
    LEFT JOIN  personas PE ON PE.idpersonanrodoc=US.idpersona
    WHERE VH.placa LIKE CONCAT('%',_item,'%')
    OR VH.modelo  LIKE CONCAT('%',_item,'%')
    OR VH.marca_vehiculo LIKE  CONCAT('%',_item,'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_cliente_registrar` (IN `_idpersona` CHAR(11), IN `_idempresa` BIGINT, IN `_tipo_cliente` CHAR(10))   BEGIN
    IF _tipo_cliente = 'Persona' THEN
        -- Insertar solo si _idpersona es no nulo
        IF _idpersona IS NOT NULL THEN
            INSERT INTO clientes (idpersona, idempresa, tipo_cliente) 
            VALUES (_idpersona, NULL, _tipo_cliente);
        END IF;
    ELSEIF _tipo_cliente = 'Empresa' THEN
        -- Insertar solo si _idempresa es no nulo
        IF _idempresa IS NOT NULL THEN
            INSERT INTO clientes (idpersona, idempresa, tipo_cliente) 
            VALUES (NULL, _idempresa, _tipo_cliente);
        END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_comprobantes_registrar` (IN `_idventa` INT)   BEGIN
    INSERT INTO comprobantes (idventa) 
    VALUES (_idventa );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_desactivar_categoria` (IN `_estado` CHAR(1), IN `_idcategoria` INT)   BEGIN
    UPDATE categorias
    SET
        estado = _estado
    WHERE idcategoria = _idcategoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_desactivar_persona` (IN `_estado` CHAR(1), IN `_idpersonanrodoc` CHAR(11))   BEGIN
	UPDATE personas
		SET
			estado = _estado
		WHERE idpersonanrodoc = _idpersonanrodoc;
        
        select row_count() as filas_afectadas;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_desactivar_usuario` (IN `_estado` CHAR(1), IN `_nombre_usuario` VARCHAR(100))   BEGIN
	UPDATE usuarios
		SET
			estado = _estado
		WHERE _nombre_usuario = nombre_usuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_despacho_registrar` (IN `_idvehiculo` INT, IN `_idusuario` INT, IN `_fecha_despacho` DATE)   BEGIN
    INSERT INTO despacho (idvehiculo, idusuario,fecha_despacho) 
    VALUES (_idvehiculo, _idusuario, _fecha_despacho);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_detalle_pedido` (IN `_idpedido` CHAR(15), IN `_idproducto` INT, IN `_cantidad_producto` INT, IN `_unidad_medida` CHAR(20), IN `_precio_unitario` DECIMAL(10,2))   BEGIN
    DECLARE _subtotal               DECIMAL(10, 2);
    DECLARE v_descuento_unitario    DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_descuento             DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE v_subtotal              DECIMAL(10, 2) DEFAULT 0.00;


    SELECT IFNULL(descuento, 0) INTO v_descuento_unitario
    FROM detalle_promociones
    WHERE idproducto = _idproducto
    LIMIT 1;
    SET v_descuento = (_cantidad_producto * _precio_unitario) * (v_descuento_unitario / 100);
    SET _subtotal = (_cantidad_producto * _precio_unitario) - v_descuento;
    INSERT INTO detalle_pedidos 
    (idpedido, idproducto, cantidad_producto, unidad_medida, precio_unitario, precio_descuento, subtotal) 
    VALUES
    (_idpedido, _idproducto, _cantidad_producto, _unidad_medida, _precio_unitario, v_descuento, _subtotal);
    SELECT LAST_INSERT_ID() AS iddetallepedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_marca` (IN `_idmarca` INT, IN `_estado` CHAR(1))   BEGIN
    UPDATE marcas
    SET 
        estado = _estado
    WHERE idmarca = _idmarca;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_subcategoria` (IN `_idsubcategoria` INT, IN `_estado` CHAR(1))   BEGIN
    UPDATE subcategorias
        SET 
            estado = _estado
        WHERE idsubcategoria = _idsubcategoria;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_empresa_registrar` (IN `_idempresaruc` BIGINT, IN `_iddistrito` INT, IN `_razonsocial` VARCHAR(100), IN `_direccion` VARCHAR(100), IN `_email` VARCHAR(100), IN `_telefono` CHAR(9))   BEGIN
    INSERT INTO empresas 
    (idempresaruc, iddistrito, razonsocial, direccion, email, telefono) 
    VALUES 
    (_idempresaruc, _iddistrito, _razonsocial, _direccion, _email, _telefono);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_cliente` (IN `_estado` CHAR(1), IN `_idcliente` INT)   BEGIN
	UPDATE clientes SET
      estado=_estado
      WHERE idcliente=_idcliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_detalle_pedido` (IN `_estado` CHAR(1), IN `_iddetallepedido` INT)   BEGIN
    UPDATE detalle_pedidos SET
        estado = _estado
        WHERE iddetallepedido = _iddetallepedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_empresa` (IN `_estado` CHAR(1), IN `_idempresaruc` BIGINT)   BEGIN
	UPDATE empresas SET
      estado=_estado
      WHERE idempresaruc=_idempresaruc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_pedido` (IN `_estado` BIT, IN `_idpedido` CHAR(15))   BEGIN
    UPDATE pedidos SET
        estado = _estado
    WHERE idpedido = _idpedido;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_producto` (IN `_estado` CHAR(1), IN `_idproducto` INT)   BEGIN
	UPDATE productos SET
      estado=_estado
      WHERE idproducto=_idproducto;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_promocion` (IN `_estado` CHAR(1), IN `_idpromocion` INT)   BEGIN
	UPDATE promociones SET
      estado=_estado
      WHERE idpromocion =_idpromocion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_proovedor` (IN `_estado` BIT, IN `_idproveedor` INT)   BEGIN
	UPDATE proveedores SET
      estado=_estado
      WHERE idproveedor =_idproveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_tipo_promocion` (IN `_estado` CHAR(1), IN `_idtipopromocion` INT)   BEGIN
	UPDATE tipos_promociones SET
      estado=_estado
      WHERE idtipopromocion =_idtipopromocion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_estado_venta` (IN `_estado` CHAR(1), IN `_idventa` INT)   BEGIN
    -- Actualizar el estado de la venta
    UPDATE ventas SET
        estado = _estado,
        update_at = NOW()
    WHERE idventa = _idventa;

    -- Verificar si el estado de la venta es '0' (cancelado)
    IF _estado = '0' THEN
        -- Actualizar el estado del pedido relacionado a 'Cancelado'
        UPDATE pedidos SET
            estado = 'Cancelado',
            update_at = NOW()
       WHERE idpedido = (SELECT idpedido FROM ventas WHERE idventa = _idventa);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_generar_reporte` (IN `_idventa` INT)   BEGIN
    -- Input validation can be added here if needed
    SELECT 
        ve.idventa,
        ve.fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        cli.idpersona,
        cli.idempresa,
        cli.tipo_cliente,
        pe.nombres,
        pe.appaterno,
        pe.apmaterno,
        em.razonsocial,
        us.idusuario,
        us.nombre_usuario,
        pr.nombreproducto ,
      --  GROUP_CONCAT(pr.preciounitario SEPARATOR ', ') AS precios_unitarios,
        dp.cantidad_producto,
        dp.unidad_medida,
        dp.precio_descuento,
        GROUP_CONCAT(dp.subtotal SEPARATOR ', ') AS subtotales
    FROM ventas ve
        INNER JOIN pedidos p ON p.idpedido = ve.idpedido
        INNER JOIN detalle_pedidos dp ON p.idpedido = dp.idpedido
        INNER JOIN productos pr ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em ON em.idempresaruc = cli.idempresa
        LEFT JOIN usuarios us ON us.idusuario=pe.idpersonanrodoc
          LEFT JOIN 
        tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE p.estado = 'Enviado' AND ve.idventa = _idventa
    
    GROUP BY p.idpedido, cli.idpersona, cli.idempresa, cli.tipo_cliente, pe.nombres, pe.appaterno, pe.apmaterno, em.razonsocial;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getById_pedido` (IN `_idpedido` CHAR(15))   BEGIN
    SELECT 
        cli.idpersona,
        cli.idempresa,
        cli.tipo_cliente,
        pe.nombres,
        pe.appaterno,
        pe.apmaterno,
        COALESCE(pe.direccion, em.direccion) AS direccion, -- Selecciona la dirección de persona o empresa
        em.razonsocial,
        dp.id_detalle_pedido,
        pr.nombreproducto,
        dp.precio_unitario,
        dp.cantidad_producto,
        dp.unidad_medida,
        dp.precio_descuento,
        dp.subtotal,
        tp.idtipocomprobante,
        tp.comprobantepago
    FROM pedidos p
        LEFT JOIN detalle_pedidos dp       ON p.idpedido = dp.idpedido
        INNER JOIN productos pr             ON pr.idproducto = dp.idproducto
        INNER JOIN clientes cli             ON cli.idcliente = p.idcliente
        LEFT JOIN personas pe               ON pe.idpersonanrodoc = cli.idpersona
        LEFT JOIN empresas em               ON em.idempresaruc = cli.idempresa
        LEFT JOIN ventas ve                 ON ve.idpedido = p.idpedido
        LEFT JOIN tipo_comprobante_pago tp  ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE p.idpedido = _idpedido
      AND ve.idventa IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getById_venta` (IN `_idventa` INT)   BEGIN 
SELECT 
    ve.idventa,
    pr.nombreproducto,
    dp.cantidad_producto,
    dp.unidad_medida,
    cl.tipo_cliente,
   CONCAT( per.nombres,' ',per.appaterno ) AS datos,
    em.razonsocial
FROM 
    ventas ve
INNER JOIN 
    pedidos pe ON pe.idpedido = ve.idpedido
LEFT JOIN 
	clientes cl ON  cl.idcliente=pe.idcliente 
LEFT JOIN
	personas per ON per.idpersonanrodoc=cl.idpersona
LEFT JOIN 
	empresas em ON em.idempresaruc=cl.idempresa
LEFT JOIN  
    detalle_pedidos dp ON dp.idpedido = pe.idpedido
LEFT JOIN 
    productos pr ON pr.idproducto = dp.idproducto

-- Relaciona con la columna idproducto en detalle_pedidos
WHERE ve.idventa=_idventa;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_historial_ventas` ()   BEGIN
    SELECT 
        ve.idventa,
        ve.fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        cli.idpersona,
        cli.tipo_cliente,
        pr.nombreproducto,
        dp.cantidad_producto,
        dp.subtotal,
        CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno) AS datos,
        pe.idpersonanrodoc,
        em.razonsocial,
        em.idempresaruc,
        ve.estado
    FROM 
        ventas ve
    INNER JOIN 
        pedidos p ON p.idpedido = ve.idpedido
    INNER JOIN 
        detalle_pedidos dp ON p.idpedido = dp.idpedido
    INNER JOIN 
        productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN 
        clientes cli ON cli.idcliente = p.idcliente
    LEFT JOIN 
        personas pe ON pe.idpersonanrodoc = cli.idpersona
    LEFT JOIN 
        empresas em ON em.idempresaruc = cli.idempresa
    LEFT JOIN 
        tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE 
        p.estado = 'Cancelado' AND ve.estado='0'
        
       -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_clientes` ()   BEGIN
    SELECT 
        c.tipo_cliente,
        c.create_at AS fecha_creacion,
        c.update_at AS fecha_actualizacion,
        c.estado AS estado_cliente
    FROM 
        clientes c
    LEFT JOIN personas p ON c.idpersona = p.idpersonanrodoc
    LEFT JOIN empresas e ON c.idempresa = e.idempresaruc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_comprobate` ()   BEGIN
	SELECT * FROM tipo_comprobante_pago;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_mePago` ()   BEGIN
	SELECT * FROM metodos_pago;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_personas` ()   BEGIN
    SELECT 
        td.documento AS tipo_documento,
        p.idpersonanrodoc AS nro_documento,
        p.nombres,
        p.appaterno,
        p.apmaterno,
        d.distrito,
        p.estado
    FROM personas p
    INNER JOIN tipo_documento td ON p.idtipodocumento = td.idtipodocumento
    INNER JOIN distritos d ON p.iddistrito = d.iddistrito;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_promociones` ()   BEGIN
    SELECT 
        tp.tipopromocion,
        p.descripcion,
        p.fechainicio,
        p.fechafin,
        p.valor_descuento
    FROM 
        promociones p
    INNER JOIN 
        tipos_promociones tp ON p.idtipopromocion = tp.idtipopromocion
    ORDER BY 
        p.fechainicio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_tipo_promociones` ()   BEGIN
    SELECT 
        tipopromocion,
        descripcion,
        create_at,
        update_at,
        CASE 
            WHEN estado = '1' THEN 'Activo'
            WHEN estado = '0' THEN 'Inactivo'
        END AS estado
    FROM 
        tipos_promociones
    ORDER BY 
        create_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_vehiculo` ()   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_listar_ventas` ()   BEGIN
    SELECT 
        ve.idventa,
        ve.fecha_venta,
        p.idpedido,
        tp.comprobantepago,
        cli.idpersona,
        cli.tipo_cliente,
        pr.nombreproducto,
        dp.cantidad_producto,
        dp.subtotal,
        CONCAT(pe.nombres, ' ', pe.appaterno, ' ', pe.apmaterno) AS datos,
        pe.idpersonanrodoc,
        em.razonsocial,
        em.idempresaruc
    FROM 
        ventas ve
    INNER JOIN 
        pedidos p ON p.idpedido = ve.idpedido
    INNER JOIN 
        detalle_pedidos dp ON p.idpedido = dp.idpedido
    INNER JOIN 
        productos pr ON pr.idproducto = dp.idproducto
    INNER JOIN 
        clientes cli ON cli.idcliente = p.idcliente
    LEFT JOIN 
        personas pe ON pe.idpersonanrodoc = cli.idpersona
    LEFT JOIN 
        empresas em ON em.idempresaruc = cli.idempresa
    LEFT JOIN 
        tipo_comprobante_pago tp ON tp.idtipocomprobante = ve.idtipocomprobante
    WHERE 
        p.estado = 'Enviado'
	AND ve.estado='1'
        AND DATE(ve.fecha_venta) = CURDATE()  -- Filtra las ventas del día actual
    GROUP BY 
        ve.idventa, p.idpedido, cli.idpersona, cli.tipo_cliente
    ORDER BY 
        p.idpedido DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_metodo_pago_registrar` (IN `_metodopago` VARCHAR(150))   BEGIN
    INSERT INTO metodos_pago (metodopago) 
    VALUES (_metodopago);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pedido_registrar` (IN `_idusuario` INT, IN `_idcliente` INT)   BEGIN
    INSERT INTO pedidos
    (idusuario, idcliente) 
    VALUES 
    ( _idusuario, _idcliente);
    SELECT idpedido FROM pedidos ORDER BY idpedido DESC LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_promocion_registrar` (IN `_idpromocion` INT, IN `_idtipopromocion` INT, IN `_descripcion` VARCHAR(250), IN `_fechaincio` DATETIME, IN `_fechafin` DATETIME, IN `_valor_descuento` DECIMAL(8,2), IN `_estado` BIT)   BEGIN
    INSERT INTO promociones
    (idpromocion,idtipopromocion, descripcion, fechaincio, fechafin, valor_descuento, estado) 
    VALUES 
    (_idpromocion,_idtipopromocion, _descripcion, _fechaincio, _fechafin, _valor_descuento, _estado);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proovedor_registrar` (IN `_idempresa` BIGINT, IN `_proveedor` VARCHAR(50), IN `_contacto_principal` VARCHAR(50), IN `_telefono_contacto` CHAR(9), IN `_direccion` VARCHAR(100), IN `_email` VARCHAR(100))   BEGIN
    INSERT INTO proveedores
    ( idempresa, proveedor, contacto_principal, telefono_contacto, direccion, email) 
    VALUES 
    ( _idempresa, _proveedor, _contacto_principal, _telefono_contacto, _direccion, _email);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrarmovimiento_kardex` (IN `_idusuario` INT, IN `_idproducto` INT, IN `_fecha_vencimiento` DATE, IN `_numlote` VARCHAR(60), IN `_tipomovimiento` ENUM('Ingreso','Salida'), IN `_cantidad` INT, IN `_motivo` VARCHAR(255))   BEGIN
    DECLARE _ultimo_stock_actual INT DEFAULT 0;
    DECLARE _nuevo_stock_actual INT;

    CALL getultimostock(_idproducto, _ultimo_stock_actual);

    IF _ultimo_stock_actual IS NULL THEN
        SET _ultimo_stock_actual = 0;
    END IF;

    IF _tipomovimiento = 'Ingreso' THEN
        SET _nuevo_stock_actual = _ultimo_stock_actual + _cantidad;
    ELSEIF _tipomovimiento = 'Salida' THEN
        IF _ultimo_stock_actual >= _cantidad THEN
            SET _nuevo_stock_actual = _ultimo_stock_actual - _cantidad;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para esta operación';
        END IF;
    END IF;

    INSERT INTO kardex (idusuario, idproducto,fecha_vencimiento,numlote, stockactual, tipomovimiento, cantidad, motivo)
    VALUES (_idusuario, _idproducto,_fecha_vencimiento,_numlote, _nuevo_stock_actual, _tipomovimiento, _cantidad, _motivo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_categoria` (IN `_categoria` VARCHAR(150))   BEGIN
    INSERT INTO categorias (categoria)
        VALUES (_categoria);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_detalleMetodo` (IN `_idventa` INT, IN `_idmetodopago` INT, IN `_monto` DECIMAL(10,2))   BEGIN
	INSERT INTO detalle_meto_Pago(idventa,idmetodopago,monto)VALUES(_idventa,_idmetodopago,_monto);
    SELECT last_insert_id() AS iddetalle_pago;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_marca` (IN `_marca` VARCHAR(150))   BEGIN
    INSERT INTO marcas (marca) 
    VALUES (_marca);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_producto` (IN `_idmarca` INT, IN `_idsubcategoria` INT, IN `_nombreproducto` VARCHAR(250), IN `_descripcion` VARCHAR(250), IN `_codigo` CHAR(30), IN `_preciounitario` DECIMAL(8,2))   BEGIN
	INSERT INTO productos 
    (idmarca,idsubcategoria,nombreproducto,descripcion,codigo) 
    VALUES
    (_idmarca,_idsubcategoria,_nombreproducto,_descripcion,_codigo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_subcategoria` (IN `_idcategoria` INT, IN `_subcategoria` VARCHAR(150))   BEGIN
    INSERT INTO subcategorias (idcategoria, subcategoria)
    VALUES (_idcategoria, _subcategoria);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_usuario` (IN `_idpersona` VARCHAR(11), IN `_idrol` INT, IN `_nombre_usuario` VARCHAR(100), IN `_password_usuario` VARCHAR(150))   BEGIN
	INSERT INTO usuarios 
    (idpersona, idrol, nombre_usuario, password_usuario) 
    VALUES (_idpersona, _idrol, _nombre_usuario, _password_usuario);
    SELECT LAST_INSERT_ID() AS idusuario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_vehiculo` (IN `_idusuario` INT, IN `_marca_vehiculo` VARCHAR(100), IN `_modelo` VARCHAR(100), IN `_placa` VARCHAR(7), IN `_capacidad` SMALLINT, IN `_condicion` ENUM('operativo','taller','averiado'))   BEGIN
    INSERT INTO vehiculos (idusuario, marca_vehiculo, modelo, placa, capacidad, condicion)
    VALUES (_idusuario, _marca_vehiculo, _modelo, _placa, _capacidad, _condicion);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_venta` (IN `_idpedido` VARCHAR(15), IN `_idtipocomprobante` INT, IN `_fecha_venta` DATETIME, IN `_subtotal` DECIMAL(10,2), IN `_descuento` DECIMAL(10,2), IN `_igv` DECIMAL(10,2), IN `_total_venta` DECIMAL(10,2))   BEGIN
    INSERT INTO ventas 
    (idpedido, idtipocomprobante,fecha_venta, subtotal, descuento, igv,total_venta) 
    VALUES
    (_idpedido,_idtipocomprobante,_fecha_venta,_subtotal, _descuento,_igv,_total_venta);
    SELECT  last_insert_id() AS idventa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tipo_comprobaantes_registrar` (IN `_comprobantepago` VARCHAR(150))   BEGIN
    INSERT INTO tipo_comprobante_pago (comprobantepago) 
    VALUES (_comprobantepago);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_tipo_promocion_registrar` (IN `_tipopromocion` VARCHAR(150), IN `_descripcion` VARCHAR(250))   BEGIN
    INSERT INTO tipos_promociones (tipopromocion, descripcion) 
    VALUES (_tipopromocion, _descripcion);
    SELECT LAST_INSERT_ID() as "id";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usuario_login` (IN `_nombre_usuario` VARCHAR(100))   BEGIN
SELECT
	USU.idusuario,
    USU.idpersona AS dni,
    PER.appaterno,
    PER.apmaterno,
    PER.nombres,
    ROL.rol,
    USU.nombre_usuario,
    USU.password_usuario
    FROM usuarios USU
	INNER JOIN personas PER ON USU.idpersona = PER.idpersonanrodoc
    INNER JOIN roles ROL	ON USU.idrol = ROL.idrol
    WHERE USU.nombre_usuario = _nombre_usuario AND USU.estado=1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `accesos`
--

CREATE TABLE `accesos` (
  `idacceso` int(11) NOT NULL,
  `modulo` varchar(100) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `idcategoria` int(11) NOT NULL,
  `categoria` varchar(150) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`idcategoria`, `categoria`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Alimentos', '2024-10-11 16:04:10', NULL, '1'),
(2, 'Bebidas', '2024-10-11 16:04:10', NULL, '1'),
(3, 'Limpieza y Hogar', '2024-10-11 16:04:10', NULL, '1'),
(4, 'Cuidado Personal', '2024-10-11 16:04:10', NULL, '1'),
(5, 'Higiene y Salud', '2024-10-11 16:04:10', NULL, '1'),
(6, 'Mascotas', '2024-10-11 16:04:10', NULL, '1'),
(7, 'Embalaje y Descartables', '2024-10-11 16:04:10', NULL, '1'),
(8, 'Electrodomésticos Pequeños', '2024-10-11 16:04:10', NULL, '1'),
(9, 'Ferretería y Herramientas', '2024-10-11 16:04:10', NULL, '1'),
(10, 'Oficina y Papelería', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `idcliente` int(11) NOT NULL,
  `idpersona` char(11) DEFAULT NULL,
  `idempresa` bigint(20) DEFAULT NULL,
  `tipo_cliente` char(10) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`idcliente`, `idpersona`, `idempresa`, `tipo_cliente`, `create_at`, `update_at`, `estado`) VALUES
(1, '26558000', NULL, 'Persona', '2024-10-11 16:04:21', NULL, '1'),
(2, NULL, 20123456781, 'Empresa', '2024-10-11 16:04:21', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comprobantes`
--

CREATE TABLE `comprobantes` (
  `idcomprobante` int(11) NOT NULL,
  `idventa` int(11) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE `departamentos` (
  `iddepartamento` int(11) NOT NULL,
  `departamento` varchar(250) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`iddepartamento`, `departamento`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Amazonas', '2024-10-11 15:51:18', NULL, '1'),
(2, 'Áncash', '2024-10-11 15:51:18', NULL, '1'),
(3, 'Apurímac', '2024-10-11 15:51:18', NULL, '1'),
(4, 'Arequipa', '2024-10-11 15:51:18', NULL, '1'),
(5, 'Ayacucho', '2024-10-11 15:51:18', NULL, '1'),
(6, 'Cajamarca', '2024-10-11 15:51:18', NULL, '1'),
(7, 'Callao', '2024-10-11 15:51:18', NULL, '1'),
(8, 'Cusco', '2024-10-11 15:51:18', NULL, '1'),
(9, 'Huancavelica', '2024-10-11 15:51:18', NULL, '1'),
(10, 'Huánuco', '2024-10-11 15:51:18', NULL, '1'),
(11, 'Ica', '2024-10-11 15:51:18', NULL, '1'),
(12, 'Junín', '2024-10-11 15:51:18', NULL, '1'),
(13, 'La Libertad', '2024-10-11 15:51:18', NULL, '1'),
(14, 'Lambayeque', '2024-10-11 15:51:18', NULL, '1'),
(15, 'Lima', '2024-10-11 15:51:18', NULL, '1'),
(16, 'Loreto', '2024-10-11 15:51:18', NULL, '1'),
(17, 'Madre de Dios', '2024-10-11 15:51:18', NULL, '1'),
(18, 'Moquegua', '2024-10-11 15:51:18', NULL, '1'),
(19, 'Pasco', '2024-10-11 15:51:18', NULL, '1'),
(20, 'Piura', '2024-10-11 15:51:18', NULL, '1'),
(21, 'Puno', '2024-10-11 15:51:18', NULL, '1'),
(22, 'San Martín', '2024-10-11 15:51:18', NULL, '1'),
(23, 'Tacna', '2024-10-11 15:51:18', NULL, '1'),
(24, 'Tumbes', '2024-10-11 15:51:18', NULL, '1'),
(25, 'Ucayali', '2024-10-11 15:51:18', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `despacho`
--

CREATE TABLE `despacho` (
  `iddespacho` int(11) NOT NULL,
  `idvehiculo` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `fecha_despacho` date NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_meto_pago`
--

CREATE TABLE `detalle_meto_pago` (
  `iddetallemetodo` int(11) NOT NULL,
  `idventa` int(11) NOT NULL,
  `idmetodopago` int(11) NOT NULL,
  `monto` decimal(10,0) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedidos`
--

CREATE TABLE `detalle_pedidos` (
  `id_detalle_pedido` int(11) NOT NULL,
  `idpedido` char(15) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `cantidad_producto` int(11) NOT NULL,
  `unidad_medida` char(20) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `precio_descuento` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Disparadores `detalle_pedidos`
--
DELIMITER $$
CREATE TRIGGER `trg_actualizar_stock` AFTER INSERT ON `detalle_pedidos` FOR EACH ROW BEGIN
    DECLARE v_stock_actual          INT;
    DECLARE v_idusuario             INT;
    DECLARE v_fecha_vencimiento     DATE;
    DECLARE v_numlote               VARCHAR(60);

    SELECT stockactual INTO v_stock_actual
    FROM kardex
    WHERE idproducto = NEW.idproducto
    LIMIT 1;

    SELECT idusuario INTO v_idusuario
    FROM pedidos
    WHERE idpedido = NEW.idpedido
    LIMIT 1;

    SELECT fecha_vencimiento, numlote INTO v_fecha_vencimiento, v_numlote
    FROM kardex
    WHERE idproducto = NEW.idproducto
    AND  stockactual > 0
    ORDER BY fecha_vencimiento ASC
    LIMIT 1;

    IF v_stock_actual >= NEW.cantidad_producto THEN
        CALL sp_registrarmovimiento_kardex
        (v_idusuario, NEW.idproducto,v_fecha_vencimiento,v_numlote, 'Salida', NEW.cantidad_producto, 'Venta de producto');
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para esta operación';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_productos`
--

CREATE TABLE `detalle_productos` (
  `id_detalle_producto` int(11) NOT NULL,
  `idproveedor` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `idunidadmedida` int(11) NOT NULL,
  `precio_compra` decimal(10,2) NOT NULL,
  `precio_venta_minorista` decimal(10,2) NOT NULL DEFAULT 0.00,
  `precio_venta_mayorista` decimal(10,2) NOT NULL DEFAULT 0.00,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `detalle_productos`
--

INSERT INTO `detalle_productos` (`id_detalle_producto`, `idproveedor`, `idproducto`, `idunidadmedida`, `precio_compra`, `precio_venta_minorista`, `precio_venta_mayorista`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 1, 1, 2.50, 3.50, 3.00, '2024-10-11 16:04:11', NULL, '1'),
(2, 1, 2, 1, 1.20, 1.50, 1.30, '2024-10-11 16:04:11', NULL, '1'),
(3, 1, 3, 2, 0.80, 1.20, 1.00, '2024-10-11 16:04:11', NULL, '1'),
(4, 1, 4, 2, 1.00, 1.50, 1.20, '2024-10-11 16:04:11', NULL, '1'),
(5, 1, 5, 3, 5.00, 7.50, 6.50, '2024-10-11 16:04:11', NULL, '1'),
(6, 1, 6, 3, 4.80, 7.00, 6.00, '2024-10-11 16:04:11', NULL, '1'),
(7, 1, 7, 1, 3.20, 4.50, 4.00, '2024-10-11 16:04:11', NULL, '1'),
(8, 1, 8, 1, 2.90, 4.00, 3.50, '2024-10-11 16:04:11', NULL, '1'),
(9, 1, 9, 3, 15.00, 20.00, 18.00, '2024-10-11 16:04:11', NULL, '1'),
(10, 1, 10, 3, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(11, 1, 11, 3, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(12, 1, 12, 2, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(13, 1, 13, 3, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(14, 1, 14, 2, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(15, 1, 15, 2, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(16, 1, 16, 3, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(17, 1, 17, 2, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1'),
(18, 1, 18, 2, 12.00, 17.00, 15.00, '2024-10-11 16:04:11', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_promociones`
--

CREATE TABLE `detalle_promociones` (
  `iddetallepromocion` int(11) NOT NULL,
  `idpromocion` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `descuento` decimal(8,2) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `detalle_promociones`
--

INSERT INTO `detalle_promociones` (`iddetallepromocion`, `idpromocion`, `idproducto`, `descuento`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 1, 5.00, '2024-10-11 16:04:11', NULL, '1'),
(2, 2, 2, 5.00, '2024-10-11 16:04:11', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `distritos`
--

CREATE TABLE `distritos` (
  `iddistrito` int(11) NOT NULL,
  `idprovincia` int(11) NOT NULL,
  `distrito` varchar(250) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `distritos`
--

INSERT INTO `distritos` (`iddistrito`, `idprovincia`, `distrito`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 'CHACHAPOYAS', '2024-10-11 15:52:01', NULL, '1'),
(2, 1, 'ASUNCION', '2024-10-11 15:52:01', NULL, '1'),
(3, 1, 'BALSAS', '2024-10-11 15:52:01', NULL, '1'),
(4, 1, 'CHETO', '2024-10-11 15:52:01', NULL, '1'),
(5, 1, 'CHILIQUIN', '2024-10-11 15:52:01', NULL, '1'),
(6, 1, 'CHUQUIBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(7, 1, 'GRANADA', '2024-10-11 15:52:01', NULL, '1'),
(8, 1, 'HUANCAS', '2024-10-11 15:52:01', NULL, '1'),
(9, 1, 'LA JALCA', '2024-10-11 15:52:01', NULL, '1'),
(10, 1, 'LEIMEBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(11, 1, 'LEVANTO', '2024-10-11 15:52:01', NULL, '1'),
(12, 1, 'MAGDALENA', '2024-10-11 15:52:01', NULL, '1'),
(13, 1, 'MARISCAL CASTILLA', '2024-10-11 15:52:01', NULL, '1'),
(14, 1, 'MOLINOPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(15, 1, 'MONTEVIDEO', '2024-10-11 15:52:01', NULL, '1'),
(16, 1, 'OLLEROS', '2024-10-11 15:52:01', NULL, '1'),
(17, 1, 'QUINJALCA', '2024-10-11 15:52:01', NULL, '1'),
(18, 1, 'SAN FRANCISCO DE DAGUAS', '2024-10-11 15:52:01', NULL, '1'),
(19, 1, 'SAN ISIDRO DE MAINO', '2024-10-11 15:52:01', NULL, '1'),
(20, 1, 'SOLOCO', '2024-10-11 15:52:01', NULL, '1'),
(21, 1, 'SONCHE', '2024-10-11 15:52:01', NULL, '1'),
(22, 2, 'LA PECA', '2024-10-11 15:52:01', NULL, '1'),
(23, 2, 'ARAMANGO', '2024-10-11 15:52:01', NULL, '1'),
(24, 2, 'COPALLIN', '2024-10-11 15:52:01', NULL, '1'),
(25, 2, 'EL PARCO', '2024-10-11 15:52:01', NULL, '1'),
(26, 2, 'IMAZA', '2024-10-11 15:52:01', NULL, '1'),
(27, 3, 'JUMBILLA', '2024-10-11 15:52:01', NULL, '1'),
(28, 3, 'CHISQUILLA', '2024-10-11 15:52:01', NULL, '1'),
(29, 3, 'CHURUJA', '2024-10-11 15:52:01', NULL, '1'),
(30, 3, 'COROSHA', '2024-10-11 15:52:01', NULL, '1'),
(31, 3, 'CUISPES', '2024-10-11 15:52:01', NULL, '1'),
(32, 3, 'FLORIDA', '2024-10-11 15:52:01', NULL, '1'),
(33, 3, 'JAZAN', '2024-10-11 15:52:01', NULL, '1'),
(34, 3, 'RECTA', '2024-10-11 15:52:01', NULL, '1'),
(35, 3, 'SAN CARLOS', '2024-10-11 15:52:01', NULL, '1'),
(36, 3, 'SHIPASBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(37, 3, 'VALERA', '2024-10-11 15:52:01', NULL, '1'),
(38, 3, 'YAMBRASBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(39, 4, 'NIEVA', '2024-10-11 15:52:01', NULL, '1'),
(40, 4, 'EL CENEPA', '2024-10-11 15:52:01', NULL, '1'),
(41, 4, 'RIO SANTIAGO', '2024-10-11 15:52:01', NULL, '1'),
(42, 5, 'LAMUD', '2024-10-11 15:52:01', NULL, '1'),
(43, 5, 'CAMPORREDONDO', '2024-10-11 15:52:01', NULL, '1'),
(44, 5, 'COCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(45, 5, 'COLCAMAR', '2024-10-11 15:52:01', NULL, '1'),
(46, 5, 'CONILA', '2024-10-11 15:52:01', NULL, '1'),
(47, 5, 'INGUILPATA', '2024-10-11 15:52:01', NULL, '1'),
(48, 5, 'LONGUITA', '2024-10-11 15:52:01', NULL, '1'),
(49, 5, 'LONYA CHICO', '2024-10-11 15:52:01', NULL, '1'),
(50, 5, 'LUYA', '2024-10-11 15:52:01', NULL, '1'),
(51, 5, 'LUYA VIEJO', '2024-10-11 15:52:01', NULL, '1'),
(52, 5, 'MARIA', '2024-10-11 15:52:01', NULL, '1'),
(53, 5, 'OCALLI', '2024-10-11 15:52:01', NULL, '1'),
(54, 5, 'OCUMAL', '2024-10-11 15:52:01', NULL, '1'),
(55, 5, 'PISUQUIA', '2024-10-11 15:52:01', NULL, '1'),
(56, 5, 'PROVIDENCIA', '2024-10-11 15:52:01', NULL, '1'),
(57, 5, 'SAN CRISTOBAL', '2024-10-11 15:52:01', NULL, '1'),
(58, 5, 'SAN FRANCISCO DEL YESO', '2024-10-11 15:52:01', NULL, '1'),
(59, 5, 'SAN JERONIMO', '2024-10-11 15:52:01', NULL, '1'),
(60, 5, 'SAN JUAN DE LOPECANCHA', '2024-10-11 15:52:01', NULL, '1'),
(61, 5, 'SANTA CATALINA', '2024-10-11 15:52:01', NULL, '1'),
(62, 5, 'SANTO TOMAS', '2024-10-11 15:52:01', NULL, '1'),
(63, 5, 'TINGO', '2024-10-11 15:52:01', NULL, '1'),
(64, 5, 'TRITA', '2024-10-11 15:52:01', NULL, '1'),
(65, 6, 'SAN NICOLAS', '2024-10-11 15:52:01', NULL, '1'),
(66, 6, 'CHIRIMOTO', '2024-10-11 15:52:01', NULL, '1'),
(67, 6, 'COCHAMAL', '2024-10-11 15:52:01', NULL, '1'),
(68, 6, 'HUAMBO', '2024-10-11 15:52:01', NULL, '1'),
(69, 6, 'LIMABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(70, 6, 'LONGAR', '2024-10-11 15:52:01', NULL, '1'),
(71, 6, 'MARISCAL BENAVIDES', '2024-10-11 15:52:01', NULL, '1'),
(72, 6, 'MILPUC', '2024-10-11 15:52:01', NULL, '1'),
(73, 6, 'OMIA', '2024-10-11 15:52:01', NULL, '1'),
(74, 6, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(75, 6, 'TOTORA', '2024-10-11 15:52:01', NULL, '1'),
(76, 6, 'VISTA ALEGRE', '2024-10-11 15:52:01', NULL, '1'),
(77, 7, 'BAGUA GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(78, 7, 'CAJARURO', '2024-10-11 15:52:01', NULL, '1'),
(79, 7, 'CUMBA', '2024-10-11 15:52:01', NULL, '1'),
(80, 7, 'EL MILAGRO', '2024-10-11 15:52:01', NULL, '1'),
(81, 7, 'JAMALCA', '2024-10-11 15:52:01', NULL, '1'),
(82, 7, 'LONYA GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(83, 7, 'YAMON', '2024-10-11 15:52:01', NULL, '1'),
(84, 8, 'HUARAZ', '2024-10-11 15:52:01', NULL, '1'),
(85, 8, 'COCHABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(86, 8, 'COLCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(87, 8, 'HUANCHAY', '2024-10-11 15:52:01', NULL, '1'),
(88, 8, 'INDEPENDENCIA', '2024-10-11 15:52:01', NULL, '1'),
(89, 8, 'JANGAS', '2024-10-11 15:52:01', NULL, '1'),
(90, 8, 'LA LIBERTAD', '2024-10-11 15:52:01', NULL, '1'),
(91, 8, 'OLLEROS', '2024-10-11 15:52:01', NULL, '1'),
(92, 8, 'PAMPAS', '2024-10-11 15:52:01', NULL, '1'),
(93, 8, 'PARIACOTO', '2024-10-11 15:52:01', NULL, '1'),
(94, 8, 'PIRA', '2024-10-11 15:52:01', NULL, '1'),
(95, 8, 'TARICA', '2024-10-11 15:52:01', NULL, '1'),
(96, 9, 'AIJA', '2024-10-11 15:52:01', NULL, '1'),
(97, 9, 'CORIS', '2024-10-11 15:52:01', NULL, '1'),
(98, 9, 'HUACLLAN', '2024-10-11 15:52:01', NULL, '1'),
(99, 9, 'LA MERCED', '2024-10-11 15:52:01', NULL, '1'),
(100, 9, 'SUCCHA', '2024-10-11 15:52:01', NULL, '1'),
(101, 10, 'LLAMELLIN', '2024-10-11 15:52:01', NULL, '1'),
(102, 10, 'ACZO', '2024-10-11 15:52:01', NULL, '1'),
(103, 10, 'CHACCHO', '2024-10-11 15:52:01', NULL, '1'),
(104, 10, 'CHINGAS', '2024-10-11 15:52:01', NULL, '1'),
(105, 10, 'MIRGAS', '2024-10-11 15:52:01', NULL, '1'),
(106, 10, 'SAN JUAN DE RONTOY', '2024-10-11 15:52:01', NULL, '1'),
(107, 11, 'CHACAS', '2024-10-11 15:52:01', NULL, '1'),
(108, 11, 'ACOCHACA', '2024-10-11 15:52:01', NULL, '1'),
(109, 12, 'CHIQUIAN', '2024-10-11 15:52:01', NULL, '1'),
(110, 12, 'ABELARDO PARDO LEZAMETA', '2024-10-11 15:52:01', NULL, '1'),
(111, 12, 'ANTONIO RAYMONDI', '2024-10-11 15:52:01', NULL, '1'),
(112, 12, 'AQUIA', '2024-10-11 15:52:01', NULL, '1'),
(113, 12, 'CAJACAY', '2024-10-11 15:52:01', NULL, '1'),
(114, 12, 'CANIS', '2024-10-11 15:52:01', NULL, '1'),
(115, 12, 'COLQUIOC', '2024-10-11 15:52:01', NULL, '1'),
(116, 12, 'HUALLANCA', '2024-10-11 15:52:01', NULL, '1'),
(117, 12, 'HUASTA', '2024-10-11 15:52:01', NULL, '1'),
(118, 12, 'HUAYLLACAYAN', '2024-10-11 15:52:01', NULL, '1'),
(119, 12, 'LA PRIMAVERA', '2024-10-11 15:52:01', NULL, '1'),
(120, 12, 'MANGAS', '2024-10-11 15:52:01', NULL, '1'),
(121, 12, 'PACLLON', '2024-10-11 15:52:01', NULL, '1'),
(122, 12, 'SAN MIGUEL DE CORPANQUI', '2024-10-11 15:52:01', NULL, '1'),
(123, 12, 'TICLLOS', '2024-10-11 15:52:01', NULL, '1'),
(124, 13, 'CARHUAZ', '2024-10-11 15:52:01', NULL, '1'),
(125, 13, 'ACOPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(126, 13, 'AMASHCA', '2024-10-11 15:52:01', NULL, '1'),
(127, 13, 'ANTA', '2024-10-11 15:52:01', NULL, '1'),
(128, 13, 'ATAQUERO', '2024-10-11 15:52:01', NULL, '1'),
(129, 13, 'MARCARA', '2024-10-11 15:52:01', NULL, '1'),
(130, 13, 'PARIAHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(131, 13, 'SAN MIGUEL DE ACO', '2024-10-11 15:52:01', NULL, '1'),
(132, 13, 'SHILLA', '2024-10-11 15:52:01', NULL, '1'),
(133, 13, 'TINCO', '2024-10-11 15:52:01', NULL, '1'),
(134, 13, 'YUNGAR', '2024-10-11 15:52:01', NULL, '1'),
(135, 14, 'SAN LUIS', '2024-10-11 15:52:01', NULL, '1'),
(136, 14, 'SAN NICOLAS', '2024-10-11 15:52:01', NULL, '1'),
(137, 14, 'YAUYA', '2024-10-11 15:52:01', NULL, '1'),
(138, 15, 'CASMA', '2024-10-11 15:52:01', NULL, '1'),
(139, 15, 'BUENA VISTA ALTA', '2024-10-11 15:52:01', NULL, '1'),
(140, 15, 'COMANDANTE NOEL', '2024-10-11 15:52:01', NULL, '1'),
(141, 15, 'YAUTAN', '2024-10-11 15:52:01', NULL, '1'),
(142, 16, 'CORONGO', '2024-10-11 15:52:01', NULL, '1'),
(143, 16, 'ACO', '2024-10-11 15:52:01', NULL, '1'),
(144, 16, 'BAMBAS', '2024-10-11 15:52:01', NULL, '1'),
(145, 16, 'CUSCA', '2024-10-11 15:52:01', NULL, '1'),
(146, 16, 'LA PAMPA', '2024-10-11 15:52:01', NULL, '1'),
(147, 16, 'YANAC', '2024-10-11 15:52:01', NULL, '1'),
(148, 16, 'YUPAN', '2024-10-11 15:52:01', NULL, '1'),
(149, 17, 'HUARI', '2024-10-11 15:52:01', NULL, '1'),
(150, 17, 'ANRA', '2024-10-11 15:52:01', NULL, '1'),
(151, 17, 'CAJAY', '2024-10-11 15:52:01', NULL, '1'),
(152, 17, 'CHAVIN DE HUANTAR', '2024-10-11 15:52:01', NULL, '1'),
(153, 17, 'HUACACHI', '2024-10-11 15:52:01', NULL, '1'),
(154, 17, 'HUACCHIS', '2024-10-11 15:52:01', NULL, '1'),
(155, 17, 'HUACHIS', '2024-10-11 15:52:01', NULL, '1'),
(156, 17, 'HUANTAR', '2024-10-11 15:52:01', NULL, '1'),
(157, 17, 'MASIN', '2024-10-11 15:52:01', NULL, '1'),
(158, 17, 'PAUCAS', '2024-10-11 15:52:01', NULL, '1'),
(159, 17, 'PONTO', '2024-10-11 15:52:01', NULL, '1'),
(160, 17, 'RAHUAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(161, 17, 'RAPAYAN', '2024-10-11 15:52:01', NULL, '1'),
(162, 17, 'SAN MARCOS', '2024-10-11 15:52:01', NULL, '1'),
(163, 17, 'SAN PEDRO DE CHANA', '2024-10-11 15:52:01', NULL, '1'),
(164, 17, 'UCO', '2024-10-11 15:52:01', NULL, '1'),
(165, 18, 'HUARMEY', '2024-10-11 15:52:01', NULL, '1'),
(166, 18, 'COCHAPETI', '2024-10-11 15:52:01', NULL, '1'),
(167, 18, 'CULEBRAS', '2024-10-11 15:52:01', NULL, '1'),
(168, 18, 'HUAYAN', '2024-10-11 15:52:01', NULL, '1'),
(169, 18, 'MALVAS', '2024-10-11 15:52:01', NULL, '1'),
(170, 26, 'CARAZ', '2024-10-11 15:52:01', NULL, '1'),
(171, 26, 'HUALLANCA', '2024-10-11 15:52:01', NULL, '1'),
(172, 26, 'HUATA', '2024-10-11 15:52:01', NULL, '1'),
(173, 26, 'HUAYLAS', '2024-10-11 15:52:01', NULL, '1'),
(174, 26, 'MATO', '2024-10-11 15:52:01', NULL, '1'),
(175, 26, 'PAMPAROMAS', '2024-10-11 15:52:01', NULL, '1'),
(176, 26, 'PUEBLO LIBRE', '2024-10-11 15:52:01', NULL, '1'),
(177, 26, 'SANTA CRUZ', '2024-10-11 15:52:01', NULL, '1'),
(178, 26, 'SANTO TORIBIO', '2024-10-11 15:52:01', NULL, '1'),
(179, 26, 'YURACMARCA', '2024-10-11 15:52:01', NULL, '1'),
(180, 27, 'PISCOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(181, 27, 'CASCA', '2024-10-11 15:52:01', NULL, '1'),
(182, 27, 'ELEAZAR GUZMAN BARRON', '2024-10-11 15:52:01', NULL, '1'),
(183, 27, 'FIDEL OLIVAS ESCUDERO', '2024-10-11 15:52:01', NULL, '1'),
(184, 27, 'LLAMA', '2024-10-11 15:52:01', NULL, '1'),
(185, 27, 'LLUMPA', '2024-10-11 15:52:01', NULL, '1'),
(186, 27, 'LUCMA', '2024-10-11 15:52:01', NULL, '1'),
(187, 27, 'MUSGA', '2024-10-11 15:52:01', NULL, '1'),
(188, 21, 'OCROS', '2024-10-11 15:52:01', NULL, '1'),
(189, 21, 'ACAS', '2024-10-11 15:52:01', NULL, '1'),
(190, 21, 'CAJAMARQUILLA', '2024-10-11 15:52:01', NULL, '1'),
(191, 21, 'CARHUAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(192, 21, 'COCHAS', '2024-10-11 15:52:01', NULL, '1'),
(193, 21, 'CONGAS', '2024-10-11 15:52:01', NULL, '1'),
(194, 21, 'LLIPA', '2024-10-11 15:52:01', NULL, '1'),
(195, 21, 'SAN CRISTOBAL DE RAJAN', '2024-10-11 15:52:01', NULL, '1'),
(196, 21, 'SAN PEDRO', '2024-10-11 15:52:01', NULL, '1'),
(197, 21, 'SANTIAGO DE CHILCAS', '2024-10-11 15:52:01', NULL, '1'),
(198, 22, 'CABANA', '2024-10-11 15:52:01', NULL, '1'),
(199, 22, 'BOLOGNESI', '2024-10-11 15:52:01', NULL, '1'),
(200, 22, 'CONCHUCOS', '2024-10-11 15:52:01', NULL, '1'),
(201, 22, 'HUACASCHUQUE', '2024-10-11 15:52:01', NULL, '1'),
(202, 22, 'HUANDOVAL', '2024-10-11 15:52:01', NULL, '1'),
(203, 22, 'LACABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(204, 22, 'LLAPO', '2024-10-11 15:52:01', NULL, '1'),
(205, 22, 'PALLASCA', '2024-10-11 15:52:01', NULL, '1'),
(206, 22, 'PAMPAS', '2024-10-11 15:52:01', NULL, '1'),
(207, 22, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(208, 22, 'TAUCA', '2024-10-11 15:52:01', NULL, '1'),
(209, 23, 'POMABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(210, 23, 'HUAYLLAN', '2024-10-11 15:52:01', NULL, '1'),
(211, 23, 'PAROBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(212, 23, 'QUINUABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(213, 24, 'RECUAY', '2024-10-11 15:52:01', NULL, '1'),
(214, 24, 'CATAC', '2024-10-11 15:52:01', NULL, '1'),
(215, 24, 'COTAPARACO', '2024-10-11 15:52:01', NULL, '1'),
(216, 24, 'HUAYLLAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(217, 24, 'LLACLLIN', '2024-10-11 15:52:01', NULL, '1'),
(218, 24, 'MARCA', '2024-10-11 15:52:01', NULL, '1'),
(219, 24, 'PAMPAS CHICO', '2024-10-11 15:52:01', NULL, '1'),
(220, 24, 'PARARIN', '2024-10-11 15:52:01', NULL, '1'),
(221, 24, 'TAPACOCHA', '2024-10-11 15:52:01', NULL, '1'),
(222, 24, 'TICAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(223, 25, 'CHIMBOTE', '2024-10-11 15:52:01', NULL, '1'),
(224, 25, 'CACERES DEL PERU', '2024-10-11 15:52:01', NULL, '1'),
(225, 25, 'COISHCO', '2024-10-11 15:52:01', NULL, '1'),
(226, 25, 'MACATE', '2024-10-11 15:52:01', NULL, '1'),
(227, 25, 'MORO', '2024-10-11 15:52:01', NULL, '1'),
(228, 25, 'NEPEÑA', '2024-10-11 15:52:01', NULL, '1'),
(229, 25, 'SAMANCO', '2024-10-11 15:52:01', NULL, '1'),
(230, 25, 'SANTA', '2024-10-11 15:52:01', NULL, '1'),
(231, 25, 'NUEVO CHIMBOTE', '2024-10-11 15:52:01', NULL, '1'),
(232, 26, 'SIHUAS', '2024-10-11 15:52:01', NULL, '1'),
(233, 26, 'ACOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(234, 26, 'ALFONSO UGARTE', '2024-10-11 15:52:01', NULL, '1'),
(235, 26, 'CASHAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(236, 26, 'CHINGALPO', '2024-10-11 15:52:01', NULL, '1'),
(237, 26, 'HUAYLLABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(238, 26, 'QUICHES', '2024-10-11 15:52:01', NULL, '1'),
(239, 26, 'RAGASH', '2024-10-11 15:52:01', NULL, '1'),
(240, 26, 'SAN JUAN', '2024-10-11 15:52:01', NULL, '1'),
(241, 26, 'SICSIBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(242, 27, 'YUNGAY', '2024-10-11 15:52:01', NULL, '1'),
(243, 27, 'CASCAPARA', '2024-10-11 15:52:01', NULL, '1'),
(244, 27, 'MANCOS', '2024-10-11 15:52:01', NULL, '1'),
(245, 27, 'MATACOTO', '2024-10-11 15:52:01', NULL, '1'),
(246, 27, 'QUILLO', '2024-10-11 15:52:01', NULL, '1'),
(247, 27, 'RANRAHIRCA', '2024-10-11 15:52:01', NULL, '1'),
(248, 27, 'SHUPLUY', '2024-10-11 15:52:01', NULL, '1'),
(249, 27, 'YANAMA', '2024-10-11 15:52:01', NULL, '1'),
(250, 28, 'ABANCAY', '2024-10-11 15:52:01', NULL, '1'),
(251, 28, 'CHACOCHE', '2024-10-11 15:52:01', NULL, '1'),
(252, 28, 'CIRCA', '2024-10-11 15:52:01', NULL, '1'),
(253, 28, 'CURAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(254, 28, 'HUANIPACA', '2024-10-11 15:52:01', NULL, '1'),
(255, 28, 'LAMBRAMA', '2024-10-11 15:52:01', NULL, '1'),
(256, 28, 'PICHIRHUA', '2024-10-11 15:52:01', NULL, '1'),
(257, 28, 'SAN PEDRO DE CACHORA', '2024-10-11 15:52:01', NULL, '1'),
(258, 28, 'TAMBURCO', '2024-10-11 15:52:01', NULL, '1'),
(259, 29, 'ANDAHUAYLAS', '2024-10-11 15:52:01', NULL, '1'),
(260, 29, 'ANDARAPA', '2024-10-11 15:52:01', NULL, '1'),
(261, 29, 'CHIARA', '2024-10-11 15:52:01', NULL, '1'),
(262, 29, 'HUANCARAMA', '2024-10-11 15:52:01', NULL, '1'),
(263, 29, 'HUANCARAY', '2024-10-11 15:52:01', NULL, '1'),
(264, 29, 'HUAYANA', '2024-10-11 15:52:01', NULL, '1'),
(265, 29, 'KISHUARA', '2024-10-11 15:52:01', NULL, '1'),
(266, 29, 'PACOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(267, 29, 'PACUCHA', '2024-10-11 15:52:01', NULL, '1'),
(268, 29, 'PAMPACHIRI', '2024-10-11 15:52:01', NULL, '1'),
(269, 29, 'POMACOCHA', '2024-10-11 15:52:01', NULL, '1'),
(270, 29, 'SAN ANTONIO DE CACHI', '2024-10-11 15:52:01', NULL, '1'),
(271, 29, 'SAN JERONIMO', '2024-10-11 15:52:01', NULL, '1'),
(272, 29, 'SAN MIGUEL DE CHACCRAMPA', '2024-10-11 15:52:01', NULL, '1'),
(273, 29, 'SANTA MARIA DE CHICMO', '2024-10-11 15:52:01', NULL, '1'),
(274, 29, 'TALAVERA', '2024-10-11 15:52:01', NULL, '1'),
(275, 29, 'TUMAY HUARACA', '2024-10-11 15:52:01', NULL, '1'),
(276, 29, 'TURPO', '2024-10-11 15:52:01', NULL, '1'),
(277, 29, 'KAQUIABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(278, 30, 'ANTABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(279, 30, 'EL ORO', '2024-10-11 15:52:01', NULL, '1'),
(280, 30, 'HUAQUIRCA', '2024-10-11 15:52:01', NULL, '1'),
(281, 30, 'JUAN ESPINOZA MEDRANO', '2024-10-11 15:52:01', NULL, '1'),
(282, 30, 'OROPESA', '2024-10-11 15:52:01', NULL, '1'),
(283, 30, 'PACHACONAS', '2024-10-11 15:52:01', NULL, '1'),
(284, 30, 'SABAINO', '2024-10-11 15:52:01', NULL, '1'),
(285, 31, 'CHALHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(286, 31, 'CAPAYA', '2024-10-11 15:52:01', NULL, '1'),
(287, 31, 'CARAYBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(288, 31, 'CHAPIMARCA', '2024-10-11 15:52:01', NULL, '1'),
(289, 31, 'COLCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(290, 31, 'COTARUSE', '2024-10-11 15:52:01', NULL, '1'),
(291, 31, 'HUAYLLO', '2024-10-11 15:52:01', NULL, '1'),
(292, 31, 'JUSTO APU SAHUARAURA', '2024-10-11 15:52:01', NULL, '1'),
(293, 31, 'LUCRE', '2024-10-11 15:52:01', NULL, '1'),
(294, 31, 'POCOHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(295, 31, 'SAN JUAN DE CHACÑA', '2024-10-11 15:52:01', NULL, '1'),
(296, 31, 'SAÑAYCA', '2024-10-11 15:52:01', NULL, '1'),
(297, 31, 'SORAYA', '2024-10-11 15:52:01', NULL, '1'),
(298, 31, 'TAPAIRIHUA', '2024-10-11 15:52:01', NULL, '1'),
(299, 31, 'TINTAY', '2024-10-11 15:52:01', NULL, '1'),
(300, 31, 'TORAYA', '2024-10-11 15:52:01', NULL, '1'),
(301, 31, 'YANACA', '2024-10-11 15:52:01', NULL, '1'),
(302, 32, 'TAMBOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(303, 32, 'COTABAMBAS', '2024-10-11 15:52:01', NULL, '1'),
(304, 32, 'COYLLURQUI', '2024-10-11 15:52:01', NULL, '1'),
(305, 32, 'HAQUIRA', '2024-10-11 15:52:01', NULL, '1'),
(306, 32, 'MARA', '2024-10-11 15:52:01', NULL, '1'),
(307, 32, 'CHALLHUAHUACHO', '2024-10-11 15:52:01', NULL, '1'),
(308, 33, 'CHINCHEROS', '2024-10-11 15:52:01', NULL, '1'),
(309, 33, 'ANCO-HUALLO', '2024-10-11 15:52:01', NULL, '1'),
(310, 33, 'COCHARCAS', '2024-10-11 15:52:01', NULL, '1'),
(311, 33, 'HUACCANA', '2024-10-11 15:52:01', NULL, '1'),
(312, 33, 'OCOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(313, 33, 'ONGOY', '2024-10-11 15:52:01', NULL, '1'),
(314, 33, 'URANMARCA', '2024-10-11 15:52:01', NULL, '1'),
(315, 33, 'RANRACANCHA', '2024-10-11 15:52:01', NULL, '1'),
(316, 34, 'CHUQUIBAMBILLA', '2024-10-11 15:52:01', NULL, '1'),
(317, 34, 'CURPAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(318, 34, 'GAMARRA', '2024-10-11 15:52:01', NULL, '1'),
(319, 34, 'HUAYLLATI', '2024-10-11 15:52:01', NULL, '1'),
(320, 34, 'MAMARA', '2024-10-11 15:52:01', NULL, '1'),
(321, 34, 'MICAELA BASTIDAS', '2024-10-11 15:52:01', NULL, '1'),
(322, 34, 'PATAYPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(323, 34, 'PROGRESO', '2024-10-11 15:52:01', NULL, '1'),
(324, 34, 'SAN ANTONIO', '2024-10-11 15:52:01', NULL, '1'),
(325, 34, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(326, 34, 'TURPAY', '2024-10-11 15:52:01', NULL, '1'),
(327, 34, 'VILCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(328, 34, 'VIRUNDO', '2024-10-11 15:52:01', NULL, '1'),
(329, 34, 'CURASCO', '2024-10-11 15:52:01', NULL, '1'),
(330, 35, 'AREQUIPA', '2024-10-11 15:52:01', NULL, '1'),
(331, 35, 'ALTO SELVA ALEGRE', '2024-10-11 15:52:01', NULL, '1'),
(332, 35, 'CAYMA', '2024-10-11 15:52:01', NULL, '1'),
(333, 35, 'CERRO COLORADO', '2024-10-11 15:52:01', NULL, '1'),
(334, 35, 'CHARACATO', '2024-10-11 15:52:01', NULL, '1'),
(335, 35, 'CHIGUATA', '2024-10-11 15:52:01', NULL, '1'),
(336, 35, 'JACOBO HUNTER', '2024-10-11 15:52:01', NULL, '1'),
(337, 35, 'LA JOYA', '2024-10-11 15:52:01', NULL, '1'),
(338, 35, 'MARIANO MELGAR', '2024-10-11 15:52:01', NULL, '1'),
(339, 35, 'MIRAFLORES', '2024-10-11 15:52:01', NULL, '1'),
(340, 35, 'MOLLEBAYA', '2024-10-11 15:52:01', NULL, '1'),
(341, 35, 'PAUCARPATA', '2024-10-11 15:52:01', NULL, '1'),
(342, 35, 'POCSI', '2024-10-11 15:52:01', NULL, '1'),
(343, 35, 'POLOBAYA', '2024-10-11 15:52:01', NULL, '1'),
(344, 35, 'QUEQUEÑA', '2024-10-11 15:52:01', NULL, '1'),
(345, 35, 'SABANDIA', '2024-10-11 15:52:01', NULL, '1'),
(346, 35, 'SACHACA', '2024-10-11 15:52:01', NULL, '1'),
(347, 35, 'SAN JUAN DE SIGUAS', '2024-10-11 15:52:01', NULL, '1'),
(348, 35, 'SAN JUAN DE TARUCANI', '2024-10-11 15:52:01', NULL, '1'),
(349, 35, 'SANTA ISABEL DE SIGUAS', '2024-10-11 15:52:01', NULL, '1'),
(350, 35, 'SANTA RITA DE SIGUAS', '2024-10-11 15:52:01', NULL, '1'),
(351, 35, 'SOCABAYA', '2024-10-11 15:52:01', NULL, '1'),
(352, 35, 'TIABAYA', '2024-10-11 15:52:01', NULL, '1'),
(353, 35, 'UCHUMAYO', '2024-10-11 15:52:01', NULL, '1'),
(354, 35, 'VITOR', '2024-10-11 15:52:01', NULL, '1'),
(355, 35, 'YANAHUARA', '2024-10-11 15:52:01', NULL, '1'),
(356, 35, 'YARABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(357, 35, 'YURA', '2024-10-11 15:52:01', NULL, '1'),
(358, 35, 'JOSE LUIS BUSTAMANTE Y RIVERO', '2024-10-11 15:52:01', NULL, '1'),
(359, 36, 'CAMANA', '2024-10-11 15:52:01', NULL, '1'),
(360, 36, 'JOSE MARIA QUIMPER', '2024-10-11 15:52:01', NULL, '1'),
(361, 36, 'MARIANO NICOLAS VALCARCEL', '2024-10-11 15:52:01', NULL, '1'),
(362, 36, 'MARISCAL CACERES', '2024-10-11 15:52:01', NULL, '1'),
(363, 36, 'NICOLAS DE PIEROLA', '2024-10-11 15:52:01', NULL, '1'),
(364, 36, 'OCOÑA', '2024-10-11 15:52:01', NULL, '1'),
(365, 36, 'QUILCA', '2024-10-11 15:52:01', NULL, '1'),
(366, 36, 'SAMUEL PASTOR', '2024-10-11 15:52:01', NULL, '1'),
(367, 37, 'CARAVELI', '2024-10-11 15:52:01', NULL, '1'),
(368, 37, 'ACARI', '2024-10-11 15:52:01', NULL, '1'),
(369, 37, 'ATICO', '2024-10-11 15:52:01', NULL, '1'),
(370, 37, 'ATIQUIPA', '2024-10-11 15:52:01', NULL, '1'),
(371, 37, 'BELLA UNION', '2024-10-11 15:52:01', NULL, '1'),
(372, 37, 'CAHUACHO', '2024-10-11 15:52:01', NULL, '1'),
(373, 37, 'CHALA', '2024-10-11 15:52:01', NULL, '1'),
(374, 37, 'CHAPARRA', '2024-10-11 15:52:01', NULL, '1'),
(375, 37, 'HUANUHUANU', '2024-10-11 15:52:01', NULL, '1'),
(376, 37, 'JAQUI', '2024-10-11 15:52:01', NULL, '1'),
(377, 37, 'LOMAS', '2024-10-11 15:52:01', NULL, '1'),
(378, 37, 'QUICACHA', '2024-10-11 15:52:01', NULL, '1'),
(379, 37, 'YAUCA', '2024-10-11 15:52:01', NULL, '1'),
(380, 38, 'APLAO', '2024-10-11 15:52:01', NULL, '1'),
(381, 38, 'ANDAGUA', '2024-10-11 15:52:01', NULL, '1'),
(382, 38, 'AYO', '2024-10-11 15:52:01', NULL, '1'),
(383, 38, 'CHACHAS', '2024-10-11 15:52:01', NULL, '1'),
(384, 38, 'CHILCAYMARCA', '2024-10-11 15:52:01', NULL, '1'),
(385, 38, 'CHOCO', '2024-10-11 15:52:01', NULL, '1'),
(386, 38, 'HUANCARQUI', '2024-10-11 15:52:01', NULL, '1'),
(387, 38, 'MACHAGUAY', '2024-10-11 15:52:01', NULL, '1'),
(388, 38, 'ORCOPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(389, 38, 'PAMPACOLCA', '2024-10-11 15:52:01', NULL, '1'),
(390, 38, 'TIPAN', '2024-10-11 15:52:01', NULL, '1'),
(391, 38, 'UNIÓN', '2024-10-11 15:52:01', NULL, '1'),
(392, 38, 'URACA', '2024-10-11 15:52:01', NULL, '1'),
(393, 38, 'VIRACO', '2024-10-11 15:52:01', NULL, '1'),
(394, 39, 'CHIVAY', '2024-10-11 15:52:01', NULL, '1'),
(395, 39, 'ACHOMA', '2024-10-11 15:52:01', NULL, '1'),
(396, 39, 'CABANACONDE', '2024-10-11 15:52:01', NULL, '1'),
(397, 39, 'CALLALLI', '2024-10-11 15:52:01', NULL, '1'),
(398, 39, 'CAYLLOMA', '2024-10-11 15:52:01', NULL, '1'),
(399, 39, 'COPORAQUE', '2024-10-11 15:52:01', NULL, '1'),
(400, 39, 'HUAMBO', '2024-10-11 15:52:01', NULL, '1'),
(401, 39, 'HUANCA', '2024-10-11 15:52:01', NULL, '1'),
(402, 39, 'ICHUPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(403, 39, 'LARI', '2024-10-11 15:52:01', NULL, '1'),
(404, 39, 'LLUTA', '2024-10-11 15:52:01', NULL, '1'),
(405, 39, 'MACA', '2024-10-11 15:52:01', NULL, '1'),
(406, 39, 'MADRIGAL', '2024-10-11 15:52:01', NULL, '1'),
(407, 39, 'SAN ANTONIO DE CHUCA', '2024-10-11 15:52:01', NULL, '1'),
(408, 39, 'SIBAYO', '2024-10-11 15:52:01', NULL, '1'),
(409, 39, 'TAPAY', '2024-10-11 15:52:01', NULL, '1'),
(410, 39, 'TISCO', '2024-10-11 15:52:01', NULL, '1'),
(411, 39, 'TUTI', '2024-10-11 15:52:01', NULL, '1'),
(412, 39, 'YANQUE', '2024-10-11 15:52:01', NULL, '1'),
(413, 39, 'MAJES', '2024-10-11 15:52:01', NULL, '1'),
(414, 40, 'CHUQUIBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(415, 40, 'ANDARAY', '2024-10-11 15:52:01', NULL, '1'),
(416, 40, 'CAYARANI', '2024-10-11 15:52:01', NULL, '1'),
(417, 40, 'CHICHAS', '2024-10-11 15:52:01', NULL, '1'),
(418, 40, 'IRAY', '2024-10-11 15:52:01', NULL, '1'),
(419, 40, 'RIO GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(420, 40, 'SALAMANCA', '2024-10-11 15:52:01', NULL, '1'),
(421, 40, 'YANAQUIHUA', '2024-10-11 15:52:01', NULL, '1'),
(422, 41, 'MOLLENDO', '2024-10-11 15:52:01', NULL, '1'),
(423, 41, 'COCACHACRA', '2024-10-11 15:52:01', NULL, '1'),
(424, 41, 'DEAN VALDIVIA', '2024-10-11 15:52:01', NULL, '1'),
(425, 41, 'ISLAY', '2024-10-11 15:52:01', NULL, '1'),
(426, 41, 'MEJIA', '2024-10-11 15:52:01', NULL, '1'),
(427, 41, 'PUNTA DE BOMBON', '2024-10-11 15:52:01', NULL, '1'),
(428, 42, 'COTAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(429, 42, 'ALCA', '2024-10-11 15:52:01', NULL, '1'),
(430, 42, 'CHARCANA', '2024-10-11 15:52:01', NULL, '1'),
(431, 42, 'HUAYNACOTAS', '2024-10-11 15:52:01', NULL, '1'),
(432, 42, 'PAMPAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(433, 42, 'PUYCA', '2024-10-11 15:52:01', NULL, '1'),
(434, 42, 'QUECHUALLA', '2024-10-11 15:52:01', NULL, '1'),
(435, 42, 'SAYLA', '2024-10-11 15:52:01', NULL, '1'),
(436, 42, 'TAURIA', '2024-10-11 15:52:01', NULL, '1'),
(437, 42, 'TOMEPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(438, 42, 'TORO', '2024-10-11 15:52:01', NULL, '1'),
(439, 43, 'AYACUCHO', '2024-10-11 15:52:01', NULL, '1'),
(440, 43, 'ACOCRO', '2024-10-11 15:52:01', NULL, '1'),
(441, 43, 'ACOS VINCHOS', '2024-10-11 15:52:01', NULL, '1'),
(442, 43, 'CARMEN ALTO', '2024-10-11 15:52:01', NULL, '1'),
(443, 43, 'CHIARA', '2024-10-11 15:52:01', NULL, '1'),
(444, 43, 'OCROS', '2024-10-11 15:52:01', NULL, '1'),
(445, 43, 'PACAYCASA', '2024-10-11 15:52:01', NULL, '1'),
(446, 43, 'QUINUA', '2024-10-11 15:52:01', NULL, '1'),
(447, 43, 'SAN JOSE DE TICLLAS', '2024-10-11 15:52:01', NULL, '1'),
(448, 43, 'SAN JUAN BAUTISTA', '2024-10-11 15:52:01', NULL, '1'),
(449, 43, 'SANTIAGO DE PISCHA', '2024-10-11 15:52:01', NULL, '1'),
(450, 43, 'SOCOS', '2024-10-11 15:52:01', NULL, '1'),
(451, 43, 'TAMBILLO', '2024-10-11 15:52:01', NULL, '1'),
(452, 43, 'VINCHOS', '2024-10-11 15:52:01', NULL, '1'),
(453, 43, 'JESUS NAZARENO', '2024-10-11 15:52:01', NULL, '1'),
(454, 44, 'CANGALLO', '2024-10-11 15:52:01', NULL, '1'),
(455, 44, 'CHUSCHI', '2024-10-11 15:52:01', NULL, '1'),
(456, 44, 'LOS MOROCHUCOS', '2024-10-11 15:52:01', NULL, '1'),
(457, 44, 'MARIA PARADO DE BELLIDO', '2024-10-11 15:52:01', NULL, '1'),
(458, 44, 'PARAS', '2024-10-11 15:52:01', NULL, '1'),
(459, 44, 'TOTOS', '2024-10-11 15:52:01', NULL, '1'),
(460, 45, 'SANCOS', '2024-10-11 15:52:01', NULL, '1'),
(461, 45, 'CARAPO', '2024-10-11 15:52:01', NULL, '1'),
(462, 45, 'SACSAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(463, 45, 'SANTIAGO DE LUCANAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(464, 46, 'HUANTA', '2024-10-11 15:52:01', NULL, '1'),
(465, 46, 'AYAHUANCO', '2024-10-11 15:52:01', NULL, '1'),
(466, 46, 'HUAMANGUILLA', '2024-10-11 15:52:01', NULL, '1'),
(467, 46, 'IGUAIN', '2024-10-11 15:52:01', NULL, '1'),
(468, 46, 'LURICOCHA', '2024-10-11 15:52:01', NULL, '1'),
(469, 46, 'SANTILLANA', '2024-10-11 15:52:01', NULL, '1'),
(470, 46, 'SIVIA', '2024-10-11 15:52:01', NULL, '1'),
(471, 46, 'LLOCHEGUA', '2024-10-11 15:52:01', NULL, '1'),
(472, 47, 'SAN MIGUEL', '2024-10-11 15:52:01', NULL, '1'),
(473, 47, 'ANCO', '2024-10-11 15:52:01', NULL, '1'),
(474, 47, 'AYNA', '2024-10-11 15:52:01', NULL, '1'),
(475, 47, 'CHILCAS', '2024-10-11 15:52:01', NULL, '1'),
(476, 47, 'CHUNGUI', '2024-10-11 15:52:01', NULL, '1'),
(477, 47, 'LUIS CARRANZA', '2024-10-11 15:52:01', NULL, '1'),
(478, 47, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(479, 47, 'TAMBO', '2024-10-11 15:52:01', NULL, '1'),
(480, 48, 'PUQUIO', '2024-10-11 15:52:01', NULL, '1'),
(481, 48, 'AUCARA', '2024-10-11 15:52:01', NULL, '1'),
(482, 48, 'CABANA', '2024-10-11 15:52:01', NULL, '1'),
(483, 48, 'CARMEN SALCEDO', '2024-10-11 15:52:01', NULL, '1'),
(484, 48, 'CHAVIÑA', '2024-10-11 15:52:01', NULL, '1'),
(485, 48, 'CHIPAO', '2024-10-11 15:52:01', NULL, '1'),
(486, 48, 'HUAC-HUAS', '2024-10-11 15:52:01', NULL, '1'),
(487, 48, 'LARAMATE', '2024-10-11 15:52:01', NULL, '1'),
(488, 48, 'LEONCIO PRADO', '2024-10-11 15:52:01', NULL, '1'),
(489, 48, 'LLAUTA', '2024-10-11 15:52:01', NULL, '1'),
(490, 48, 'LUCANAS', '2024-10-11 15:52:01', NULL, '1'),
(491, 48, 'OCAÑA', '2024-10-11 15:52:01', NULL, '1'),
(492, 48, 'OTOCA', '2024-10-11 15:52:01', NULL, '1'),
(493, 48, 'SAISA', '2024-10-11 15:52:01', NULL, '1'),
(494, 48, 'SAN CRISTOBAL', '2024-10-11 15:52:01', NULL, '1'),
(495, 48, 'SAN JUAN', '2024-10-11 15:52:01', NULL, '1'),
(496, 48, 'SAN PEDRO', '2024-10-11 15:52:01', NULL, '1'),
(497, 48, 'SAN PEDRO DE PALCO', '2024-10-11 15:52:01', NULL, '1'),
(498, 48, 'SANCOS', '2024-10-11 15:52:01', NULL, '1'),
(499, 48, 'SANTA ANA DE HUAYCAHUACHO', '2024-10-11 15:52:01', NULL, '1'),
(500, 48, 'SANTA LUCIA', '2024-10-11 15:52:01', NULL, '1'),
(501, 49, 'CORACORA', '2024-10-11 15:52:01', NULL, '1'),
(502, 49, 'CHUMPI', '2024-10-11 15:52:01', NULL, '1'),
(503, 49, 'CORONEL CASTAÑEDA', '2024-10-11 15:52:01', NULL, '1'),
(504, 49, 'PACAPAUSA', '2024-10-11 15:52:01', NULL, '1'),
(505, 49, 'PULLO', '2024-10-11 15:52:01', NULL, '1'),
(506, 49, 'PUYUSCA', '2024-10-11 15:52:01', NULL, '1'),
(507, 49, 'SAN FRANCISCO DE RAVACAYCO', '2024-10-11 15:52:01', NULL, '1'),
(508, 49, 'UPAHUACHO', '2024-10-11 15:52:01', NULL, '1'),
(509, 50, 'PAUSA', '2024-10-11 15:52:01', NULL, '1'),
(510, 50, 'COLTA', '2024-10-11 15:52:01', NULL, '1'),
(511, 50, 'CORCULLA', '2024-10-11 15:52:01', NULL, '1'),
(512, 50, 'LAMPA', '2024-10-11 15:52:01', NULL, '1'),
(513, 50, 'MARCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(514, 50, 'OYOLO', '2024-10-11 15:52:01', NULL, '1'),
(515, 50, 'PARARCA', '2024-10-11 15:52:01', NULL, '1'),
(516, 50, 'SAN JAVIER DE ALPABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(517, 50, 'SAN JOSE DE USHUA', '2024-10-11 15:52:01', NULL, '1'),
(518, 50, 'SARA SARA', '2024-10-11 15:52:01', NULL, '1'),
(519, 51, 'QUEROBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(520, 51, 'BELEN', '2024-10-11 15:52:01', NULL, '1'),
(521, 51, 'CHALCOS', '2024-10-11 15:52:01', NULL, '1'),
(522, 51, 'CHILCAYOC', '2024-10-11 15:52:01', NULL, '1'),
(523, 51, 'HUACAÑA', '2024-10-11 15:52:01', NULL, '1'),
(524, 51, 'MORCOLLA', '2024-10-11 15:52:01', NULL, '1'),
(525, 51, 'PAICO', '2024-10-11 15:52:01', NULL, '1'),
(526, 51, 'SAN PEDRO DE LARCAY', '2024-10-11 15:52:01', NULL, '1'),
(527, 51, 'SAN SALVADOR DE QUIJE', '2024-10-11 15:52:01', NULL, '1'),
(528, 51, 'SANTIAGO DE PAUCARAY', '2024-10-11 15:52:01', NULL, '1'),
(529, 51, 'SORAS', '2024-10-11 15:52:01', NULL, '1'),
(530, 52, 'HUANCAPI', '2024-10-11 15:52:01', NULL, '1'),
(531, 52, 'ALCAMENCA', '2024-10-11 15:52:01', NULL, '1'),
(532, 52, 'APONGO', '2024-10-11 15:52:01', NULL, '1'),
(533, 52, 'ASQUIPATA', '2024-10-11 15:52:01', NULL, '1'),
(534, 52, 'CANARIA', '2024-10-11 15:52:01', NULL, '1'),
(535, 52, 'CAYARA', '2024-10-11 15:52:01', NULL, '1'),
(536, 52, 'COLCA', '2024-10-11 15:52:01', NULL, '1'),
(537, 52, 'HUAMANQUIQUIA', '2024-10-11 15:52:01', NULL, '1'),
(538, 52, 'HUANCARAYLLA', '2024-10-11 15:52:01', NULL, '1'),
(539, 52, 'HUAYA', '2024-10-11 15:52:01', NULL, '1'),
(540, 52, 'SARHUA', '2024-10-11 15:52:01', NULL, '1'),
(541, 52, 'VILCANCHOS', '2024-10-11 15:52:01', NULL, '1'),
(542, 53, 'VILCAS HUAMAN', '2024-10-11 15:52:01', NULL, '1'),
(543, 53, 'ACCOMARCA', '2024-10-11 15:52:01', NULL, '1'),
(544, 53, 'CARHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(545, 53, 'CONCEPCION', '2024-10-11 15:52:01', NULL, '1'),
(546, 53, 'HUAMBALPA', '2024-10-11 15:52:01', NULL, '1'),
(547, 53, 'INDEPENDENCIA', '2024-10-11 15:52:01', NULL, '1'),
(548, 53, 'SAURAMA', '2024-10-11 15:52:01', NULL, '1'),
(549, 53, 'VISCHONGO', '2024-10-11 15:52:01', NULL, '1'),
(550, 54, 'CAJAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(551, 54, 'CAJAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(552, 54, 'ASUNCION', '2024-10-11 15:52:01', NULL, '1'),
(553, 54, 'CHETILLA', '2024-10-11 15:52:01', NULL, '1'),
(554, 54, 'COSPAN', '2024-10-11 15:52:01', NULL, '1'),
(555, 54, 'ENCAÑADA', '2024-10-11 15:52:01', NULL, '1'),
(556, 54, 'JESUS', '2024-10-11 15:52:01', NULL, '1'),
(557, 54, 'LLACANORA', '2024-10-11 15:52:01', NULL, '1'),
(558, 54, 'LOS BAÑOS DEL INCA', '2024-10-11 15:52:01', NULL, '1'),
(559, 54, 'MAGDALENA', '2024-10-11 15:52:01', NULL, '1'),
(560, 54, 'MATARA', '2024-10-11 15:52:01', NULL, '1'),
(561, 54, 'NAMORA', '2024-10-11 15:52:01', NULL, '1'),
(562, 54, 'SAN JUAN', '2024-10-11 15:52:01', NULL, '1'),
(563, 55, 'CAJABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(564, 55, 'CACHACHI', '2024-10-11 15:52:01', NULL, '1'),
(565, 55, 'CONDEBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(566, 55, 'SITACOCHA', '2024-10-11 15:52:01', NULL, '1'),
(567, 56, 'CELENDIN', '2024-10-11 15:52:01', NULL, '1'),
(568, 56, 'CHUMUCH', '2024-10-11 15:52:01', NULL, '1'),
(569, 56, 'CORTEGANA', '2024-10-11 15:52:01', NULL, '1'),
(570, 56, 'HUASMIN', '2024-10-11 15:52:01', NULL, '1'),
(571, 56, 'JORGE CHAVEZ', '2024-10-11 15:52:01', NULL, '1'),
(572, 56, 'JOSE GALVEZ', '2024-10-11 15:52:01', NULL, '1'),
(573, 56, 'MIGUEL IGLESIAS', '2024-10-11 15:52:01', NULL, '1'),
(574, 56, 'OXAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(575, 56, 'SOROCHUCO', '2024-10-11 15:52:01', NULL, '1'),
(576, 56, 'SUCRE', '2024-10-11 15:52:01', NULL, '1'),
(577, 56, 'UTCO', '2024-10-11 15:52:01', NULL, '1'),
(578, 56, 'LA LIBERTAD DE PALLAN', '2024-10-11 15:52:01', NULL, '1'),
(579, 57, 'CHOTA', '2024-10-11 15:52:01', NULL, '1'),
(580, 57, 'ANGUIA', '2024-10-11 15:52:01', NULL, '1'),
(581, 57, 'CHADIN', '2024-10-11 15:52:01', NULL, '1'),
(582, 57, 'CHIGUIRIP', '2024-10-11 15:52:01', NULL, '1'),
(583, 57, 'CHIMBAN', '2024-10-11 15:52:01', NULL, '1'),
(584, 57, 'CHOROPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(585, 57, 'COCHABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(586, 57, 'CONCHAN', '2024-10-11 15:52:01', NULL, '1'),
(587, 57, 'HUAMBOS', '2024-10-11 15:52:01', NULL, '1'),
(588, 57, 'LAJAS', '2024-10-11 15:52:01', NULL, '1'),
(589, 57, 'LLAMA', '2024-10-11 15:52:01', NULL, '1'),
(590, 57, 'MIRACOSTA', '2024-10-11 15:52:01', NULL, '1'),
(591, 57, 'PACCHA', '2024-10-11 15:52:01', NULL, '1'),
(592, 57, 'PION', '2024-10-11 15:52:01', NULL, '1'),
(593, 57, 'QUEROCOTO', '2024-10-11 15:52:01', NULL, '1'),
(594, 57, 'SAN JUAN DE LICUPIS', '2024-10-11 15:52:01', NULL, '1'),
(595, 57, 'TACABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(596, 57, 'TOCMOCHE', '2024-10-11 15:52:01', NULL, '1'),
(597, 57, 'CHALAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(598, 58, 'CONTUMAZA', '2024-10-11 15:52:01', NULL, '1'),
(599, 58, 'CHILETE', '2024-10-11 15:52:01', NULL, '1'),
(600, 58, 'CUPISNIQUE', '2024-10-11 15:52:01', NULL, '1'),
(601, 58, 'GUZMANGO', '2024-10-11 15:52:01', NULL, '1'),
(602, 58, 'SAN BENITO', '2024-10-11 15:52:01', NULL, '1'),
(603, 58, 'SANTA CRUZ DE TOLED', '2024-10-11 15:52:01', NULL, '1'),
(604, 58, 'TANTARICA', '2024-10-11 15:52:01', NULL, '1'),
(605, 58, 'YONAN', '2024-10-11 15:52:01', NULL, '1'),
(606, 59, 'CUTERVO', '2024-10-11 15:52:01', NULL, '1'),
(607, 59, 'CALLAYUC', '2024-10-11 15:52:01', NULL, '1'),
(608, 59, 'CHOROS', '2024-10-11 15:52:01', NULL, '1'),
(609, 59, 'CUJILLO', '2024-10-11 15:52:01', NULL, '1'),
(610, 59, 'LA RAMADA', '2024-10-11 15:52:01', NULL, '1'),
(611, 59, 'PIMPINGOS', '2024-10-11 15:52:01', NULL, '1'),
(612, 59, 'QUEROCOTILLO', '2024-10-11 15:52:01', NULL, '1'),
(613, 59, 'SAN ANDRES DE CUTERVO', '2024-10-11 15:52:01', NULL, '1'),
(614, 59, 'SAN JUAN DE CUTERVO', '2024-10-11 15:52:01', NULL, '1'),
(615, 59, 'SAN LUIS DE LUCMA', '2024-10-11 15:52:01', NULL, '1'),
(616, 59, 'SANTA CRUZ', '2024-10-11 15:52:01', NULL, '1'),
(617, 59, 'SANTO DOMINGO DE LA CAPILLA', '2024-10-11 15:52:01', NULL, '1'),
(618, 59, 'SANTO TOMAS', '2024-10-11 15:52:01', NULL, '1'),
(619, 59, 'SOCOTA', '2024-10-11 15:52:01', NULL, '1'),
(620, 59, 'TORIBIO CASANOVA', '2024-10-11 15:52:01', NULL, '1'),
(621, 60, 'BAMBAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(622, 60, 'CHUGUR', '2024-10-11 15:52:01', NULL, '1'),
(623, 60, 'HUALGAYOC', '2024-10-11 15:52:01', NULL, '1'),
(624, 61, 'JAEN', '2024-10-11 15:52:01', NULL, '1'),
(625, 61, 'BELLAVISTA', '2024-10-11 15:52:01', NULL, '1'),
(626, 61, 'CHONTALI', '2024-10-11 15:52:01', NULL, '1'),
(627, 61, 'COLASAY', '2024-10-11 15:52:01', NULL, '1'),
(628, 61, 'HUABAL', '2024-10-11 15:52:01', NULL, '1'),
(629, 61, 'LAS PIRIAS', '2024-10-11 15:52:01', NULL, '1'),
(630, 61, 'POMAHUACA', '2024-10-11 15:52:01', NULL, '1'),
(631, 61, 'PUCARA', '2024-10-11 15:52:01', NULL, '1'),
(632, 61, 'SALLIQUE', '2024-10-11 15:52:01', NULL, '1'),
(633, 61, 'SAN FELIPE', '2024-10-11 15:52:01', NULL, '1'),
(634, 61, 'SAN JOSE DEL ALTO', '2024-10-11 15:52:01', NULL, '1'),
(635, 61, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(636, 62, 'SAN IGNACIO', '2024-10-11 15:52:01', NULL, '1'),
(637, 62, 'CHIRINOS', '2024-10-11 15:52:01', NULL, '1'),
(638, 62, 'HUARANGO', '2024-10-11 15:52:01', NULL, '1'),
(639, 62, 'LA COIPA', '2024-10-11 15:52:01', NULL, '1'),
(640, 62, 'NAMBALLE', '2024-10-11 15:52:01', NULL, '1'),
(641, 62, 'SAN JOSE DE LOURDES', '2024-10-11 15:52:01', NULL, '1'),
(642, 62, 'TABACONAS', '2024-10-11 15:52:01', NULL, '1'),
(643, 63, 'PEDRO GALVEZ', '2024-10-11 15:52:01', NULL, '1'),
(644, 63, 'CHANCAY', '2024-10-11 15:52:01', NULL, '1'),
(645, 63, 'EDUARDO VILLANUEVA', '2024-10-11 15:52:01', NULL, '1'),
(646, 63, 'GREGORIO PITA', '2024-10-11 15:52:01', NULL, '1'),
(647, 63, 'ICHOCAN', '2024-10-11 15:52:01', NULL, '1'),
(648, 63, 'JOSE MANUEL QUIROZ', '2024-10-11 15:52:01', NULL, '1'),
(649, 63, 'JOSE SABOGAL', '2024-10-11 15:52:01', NULL, '1'),
(650, 64, 'SAN MIGUEL', '2024-10-11 15:52:01', NULL, '1'),
(651, 64, 'SAN MIGUEL', '2024-10-11 15:52:01', NULL, '1'),
(652, 64, 'BOLIVAR', '2024-10-11 15:52:01', NULL, '1'),
(653, 64, 'CALQUIS', '2024-10-11 15:52:01', NULL, '1'),
(654, 64, 'CATILLUC', '2024-10-11 15:52:01', NULL, '1'),
(655, 64, 'EL PRADO', '2024-10-11 15:52:01', NULL, '1'),
(656, 64, 'LA FLORIDA', '2024-10-11 15:52:01', NULL, '1'),
(657, 64, 'LLAPA', '2024-10-11 15:52:01', NULL, '1'),
(658, 64, 'NANCHOC', '2024-10-11 15:52:01', NULL, '1'),
(659, 64, 'NIEPOS', '2024-10-11 15:52:01', NULL, '1'),
(660, 64, 'SAN GREGORIO', '2024-10-11 15:52:01', NULL, '1'),
(661, 64, 'SAN SILVESTRE DE COCHAN', '2024-10-11 15:52:01', NULL, '1'),
(662, 64, 'TONGOD', '2024-10-11 15:52:01', NULL, '1'),
(663, 64, 'UNION AGUA BLANCA', '2024-10-11 15:52:01', NULL, '1'),
(664, 65, 'SAN PABLO', '2024-10-11 15:52:01', NULL, '1'),
(665, 65, 'SAN BERNARDINO', '2024-10-11 15:52:01', NULL, '1'),
(666, 65, 'SAN LUIS', '2024-10-11 15:52:01', NULL, '1'),
(667, 65, 'TUMBADEN', '2024-10-11 15:52:01', NULL, '1'),
(668, 66, 'SANTA CRUZ', '2024-10-11 15:52:01', NULL, '1'),
(669, 66, 'ANDABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(670, 66, 'CATACHE', '2024-10-11 15:52:01', NULL, '1'),
(671, 66, 'CHANCAYBAÑOS', '2024-10-11 15:52:01', NULL, '1'),
(672, 66, 'LA ESPERANZA', '2024-10-11 15:52:01', NULL, '1'),
(673, 66, 'NINABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(674, 66, 'PULAN', '2024-10-11 15:52:01', NULL, '1'),
(675, 66, 'SAUCEPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(676, 66, 'SEXI', '2024-10-11 15:52:01', NULL, '1'),
(677, 66, 'UTICYACU', '2024-10-11 15:52:01', NULL, '1'),
(678, 66, 'YAUYUCAN', '2024-10-11 15:52:01', NULL, '1'),
(679, 67, 'CALLAO', '2024-10-11 15:52:01', NULL, '1'),
(680, 67, 'BELLAVISTA', '2024-10-11 15:52:01', NULL, '1'),
(681, 67, 'CARMEN DE LA LEGUA REYNOSO', '2024-10-11 15:52:01', NULL, '1'),
(682, 67, 'LA PERLA', '2024-10-11 15:52:01', NULL, '1'),
(683, 67, 'LA PUNTA', '2024-10-11 15:52:01', NULL, '1'),
(684, 67, 'VENTANILLA', '2024-10-11 15:52:01', NULL, '1'),
(685, 67, 'CUSCO', '2024-10-11 15:52:01', NULL, '1'),
(686, 67, 'CCORCA', '2024-10-11 15:52:01', NULL, '1'),
(687, 67, 'POROY', '2024-10-11 15:52:01', NULL, '1'),
(688, 67, 'SAN JERONIMO', '2024-10-11 15:52:01', NULL, '1'),
(689, 67, 'SAN SEBASTIAN', '2024-10-11 15:52:01', NULL, '1'),
(690, 67, 'SANTIAGO', '2024-10-11 15:52:01', NULL, '1'),
(691, 67, 'SAYLLA', '2024-10-11 15:52:01', NULL, '1'),
(692, 67, 'WANCHAQ', '2024-10-11 15:52:01', NULL, '1'),
(693, 68, 'ACOMAYO', '2024-10-11 15:52:01', NULL, '1'),
(694, 68, 'ACOPIA', '2024-10-11 15:52:01', NULL, '1'),
(695, 68, 'ACOS', '2024-10-11 15:52:01', NULL, '1'),
(696, 68, 'MOSOC LLACTA', '2024-10-11 15:52:01', NULL, '1'),
(697, 68, 'POMACANCHI', '2024-10-11 15:52:01', NULL, '1'),
(698, 68, 'RONDOCAN', '2024-10-11 15:52:01', NULL, '1'),
(699, 68, 'SANGARARA', '2024-10-11 15:52:01', NULL, '1'),
(700, 69, 'ANTA', '2024-10-11 15:52:01', NULL, '1'),
(701, 69, 'ANCAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(702, 69, 'CACHIMAYO', '2024-10-11 15:52:01', NULL, '1'),
(703, 69, 'CHINCHAYPUJIO', '2024-10-11 15:52:01', NULL, '1'),
(704, 69, 'HUAROCONDO', '2024-10-11 15:52:01', NULL, '1'),
(705, 69, 'LIMATAMBO', '2024-10-11 15:52:01', NULL, '1'),
(706, 69, 'MOLLEPATA', '2024-10-11 15:52:01', NULL, '1'),
(707, 69, 'PUCYURA', '2024-10-11 15:52:01', NULL, '1'),
(708, 69, 'ZURITE', '2024-10-11 15:52:01', NULL, '1'),
(709, 70, 'CALCA', '2024-10-11 15:52:01', NULL, '1'),
(710, 70, 'COYA', '2024-10-11 15:52:01', NULL, '1'),
(711, 70, 'LAMAY', '2024-10-11 15:52:01', NULL, '1'),
(712, 70, 'LARES', '2024-10-11 15:52:01', NULL, '1'),
(713, 70, 'PISAC', '2024-10-11 15:52:01', NULL, '1'),
(714, 70, 'SAN SALVADOR', '2024-10-11 15:52:01', NULL, '1'),
(715, 70, 'TARAY', '2024-10-11 15:52:01', NULL, '1'),
(716, 70, 'YANATILE', '2024-10-11 15:52:01', NULL, '1'),
(717, 71, 'YANAOCA', '2024-10-11 15:52:01', NULL, '1'),
(718, 71, 'CHECCA', '2024-10-11 15:52:01', NULL, '1'),
(719, 71, 'KUNTURKANKI', '2024-10-11 15:52:01', NULL, '1'),
(720, 71, 'LANGUI', '2024-10-11 15:52:01', NULL, '1'),
(721, 71, 'LAYO', '2024-10-11 15:52:01', NULL, '1'),
(722, 71, 'PAMPAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(723, 71, 'QUEHUE', '2024-10-11 15:52:01', NULL, '1'),
(724, 71, 'TUPAC AMARU', '2024-10-11 15:52:01', NULL, '1'),
(725, 72, 'SICUANI', '2024-10-11 15:52:01', NULL, '1'),
(726, 72, 'CHECACUPE', '2024-10-11 15:52:01', NULL, '1'),
(727, 72, 'COMBAPATA', '2024-10-11 15:52:01', NULL, '1'),
(728, 72, 'MARANGANI', '2024-10-11 15:52:01', NULL, '1'),
(729, 72, 'PITUMARCA', '2024-10-11 15:52:01', NULL, '1'),
(730, 72, 'SAN PABLO', '2024-10-11 15:52:01', NULL, '1'),
(731, 72, 'SAN PEDRO', '2024-10-11 15:52:01', NULL, '1'),
(732, 72, 'TINTA', '2024-10-11 15:52:01', NULL, '1'),
(733, 73, 'SANTO TOMAS', '2024-10-11 15:52:01', NULL, '1'),
(734, 73, 'CAPACMARCA', '2024-10-11 15:52:01', NULL, '1'),
(735, 73, 'CHAMACA', '2024-10-11 15:52:01', NULL, '1'),
(736, 73, 'COLQUEMARCA', '2024-10-11 15:52:01', NULL, '1'),
(737, 73, 'LIVITACA', '2024-10-11 15:52:01', NULL, '1'),
(738, 73, 'LLUSCO', '2024-10-11 15:52:01', NULL, '1'),
(739, 73, 'QUIÑOTA', '2024-10-11 15:52:01', NULL, '1'),
(740, 73, 'VELILLE', '2024-10-11 15:52:01', NULL, '1'),
(741, 74, 'ESPINAR', '2024-10-11 15:52:01', NULL, '1'),
(742, 74, 'CONDOROMA', '2024-10-11 15:52:01', NULL, '1'),
(743, 74, 'COPORAQUE', '2024-10-11 15:52:01', NULL, '1'),
(744, 74, 'OCORURO', '2024-10-11 15:52:01', NULL, '1'),
(745, 74, 'PALLPATA', '2024-10-11 15:52:01', NULL, '1'),
(746, 74, 'PICHIGUA', '2024-10-11 15:52:01', NULL, '1'),
(747, 74, 'SUYCKUTAMBO', '2024-10-11 15:52:01', NULL, '1'),
(748, 74, 'ALTO PICHIGUA', '2024-10-11 15:52:01', NULL, '1'),
(749, 75, 'SANTA ANA', '2024-10-11 15:52:01', NULL, '1'),
(750, 75, 'ECHARATE', '2024-10-11 15:52:01', NULL, '1'),
(751, 75, 'HUAYOPATA', '2024-10-11 15:52:01', NULL, '1'),
(752, 75, 'MARANURA', '2024-10-11 15:52:01', NULL, '1'),
(753, 75, 'OCOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(754, 75, 'QUELLOUNO', '2024-10-11 15:52:01', NULL, '1'),
(755, 75, 'KIMBIRI', '2024-10-11 15:52:01', NULL, '1'),
(756, 75, 'SANTA TERESA', '2024-10-11 15:52:01', NULL, '1'),
(757, 75, 'VILCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(758, 75, 'PICHARI', '2024-10-11 15:52:01', NULL, '1'),
(759, 76, 'PARURO', '2024-10-11 15:52:01', NULL, '1'),
(760, 76, 'ACCHA', '2024-10-11 15:52:01', NULL, '1'),
(761, 76, 'CCAPI', '2024-10-11 15:52:01', NULL, '1'),
(762, 76, 'COLCHA', '2024-10-11 15:52:01', NULL, '1'),
(763, 76, 'HUANOQUITE', '2024-10-11 15:52:01', NULL, '1'),
(764, 76, 'OMACHA', '2024-10-11 15:52:01', NULL, '1'),
(765, 76, 'PACCARITAMBO', '2024-10-11 15:52:01', NULL, '1'),
(766, 76, 'PILLPINTO', '2024-10-11 15:52:01', NULL, '1'),
(767, 76, 'YAURISQUE', '2024-10-11 15:52:01', NULL, '1'),
(768, 77, 'PAUCARTAMBO', '2024-10-11 15:52:01', NULL, '1'),
(769, 77, 'CAICAY', '2024-10-11 15:52:01', NULL, '1'),
(770, 77, 'CHALLABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(771, 77, 'COLQUEPATA', '2024-10-11 15:52:01', NULL, '1'),
(772, 77, 'HUANCARANI', '2024-10-11 15:52:01', NULL, '1'),
(773, 77, 'KOSÑIPATA', '2024-10-11 15:52:01', NULL, '1'),
(774, 78, 'URCOS', '2024-10-11 15:52:01', NULL, '1'),
(775, 78, 'ANDAHUAYLILLAS', '2024-10-11 15:52:01', NULL, '1'),
(776, 78, 'CAMANTI', '2024-10-11 15:52:01', NULL, '1'),
(777, 78, 'CCARHUAYO', '2024-10-11 15:52:01', NULL, '1'),
(778, 78, 'CCATCA', '2024-10-11 15:52:01', NULL, '1'),
(779, 78, 'CUSIPATA', '2024-10-11 15:52:01', NULL, '1'),
(780, 78, 'HUARO', '2024-10-11 15:52:01', NULL, '1'),
(781, 78, 'LUCRE', '2024-10-11 15:52:01', NULL, '1'),
(782, 78, 'MARCAPATA', '2024-10-11 15:52:01', NULL, '1'),
(783, 78, 'OCONGATE', '2024-10-11 15:52:01', NULL, '1'),
(784, 78, 'OROPESA', '2024-10-11 15:52:01', NULL, '1'),
(785, 78, 'QUIQUIJANA', '2024-10-11 15:52:01', NULL, '1'),
(786, 79, 'URUBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(787, 79, 'CHINCHERO', '2024-10-11 15:52:01', NULL, '1'),
(788, 79, 'HUAYLLABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(789, 79, 'MACHUPICCHU', '2024-10-11 15:52:01', NULL, '1'),
(790, 79, 'MARAS', '2024-10-11 15:52:01', NULL, '1'),
(791, 79, 'OLLANTAYTAMBO', '2024-10-11 15:52:01', NULL, '1'),
(792, 79, 'YUCAY', '2024-10-11 15:52:01', NULL, '1'),
(793, 80, 'HUANCAVELICA', '2024-10-11 15:52:01', NULL, '1'),
(794, 80, 'ACOBAMBILLA', '2024-10-11 15:52:01', NULL, '1'),
(795, 80, 'ACORIA', '2024-10-11 15:52:01', NULL, '1'),
(796, 80, 'CONAYCA', '2024-10-11 15:52:01', NULL, '1'),
(797, 80, 'CUENCA', '2024-10-11 15:52:01', NULL, '1'),
(798, 80, 'HUACHOCOLPA', '2024-10-11 15:52:01', NULL, '1'),
(799, 80, 'HUAYLLAHUARA', '2024-10-11 15:52:01', NULL, '1'),
(800, 80, 'IZCUCHACA', '2024-10-11 15:52:01', NULL, '1'),
(801, 80, 'LARIA', '2024-10-11 15:52:01', NULL, '1'),
(802, 80, 'MANTA', '2024-10-11 15:52:01', NULL, '1'),
(803, 80, 'MARISCAL CACERES', '2024-10-11 15:52:01', NULL, '1'),
(804, 80, 'MOYA', '2024-10-11 15:52:01', NULL, '1'),
(805, 80, 'NUEVO OCCORO', '2024-10-11 15:52:01', NULL, '1'),
(806, 80, 'PALCA', '2024-10-11 15:52:01', NULL, '1'),
(807, 80, 'PILCHACA', '2024-10-11 15:52:01', NULL, '1'),
(808, 80, 'VILCA', '2024-10-11 15:52:01', NULL, '1'),
(809, 80, 'YAULI', '2024-10-11 15:52:01', NULL, '1'),
(810, 80, 'ASCENSION', '2024-10-11 15:52:01', NULL, '1'),
(811, 80, 'HUANDO', '2024-10-11 15:52:01', NULL, '1'),
(812, 81, 'ACOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(813, 81, 'ANDABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(814, 81, 'ANTA', '2024-10-11 15:52:01', NULL, '1'),
(815, 81, 'CAJA', '2024-10-11 15:52:01', NULL, '1'),
(816, 81, 'MARCAS', '2024-10-11 15:52:01', NULL, '1'),
(817, 81, 'PAUCARA', '2024-10-11 15:52:01', NULL, '1'),
(818, 81, 'POMACOCHA', '2024-10-11 15:52:01', NULL, '1'),
(819, 81, 'ROSARIO', '2024-10-11 15:52:01', NULL, '1'),
(820, 82, 'LIRCAY', '2024-10-11 15:52:01', NULL, '1'),
(821, 82, 'ANCHONGA', '2024-10-11 15:52:01', NULL, '1'),
(822, 82, 'CALLANMARCA', '2024-10-11 15:52:01', NULL, '1'),
(823, 82, 'CCOCHACCASA', '2024-10-11 15:52:01', NULL, '1'),
(824, 82, 'CHINCHO', '2024-10-11 15:52:01', NULL, '1'),
(825, 82, 'CONGALLA', '2024-10-11 15:52:01', NULL, '1'),
(826, 82, 'HUANCA-HUANCA', '2024-10-11 15:52:01', NULL, '1'),
(827, 82, 'HUAYLLAY GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(828, 82, 'JULCAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(829, 82, 'SAN ANTONIO DE ANTAPARCO', '2024-10-11 15:52:01', NULL, '1'),
(830, 82, 'SANTO TOMAS DE PATA', '2024-10-11 15:52:01', NULL, '1'),
(831, 82, 'SECCLLA', '2024-10-11 15:52:01', NULL, '1'),
(832, 83, 'CASTROVIRREYNA', '2024-10-11 15:52:01', NULL, '1'),
(833, 83, 'ARMA', '2024-10-11 15:52:01', NULL, '1'),
(834, 83, 'AURAHUA', '2024-10-11 15:52:01', NULL, '1'),
(835, 83, 'CAPILLAS', '2024-10-11 15:52:01', NULL, '1'),
(836, 83, 'CHUPAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(837, 83, 'COCAS', '2024-10-11 15:52:01', NULL, '1'),
(838, 83, 'HUACHOS', '2024-10-11 15:52:01', NULL, '1'),
(839, 83, 'HUAMATAMBO', '2024-10-11 15:52:01', NULL, '1'),
(840, 83, 'MOLLEPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(841, 83, 'SAN JUAN', '2024-10-11 15:52:01', NULL, '1'),
(842, 83, 'SANTA ANA', '2024-10-11 15:52:01', NULL, '1'),
(843, 83, 'TANTARA', '2024-10-11 15:52:01', NULL, '1'),
(844, 83, 'TICRAPO', '2024-10-11 15:52:01', NULL, '1'),
(845, 84, 'CHURCAMPA', '2024-10-11 15:52:01', NULL, '1'),
(846, 84, 'ANCO', '2024-10-11 15:52:01', NULL, '1'),
(847, 84, 'CHINCHIHUASI', '2024-10-11 15:52:01', NULL, '1'),
(848, 84, 'EL CARMEN', '2024-10-11 15:52:01', NULL, '1'),
(849, 84, 'LA MERCED', '2024-10-11 15:52:01', NULL, '1'),
(850, 84, 'LOCROJA', '2024-10-11 15:52:01', NULL, '1'),
(851, 84, 'PAUCARBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(852, 84, 'SAN MIGUEL DE MAYOCC', '2024-10-11 15:52:01', NULL, '1'),
(853, 84, 'SAN PEDRO DE CORIS', '2024-10-11 15:52:01', NULL, '1'),
(854, 84, 'PACHAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(855, 85, 'HUAYTARA', '2024-10-11 15:52:01', NULL, '1'),
(856, 85, 'AYAVI', '2024-10-11 15:52:01', NULL, '1'),
(857, 85, 'CORDOVA', '2024-10-11 15:52:01', NULL, '1'),
(858, 85, 'HUAYACUNDO ARMA', '2024-10-11 15:52:01', NULL, '1'),
(859, 85, 'LARAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(860, 85, 'OCOYO', '2024-10-11 15:52:01', NULL, '1'),
(861, 85, 'PILPICHACA', '2024-10-11 15:52:01', NULL, '1'),
(862, 85, 'QUERCO', '2024-10-11 15:52:01', NULL, '1'),
(863, 85, 'QUITO-ARMA', '2024-10-11 15:52:01', NULL, '1'),
(864, 85, 'SAN ANTONIO DE CUSICANCHA', '2024-10-11 15:52:01', NULL, '1'),
(865, 85, 'SAN FRANCISCO DE SANGAYAICO', '2024-10-11 15:52:01', NULL, '1'),
(866, 85, 'SAN ISIDRO', '2024-10-11 15:52:01', NULL, '1'),
(867, 85, 'SANTIAGO DE CHOCORVOS', '2024-10-11 15:52:01', NULL, '1'),
(868, 85, 'SANTIAGO DE QUIRAHUARA', '2024-10-11 15:52:01', NULL, '1'),
(869, 85, 'SANTO DOMINGO DE CAPILLAS', '2024-10-11 15:52:01', NULL, '1'),
(870, 85, 'TAMBO', '2024-10-11 15:52:01', NULL, '1'),
(871, 86, 'PAMPAS', '2024-10-11 15:52:01', NULL, '1'),
(872, 86, 'ACOSTAMBO', '2024-10-11 15:52:01', NULL, '1'),
(873, 86, 'ACRAQUIA', '2024-10-11 15:52:01', NULL, '1'),
(874, 86, 'AHUAYCHA', '2024-10-11 15:52:01', NULL, '1'),
(875, 86, 'COLCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(876, 86, 'DANIEL HERNANDEZ', '2024-10-11 15:52:01', NULL, '1'),
(877, 86, 'HUACHOCOLPA', '2024-10-11 15:52:01', NULL, '1'),
(878, 86, 'HUARIBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(879, 86, 'ÑAHUIMPUQUIO', '2024-10-11 15:52:01', NULL, '1'),
(880, 86, 'PAZOS', '2024-10-11 15:52:01', NULL, '1'),
(881, 86, 'QUISHUAR', '2024-10-11 15:52:01', NULL, '1'),
(882, 86, 'SALCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(883, 86, 'SALCAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(884, 86, 'SAN MARCOS DE ROCCHAC', '2024-10-11 15:52:01', NULL, '1'),
(885, 86, 'SURCUBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(886, 86, 'TINTAY PUNCU', '2024-10-11 15:52:01', NULL, '1'),
(887, 87, 'HUANUCO', '2024-10-11 15:52:01', NULL, '1'),
(888, 87, 'AMARILIS', '2024-10-11 15:52:01', NULL, '1'),
(889, 87, 'CHINCHAO', '2024-10-11 15:52:01', NULL, '1'),
(890, 87, 'CHURUBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(891, 87, 'MARGOS', '2024-10-11 15:52:01', NULL, '1'),
(892, 87, 'QUISQUI', '2024-10-11 15:52:01', NULL, '1'),
(893, 87, 'SAN FRANCISCO DE CAYRAN', '2024-10-11 15:52:01', NULL, '1');
INSERT INTO `distritos` (`iddistrito`, `idprovincia`, `distrito`, `create_at`, `update_at`, `estado`) VALUES
(894, 87, 'SAN PEDRO DE CHAULAN', '2024-10-11 15:52:01', NULL, '1'),
(895, 87, 'SANTA MARIA DEL VALLE', '2024-10-11 15:52:01', NULL, '1'),
(896, 87, 'YARUMAYO', '2024-10-11 15:52:01', NULL, '1'),
(897, 87, 'PILLCO MARCA', '2024-10-11 15:52:01', NULL, '1'),
(898, 88, 'AMBO', '2024-10-11 15:52:01', NULL, '1'),
(899, 88, 'CAYNA', '2024-10-11 15:52:01', NULL, '1'),
(900, 88, 'COLPAS', '2024-10-11 15:52:01', NULL, '1'),
(901, 88, 'CONCHAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(902, 88, 'HUACAR', '2024-10-11 15:52:01', NULL, '1'),
(903, 88, 'SAN FRANCISCO', '2024-10-11 15:52:01', NULL, '1'),
(904, 88, 'SAN RAFAEL', '2024-10-11 15:52:01', NULL, '1'),
(905, 88, 'TOMAY KICHWA', '2024-10-11 15:52:01', NULL, '1'),
(906, 89, 'LA UNION', '2024-10-11 15:52:01', NULL, '1'),
(907, 89, 'CHUQUIS', '2024-10-11 15:52:01', NULL, '1'),
(908, 89, 'MARIAS', '2024-10-11 15:52:01', NULL, '1'),
(909, 89, 'PACHAS', '2024-10-11 15:52:01', NULL, '1'),
(910, 89, 'QUIVILLA', '2024-10-11 15:52:01', NULL, '1'),
(911, 89, 'RIPAN', '2024-10-11 15:52:01', NULL, '1'),
(912, 89, 'SHUNQUI', '2024-10-11 15:52:01', NULL, '1'),
(913, 89, 'SILLAPATA', '2024-10-11 15:52:01', NULL, '1'),
(914, 89, 'YANAS', '2024-10-11 15:52:01', NULL, '1'),
(915, 90, 'HUACAYBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(916, 90, 'CANCHABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(917, 90, 'COCHABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(918, 90, 'PINRA', '2024-10-11 15:52:01', NULL, '1'),
(919, 91, 'LLATA', '2024-10-11 15:52:01', NULL, '1'),
(920, 91, 'ARANCAY', '2024-10-11 15:52:01', NULL, '1'),
(921, 91, 'CHAVIN DE PARIARCA', '2024-10-11 15:52:01', NULL, '1'),
(922, 91, 'JACAS GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(923, 91, 'JIRCAN', '2024-10-11 15:52:01', NULL, '1'),
(924, 91, 'MIRAFLORES', '2024-10-11 15:52:01', NULL, '1'),
(925, 91, 'MONZON', '2024-10-11 15:52:01', NULL, '1'),
(926, 91, 'PUNCHAO', '2024-10-11 15:52:01', NULL, '1'),
(927, 91, 'PUÑOS', '2024-10-11 15:52:01', NULL, '1'),
(928, 91, 'SINGA', '2024-10-11 15:52:01', NULL, '1'),
(929, 91, 'TANTAMAYO', '2024-10-11 15:52:01', NULL, '1'),
(930, 92, 'RUPA-RUPA', '2024-10-11 15:52:01', NULL, '1'),
(931, 92, 'DANIEL ALOMIA ROBLES', '2024-10-11 15:52:01', NULL, '1'),
(932, 92, 'HERMILIO VALDIZAN', '2024-10-11 15:52:01', NULL, '1'),
(933, 92, 'JOSE CRESPO Y CASTILLO', '2024-10-11 15:52:01', NULL, '1'),
(934, 92, 'LUYANDO', '2024-10-11 15:52:01', NULL, '1'),
(935, 92, 'MARIANO DAMASO BERAUN', '2024-10-11 15:52:01', NULL, '1'),
(936, 93, 'HUACRACHUCO', '2024-10-11 15:52:01', NULL, '1'),
(937, 93, 'CHOLON', '2024-10-11 15:52:01', NULL, '1'),
(938, 93, 'SAN BUENAVENTURA', '2024-10-11 15:52:01', NULL, '1'),
(939, 94, 'PANAO', '2024-10-11 15:52:01', NULL, '1'),
(940, 94, 'CHAGLLA', '2024-10-11 15:52:01', NULL, '1'),
(941, 94, 'MOLINO', '2024-10-11 15:52:01', NULL, '1'),
(942, 94, 'UMARI', '2024-10-11 15:52:01', NULL, '1'),
(943, 95, 'PUERTO INCA', '2024-10-11 15:52:01', NULL, '1'),
(944, 95, 'CODO DEL POZUZO', '2024-10-11 15:52:01', NULL, '1'),
(945, 95, 'HONORIA', '2024-10-11 15:52:01', NULL, '1'),
(946, 95, 'TOURNAVISTA', '2024-10-11 15:52:01', NULL, '1'),
(947, 95, 'YUYAPICHIS', '2024-10-11 15:52:01', NULL, '1'),
(948, 96, 'JESUS', '2024-10-11 15:52:01', NULL, '1'),
(949, 96, 'BAÑOS', '2024-10-11 15:52:01', NULL, '1'),
(950, 96, 'JIVIA', '2024-10-11 15:52:01', NULL, '1'),
(951, 96, 'QUEROPALCA', '2024-10-11 15:52:01', NULL, '1'),
(952, 96, 'RONDOS', '2024-10-11 15:52:01', NULL, '1'),
(953, 96, 'SAN FRANCISCO DE ASIS', '2024-10-11 15:52:01', NULL, '1'),
(954, 96, 'SAN MIGUEL DE CAURI', '2024-10-11 15:52:01', NULL, '1'),
(955, 97, 'CHAVINILLO', '2024-10-11 15:52:01', NULL, '1'),
(956, 97, 'CAHUAC', '2024-10-11 15:52:01', NULL, '1'),
(957, 97, 'CHACABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(958, 97, 'APARICIO POMARES', '2024-10-11 15:52:01', NULL, '1'),
(959, 97, 'JACAS CHICO', '2024-10-11 15:52:01', NULL, '1'),
(960, 97, 'OBAS', '2024-10-11 15:52:01', NULL, '1'),
(961, 97, 'PAMPAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(962, 97, 'CHORAS', '2024-10-11 15:52:01', NULL, '1'),
(963, 98, 'ICA', '2024-10-11 15:52:01', NULL, '1'),
(964, 98, 'LA TINGUIÑA', '2024-10-11 15:52:01', NULL, '1'),
(965, 98, 'LOS AQUIJES', '2024-10-11 15:52:01', NULL, '1'),
(966, 98, 'OCUCAJE', '2024-10-11 15:52:01', NULL, '1'),
(967, 98, 'PACHACUTEC', '2024-10-11 15:52:01', NULL, '1'),
(968, 98, 'PARCONA', '2024-10-11 15:52:01', NULL, '1'),
(969, 98, 'PUEBLO NUEVO', '2024-10-11 15:52:01', NULL, '1'),
(970, 98, 'SALAS', '2024-10-11 15:52:01', NULL, '1'),
(971, 98, 'SAN JOSE DE LOS MOLINOS', '2024-10-11 15:52:01', NULL, '1'),
(972, 98, 'SAN JUAN BAUTISTA', '2024-10-11 15:52:01', NULL, '1'),
(973, 98, 'SANTIAGO', '2024-10-11 15:52:01', NULL, '1'),
(974, 98, 'SUBTANJALLA', '2024-10-11 15:52:01', NULL, '1'),
(975, 98, 'TATE', '2024-10-11 15:52:01', NULL, '1'),
(976, 98, 'YAUCA DEL ROSARIO', '2024-10-11 15:52:01', NULL, '1'),
(977, 99, 'CHINCHA ALTA', '2024-10-11 15:52:01', NULL, '1'),
(978, 99, 'ALTO LARAN', '2024-10-11 15:52:01', NULL, '1'),
(979, 99, 'CHAVIN', '2024-10-11 15:52:01', NULL, '1'),
(980, 99, 'CHINCHA BAJA', '2024-10-11 15:52:01', NULL, '1'),
(981, 99, 'EL CARMEN', '2024-10-11 15:52:01', NULL, '1'),
(982, 99, 'GROCIO PRADO', '2024-10-11 15:52:01', NULL, '1'),
(983, 99, 'PUEBLO NUEVO', '2024-10-11 15:52:01', NULL, '1'),
(984, 99, 'SAN JUAN DE YANAC', '2024-10-11 15:52:01', NULL, '1'),
(985, 99, 'SAN PEDRO DE HUACARPANA', '2024-10-11 15:52:01', NULL, '1'),
(986, 99, 'SUNAMPE', '2024-10-11 15:52:01', NULL, '1'),
(987, 99, 'TAMBO DE MORA', '2024-10-11 15:52:01', NULL, '1'),
(988, 100, 'NAZCA', '2024-10-11 15:52:01', NULL, '1'),
(989, 100, 'CHANGUILLO', '2024-10-11 15:52:01', NULL, '1'),
(990, 100, 'EL INGENIO', '2024-10-11 15:52:01', NULL, '1'),
(991, 100, 'MARCONA', '2024-10-11 15:52:01', NULL, '1'),
(992, 100, 'VISTA ALEGRE', '2024-10-11 15:52:01', NULL, '1'),
(993, 101, 'PALPA', '2024-10-11 15:52:01', NULL, '1'),
(994, 101, 'LLIPATA', '2024-10-11 15:52:01', NULL, '1'),
(995, 101, 'RIO GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(996, 101, 'SANTA CRUZ', '2024-10-11 15:52:01', NULL, '1'),
(997, 101, 'TIBILLO', '2024-10-11 15:52:01', NULL, '1'),
(998, 102, 'PISCO', '2024-10-11 15:52:01', NULL, '1'),
(999, 102, 'HUANCANO', '2024-10-11 15:52:01', NULL, '1'),
(1000, 102, 'HUMAY', '2024-10-11 15:52:01', NULL, '1'),
(1001, 102, 'INDEPENDENCIA', '2024-10-11 15:52:01', NULL, '1'),
(1002, 102, 'PARACAS', '2024-10-11 15:52:01', NULL, '1'),
(1003, 102, 'SAN ANDRES', '2024-10-11 15:52:01', NULL, '1'),
(1004, 102, 'SAN CLEMENTE', '2024-10-11 15:52:01', NULL, '1'),
(1005, 102, 'TUPAC AMARU INCA', '2024-10-11 15:52:01', NULL, '1'),
(1006, 103, 'HUANCAYO', '2024-10-11 15:52:01', NULL, '1'),
(1007, 103, 'CARHUACALLANGA', '2024-10-11 15:52:01', NULL, '1'),
(1008, 103, 'CHACAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1009, 103, 'CHICCHE', '2024-10-11 15:52:01', NULL, '1'),
(1010, 103, 'CHILCA', '2024-10-11 15:52:01', NULL, '1'),
(1011, 103, 'CHONGOS ALTO', '2024-10-11 15:52:01', NULL, '1'),
(1012, 103, 'CHUPURO', '2024-10-11 15:52:01', NULL, '1'),
(1013, 103, 'COLCA', '2024-10-11 15:52:01', NULL, '1'),
(1014, 103, 'CULLHUAS', '2024-10-11 15:52:01', NULL, '1'),
(1015, 103, 'EL TAMBO', '2024-10-11 15:52:01', NULL, '1'),
(1016, 103, 'HUACRAPUQUIO', '2024-10-11 15:52:01', NULL, '1'),
(1017, 103, 'HUALHUAS', '2024-10-11 15:52:01', NULL, '1'),
(1018, 103, 'HUANCAN', '2024-10-11 15:52:01', NULL, '1'),
(1019, 103, 'HUASICANCHA', '2024-10-11 15:52:01', NULL, '1'),
(1020, 103, 'HUAYUCACHI', '2024-10-11 15:52:01', NULL, '1'),
(1021, 103, 'INGENIO', '2024-10-11 15:52:01', NULL, '1'),
(1022, 103, 'PARIAHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(1023, 103, 'PILCOMAYO', '2024-10-11 15:52:01', NULL, '1'),
(1024, 103, 'PUCARA', '2024-10-11 15:52:01', NULL, '1'),
(1025, 103, 'QUICHUAY', '2024-10-11 15:52:01', NULL, '1'),
(1026, 103, 'QUILCAS', '2024-10-11 15:52:01', NULL, '1'),
(1027, 103, 'SAN AGUSTIN', '2024-10-11 15:52:01', NULL, '1'),
(1028, 103, 'SAN JERONIMO DE TUNAN', '2024-10-11 15:52:01', NULL, '1'),
(1029, 103, 'SAÑO', '2024-10-11 15:52:01', NULL, '1'),
(1030, 103, 'SAPALLANGA', '2024-10-11 15:52:01', NULL, '1'),
(1031, 103, 'SICAYA', '2024-10-11 15:52:01', NULL, '1'),
(1032, 103, 'SANTO DOMINGO DE ACOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1033, 103, 'VIQUES', '2024-10-11 15:52:01', NULL, '1'),
(1034, 104, 'CONCEPCION', '2024-10-11 15:52:01', NULL, '1'),
(1035, 104, 'ACO', '2024-10-11 15:52:01', NULL, '1'),
(1036, 104, 'ANDAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1037, 104, 'CHAMBARA', '2024-10-11 15:52:01', NULL, '1'),
(1038, 104, 'COCHAS', '2024-10-11 15:52:01', NULL, '1'),
(1039, 104, 'COMAS', '2024-10-11 15:52:01', NULL, '1'),
(1040, 104, 'HEROINAS TOLEDO', '2024-10-11 15:52:01', NULL, '1'),
(1041, 104, 'MANZANARES', '2024-10-11 15:52:01', NULL, '1'),
(1042, 104, 'MARISCAL CASTILLA', '2024-10-11 15:52:01', NULL, '1'),
(1043, 104, 'MATAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(1044, 104, 'MITO', '2024-10-11 15:52:01', NULL, '1'),
(1045, 104, 'NUEVE DE JULIO', '2024-10-11 15:52:01', NULL, '1'),
(1046, 104, 'ORCOTUNA', '2024-10-11 15:52:01', NULL, '1'),
(1047, 104, 'SAN JOSE DE QUERO', '2024-10-11 15:52:01', NULL, '1'),
(1048, 104, 'SANTA ROSA DE OCOPA', '2024-10-11 15:52:01', NULL, '1'),
(1049, 105, 'CHANCHAMAYO', '2024-10-11 15:52:01', NULL, '1'),
(1050, 105, 'PERENE', '2024-10-11 15:52:01', NULL, '1'),
(1051, 105, 'PICHANAQUI', '2024-10-11 15:52:01', NULL, '1'),
(1052, 105, 'SAN LUIS DE SHUARO', '2024-10-11 15:52:01', NULL, '1'),
(1053, 105, 'SAN RAMON', '2024-10-11 15:52:01', NULL, '1'),
(1054, 105, 'VITOC', '2024-10-11 15:52:01', NULL, '1'),
(1055, 106, 'JAUJA', '2024-10-11 15:52:01', NULL, '1'),
(1056, 106, 'ACOLLA', '2024-10-11 15:52:01', NULL, '1'),
(1057, 106, 'APATA', '2024-10-11 15:52:01', NULL, '1'),
(1058, 106, 'ATAURA', '2024-10-11 15:52:01', NULL, '1'),
(1059, 106, 'CANCHAYLLO', '2024-10-11 15:52:01', NULL, '1'),
(1060, 106, 'CURICACA', '2024-10-11 15:52:01', NULL, '1'),
(1061, 106, 'EL MANTARO', '2024-10-11 15:52:01', NULL, '1'),
(1062, 106, 'HUAMALI', '2024-10-11 15:52:01', NULL, '1'),
(1063, 106, 'HUARIPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1064, 106, 'HUERTAS', '2024-10-11 15:52:01', NULL, '1'),
(1065, 106, 'JANJAILLO', '2024-10-11 15:52:01', NULL, '1'),
(1066, 106, 'JULCAN', '2024-10-11 15:52:01', NULL, '1'),
(1067, 106, 'LEONOR ORDOÑEZ', '2024-10-11 15:52:01', NULL, '1'),
(1068, 106, 'LLOCLLAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1069, 106, 'MARCO', '2024-10-11 15:52:01', NULL, '1'),
(1070, 106, 'MASMA', '2024-10-11 15:52:01', NULL, '1'),
(1071, 106, 'MASMA CHICCHE', '2024-10-11 15:52:01', NULL, '1'),
(1072, 106, 'MOLINOS', '2024-10-11 15:52:01', NULL, '1'),
(1073, 106, 'MONOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1074, 106, 'MUQUI', '2024-10-11 15:52:01', NULL, '1'),
(1075, 106, 'MUQUIYAUYO', '2024-10-11 15:52:01', NULL, '1'),
(1076, 106, 'PACA', '2024-10-11 15:52:01', NULL, '1'),
(1077, 106, 'PACCHA', '2024-10-11 15:52:01', NULL, '1'),
(1078, 106, 'PANCAN', '2024-10-11 15:52:01', NULL, '1'),
(1079, 106, 'PARCO', '2024-10-11 15:52:01', NULL, '1'),
(1080, 106, 'POMACANCHA', '2024-10-11 15:52:01', NULL, '1'),
(1081, 106, 'RICRAN', '2024-10-11 15:52:01', NULL, '1'),
(1082, 106, 'SAN LORENZO', '2024-10-11 15:52:01', NULL, '1'),
(1083, 106, 'SAN PEDRO DE CHUNAN', '2024-10-11 15:52:01', NULL, '1'),
(1084, 106, 'SAUSA', '2024-10-11 15:52:01', NULL, '1'),
(1085, 106, 'SINCOS', '2024-10-11 15:52:01', NULL, '1'),
(1086, 106, 'TUNAN MARCA', '2024-10-11 15:52:01', NULL, '1'),
(1087, 106, 'YAULI', '2024-10-11 15:52:01', NULL, '1'),
(1088, 106, 'YAUYOS', '2024-10-11 15:52:01', NULL, '1'),
(1089, 107, 'JUNIN', '2024-10-11 15:52:01', NULL, '1'),
(1090, 107, 'CARHUAMAYO', '2024-10-11 15:52:01', NULL, '1'),
(1091, 107, 'ONDORES', '2024-10-11 15:52:01', NULL, '1'),
(1092, 107, 'ULCUMAYO', '2024-10-11 15:52:01', NULL, '1'),
(1093, 108, 'SATIPO', '2024-10-11 15:52:01', NULL, '1'),
(1094, 108, 'COVIRIALI', '2024-10-11 15:52:01', NULL, '1'),
(1095, 108, 'LLAYLLA', '2024-10-11 15:52:01', NULL, '1'),
(1096, 108, 'MAZAMARI', '2024-10-11 15:52:01', NULL, '1'),
(1097, 108, 'PAMPA HERMOSA', '2024-10-11 15:52:01', NULL, '1'),
(1098, 108, 'PANGOA', '2024-10-11 15:52:01', NULL, '1'),
(1099, 108, 'RIO NEGRO', '2024-10-11 15:52:01', NULL, '1'),
(1100, 108, 'RIO TAMBO', '2024-10-11 15:52:01', NULL, '1'),
(1101, 109, 'TARMA', '2024-10-11 15:52:01', NULL, '1'),
(1102, 109, 'ACOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1103, 109, 'HUARICOLCA', '2024-10-11 15:52:01', NULL, '1'),
(1104, 109, 'HUASAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(1105, 109, 'LA UNION', '2024-10-11 15:52:01', NULL, '1'),
(1106, 109, 'PALCA', '2024-10-11 15:52:01', NULL, '1'),
(1107, 109, 'PALCAMAYO', '2024-10-11 15:52:01', NULL, '1'),
(1108, 109, 'SAN PEDRO DE CAJAS', '2024-10-11 15:52:01', NULL, '1'),
(1109, 109, 'TAPO', '2024-10-11 15:52:01', NULL, '1'),
(1110, 110, 'LA OROYA', '2024-10-11 15:52:01', NULL, '1'),
(1111, 110, 'CHACAPALPA', '2024-10-11 15:52:01', NULL, '1'),
(1112, 110, 'HUAY-HUAY', '2024-10-11 15:52:01', NULL, '1'),
(1113, 110, 'MARCAPOMACOCHA', '2024-10-11 15:52:01', NULL, '1'),
(1114, 110, 'MOROCOCHA', '2024-10-11 15:52:01', NULL, '1'),
(1115, 110, 'PACCHA', '2024-10-11 15:52:01', NULL, '1'),
(1116, 110, 'SANTA BARBARA DE CARHUACAYAN', '2024-10-11 15:52:01', NULL, '1'),
(1117, 110, 'SANTA ROSA DE SACCO', '2024-10-11 15:52:01', NULL, '1'),
(1118, 110, 'SUITUCANCHA', '2024-10-11 15:52:01', NULL, '1'),
(1119, 110, 'YAULI', '2024-10-11 15:52:01', NULL, '1'),
(1120, 111, 'CHUPACA', '2024-10-11 15:52:01', NULL, '1'),
(1121, 111, 'AHUAC', '2024-10-11 15:52:01', NULL, '1'),
(1122, 111, 'CHONGOS BAJO', '2024-10-11 15:52:01', NULL, '1'),
(1123, 111, 'HUACHAC', '2024-10-11 15:52:01', NULL, '1'),
(1124, 111, 'HUAMANCACA CHICO', '2024-10-11 15:52:01', NULL, '1'),
(1125, 111, 'SAN JUAN DE ISCOS', '2024-10-11 15:52:01', NULL, '1'),
(1126, 111, 'SAN JUAN DE JARPA', '2024-10-11 15:52:01', NULL, '1'),
(1127, 111, 'TRES DE DICIEMBRE', '2024-10-11 15:52:01', NULL, '1'),
(1128, 111, 'YANACANCHA', '2024-10-11 15:52:01', NULL, '1'),
(1129, 112, 'TRUJILLO', '2024-10-11 15:52:01', NULL, '1'),
(1130, 112, 'EL PORVENIR', '2024-10-11 15:52:01', NULL, '1'),
(1131, 112, 'FLORENCIA DE MORA', '2024-10-11 15:52:01', NULL, '1'),
(1132, 112, 'HUANCHACO', '2024-10-11 15:52:01', NULL, '1'),
(1133, 112, 'LA ESPERANZA', '2024-10-11 15:52:01', NULL, '1'),
(1134, 112, 'LAREDO', '2024-10-11 15:52:01', NULL, '1'),
(1135, 112, 'MOCHE', '2024-10-11 15:52:01', NULL, '1'),
(1136, 112, 'POROTO', '2024-10-11 15:52:01', NULL, '1'),
(1137, 112, 'SALAVERRY', '2024-10-11 15:52:01', NULL, '1'),
(1138, 112, 'SIMBAL', '2024-10-11 15:52:01', NULL, '1'),
(1139, 112, 'VICTOR LARCO HERRERA', '2024-10-11 15:52:01', NULL, '1'),
(1140, 113, 'ASCOPE', '2024-10-11 15:52:01', NULL, '1'),
(1141, 113, 'CHICAMA', '2024-10-11 15:52:01', NULL, '1'),
(1142, 113, 'CHOCOPE', '2024-10-11 15:52:01', NULL, '1'),
(1143, 113, 'MAGDALENA DE CAO', '2024-10-11 15:52:01', NULL, '1'),
(1144, 113, 'PAIJAN', '2024-10-11 15:52:01', NULL, '1'),
(1145, 113, 'RAZURI', '2024-10-11 15:52:01', NULL, '1'),
(1146, 113, 'SANTIAGO DE CAO', '2024-10-11 15:52:01', NULL, '1'),
(1147, 113, 'CASA GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(1148, 114, 'BOLIVAR', '2024-10-11 15:52:01', NULL, '1'),
(1149, 114, 'BAMBAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1150, 114, 'CONDORMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1151, 114, 'LONGOTEA', '2024-10-11 15:52:01', NULL, '1'),
(1152, 114, 'UCHUMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1153, 114, 'UCUNCHA', '2024-10-11 15:52:01', NULL, '1'),
(1154, 115, 'CHEPEN', '2024-10-11 15:52:01', NULL, '1'),
(1155, 115, 'PACANGA', '2024-10-11 15:52:01', NULL, '1'),
(1156, 115, 'PUEBLO NUEVO', '2024-10-11 15:52:01', NULL, '1'),
(1157, 116, 'JULCAN', '2024-10-11 15:52:01', NULL, '1'),
(1158, 116, 'CALAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1159, 116, 'CARABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1160, 116, 'HUASO', '2024-10-11 15:52:01', NULL, '1'),
(1161, 117, 'OTUZCO', '2024-10-11 15:52:01', NULL, '1'),
(1162, 117, 'AGALLPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1163, 117, 'CHARAT', '2024-10-11 15:52:01', NULL, '1'),
(1164, 117, 'HUARANCHAL', '2024-10-11 15:52:01', NULL, '1'),
(1165, 117, 'LA CUESTA', '2024-10-11 15:52:01', NULL, '1'),
(1166, 117, 'MACHE', '2024-10-11 15:52:01', NULL, '1'),
(1167, 117, 'PARANDAY', '2024-10-11 15:52:01', NULL, '1'),
(1168, 117, 'SALPO', '2024-10-11 15:52:01', NULL, '1'),
(1169, 117, 'SINSICAP', '2024-10-11 15:52:01', NULL, '1'),
(1170, 117, 'USQUIL', '2024-10-11 15:52:01', NULL, '1'),
(1171, 118, 'SAN PEDRO DE LLOC', '2024-10-11 15:52:01', NULL, '1'),
(1172, 118, 'GUADALUPE', '2024-10-11 15:52:01', NULL, '1'),
(1173, 118, 'JEQUETEPEQUE', '2024-10-11 15:52:01', NULL, '1'),
(1174, 118, 'PACASMAYO', '2024-10-11 15:52:01', NULL, '1'),
(1175, 118, 'SAN JOSE', '2024-10-11 15:52:01', NULL, '1'),
(1176, 119, 'TAYABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1177, 119, 'BULDIBUYO', '2024-10-11 15:52:01', NULL, '1'),
(1178, 119, 'CHILLIA', '2024-10-11 15:52:01', NULL, '1'),
(1179, 119, 'HUANCASPATA', '2024-10-11 15:52:01', NULL, '1'),
(1180, 119, 'HUAYLILLAS', '2024-10-11 15:52:01', NULL, '1'),
(1181, 119, 'HUAYO', '2024-10-11 15:52:01', NULL, '1'),
(1182, 119, 'ONGON', '2024-10-11 15:52:01', NULL, '1'),
(1183, 119, 'PARCOY', '2024-10-11 15:52:01', NULL, '1'),
(1184, 119, 'PATAZ', '2024-10-11 15:52:01', NULL, '1'),
(1185, 119, 'PIAS', '2024-10-11 15:52:01', NULL, '1'),
(1186, 119, 'SANTIAGO DE CHALLAS', '2024-10-11 15:52:01', NULL, '1'),
(1187, 119, 'TAURIJA', '2024-10-11 15:52:01', NULL, '1'),
(1188, 119, 'URPAY', '2024-10-11 15:52:01', NULL, '1'),
(1189, 120, 'HUAMACHUCO', '2024-10-11 15:52:01', NULL, '1'),
(1190, 120, 'CHUGAY', '2024-10-11 15:52:01', NULL, '1'),
(1191, 120, 'COCHORCO', '2024-10-11 15:52:01', NULL, '1'),
(1192, 120, 'CURGOS', '2024-10-11 15:52:01', NULL, '1'),
(1193, 120, 'MARCABAL', '2024-10-11 15:52:01', NULL, '1'),
(1194, 120, 'SANAGORAN', '2024-10-11 15:52:01', NULL, '1'),
(1195, 120, 'SARIN', '2024-10-11 15:52:01', NULL, '1'),
(1196, 120, 'SARTIMBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1197, 121, 'SANTIAGO DE CHUCO', '2024-10-11 15:52:01', NULL, '1'),
(1198, 121, 'ANGASMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1199, 121, 'CACHICADAN', '2024-10-11 15:52:01', NULL, '1'),
(1200, 121, 'MOLLEBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1201, 121, 'MOLLEPATA', '2024-10-11 15:52:01', NULL, '1'),
(1202, 121, 'QUIRUVILCA', '2024-10-11 15:52:01', NULL, '1'),
(1203, 121, 'SANTA CRUZ DE CHUCA', '2024-10-11 15:52:01', NULL, '1'),
(1204, 121, 'SITABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1205, 122, 'GRAN CHIMU', '2024-10-11 15:52:01', NULL, '1'),
(1206, 122, 'CASCAS', '2024-10-11 15:52:01', NULL, '1'),
(1207, 122, 'LUCMA', '2024-10-11 15:52:01', NULL, '1'),
(1208, 122, 'MARMOT', '2024-10-11 15:52:01', NULL, '1'),
(1209, 122, 'SAYAPULLO', '2024-10-11 15:52:01', NULL, '1'),
(1210, 123, 'VIRU', '2024-10-11 15:52:01', NULL, '1'),
(1211, 123, 'CHAO', '2024-10-11 15:52:01', NULL, '1'),
(1212, 123, 'GUADALUPITO', '2024-10-11 15:52:01', NULL, '1'),
(1213, 124, 'CHICLAYO', '2024-10-11 15:52:01', NULL, '1'),
(1214, 124, 'CHONGOYAPE', '2024-10-11 15:52:01', NULL, '1'),
(1215, 124, 'ETEN', '2024-10-11 15:52:01', NULL, '1'),
(1216, 124, 'ETEN PUERTO', '2024-10-11 15:52:01', NULL, '1'),
(1217, 124, 'JOSE LEONARDO ORTIZ', '2024-10-11 15:52:01', NULL, '1'),
(1218, 124, 'LA VICTORIA', '2024-10-11 15:52:01', NULL, '1'),
(1219, 124, 'LAGUNAS', '2024-10-11 15:52:01', NULL, '1'),
(1220, 124, 'MONSEFU', '2024-10-11 15:52:01', NULL, '1'),
(1221, 124, 'NUEVA ARICA', '2024-10-11 15:52:01', NULL, '1'),
(1222, 124, 'OYOTUN', '2024-10-11 15:52:01', NULL, '1'),
(1223, 124, 'PICSI', '2024-10-11 15:52:01', NULL, '1'),
(1224, 124, 'PIMENTEL', '2024-10-11 15:52:01', NULL, '1'),
(1225, 124, 'REQUE', '2024-10-11 15:52:01', NULL, '1'),
(1226, 124, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(1227, 124, 'SAÑA', '2024-10-11 15:52:01', NULL, '1'),
(1228, 124, 'CAYALTI', '2024-10-11 15:52:01', NULL, '1'),
(1229, 124, 'PATAPO', '2024-10-11 15:52:01', NULL, '1'),
(1230, 124, 'POMALCA', '2024-10-11 15:52:01', NULL, '1'),
(1231, 124, 'PUCALA', '2024-10-11 15:52:01', NULL, '1'),
(1232, 124, 'TUMAN', '2024-10-11 15:52:01', NULL, '1'),
(1233, 125, 'FERREÑAFE', '2024-10-11 15:52:01', NULL, '1'),
(1234, 125, 'CAÑARIS', '2024-10-11 15:52:01', NULL, '1'),
(1235, 125, 'INCAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(1236, 125, 'MANUEL ANTONIO MESONES MURO', '2024-10-11 15:52:01', NULL, '1'),
(1237, 125, 'PITIPO', '2024-10-11 15:52:01', NULL, '1'),
(1238, 125, 'PUEBLO NUEVO', '2024-10-11 15:52:01', NULL, '1'),
(1239, 126, 'LAMBAYEQUE', '2024-10-11 15:52:01', NULL, '1'),
(1240, 126, 'CHOCHOPE', '2024-10-11 15:52:01', NULL, '1'),
(1241, 126, 'ILLIMO', '2024-10-11 15:52:01', NULL, '1'),
(1242, 126, 'JAYANCA', '2024-10-11 15:52:01', NULL, '1'),
(1243, 126, 'MOCHUMI', '2024-10-11 15:52:01', NULL, '1'),
(1244, 126, 'MORROPE', '2024-10-11 15:52:01', NULL, '1'),
(1245, 126, 'MOTUPE', '2024-10-11 15:52:01', NULL, '1'),
(1246, 126, 'OLMOS', '2024-10-11 15:52:01', NULL, '1'),
(1247, 126, 'PACORA', '2024-10-11 15:52:01', NULL, '1'),
(1248, 126, 'SALAS', '2024-10-11 15:52:01', NULL, '1'),
(1249, 126, 'SAN JOSE', '2024-10-11 15:52:01', NULL, '1'),
(1250, 126, 'TUCUME', '2024-10-11 15:52:01', NULL, '1'),
(1251, 127, 'LIMA', '2024-10-11 15:52:01', NULL, '1'),
(1252, 127, 'ANCON', '2024-10-11 15:52:01', NULL, '1'),
(1253, 127, 'ATE', '2024-10-11 15:52:01', NULL, '1'),
(1254, 127, 'BARRANCO', '2024-10-11 15:52:01', NULL, '1'),
(1255, 127, 'BREÑA', '2024-10-11 15:52:01', NULL, '1'),
(1256, 127, 'CARABAYLLO', '2024-10-11 15:52:01', NULL, '1'),
(1257, 127, 'CHACLACAYO', '2024-10-11 15:52:01', NULL, '1'),
(1258, 127, 'CHORRILLOS', '2024-10-11 15:52:01', NULL, '1'),
(1259, 127, 'CIENEGUILLA', '2024-10-11 15:52:01', NULL, '1'),
(1260, 127, 'COMAS', '2024-10-11 15:52:01', NULL, '1'),
(1261, 127, 'EL AGUSTINO', '2024-10-11 15:52:01', NULL, '1'),
(1262, 127, 'INDEPENDENCIA', '2024-10-11 15:52:01', NULL, '1'),
(1263, 127, 'JESUS MARIA', '2024-10-11 15:52:01', NULL, '1'),
(1264, 127, 'LA MOLINA', '2024-10-11 15:52:01', NULL, '1'),
(1265, 127, 'LA VICTORIA', '2024-10-11 15:52:01', NULL, '1'),
(1266, 127, 'LINCE', '2024-10-11 15:52:01', NULL, '1'),
(1267, 127, 'LOS OLIVOS', '2024-10-11 15:52:01', NULL, '1'),
(1268, 127, 'LURIGANCHO', '2024-10-11 15:52:01', NULL, '1'),
(1269, 127, 'LURIN', '2024-10-11 15:52:01', NULL, '1'),
(1270, 127, 'MAGDALENA DEL MAR', '2024-10-11 15:52:01', NULL, '1'),
(1271, 127, 'MAGDALENA VIEJA', '2024-10-11 15:52:01', NULL, '1'),
(1272, 127, 'MIRAFLORES', '2024-10-11 15:52:01', NULL, '1'),
(1273, 127, 'PACHACAMAC', '2024-10-11 15:52:01', NULL, '1'),
(1274, 127, 'PUCUSANA', '2024-10-11 15:52:01', NULL, '1'),
(1275, 127, 'PUENTE PIEDRA', '2024-10-11 15:52:01', NULL, '1'),
(1276, 127, 'PUNTA HERMOSA', '2024-10-11 15:52:01', NULL, '1'),
(1277, 127, 'PUNTA NEGRA', '2024-10-11 15:52:01', NULL, '1'),
(1278, 127, 'RIMAC', '2024-10-11 15:52:01', NULL, '1'),
(1279, 127, 'SAN BARTOLO', '2024-10-11 15:52:01', NULL, '1'),
(1280, 127, 'SAN BORJA', '2024-10-11 15:52:01', NULL, '1'),
(1281, 127, 'SAN ISIDRO', '2024-10-11 15:52:01', NULL, '1'),
(1282, 127, 'SAN JUAN DE LURIGANCHO', '2024-10-11 15:52:01', NULL, '1'),
(1283, 127, 'SAN JUAN DE MIRAFLORES', '2024-10-11 15:52:01', NULL, '1'),
(1284, 127, 'SAN LUIS', '2024-10-11 15:52:01', NULL, '1'),
(1285, 127, 'SAN MARTIN DE PORRES', '2024-10-11 15:52:01', NULL, '1'),
(1286, 127, 'SAN MIGUEL', '2024-10-11 15:52:01', NULL, '1'),
(1287, 127, 'SANTA ANITA', '2024-10-11 15:52:01', NULL, '1'),
(1288, 127, 'SANTA MARIA DEL MAR', '2024-10-11 15:52:01', NULL, '1'),
(1289, 127, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(1290, 127, 'SANTIAGO DE SURCO', '2024-10-11 15:52:01', NULL, '1'),
(1291, 127, 'SURQUILLO', '2024-10-11 15:52:01', NULL, '1'),
(1292, 127, 'VILLA EL SALVADOR', '2024-10-11 15:52:01', NULL, '1'),
(1293, 127, 'VILLA MARIA DEL TRIUNFO', '2024-10-11 15:52:01', NULL, '1'),
(1294, 128, 'BARRANCA', '2024-10-11 15:52:01', NULL, '1'),
(1295, 128, 'PARAMONGA', '2024-10-11 15:52:01', NULL, '1'),
(1296, 128, 'PATIVILCA', '2024-10-11 15:52:01', NULL, '1'),
(1297, 128, 'SUPE', '2024-10-11 15:52:01', NULL, '1'),
(1298, 128, 'SUPE PUERTO', '2024-10-11 15:52:01', NULL, '1'),
(1299, 129, 'CAJATAMBO', '2024-10-11 15:52:01', NULL, '1'),
(1300, 129, 'COPA', '2024-10-11 15:52:01', NULL, '1'),
(1301, 129, 'GORGOR', '2024-10-11 15:52:01', NULL, '1'),
(1302, 129, 'HUANCAPON', '2024-10-11 15:52:01', NULL, '1'),
(1303, 129, 'MANAS', '2024-10-11 15:52:01', NULL, '1'),
(1304, 130, 'CANTA', '2024-10-11 15:52:01', NULL, '1'),
(1305, 130, 'ARAHUAY', '2024-10-11 15:52:01', NULL, '1'),
(1306, 130, 'HUAMANTANGA', '2024-10-11 15:52:01', NULL, '1'),
(1307, 130, 'HUAROS', '2024-10-11 15:52:01', NULL, '1'),
(1308, 130, 'LACHAQUI', '2024-10-11 15:52:01', NULL, '1'),
(1309, 130, 'SAN BUENAVENTURA', '2024-10-11 15:52:01', NULL, '1'),
(1310, 130, 'SANTA ROSA DE QUIVES', '2024-10-11 15:52:01', NULL, '1'),
(1311, 131, 'SAN VICENTE DE CAÑETE', '2024-10-11 15:52:01', NULL, '1'),
(1312, 131, 'ASIA', '2024-10-11 15:52:01', NULL, '1'),
(1313, 131, 'CALANGO', '2024-10-11 15:52:01', NULL, '1'),
(1314, 131, 'CERRO AZUL', '2024-10-11 15:52:01', NULL, '1'),
(1315, 131, 'CHILCA', '2024-10-11 15:52:01', NULL, '1'),
(1316, 131, 'COAYLLO', '2024-10-11 15:52:01', NULL, '1'),
(1317, 131, 'IMPERIAL', '2024-10-11 15:52:01', NULL, '1'),
(1318, 131, 'LUNAHUANA', '2024-10-11 15:52:01', NULL, '1'),
(1319, 131, 'MALA', '2024-10-11 15:52:01', NULL, '1'),
(1320, 131, 'NUEVO IMPERIAL', '2024-10-11 15:52:01', NULL, '1'),
(1321, 131, 'PACARAN', '2024-10-11 15:52:01', NULL, '1'),
(1322, 131, 'QUILMANA', '2024-10-11 15:52:01', NULL, '1'),
(1323, 131, 'SAN ANTONIO', '2024-10-11 15:52:01', NULL, '1'),
(1324, 131, 'SAN LUIS', '2024-10-11 15:52:01', NULL, '1'),
(1325, 131, 'SANTA CRUZ DE FLORES', '2024-10-11 15:52:01', NULL, '1'),
(1326, 131, 'ZUÑIGA', '2024-10-11 15:52:01', NULL, '1'),
(1327, 132, 'HUARAL', '2024-10-11 15:52:01', NULL, '1'),
(1328, 132, 'ATAVILLOS ALTO', '2024-10-11 15:52:01', NULL, '1'),
(1329, 132, 'ATAVILLOS BAJO', '2024-10-11 15:52:01', NULL, '1'),
(1330, 132, 'AUCALLAMA', '2024-10-11 15:52:01', NULL, '1'),
(1331, 132, 'CHANCAY', '2024-10-11 15:52:01', NULL, '1'),
(1332, 132, 'IHUARI', '2024-10-11 15:52:01', NULL, '1'),
(1333, 132, 'LAMPIAN', '2024-10-11 15:52:01', NULL, '1'),
(1334, 132, 'PACARAOS', '2024-10-11 15:52:01', NULL, '1'),
(1335, 132, 'SAN MIGUEL DE ACOS', '2024-10-11 15:52:01', NULL, '1'),
(1336, 132, 'SANTA CRUZ DE ANDAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1337, 132, 'SUMBILCA', '2024-10-11 15:52:01', NULL, '1'),
(1338, 132, 'VEINTISIETE DE NOVIEMBRE', '2024-10-11 15:52:01', NULL, '1'),
(1339, 133, 'MATUCANA', '2024-10-11 15:52:01', NULL, '1'),
(1340, 133, 'ANTIOQUIA', '2024-10-11 15:52:01', NULL, '1'),
(1341, 133, 'CALLAHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(1342, 133, 'CARAMPOMA', '2024-10-11 15:52:01', NULL, '1'),
(1343, 133, 'CHICLA', '2024-10-11 15:52:01', NULL, '1'),
(1344, 133, 'CUENCA', '2024-10-11 15:52:01', NULL, '1'),
(1345, 133, 'HUACHUPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1346, 133, 'HUANZA', '2024-10-11 15:52:01', NULL, '1'),
(1347, 133, 'HUAROCHIRI', '2024-10-11 15:52:01', NULL, '1'),
(1348, 133, 'LAHUAYTAMBO', '2024-10-11 15:52:01', NULL, '1'),
(1349, 133, 'LANGA', '2024-10-11 15:52:01', NULL, '1'),
(1350, 133, 'LARAOS', '2024-10-11 15:52:01', NULL, '1'),
(1351, 133, 'MARIATANA', '2024-10-11 15:52:01', NULL, '1'),
(1352, 133, 'RICARDO PALMA', '2024-10-11 15:52:01', NULL, '1'),
(1353, 133, 'SAN ANDRES DE TUPICOCHA', '2024-10-11 15:52:01', NULL, '1'),
(1354, 133, 'SAN ANTONIO', '2024-10-11 15:52:01', NULL, '1'),
(1355, 133, 'SAN BARTOLOME', '2024-10-11 15:52:01', NULL, '1'),
(1356, 133, 'SAN DAMIAN', '2024-10-11 15:52:01', NULL, '1'),
(1357, 133, 'SAN JUAN DE IRIS', '2024-10-11 15:52:01', NULL, '1'),
(1358, 133, 'SAN JUAN DE TANTARANCHE', '2024-10-11 15:52:01', NULL, '1'),
(1359, 133, 'SAN LORENZO DE QUINTI', '2024-10-11 15:52:01', NULL, '1'),
(1360, 133, 'SAN MATEO', '2024-10-11 15:52:01', NULL, '1'),
(1361, 133, 'SAN MATEO DE OTAO', '2024-10-11 15:52:01', NULL, '1'),
(1362, 133, 'SAN PEDRO DE CASTA', '2024-10-11 15:52:01', NULL, '1'),
(1363, 133, 'SAN PEDRO DE HUANCAYRE', '2024-10-11 15:52:01', NULL, '1'),
(1364, 133, 'SANGALLAYA', '2024-10-11 15:52:01', NULL, '1'),
(1365, 133, 'SANTA CRUZ DE COCACHACRA', '2024-10-11 15:52:01', NULL, '1'),
(1366, 133, 'SANTA EULALIA', '2024-10-11 15:52:01', NULL, '1'),
(1367, 133, 'SANTIAGO DE ANCHUCAYA', '2024-10-11 15:52:01', NULL, '1'),
(1368, 133, 'SANTIAGO DE TUNA', '2024-10-11 15:52:01', NULL, '1'),
(1369, 133, 'SANTO DOMINGO DE LOS OLLEROS', '2024-10-11 15:52:01', NULL, '1'),
(1370, 133, 'SURCO', '2024-10-11 15:52:01', NULL, '1'),
(1371, 134, 'HUACHO', '2024-10-11 15:52:01', NULL, '1'),
(1372, 134, 'AMBAR', '2024-10-11 15:52:01', NULL, '1'),
(1373, 134, 'CALETA DE CARQUIN', '2024-10-11 15:52:01', NULL, '1'),
(1374, 134, 'CHECRAS', '2024-10-11 15:52:01', NULL, '1'),
(1375, 134, 'HUALMAY', '2024-10-11 15:52:01', NULL, '1'),
(1376, 134, 'HUAURA', '2024-10-11 15:52:01', NULL, '1'),
(1377, 134, 'LEONCIO PRADO', '2024-10-11 15:52:01', NULL, '1'),
(1378, 134, 'PACCHO', '2024-10-11 15:52:01', NULL, '1'),
(1379, 134, 'SANTA LEONOR', '2024-10-11 15:52:01', NULL, '1'),
(1380, 134, 'SANTA MARIA', '2024-10-11 15:52:01', NULL, '1'),
(1381, 134, 'SAYAN', '2024-10-11 15:52:01', NULL, '1'),
(1382, 134, 'VEGUETA', '2024-10-11 15:52:01', NULL, '1'),
(1383, 135, 'OYON', '2024-10-11 15:52:01', NULL, '1'),
(1384, 135, 'ANDAJES', '2024-10-11 15:52:01', NULL, '1'),
(1385, 135, 'CAUJUL', '2024-10-11 15:52:01', NULL, '1'),
(1386, 135, 'COCHAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1387, 135, 'NAVAN', '2024-10-11 15:52:01', NULL, '1'),
(1388, 135, 'PACHANGARA', '2024-10-11 15:52:01', NULL, '1'),
(1389, 136, 'YAUYOS', '2024-10-11 15:52:01', NULL, '1'),
(1390, 136, 'ALIS', '2024-10-11 15:52:01', NULL, '1'),
(1391, 136, 'AYAUCA', '2024-10-11 15:52:01', NULL, '1'),
(1392, 136, 'AYAVIRI', '2024-10-11 15:52:01', NULL, '1'),
(1393, 136, 'AZANGARO', '2024-10-11 15:52:01', NULL, '1'),
(1394, 136, 'CACRA', '2024-10-11 15:52:01', NULL, '1'),
(1395, 136, 'CARANIA', '2024-10-11 15:52:01', NULL, '1'),
(1396, 136, 'CATAHUASI', '2024-10-11 15:52:01', NULL, '1'),
(1397, 136, 'CHOCOS', '2024-10-11 15:52:01', NULL, '1'),
(1398, 136, 'COCHAS', '2024-10-11 15:52:01', NULL, '1'),
(1399, 136, 'COLONIA', '2024-10-11 15:52:01', NULL, '1'),
(1400, 136, 'HONGOS', '2024-10-11 15:52:01', NULL, '1'),
(1401, 136, 'HUAMPARA', '2024-10-11 15:52:01', NULL, '1'),
(1402, 136, 'HUANCAYA', '2024-10-11 15:52:01', NULL, '1'),
(1403, 136, 'HUANGASCAR', '2024-10-11 15:52:01', NULL, '1'),
(1404, 136, 'HUANTAN', '2024-10-11 15:52:01', NULL, '1'),
(1405, 136, 'HUÑEC', '2024-10-11 15:52:01', NULL, '1'),
(1406, 136, 'LARAOS', '2024-10-11 15:52:01', NULL, '1'),
(1407, 136, 'LINCHA', '2024-10-11 15:52:01', NULL, '1'),
(1408, 136, 'MADEAN', '2024-10-11 15:52:01', NULL, '1'),
(1409, 136, 'MIRAFLORES', '2024-10-11 15:52:01', NULL, '1'),
(1410, 136, 'OMAS', '2024-10-11 15:52:01', NULL, '1'),
(1411, 136, 'PUTINZA', '2024-10-11 15:52:01', NULL, '1'),
(1412, 136, 'QUINCHES', '2024-10-11 15:52:01', NULL, '1'),
(1413, 136, 'QUINOCAY', '2024-10-11 15:52:01', NULL, '1'),
(1414, 136, 'SAN JOAQUIN', '2024-10-11 15:52:01', NULL, '1'),
(1415, 136, 'SAN PEDRO DE PILAS', '2024-10-11 15:52:01', NULL, '1'),
(1416, 136, 'TANTA', '2024-10-11 15:52:01', NULL, '1'),
(1417, 136, 'TAURIPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1418, 136, 'TOMAS', '2024-10-11 15:52:01', NULL, '1'),
(1419, 136, 'TUPE', '2024-10-11 15:52:01', NULL, '1'),
(1420, 136, 'VIÑAC', '2024-10-11 15:52:01', NULL, '1'),
(1421, 136, 'VITIS', '2024-10-11 15:52:01', NULL, '1'),
(1422, 137, 'IQUITOS', '2024-10-11 15:52:01', NULL, '1'),
(1423, 137, 'ALTO NANAY', '2024-10-11 15:52:01', NULL, '1'),
(1424, 137, 'FERNANDO LORES', '2024-10-11 15:52:01', NULL, '1'),
(1425, 137, 'INDIANA', '2024-10-11 15:52:01', NULL, '1'),
(1426, 137, 'LAS AMAZONAS', '2024-10-11 15:52:01', NULL, '1'),
(1427, 137, 'MAZAN', '2024-10-11 15:52:01', NULL, '1'),
(1428, 137, 'NAPO', '2024-10-11 15:52:01', NULL, '1'),
(1429, 137, 'PUNCHANA', '2024-10-11 15:52:01', NULL, '1'),
(1430, 137, 'PUTUMAYO', '2024-10-11 15:52:01', NULL, '1'),
(1431, 137, 'TORRES CAUSANA', '2024-10-11 15:52:01', NULL, '1'),
(1432, 137, 'BELEN', '2024-10-11 15:52:01', NULL, '1'),
(1433, 137, 'SAN JUAN BAUTISTA', '2024-10-11 15:52:01', NULL, '1'),
(1434, 138, 'YURIMAGUAS', '2024-10-11 15:52:01', NULL, '1'),
(1435, 138, 'BALSAPUERTO', '2024-10-11 15:52:01', NULL, '1'),
(1436, 138, 'BARRANCA', '2024-10-11 15:52:01', NULL, '1'),
(1437, 138, 'CAHUAPANAS', '2024-10-11 15:52:01', NULL, '1'),
(1438, 138, 'JEBEROS', '2024-10-11 15:52:01', NULL, '1'),
(1439, 138, 'LAGUNAS', '2024-10-11 15:52:01', NULL, '1'),
(1440, 138, 'MANSERICHE', '2024-10-11 15:52:01', NULL, '1'),
(1441, 138, 'MORONA', '2024-10-11 15:52:01', NULL, '1'),
(1442, 138, 'PASTAZA', '2024-10-11 15:52:01', NULL, '1'),
(1443, 138, 'SANTA CRUZ', '2024-10-11 15:52:01', NULL, '1'),
(1444, 138, 'TENIENTE CESAR LOPEZ ROJAS', '2024-10-11 15:52:01', NULL, '1'),
(1445, 139, 'NAUTA', '2024-10-11 15:52:01', NULL, '1'),
(1446, 139, 'PARINARI', '2024-10-11 15:52:01', NULL, '1'),
(1447, 139, 'TIGRE', '2024-10-11 15:52:01', NULL, '1'),
(1448, 139, 'TROMPETEROS', '2024-10-11 15:52:01', NULL, '1'),
(1449, 139, 'URARINAS', '2024-10-11 15:52:01', NULL, '1'),
(1450, 140, 'RAMON CASTILLA', '2024-10-11 15:52:01', NULL, '1'),
(1451, 140, 'PEBAS', '2024-10-11 15:52:01', NULL, '1'),
(1452, 140, 'YAVARI', '2024-10-11 15:52:01', NULL, '1'),
(1453, 140, 'SAN PABLO', '2024-10-11 15:52:01', NULL, '1'),
(1454, 141, 'REQUENA', '2024-10-11 15:52:01', NULL, '1'),
(1455, 141, 'ALTO TAPICHE', '2024-10-11 15:52:01', NULL, '1'),
(1456, 141, 'CAPELO', '2024-10-11 15:52:01', NULL, '1'),
(1457, 141, 'EMILIO SAN MARTIN', '2024-10-11 15:52:01', NULL, '1'),
(1458, 141, 'MAQUIA', '2024-10-11 15:52:01', NULL, '1'),
(1459, 141, 'PUINAHUA', '2024-10-11 15:52:01', NULL, '1'),
(1460, 141, 'SAQUENA', '2024-10-11 15:52:01', NULL, '1'),
(1461, 141, 'SOPLIN', '2024-10-11 15:52:01', NULL, '1'),
(1462, 141, 'TAPICHE', '2024-10-11 15:52:01', NULL, '1'),
(1463, 141, 'JENARO HERRERA', '2024-10-11 15:52:01', NULL, '1'),
(1464, 141, 'YAQUERANA', '2024-10-11 15:52:01', NULL, '1'),
(1465, 142, 'CONTAMANA', '2024-10-11 15:52:01', NULL, '1'),
(1466, 142, 'INAHUAYA', '2024-10-11 15:52:01', NULL, '1'),
(1467, 142, 'PADRE MARQUEZ', '2024-10-11 15:52:01', NULL, '1'),
(1468, 142, 'PAMPA HERMOSA', '2024-10-11 15:52:01', NULL, '1'),
(1469, 142, 'SARAYACU', '2024-10-11 15:52:01', NULL, '1'),
(1470, 142, 'VARGAS GUERRA', '2024-10-11 15:52:01', NULL, '1'),
(1471, 143, 'TAMBOPATA', '2024-10-11 15:52:01', NULL, '1'),
(1472, 143, 'INAMBARI', '2024-10-11 15:52:01', NULL, '1'),
(1473, 143, 'LAS PIEDRAS', '2024-10-11 15:52:01', NULL, '1'),
(1474, 143, 'LABERINTO', '2024-10-11 15:52:01', NULL, '1'),
(1475, 144, 'MANU', '2024-10-11 15:52:01', NULL, '1'),
(1476, 144, 'FITZCARRALD', '2024-10-11 15:52:01', NULL, '1'),
(1477, 144, 'MADRE DE DIOS', '2024-10-11 15:52:01', NULL, '1'),
(1478, 144, 'HUEPETUHE', '2024-10-11 15:52:01', NULL, '1'),
(1479, 145, 'INAPARI', '2024-10-11 15:52:01', NULL, '1'),
(1480, 145, 'IBERIA', '2024-10-11 15:52:01', NULL, '1'),
(1481, 145, 'TAHUAMANU', '2024-10-11 15:52:01', NULL, '1'),
(1482, 146, 'MOQUEGUA', '2024-10-11 15:52:01', NULL, '1'),
(1483, 146, 'CARUMAS', '2024-10-11 15:52:01', NULL, '1'),
(1484, 146, 'CUCHUMBAYA', '2024-10-11 15:52:01', NULL, '1'),
(1485, 146, 'SAMEGUA', '2024-10-11 15:52:01', NULL, '1'),
(1486, 146, 'SAN CRISTOBAL', '2024-10-11 15:52:01', NULL, '1'),
(1487, 146, 'TORATA', '2024-10-11 15:52:01', NULL, '1'),
(1488, 147, 'OMATE', '2024-10-11 15:52:01', NULL, '1'),
(1489, 147, 'CHOJATA', '2024-10-11 15:52:01', NULL, '1'),
(1490, 147, 'COALAQUE', '2024-10-11 15:52:01', NULL, '1'),
(1491, 147, 'ICHUÑA', '2024-10-11 15:52:01', NULL, '1'),
(1492, 147, 'LA CAPILLA', '2024-10-11 15:52:01', NULL, '1'),
(1493, 147, 'LLOQUE', '2024-10-11 15:52:01', NULL, '1'),
(1494, 147, 'MATALAQUE', '2024-10-11 15:52:01', NULL, '1'),
(1495, 147, 'PUQUINA', '2024-10-11 15:52:01', NULL, '1'),
(1496, 147, 'QUINISTAQUILLAS', '2024-10-11 15:52:01', NULL, '1'),
(1497, 147, 'UBINAS', '2024-10-11 15:52:01', NULL, '1'),
(1498, 147, 'YUNGA', '2024-10-11 15:52:01', NULL, '1'),
(1499, 148, 'ILO', '2024-10-11 15:52:01', NULL, '1'),
(1500, 148, 'EL ALGARROBAL', '2024-10-11 15:52:01', NULL, '1'),
(1501, 148, 'PACOCHA', '2024-10-11 15:52:01', NULL, '1'),
(1502, 149, 'CHAUPIMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1503, 149, 'HUACHON', '2024-10-11 15:52:01', NULL, '1'),
(1504, 149, 'HUARIACA', '2024-10-11 15:52:01', NULL, '1'),
(1505, 149, 'HUAYLLAY', '2024-10-11 15:52:01', NULL, '1'),
(1506, 149, 'NINACACA', '2024-10-11 15:52:01', NULL, '1'),
(1507, 149, 'PALLANCHACRA', '2024-10-11 15:52:01', NULL, '1'),
(1508, 149, 'PAUCARTAMBO', '2024-10-11 15:52:01', NULL, '1'),
(1509, 149, 'SAN FCO.DE ASIS DE YARUSYACAN', '2024-10-11 15:52:01', NULL, '1'),
(1510, 149, 'SIMON BOLIVAR', '2024-10-11 15:52:01', NULL, '1'),
(1511, 149, 'TICLACAYAN', '2024-10-11 15:52:01', NULL, '1'),
(1512, 149, 'TINYAHUARCO', '2024-10-11 15:52:01', NULL, '1'),
(1513, 149, 'VICCO', '2024-10-11 15:52:01', NULL, '1'),
(1514, 149, 'YANACANCHA', '2024-10-11 15:52:01', NULL, '1'),
(1515, 150, 'YANAHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(1516, 150, 'CHACAYAN', '2024-10-11 15:52:01', NULL, '1'),
(1517, 150, 'GOYLLARISQUIZGA', '2024-10-11 15:52:01', NULL, '1'),
(1518, 150, 'PAUCAR', '2024-10-11 15:52:01', NULL, '1'),
(1519, 150, 'SAN PEDRO DE PILLAO', '2024-10-11 15:52:01', NULL, '1'),
(1520, 150, 'SANTA ANA DE TUSI', '2024-10-11 15:52:01', NULL, '1'),
(1521, 150, 'TAPUC', '2024-10-11 15:52:01', NULL, '1'),
(1522, 150, 'VILCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1523, 151, 'OXAPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1524, 151, 'CHONTABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1525, 151, 'HUANCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1526, 151, 'PALCAZU', '2024-10-11 15:52:01', NULL, '1'),
(1527, 151, 'POZUZO', '2024-10-11 15:52:01', NULL, '1'),
(1528, 151, 'PUERTO BERMUDEZ', '2024-10-11 15:52:01', NULL, '1'),
(1529, 151, 'VILLA RICA', '2024-10-11 15:52:01', NULL, '1'),
(1530, 152, 'PIURA', '2024-10-11 15:52:01', NULL, '1'),
(1531, 152, 'CASTILLA', '2024-10-11 15:52:01', NULL, '1'),
(1532, 152, 'CATACAOS', '2024-10-11 15:52:01', NULL, '1'),
(1533, 152, 'CURA MORI', '2024-10-11 15:52:01', NULL, '1'),
(1534, 152, 'EL TALLAN', '2024-10-11 15:52:01', NULL, '1'),
(1535, 152, 'LA ARENA', '2024-10-11 15:52:01', NULL, '1'),
(1536, 152, 'LA UNION', '2024-10-11 15:52:01', NULL, '1'),
(1537, 152, 'LAS LOMAS', '2024-10-11 15:52:01', NULL, '1'),
(1538, 152, 'TAMBO GRANDE', '2024-10-11 15:52:01', NULL, '1'),
(1539, 153, 'AYABACA', '2024-10-11 15:52:01', NULL, '1'),
(1540, 153, 'FRIAS', '2024-10-11 15:52:01', NULL, '1'),
(1541, 153, 'JILILI', '2024-10-11 15:52:01', NULL, '1'),
(1542, 153, 'LAGUNAS', '2024-10-11 15:52:01', NULL, '1'),
(1543, 153, 'MONTERO', '2024-10-11 15:52:01', NULL, '1'),
(1544, 153, 'PACAIPAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1545, 153, 'PAIMAS', '2024-10-11 15:52:01', NULL, '1'),
(1546, 153, 'SAPILLICA', '2024-10-11 15:52:01', NULL, '1'),
(1547, 153, 'SICCHEZ', '2024-10-11 15:52:01', NULL, '1'),
(1548, 153, 'SUYO', '2024-10-11 15:52:01', NULL, '1'),
(1549, 154, 'HUANCABAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1550, 154, 'CANCHAQUE', '2024-10-11 15:52:01', NULL, '1'),
(1551, 154, 'EL CARMEN DE LA FRONTERA', '2024-10-11 15:52:01', NULL, '1'),
(1552, 154, 'HUARMACA', '2024-10-11 15:52:01', NULL, '1'),
(1553, 154, 'LALAQUIZ', '2024-10-11 15:52:01', NULL, '1'),
(1554, 154, 'SAN MIGUEL DE EL FAIQUE', '2024-10-11 15:52:01', NULL, '1'),
(1555, 154, 'SONDOR', '2024-10-11 15:52:01', NULL, '1'),
(1556, 154, 'SONDORILLO', '2024-10-11 15:52:01', NULL, '1'),
(1557, 155, 'CHULUCANAS', '2024-10-11 15:52:01', NULL, '1'),
(1558, 155, 'BUENOS AIRES', '2024-10-11 15:52:01', NULL, '1'),
(1559, 155, 'CHALACO', '2024-10-11 15:52:01', NULL, '1'),
(1560, 155, 'LA MATANZA', '2024-10-11 15:52:01', NULL, '1'),
(1561, 155, 'MORROPON', '2024-10-11 15:52:01', NULL, '1'),
(1562, 155, 'SALITRAL', '2024-10-11 15:52:01', NULL, '1'),
(1563, 155, 'SAN JUAN DE BIGOTE', '2024-10-11 15:52:01', NULL, '1'),
(1564, 155, 'SANTA CATALINA DE MOSSA', '2024-10-11 15:52:01', NULL, '1'),
(1565, 155, 'SANTO DOMINGO', '2024-10-11 15:52:01', NULL, '1'),
(1566, 155, 'YAMANGO', '2024-10-11 15:52:01', NULL, '1'),
(1567, 156, 'PAITA', '2024-10-11 15:52:01', NULL, '1'),
(1568, 156, 'AMOTAPE', '2024-10-11 15:52:01', NULL, '1'),
(1569, 156, 'ARENAL', '2024-10-11 15:52:01', NULL, '1'),
(1570, 156, 'COLAN', '2024-10-11 15:52:01', NULL, '1'),
(1571, 156, 'LA HUACA', '2024-10-11 15:52:01', NULL, '1'),
(1572, 156, 'TAMARINDO', '2024-10-11 15:52:01', NULL, '1'),
(1573, 156, 'VICHAYAL', '2024-10-11 15:52:01', NULL, '1'),
(1574, 157, 'SULLANA', '2024-10-11 15:52:01', NULL, '1'),
(1575, 157, 'BELLAVISTA', '2024-10-11 15:52:01', NULL, '1'),
(1576, 157, 'IGNACIO ESCUDERO', '2024-10-11 15:52:01', NULL, '1'),
(1577, 157, 'LANCONES', '2024-10-11 15:52:01', NULL, '1'),
(1578, 157, 'MARCAVELICA', '2024-10-11 15:52:01', NULL, '1'),
(1579, 157, 'MIGUEL CHECA', '2024-10-11 15:52:01', NULL, '1'),
(1580, 157, 'QUERECOTILLO', '2024-10-11 15:52:01', NULL, '1'),
(1581, 157, 'SALITRAL', '2024-10-11 15:52:01', NULL, '1'),
(1582, 158, 'PARIÑAS', '2024-10-11 15:52:01', NULL, '1'),
(1583, 158, 'EL ALTO', '2024-10-11 15:52:01', NULL, '1'),
(1584, 158, 'LA BREA', '2024-10-11 15:52:01', NULL, '1'),
(1585, 158, 'LOBITOS', '2024-10-11 15:52:01', NULL, '1'),
(1586, 158, 'LOS ORGANOS', '2024-10-11 15:52:01', NULL, '1'),
(1587, 158, 'MANCORA', '2024-10-11 15:52:01', NULL, '1'),
(1588, 159, 'SECHURA', '2024-10-11 15:52:01', NULL, '1'),
(1589, 159, 'BELLAVISTA DE LA UNION', '2024-10-11 15:52:01', NULL, '1'),
(1590, 159, 'BERNAL', '2024-10-11 15:52:01', NULL, '1'),
(1591, 159, 'CRISTO NOS VALGA', '2024-10-11 15:52:01', NULL, '1'),
(1592, 159, 'VICE', '2024-10-11 15:52:01', NULL, '1'),
(1593, 159, 'RINCONADA LLICUAR', '2024-10-11 15:52:01', NULL, '1'),
(1594, 160, 'PUNO', '2024-10-11 15:52:01', NULL, '1'),
(1595, 160, 'ACORA', '2024-10-11 15:52:01', NULL, '1'),
(1596, 160, 'AMANTANI', '2024-10-11 15:52:01', NULL, '1'),
(1597, 160, 'ATUNCOLLA', '2024-10-11 15:52:01', NULL, '1'),
(1598, 160, 'CAPACHICA', '2024-10-11 15:52:01', NULL, '1'),
(1599, 160, 'CHUCUITO', '2024-10-11 15:52:01', NULL, '1'),
(1600, 160, 'COATA', '2024-10-11 15:52:01', NULL, '1'),
(1601, 160, 'HUATA', '2024-10-11 15:52:01', NULL, '1'),
(1602, 160, 'MAÑAZO', '2024-10-11 15:52:01', NULL, '1'),
(1603, 160, 'PAUCARCOLLA', '2024-10-11 15:52:01', NULL, '1'),
(1604, 160, 'PICHACANI', '2024-10-11 15:52:01', NULL, '1'),
(1605, 160, 'PLATERIA', '2024-10-11 15:52:01', NULL, '1'),
(1606, 160, 'SAN ANTONIO', '2024-10-11 15:52:01', NULL, '1'),
(1607, 160, 'TIQUILLACA', '2024-10-11 15:52:01', NULL, '1'),
(1608, 160, 'VILQUE', '2024-10-11 15:52:01', NULL, '1'),
(1609, 161, 'AZANGARO', '2024-10-11 15:52:01', NULL, '1'),
(1610, 161, 'ACHAYA', '2024-10-11 15:52:01', NULL, '1'),
(1611, 161, 'ARAPA', '2024-10-11 15:52:01', NULL, '1'),
(1612, 161, 'ASILLO', '2024-10-11 15:52:01', NULL, '1'),
(1613, 161, 'CAMINACA', '2024-10-11 15:52:01', NULL, '1'),
(1614, 161, 'CHUPA', '2024-10-11 15:52:01', NULL, '1'),
(1615, 161, 'JOSE DOMINGO CHOQUEHUANCA', '2024-10-11 15:52:01', NULL, '1'),
(1616, 161, 'MUÑANI', '2024-10-11 15:52:01', NULL, '1'),
(1617, 161, 'POTONI', '2024-10-11 15:52:01', NULL, '1'),
(1618, 161, 'SAMAN', '2024-10-11 15:52:01', NULL, '1'),
(1619, 161, 'SAN ANTON', '2024-10-11 15:52:01', NULL, '1'),
(1620, 161, 'SAN JOSE', '2024-10-11 15:52:01', NULL, '1'),
(1621, 161, 'SAN JUAN DE SALINAS', '2024-10-11 15:52:01', NULL, '1'),
(1622, 161, 'SANTIAGO DE PUPUJA', '2024-10-11 15:52:01', NULL, '1'),
(1623, 161, 'TIRAPATA', '2024-10-11 15:52:01', NULL, '1'),
(1624, 162, 'MACUSANI', '2024-10-11 15:52:01', NULL, '1'),
(1625, 162, 'AJOYANI', '2024-10-11 15:52:01', NULL, '1'),
(1626, 162, 'AYAPATA', '2024-10-11 15:52:01', NULL, '1'),
(1627, 162, 'COASA', '2024-10-11 15:52:01', NULL, '1'),
(1628, 162, 'CORANI', '2024-10-11 15:52:01', NULL, '1'),
(1629, 162, 'CRUCERO', '2024-10-11 15:52:01', NULL, '1'),
(1630, 162, 'ITUATA', '2024-10-11 15:52:01', NULL, '1'),
(1631, 162, 'OLLACHEA', '2024-10-11 15:52:01', NULL, '1'),
(1632, 162, 'SAN GABAN', '2024-10-11 15:52:01', NULL, '1'),
(1633, 162, 'USICAYOS', '2024-10-11 15:52:01', NULL, '1'),
(1634, 163, 'JULI', '2024-10-11 15:52:01', NULL, '1'),
(1635, 163, 'DESAGUADERO', '2024-10-11 15:52:01', NULL, '1'),
(1636, 163, 'HUACULLANI', '2024-10-11 15:52:01', NULL, '1'),
(1637, 163, 'KELLUYO', '2024-10-11 15:52:01', NULL, '1'),
(1638, 163, 'PISACOMA', '2024-10-11 15:52:01', NULL, '1'),
(1639, 163, 'POMATA', '2024-10-11 15:52:01', NULL, '1'),
(1640, 163, 'ZEPITA', '2024-10-11 15:52:01', NULL, '1'),
(1641, 164, 'ILAVE', '2024-10-11 15:52:01', NULL, '1'),
(1642, 164, 'CAPAZO', '2024-10-11 15:52:01', NULL, '1'),
(1643, 164, 'PILCUYO', '2024-10-11 15:52:01', NULL, '1'),
(1644, 164, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(1645, 164, 'CONDURIRI', '2024-10-11 15:52:01', NULL, '1'),
(1646, 165, 'HUANCANE', '2024-10-11 15:52:01', NULL, '1'),
(1647, 165, 'COJATA', '2024-10-11 15:52:01', NULL, '1'),
(1648, 165, 'HUATASANI', '2024-10-11 15:52:01', NULL, '1'),
(1649, 165, 'INCHUPALLA', '2024-10-11 15:52:01', NULL, '1'),
(1650, 165, 'PUSI', '2024-10-11 15:52:01', NULL, '1'),
(1651, 165, 'ROSASPATA', '2024-10-11 15:52:01', NULL, '1'),
(1652, 165, 'TARACO', '2024-10-11 15:52:01', NULL, '1'),
(1653, 165, 'VILQUE CHICO', '2024-10-11 15:52:01', NULL, '1'),
(1654, 166, 'LAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1655, 166, 'CABANILLA', '2024-10-11 15:52:01', NULL, '1'),
(1656, 166, 'CALAPUJA', '2024-10-11 15:52:01', NULL, '1'),
(1657, 166, 'NICASIO', '2024-10-11 15:52:01', NULL, '1'),
(1658, 166, 'OCUVIRI', '2024-10-11 15:52:01', NULL, '1'),
(1659, 166, 'PALCA', '2024-10-11 15:52:01', NULL, '1'),
(1660, 166, 'PARATIA', '2024-10-11 15:52:01', NULL, '1'),
(1661, 166, 'PUCARA', '2024-10-11 15:52:01', NULL, '1'),
(1662, 166, 'SANTA LUCIA', '2024-10-11 15:52:01', NULL, '1'),
(1663, 166, 'VILAVILA', '2024-10-11 15:52:01', NULL, '1'),
(1664, 167, 'AYAVIRI', '2024-10-11 15:52:01', NULL, '1'),
(1665, 167, 'ANTAUTA', '2024-10-11 15:52:01', NULL, '1'),
(1666, 167, 'CUPI', '2024-10-11 15:52:01', NULL, '1'),
(1667, 167, 'LLALLI', '2024-10-11 15:52:01', NULL, '1'),
(1668, 167, 'MACARI', '2024-10-11 15:52:01', NULL, '1'),
(1669, 167, 'NUÑOA', '2024-10-11 15:52:01', NULL, '1'),
(1670, 167, 'ORURILLO', '2024-10-11 15:52:01', NULL, '1'),
(1671, 167, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(1672, 167, 'UMACHIRI', '2024-10-11 15:52:01', NULL, '1'),
(1673, 168, 'MOHO', '2024-10-11 15:52:01', NULL, '1'),
(1674, 168, 'CONIMA', '2024-10-11 15:52:01', NULL, '1'),
(1675, 168, 'HUAYRAPATA', '2024-10-11 15:52:01', NULL, '1'),
(1676, 168, 'TILALI', '2024-10-11 15:52:01', NULL, '1'),
(1677, 169, 'PUTINA', '2024-10-11 15:52:01', NULL, '1'),
(1678, 169, 'ANANEA', '2024-10-11 15:52:01', NULL, '1'),
(1679, 169, 'PEDRO VILCA APAZA', '2024-10-11 15:52:01', NULL, '1'),
(1680, 169, 'QUILCAPUNCU', '2024-10-11 15:52:01', NULL, '1'),
(1681, 169, 'SINA', '2024-10-11 15:52:01', NULL, '1'),
(1682, 170, 'JULIACA', '2024-10-11 15:52:01', NULL, '1'),
(1683, 170, 'CABANA', '2024-10-11 15:52:01', NULL, '1'),
(1684, 170, 'CABANILLAS', '2024-10-11 15:52:01', NULL, '1'),
(1685, 170, 'CARACOTO', '2024-10-11 15:52:01', NULL, '1'),
(1686, 171, 'SANDIA', '2024-10-11 15:52:01', NULL, '1'),
(1687, 171, 'CUYOCUYO', '2024-10-11 15:52:01', NULL, '1'),
(1688, 171, 'LIMBANI', '2024-10-11 15:52:01', NULL, '1'),
(1689, 171, 'PATAMBUCO', '2024-10-11 15:52:01', NULL, '1'),
(1690, 171, 'PHARA', '2024-10-11 15:52:01', NULL, '1'),
(1691, 171, 'QUIACA', '2024-10-11 15:52:01', NULL, '1'),
(1692, 171, 'SAN JUAN DEL ORO', '2024-10-11 15:52:01', NULL, '1'),
(1693, 171, 'YANAHUAYA', '2024-10-11 15:52:01', NULL, '1'),
(1694, 171, 'ALTO INAMBARI', '2024-10-11 15:52:01', NULL, '1'),
(1695, 172, 'YUNGUYO', '2024-10-11 15:52:01', NULL, '1'),
(1696, 172, 'ANAPIA', '2024-10-11 15:52:01', NULL, '1'),
(1697, 172, 'COPANI', '2024-10-11 15:52:01', NULL, '1'),
(1698, 172, 'CUTURAPI', '2024-10-11 15:52:01', NULL, '1'),
(1699, 172, 'OLLARAYA', '2024-10-11 15:52:01', NULL, '1'),
(1700, 172, 'TINICACHI', '2024-10-11 15:52:01', NULL, '1'),
(1701, 172, 'UNICACHI', '2024-10-11 15:52:01', NULL, '1'),
(1702, 173, 'MOYOBAMBA', '2024-10-11 15:52:01', NULL, '1'),
(1703, 173, 'CALZADA', '2024-10-11 15:52:01', NULL, '1'),
(1704, 173, 'HABANA', '2024-10-11 15:52:01', NULL, '1'),
(1705, 173, 'JEPELACIO', '2024-10-11 15:52:01', NULL, '1'),
(1706, 173, 'SORITOR', '2024-10-11 15:52:01', NULL, '1'),
(1707, 173, 'YANTALO', '2024-10-11 15:52:01', NULL, '1'),
(1708, 174, 'BELLAVISTA', '2024-10-11 15:52:01', NULL, '1'),
(1709, 174, 'ALTO BIAVO', '2024-10-11 15:52:01', NULL, '1'),
(1710, 174, 'BAJO BIAVO', '2024-10-11 15:52:01', NULL, '1'),
(1711, 174, 'HUALLAGA', '2024-10-11 15:52:01', NULL, '1'),
(1712, 174, 'SAN PABLO', '2024-10-11 15:52:01', NULL, '1'),
(1713, 174, 'SAN RAFAEL', '2024-10-11 15:52:01', NULL, '1'),
(1714, 175, 'SAN JOSE DE SISA', '2024-10-11 15:52:01', NULL, '1'),
(1715, 175, 'AGUA BLANCA', '2024-10-11 15:52:01', NULL, '1'),
(1716, 175, 'SAN MARTIN', '2024-10-11 15:52:01', NULL, '1'),
(1717, 175, 'SANTA ROSA', '2024-10-11 15:52:01', NULL, '1'),
(1718, 175, 'SHATOJA', '2024-10-11 15:52:01', NULL, '1'),
(1719, 176, 'SAPOSOA', '2024-10-11 15:52:01', NULL, '1'),
(1720, 176, 'ALTO SAPOSOA', '2024-10-11 15:52:01', NULL, '1'),
(1721, 176, 'EL ESLABON', '2024-10-11 15:52:01', NULL, '1'),
(1722, 176, 'PISCOYACU', '2024-10-11 15:52:01', NULL, '1'),
(1723, 176, 'SACANCHE', '2024-10-11 15:52:01', NULL, '1'),
(1724, 176, 'TINGO DE SAPOSOA', '2024-10-11 15:52:01', NULL, '1'),
(1725, 177, 'LAMAS', '2024-10-11 15:52:01', NULL, '1'),
(1726, 177, 'ALONSO DE ALVARADO', '2024-10-11 15:52:01', NULL, '1'),
(1727, 177, 'BARRANQUITA', '2024-10-11 15:52:01', NULL, '1'),
(1728, 177, 'CAYNARACHI', '2024-10-11 15:52:01', NULL, '1'),
(1729, 177, 'CUÑUMBUQUI', '2024-10-11 15:52:01', NULL, '1'),
(1730, 177, 'PINTO RECODO', '2024-10-11 15:52:01', NULL, '1'),
(1731, 177, 'RUMISAPA', '2024-10-11 15:52:01', NULL, '1'),
(1732, 177, 'SAN ROQUE DE CUMBAZA', '2024-10-11 15:52:01', NULL, '1'),
(1733, 177, 'SHANAO', '2024-10-11 15:52:01', NULL, '1'),
(1734, 177, 'TABALOSOS', '2024-10-11 15:52:01', NULL, '1'),
(1735, 177, 'ZAPATERO', '2024-10-11 15:52:01', NULL, '1'),
(1736, 178, 'JUANJUI', '2024-10-11 15:52:01', NULL, '1'),
(1737, 178, 'CAMPANILLA', '2024-10-11 15:52:01', NULL, '1'),
(1738, 178, 'HUICUNGO', '2024-10-11 15:52:01', NULL, '1'),
(1739, 178, 'PACHIZA', '2024-10-11 15:52:01', NULL, '1'),
(1740, 178, 'PAJARILLO', '2024-10-11 15:52:01', NULL, '1'),
(1741, 179, 'PICOTA', '2024-10-11 15:52:01', NULL, '1'),
(1742, 179, 'BUENOS AIRES', '2024-10-11 15:52:01', NULL, '1'),
(1743, 179, 'CASPISAPA', '2024-10-11 15:52:01', NULL, '1'),
(1744, 179, 'PILLUANA', '2024-10-11 15:52:01', NULL, '1'),
(1745, 179, 'PUCACACA', '2024-10-11 15:52:01', NULL, '1'),
(1746, 179, 'SAN CRISTOBAL', '2024-10-11 15:52:01', NULL, '1'),
(1747, 179, 'SAN HILARION', '2024-10-11 15:52:01', NULL, '1'),
(1748, 179, 'SHAMBOYACU', '2024-10-11 15:52:01', NULL, '1'),
(1749, 179, 'TINGO DE PONASA', '2024-10-11 15:52:01', NULL, '1'),
(1750, 179, 'TRES UNIDOS', '2024-10-11 15:52:01', NULL, '1'),
(1751, 180, 'RIOJA', '2024-10-11 15:52:01', NULL, '1'),
(1752, 180, 'AWAJUN', '2024-10-11 15:52:01', NULL, '1');
INSERT INTO `distritos` (`iddistrito`, `idprovincia`, `distrito`, `create_at`, `update_at`, `estado`) VALUES
(1753, 180, 'ELIAS SOPLIN VARGAS', '2024-10-11 15:52:01', NULL, '1'),
(1754, 180, 'NUEVA CAJAMARCA', '2024-10-11 15:52:01', NULL, '1'),
(1755, 180, 'PARDO MIGUEL', '2024-10-11 15:52:01', NULL, '1'),
(1756, 180, 'POSIC', '2024-10-11 15:52:01', NULL, '1'),
(1757, 180, 'SAN FERNANDO', '2024-10-11 15:52:01', NULL, '1'),
(1758, 180, 'YORONGOS', '2024-10-11 15:52:01', NULL, '1'),
(1759, 180, 'YURACYACU', '2024-10-11 15:52:01', NULL, '1'),
(1760, 181, 'TARAPOTO', '2024-10-11 15:52:01', NULL, '1'),
(1761, 181, 'ALBERTO LEVEAU', '2024-10-11 15:52:01', NULL, '1'),
(1762, 181, 'CACATACHI', '2024-10-11 15:52:01', NULL, '1'),
(1763, 181, 'CHAZUTA', '2024-10-11 15:52:01', NULL, '1'),
(1764, 181, 'CHIPURANA', '2024-10-11 15:52:01', NULL, '1'),
(1765, 181, 'EL PORVENIR', '2024-10-11 15:52:01', NULL, '1'),
(1766, 181, 'HUIMBAYOC', '2024-10-11 15:52:01', NULL, '1'),
(1767, 181, 'JUAN GUERRA', '2024-10-11 15:52:01', NULL, '1'),
(1768, 181, 'LA BANDA DE SHILCAYO', '2024-10-11 15:52:01', NULL, '1'),
(1769, 181, 'MORALES', '2024-10-11 15:52:01', NULL, '1'),
(1770, 181, 'PAPAPLAYA', '2024-10-11 15:52:01', NULL, '1'),
(1771, 181, 'SAN ANTONIO', '2024-10-11 15:52:01', NULL, '1'),
(1772, 181, 'SAUCE', '2024-10-11 15:52:01', NULL, '1'),
(1773, 181, 'SHAPAJA', '2024-10-11 15:52:01', NULL, '1'),
(1774, 182, 'TOCACHE', '2024-10-11 15:52:01', NULL, '1'),
(1775, 182, 'NUEVO PROGRESO', '2024-10-11 15:52:01', NULL, '1'),
(1776, 182, 'POLVORA', '2024-10-11 15:52:01', NULL, '1'),
(1777, 182, 'SHUNTE', '2024-10-11 15:52:01', NULL, '1'),
(1778, 182, 'UCHIZA', '2024-10-11 15:52:01', NULL, '1'),
(1779, 183, 'TACNA', '2024-10-11 15:52:01', NULL, '1'),
(1780, 183, 'ALTO DE LA ALIANZA', '2024-10-11 15:52:01', NULL, '1'),
(1781, 183, 'CALANA', '2024-10-11 15:52:01', NULL, '1'),
(1782, 183, 'CIUDAD NUEVA', '2024-10-11 15:52:01', NULL, '1'),
(1783, 183, 'INCLAN', '2024-10-11 15:52:01', NULL, '1'),
(1784, 183, 'PACHIA', '2024-10-11 15:52:01', NULL, '1'),
(1785, 183, 'PALCA', '2024-10-11 15:52:01', NULL, '1'),
(1786, 183, 'POCOLLAY', '2024-10-11 15:52:01', NULL, '1'),
(1787, 183, 'SAMA', '2024-10-11 15:52:01', NULL, '1'),
(1788, 183, 'CORONEL GREGORIO ALBARRACIN LANCHIPA', '2024-10-11 15:52:01', NULL, '1'),
(1789, 184, 'CANDARAVE', '2024-10-11 15:52:01', NULL, '1'),
(1790, 184, 'CAIRANI', '2024-10-11 15:52:01', NULL, '1'),
(1791, 184, 'CAMILACA', '2024-10-11 15:52:01', NULL, '1'),
(1792, 184, 'CURIBAYA', '2024-10-11 15:52:01', NULL, '1'),
(1793, 184, 'HUANUARA', '2024-10-11 15:52:01', NULL, '1'),
(1794, 184, 'QUILAHUANI', '2024-10-11 15:52:01', NULL, '1'),
(1795, 185, 'LOCUMBA', '2024-10-11 15:52:01', NULL, '1'),
(1796, 185, 'ILABAYA', '2024-10-11 15:52:01', NULL, '1'),
(1797, 185, 'ITE', '2024-10-11 15:52:01', NULL, '1'),
(1798, 186, 'TARATA', '2024-10-11 15:52:01', NULL, '1'),
(1799, 186, 'CHUCATAMANI', '2024-10-11 15:52:01', NULL, '1'),
(1800, 186, 'ESTIQUE', '2024-10-11 15:52:01', NULL, '1'),
(1801, 186, 'ESTIQUE-PAMPA', '2024-10-11 15:52:01', NULL, '1'),
(1802, 186, 'SITAJARA', '2024-10-11 15:52:01', NULL, '1'),
(1803, 186, 'SUSAPAYA', '2024-10-11 15:52:01', NULL, '1'),
(1804, 186, 'TARUCACHI', '2024-10-11 15:52:01', NULL, '1'),
(1805, 186, 'TICACO', '2024-10-11 15:52:01', NULL, '1'),
(1806, 187, 'TUMBES', '2024-10-11 15:52:01', NULL, '1'),
(1807, 187, 'CORRALES', '2024-10-11 15:52:01', NULL, '1'),
(1808, 187, 'LA CRUZ', '2024-10-11 15:52:01', NULL, '1'),
(1809, 187, 'PAMPAS DE HOSPITAL', '2024-10-11 15:52:01', NULL, '1'),
(1810, 187, 'SAN JACINTO', '2024-10-11 15:52:01', NULL, '1'),
(1811, 187, 'SAN JUAN DE LA VIRGEN', '2024-10-11 15:52:01', NULL, '1'),
(1812, 188, 'ZORRITOS', '2024-10-11 15:52:01', NULL, '1'),
(1813, 188, 'CASITAS', '2024-10-11 15:52:01', NULL, '1'),
(1814, 189, 'ZARUMILLA', '2024-10-11 15:52:01', NULL, '1'),
(1815, 189, 'AGUAS VERDES', '2024-10-11 15:52:01', NULL, '1'),
(1816, 189, 'MATAPALO', '2024-10-11 15:52:01', NULL, '1'),
(1817, 189, 'PAPAYAL', '2024-10-11 15:52:01', NULL, '1'),
(1818, 190, 'CALLERIA', '2024-10-11 15:52:01', NULL, '1'),
(1819, 190, 'CAMPOVERDE', '2024-10-11 15:52:01', NULL, '1'),
(1820, 190, 'IPARIA', '2024-10-11 15:52:01', NULL, '1'),
(1821, 190, 'MASISEA', '2024-10-11 15:52:01', NULL, '1'),
(1822, 190, 'YARINACOCHA', '2024-10-11 15:52:01', NULL, '1'),
(1823, 190, 'NUEVA REQUENA', '2024-10-11 15:52:01', NULL, '1'),
(1824, 191, 'RAYMONDI', '2024-10-11 15:52:01', NULL, '1'),
(1825, 191, 'SEPAHUA', '2024-10-11 15:52:01', NULL, '1'),
(1826, 191, 'TAHUANIA', '2024-10-11 15:52:01', NULL, '1'),
(1827, 191, 'YURUA', '2024-10-11 15:52:01', NULL, '1'),
(1828, 192, 'PADRE ABAD', '2024-10-11 15:52:01', NULL, '1'),
(1829, 192, 'IRAZOLA', '2024-10-11 15:52:01', NULL, '1'),
(1830, 192, 'CURIMANA', '2024-10-11 15:52:01', NULL, '1'),
(1831, 193, 'PURUS', '2024-10-11 15:52:01', NULL, '1'),
(1832, 190, 'MANANTAY', '2024-10-11 15:52:01', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas`
--

CREATE TABLE `empresas` (
  `idempresaruc` bigint(20) NOT NULL,
  `iddistrito` int(11) NOT NULL,
  `razonsocial` varchar(100) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefono` char(9) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `empresas`
--

INSERT INTO `empresas` (`idempresaruc`, `iddistrito`, `razonsocial`, `direccion`, `email`, `telefono`, `create_at`, `update_at`, `inactive_at`, `estado`) VALUES
(20123456780, 954, 'Dijisa', 'Av. Bancarios ', 'santafe@gmail.com', '987654321', '2024-10-11 16:04:21', NULL, NULL, '1'),
(20123456781, 954, 'Archor', 'Av. Bancarios ', 'santafe@gmail.com', '987654321', '2024-10-11 16:04:21', NULL, NULL, '1'),
(20123456782, 954, 'JRCA', 'Av. Bancarios ', 'santafe@gmail.com', '987654321', '2024-10-11 16:04:22', NULL, NULL, '1'),
(20123456783, 954, 'JRC', 'Av. Bancarios ', 'santa1fe@gmail.com', '987654321', '2024-10-11 16:04:11', NULL, NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entidades_roles`
--

CREATE TABLE `entidades_roles` (
  `id_entidad_rol` int(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `idacceso` int(11) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `kardex`
--

CREATE TABLE `kardex` (
  `idkardex` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `numlote` varchar(60) DEFAULT NULL,
  `stockactual` int(11) DEFAULT 0,
  `tipomovimiento` enum('Ingreso','Salida') NOT NULL,
  `cantidad` int(11) NOT NULL,
  `motivo` varchar(255) DEFAULT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `kardex`
--

INSERT INTO `kardex` (`idkardex`, `idusuario`, `idproducto`, `fecha_vencimiento`, `numlote`, `stockactual`, `tipomovimiento`, `cantidad`, `motivo`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 1, '2023-10-05', 'LOT002', 100, 'Ingreso', 100, 'Ingreso de productos adicionales', '2024-10-11 16:05:11', NULL, '1'),
(2, 1, 2, '2023-10-05', 'LOT002', 125, 'Ingreso', 125, 'Ingreso de productos para venta', '2024-10-11 16:05:11', NULL, '1'),
(3, 1, 3, '2023-10-05', 'LOT002', 150, 'Ingreso', 150, 'Ingreso de productos adicionales', '2024-10-11 16:05:11', NULL, '1'),
(4, 1, 4, '2023-10-05', 'LOT002', 200, 'Ingreso', 200, 'Ingreso de productos adicionales', '2024-10-11 16:05:11', NULL, '1'),
(5, 1, 5, '2023-10-05', 'LOT002', 225, 'Ingreso', 225, 'Ingreso de productos adicionales', '2024-10-11 16:05:12', NULL, '1'),
(6, 1, 6, '2023-10-05', 'LOT002', 250, 'Ingreso', 250, 'Ingreso de productos adicionales', '2024-10-11 16:05:12', NULL, '1'),
(7, 1, 7, '2023-10-05', 'LOT002', 300, 'Ingreso', 300, 'Ingreso de productos adicionales', '2024-10-11 16:05:12', NULL, '1'),
(8, 1, 8, '2023-10-05', 'LOT002', 325, 'Ingreso', 325, 'Ingreso de productos adicionales', '2024-10-11 16:05:12', NULL, '1'),
(9, 1, 9, '2023-10-05', 'LOT002', 350, 'Ingreso', 350, 'Ingreso de productos adicionales', '2024-10-11 16:05:12', NULL, '1'),
(10, 1, 10, '2023-10-05', 'LOT002', 400, 'Ingreso', 400, 'Ingreso de productos adicionales', '2024-10-11 16:05:12', NULL, '1'),
(11, 1, 11, '2023-10-05', 'LOT002', 425, 'Ingreso', 425, 'Ingreso de productos adicionales', '2024-10-11 16:05:12', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `idmarca` int(11) NOT NULL,
  `marca` varchar(150) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`idmarca`, `marca`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Coca Cola', '2024-10-11 16:04:10', NULL, '1'),
(2, 'Inca Kola', '2024-10-11 16:04:10', NULL, '1'),
(3, 'Ariel', '2024-10-11 16:04:10', NULL, '1'),
(4, 'Ace', '2024-10-11 16:04:10', NULL, '1'),
(5, 'Pantene', '2024-10-11 16:04:10', NULL, '1'),
(6, 'Sedal', '2024-10-11 16:04:10', NULL, '1'),
(7, 'Dog Chow', '2024-10-11 16:04:10', NULL, '1'),
(8, 'Pedigree', '2024-10-11 16:04:10', NULL, '1'),
(9, 'Nestlé', '2024-10-11 16:04:10', NULL, '1'),
(10, 'Gloria', '2024-10-11 16:04:10', NULL, '1'),
(11, 'Colgate', '2024-10-11 16:04:10', NULL, '1'),
(12, 'Huggies', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodos_pago`
--

CREATE TABLE `metodos_pago` (
  `idmetodopago` int(11) NOT NULL,
  `metodopago` varchar(150) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `metodos_pago`
--

INSERT INTO `metodos_pago` (`idmetodopago`, `metodopago`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Efectivo', '2024-10-11 16:04:10', NULL, '1'),
(2, 'Transferencia', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `idpedido` char(15) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idcliente` int(11) NOT NULL,
  `fecha_pedido` datetime NOT NULL DEFAULT current_timestamp(),
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(10) NOT NULL DEFAULT 'Pendiente'
) ;

--
-- Disparadores `pedidos`
--
DELIMITER $$
CREATE TRIGGER `before_insert_pedidos` BEFORE INSERT ON `pedidos` FOR EACH ROW BEGIN
    DECLARE nuevo_id CHAR(15); 
    SET nuevo_id = CONCAT('PED-', LPAD((SELECT COUNT(*) + 1 FROM pedidos), 9, '0'));
    SET NEW.idpedido = nuevo_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `idtipodocumento` int(11) NOT NULL,
  `idpersonanrodoc` char(11) NOT NULL,
  `iddistrito` int(11) NOT NULL,
  `nombres` varchar(80) NOT NULL,
  `appaterno` varchar(80) NOT NULL,
  `apmaterno` varchar(80) NOT NULL,
  `telefono` char(9) DEFAULT NULL,
  `direccion` varchar(250) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`idtipodocumento`, `idpersonanrodoc`, `iddistrito`, `nombres`, `appaterno`, `apmaterno`, `telefono`, `direccion`, `create_at`, `update_at`, `estado`) VALUES
(1, '26558000', 1, 'Miguel', 'Loyola', 'Torres', NULL, 'Calle Falsa 123', '2024-10-11 16:04:21', NULL, '1'),
(1, '26558001', 1, 'pepito', 'Levano', 'Martinez', NULL, 'Calle Falsa 123', '2024-10-11 16:04:21', NULL, '1'),
(1, '26558002', 2, 'pepito', 'Levano', 'Martinez', NULL, 'Calle Falsa 123', '2024-10-11 16:04:21', NULL, '1'),
(1, '26558003', 2, 'pepito', 'Levano', 'Martinez', NULL, 'Calle Falsa 123', '2024-10-11 16:04:21', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `precios_historicos`
--

CREATE TABLE `precios_historicos` (
  `id_precio_historico` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `precio_antiguo` decimal(10,2) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `idproducto` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `idsubcategoria` int(11) NOT NULL,
  `nombreproducto` varchar(250) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `codigo` char(30) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`idproducto`, `idmarca`, `idsubcategoria`, `nombreproducto`, `descripcion`, `codigo`, `create_at`, `update_at`, `estado`) VALUES
(1, 9, 1, 'Atún Nestlé en Aceite', 'Lata de atún en aceite vegetal 170g', 'AL001CON', '2024-10-11 16:04:10', NULL, '1'),
(2, 9, 1, 'Sardinas Nestlé en Tomate', 'Lata de sardinas en salsa de tomate 240g', 'AL002CON', '2024-10-11 16:04:10', NULL, '1'),
(3, 9, 2, 'Avena Nestlé Instantánea', 'Avena instantánea de 500g', 'AL001CER', '2024-10-11 16:04:10', NULL, '1'),
(4, 9, 2, 'Quinua Orgánica Nestlé', 'Bolsa de quinua orgánica 500g', 'AL002CER', '2024-10-11 16:04:10', NULL, '1'),
(5, 1, 5, 'Coca Cola 500ml', 'Bebida gaseosa Coca Cola en botella de 500ml', 'BEV001GAS', '2024-10-11 16:04:10', NULL, '1'),
(6, 1, 5, 'Coca Cola 2L', 'Bebida gaseosa Coca Cola en botella de 2L', 'BEV002GAS', '2024-10-11 16:04:10', NULL, '1'),
(7, 2, 5, 'Inca Kola 500ml', 'Bebida gaseosa Inca Kola en botella de 500ml', 'BEV003GAS', '2024-10-11 16:04:11', NULL, '1'),
(8, 2, 5, 'Inca Kola 2L', 'Bebida gaseosa Inca Kola en botella de 2L', 'BEV004GAS', '2024-10-11 16:04:11', NULL, '1'),
(9, 3, 8, 'Detergente Ariel 1kg', 'Detergente en polvo Ariel 1kg', 'LH001DET', '2024-10-11 16:04:11', NULL, '1'),
(10, 4, 8, 'Detergente líquido Ace 900ml', 'Detergente líquido para ropa blanca y color 900ml', 'LH002DET', '2024-10-11 16:04:11', NULL, '1'),
(11, 5, 10, 'Shampoo Pantene 400ml', 'Shampoo para todo tipo de cabello', 'CP001CAB', '2024-10-11 16:04:11', NULL, '1'),
(12, 5, 10, 'Acondicionador Pantene 350ml', 'Acondicionador hidratante para cabello seco', 'CP002CAB', '2024-10-11 16:04:11', NULL, '1'),
(13, 6, 10, 'Shampoo Sedal 400ml', 'Shampoo revitalizante para cabello graso', 'CP003CAB', '2024-10-11 16:04:11', NULL, '1'),
(14, 6, 10, 'Acondicionador Sedal 350ml', 'Acondicionador para cabello liso y brillante', 'CP004CAB', '2024-10-11 16:04:11', NULL, '1'),
(15, 7, 17, 'Dog Chow Adultos 4kg', 'Alimento balanceado para perros adultos', 'MASC001PER', '2024-10-11 16:04:11', NULL, '1'),
(16, 7, 17, 'Dog Chow Cachorros 2kg', 'Alimento para cachorros', 'MASC002PER', '2024-10-11 16:04:11', NULL, '1'),
(17, 8, 18, 'Pedigree Gatos Adultos 3kg', 'Alimento completo para gatos adultos', 'MASC001GAT', '2024-10-11 16:04:11', NULL, '1'),
(18, 8, 18, 'Pedigree Gatos Cachorros 1.5kg', 'Alimento nutritivo para gatitos', 'MASC002GAT', '2024-10-11 16:04:11', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `promociones`
--

CREATE TABLE `promociones` (
  `idpromocion` int(11) NOT NULL,
  `idtipopromocion` int(11) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `fechainicio` date NOT NULL,
  `fechafin` date NOT NULL,
  `valor_descuento` decimal(8,2) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `promociones`
--

INSERT INTO `promociones` (`idpromocion`, `idtipopromocion`, `descripcion`, `fechainicio`, `fechafin`, `valor_descuento`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 'Descuento de Temporada', '2024-06-01', '2024-06-30', 5.00, '2024-10-11 16:04:11', NULL, '1'),
(2, 2, 'Descuento del 5% por und', '2021-06-01', '2021-06-30', 5.00, '2024-10-11 16:04:11', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `idproveedor` int(11) NOT NULL,
  `idempresa` bigint(20) NOT NULL,
  `proveedor` varchar(100) NOT NULL,
  `contacto_principal` varchar(50) NOT NULL,
  `telefono_contacto` char(9) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `inactive_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`idproveedor`, `idempresa`, `proveedor`, `contacto_principal`, `telefono_contacto`, `direccion`, `email`, `create_at`, `update_at`, `inactive_at`, `estado`) VALUES
(1, 20123456783, 'Proveedor Ejemplo', 'Juan Pérez', '987654321', 'Av. Principal 123, Ciudad', 'contacto@proveedorejemplo.com', '2024-10-11 16:04:11', NULL, NULL, '1'),
(2, 20123456781, '1', 'José Carlos', '932143290', 'Av. el Porvenir', 'jose@gmail.com', '2024-10-11 16:04:22', NULL, NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincias`
--

CREATE TABLE `provincias` (
  `idprovincia` int(11) NOT NULL,
  `iddepartamento` int(11) NOT NULL,
  `provincia` varchar(250) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `provincias`
--

INSERT INTO `provincias` (`idprovincia`, `iddepartamento`, `provincia`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 'Chachapoyas', '2024-10-11 15:51:35', NULL, '1'),
(2, 1, 'Bagua', '2024-10-11 15:51:35', NULL, '1'),
(3, 1, 'Bongará', '2024-10-11 15:51:35', NULL, '1'),
(4, 1, 'Condorcanqui', '2024-10-11 15:51:35', NULL, '1'),
(5, 1, 'Luya', '2024-10-11 15:51:35', NULL, '1'),
(6, 1, 'Rodríguez de Mendoza', '2024-10-11 15:51:35', NULL, '1'),
(7, 1, 'Utcubamba', '2024-10-11 15:51:35', NULL, '1'),
(8, 2, 'Huaraz', '2024-10-11 15:51:35', NULL, '1'),
(9, 2, 'Aija', '2024-10-11 15:51:35', NULL, '1'),
(10, 2, 'Antonio Raymondi', '2024-10-11 15:51:35', NULL, '1'),
(11, 2, 'Asunción', '2024-10-11 15:51:35', NULL, '1'),
(12, 2, 'Bolognesi', '2024-10-11 15:51:35', NULL, '1'),
(13, 2, 'Carhuaz', '2024-10-11 15:51:35', NULL, '1'),
(14, 2, 'Carlos Fermín Fitzcarrald', '2024-10-11 15:51:35', NULL, '1'),
(15, 2, 'Casma', '2024-10-11 15:51:35', NULL, '1'),
(16, 2, 'Corongo', '2024-10-11 15:51:35', NULL, '1'),
(17, 2, 'Huaylas', '2024-10-11 15:51:35', NULL, '1'),
(18, 2, 'Huastán', '2024-10-11 15:51:35', NULL, '1'),
(19, 2, 'Huaylas', '2024-10-11 15:51:35', NULL, '1'),
(20, 2, 'María José', '2024-10-11 15:51:35', NULL, '1'),
(21, 2, 'Olleros', '2024-10-11 15:51:35', NULL, '1'),
(22, 2, 'Pallasca', '2024-10-11 15:51:35', NULL, '1'),
(23, 2, 'Pomabamba', '2024-10-11 15:51:35', NULL, '1'),
(24, 2, 'Pucas', '2024-10-11 15:51:35', NULL, '1'),
(25, 2, 'Santa', '2024-10-11 15:51:35', NULL, '1'),
(26, 2, 'Sihuas', '2024-10-11 15:51:35', NULL, '1'),
(27, 2, 'Yungay', '2024-10-11 15:51:35', NULL, '1'),
(28, 3, 'Abancay', '2024-10-11 15:51:35', NULL, '1'),
(29, 3, 'Andahuaylas', '2024-10-11 15:51:35', NULL, '1'),
(30, 3, 'Antabamba', '2024-10-11 15:51:35', NULL, '1'),
(31, 3, 'Cotabambas', '2024-10-11 15:51:35', NULL, '1'),
(32, 3, 'Chincheros', '2024-10-11 15:51:35', NULL, '1'),
(33, 3, 'Grau', '2024-10-11 15:51:35', NULL, '1'),
(34, 3, 'Huinchiri', '2024-10-11 15:51:35', NULL, '1'),
(35, 3, 'Pampachiri', '2024-10-11 15:51:35', NULL, '1'),
(36, 3, 'Talavera', '2024-10-11 15:51:35', NULL, '1'),
(37, 3, 'Turpo', '2024-10-11 15:51:35', NULL, '1'),
(38, 4, 'Arequipa', '2024-10-11 15:51:35', NULL, '1'),
(39, 4, 'Camaná', '2024-10-11 15:51:35', NULL, '1'),
(40, 4, 'Caravelí', '2024-10-11 15:51:35', NULL, '1'),
(41, 4, 'Castilla', '2024-10-11 15:51:35', NULL, '1'),
(42, 4, 'Caylloma', '2024-10-11 15:51:35', NULL, '1'),
(43, 4, 'Islay', '2024-10-11 15:51:35', NULL, '1'),
(44, 4, 'La Unión', '2024-10-11 15:51:35', NULL, '1'),
(45, 5, 'Huamanga', '2024-10-11 15:51:35', NULL, '1'),
(46, 5, 'Cangallo', '2024-10-11 15:51:35', NULL, '1'),
(47, 5, 'Huanca Sancos', '2024-10-11 15:51:35', NULL, '1'),
(48, 5, 'Huanta', '2024-10-11 15:51:35', NULL, '1'),
(49, 5, 'La Mar', '2024-10-11 15:51:35', NULL, '1'),
(50, 5, 'Lucanas', '2024-10-11 15:51:35', NULL, '1'),
(51, 5, 'Parinacochas', '2024-10-11 15:51:35', NULL, '1'),
(52, 5, 'Paucar del Sara Sara', '2024-10-11 15:51:35', NULL, '1'),
(53, 5, 'Sucre', '2024-10-11 15:51:35', NULL, '1'),
(54, 5, 'Vinchos', '2024-10-11 15:51:35', NULL, '1'),
(55, 6, 'Jaén', '2024-10-11 15:51:35', NULL, '1'),
(56, 6, 'San Ignacio', '2024-10-11 15:51:35', NULL, '1'),
(57, 6, 'San José de Lourdes', '2024-10-11 15:51:35', NULL, '1'),
(58, 6, 'San Miguel', '2024-10-11 15:51:35', NULL, '1'),
(59, 6, 'San Pablo', '2024-10-11 15:51:35', NULL, '1'),
(60, 6, 'Santa María de Nieva', '2024-10-11 15:51:35', NULL, '1'),
(61, 7, 'Callao', '2024-10-11 15:51:35', NULL, '1'),
(62, 8, 'Cusco', '2024-10-11 15:51:35', NULL, '1'),
(63, 8, 'Acomayo', '2024-10-11 15:51:35', NULL, '1'),
(64, 8, 'Anta', '2024-10-11 15:51:35', NULL, '1'),
(65, 8, 'Calca', '2024-10-11 15:51:35', NULL, '1'),
(66, 8, 'Canas', '2024-10-11 15:51:35', NULL, '1'),
(67, 8, 'Canchis', '2024-10-11 15:51:35', NULL, '1'),
(68, 8, 'Chumbivilcas', '2024-10-11 15:51:35', NULL, '1'),
(69, 8, 'Espinar', '2024-10-11 15:51:35', NULL, '1'),
(70, 8, 'La Convención', '2024-10-11 15:51:35', NULL, '1'),
(71, 8, 'Paruro', '2024-10-11 15:51:35', NULL, '1'),
(72, 8, 'Paucartambo', '2024-10-11 15:51:35', NULL, '1'),
(73, 8, 'Quispicanchi', '2024-10-11 15:51:35', NULL, '1'),
(74, 8, 'Urubamba', '2024-10-11 15:51:35', NULL, '1'),
(75, 9, 'Huancavelica', '2024-10-11 15:51:35', NULL, '1'),
(76, 9, 'Acobamba', '2024-10-11 15:51:35', NULL, '1'),
(77, 9, 'Angaraes', '2024-10-11 15:51:35', NULL, '1'),
(78, 9, 'Castrovirreyna', '2024-10-11 15:51:35', NULL, '1'),
(79, 9, 'Churcampa', '2024-10-11 15:51:35', NULL, '1'),
(80, 9, 'Huancavelica', '2024-10-11 15:51:35', NULL, '1'),
(81, 9, 'Huaytará', '2024-10-11 15:51:35', NULL, '1'),
(82, 9, 'Tayacaja', '2024-10-11 15:51:35', NULL, '1'),
(83, 10, 'Huánuco', '2024-10-11 15:51:35', NULL, '1'),
(84, 10, 'Ambo', '2024-10-11 15:51:35', NULL, '1'),
(85, 10, 'Dos de Mayo', '2024-10-11 15:51:35', NULL, '1'),
(86, 10, 'Huacaybamba', '2024-10-11 15:51:35', NULL, '1'),
(87, 10, 'Huánuco', '2024-10-11 15:51:35', NULL, '1'),
(88, 10, 'Lauricocha', '2024-10-11 15:51:35', NULL, '1'),
(89, 10, 'Leoncio Prado', '2024-10-11 15:51:35', NULL, '1'),
(90, 10, 'Marañón', '2024-10-11 15:51:35', NULL, '1'),
(91, 10, 'Pachitea', '2024-10-11 15:51:35', NULL, '1'),
(92, 10, 'Puerto Inca', '2024-10-11 15:51:35', NULL, '1'),
(93, 10, 'Yarowilca', '2024-10-11 15:51:35', NULL, '1'),
(94, 11, 'Ica', '2024-10-11 15:51:35', NULL, '1'),
(95, 11, 'Chincha', '2024-10-11 15:51:35', NULL, '1'),
(96, 11, 'Ica', '2024-10-11 15:51:35', NULL, '1'),
(97, 11, 'Nazca', '2024-10-11 15:51:35', NULL, '1'),
(98, 11, 'Palpa', '2024-10-11 15:51:35', NULL, '1'),
(99, 11, 'Pisco', '2024-10-11 15:51:35', NULL, '1'),
(100, 12, 'Junín', '2024-10-11 15:51:35', NULL, '1'),
(101, 12, 'Apata', '2024-10-11 15:51:35', NULL, '1'),
(102, 12, 'Chanchamayo', '2024-10-11 15:51:35', NULL, '1'),
(103, 12, 'Huancayo', '2024-10-11 15:51:35', NULL, '1'),
(104, 12, 'Huancavelica', '2024-10-11 15:51:35', NULL, '1'),
(105, 12, 'Jauja', '2024-10-11 15:51:35', NULL, '1'),
(106, 12, 'Junín', '2024-10-11 15:51:35', NULL, '1'),
(107, 12, 'La Mar', '2024-10-11 15:51:35', NULL, '1'),
(108, 12, 'Marañón', '2024-10-11 15:51:35', NULL, '1'),
(109, 12, 'Pangoa', '2024-10-11 15:51:35', NULL, '1'),
(110, 12, 'San Martín de Pangoa', '2024-10-11 15:51:35', NULL, '1'),
(111, 12, 'Satipo', '2024-10-11 15:51:35', NULL, '1'),
(112, 12, 'Tarma', '2024-10-11 15:51:35', NULL, '1'),
(113, 12, 'Yauli', '2024-10-11 15:51:35', NULL, '1'),
(114, 13, 'La Libertad', '2024-10-11 15:51:35', NULL, '1'),
(115, 13, 'Ascope', '2024-10-11 15:51:35', NULL, '1'),
(116, 13, 'Bolívar', '2024-10-11 15:51:35', NULL, '1'),
(117, 13, 'Chepén', '2024-10-11 15:51:35', NULL, '1'),
(118, 13, 'Gran Chimú', '2024-10-11 15:51:35', NULL, '1'),
(119, 13, 'Julcán', '2024-10-11 15:51:35', NULL, '1'),
(120, 13, 'Otuzco', '2024-10-11 15:51:35', NULL, '1'),
(121, 13, 'Pacasmayo', '2024-10-11 15:51:35', NULL, '1'),
(122, 13, 'Trujillo', '2024-10-11 15:51:35', NULL, '1'),
(123, 13, 'Santiago de Chuco', '2024-10-11 15:51:35', NULL, '1'),
(124, 13, 'Pataz', '2024-10-11 15:51:35', NULL, '1'),
(125, 13, 'Virú', '2024-10-11 15:51:35', NULL, '1'),
(126, 14, 'Lambayeque', '2024-10-11 15:51:35', NULL, '1'),
(127, 14, 'Chiclayo', '2024-10-11 15:51:35', NULL, '1'),
(128, 14, 'Ferreñafe', '2024-10-11 15:51:35', NULL, '1'),
(129, 14, 'Lambayeque', '2024-10-11 15:51:35', NULL, '1'),
(130, 15, 'Lima', '2024-10-11 15:51:35', NULL, '1'),
(131, 15, 'Canta', '2024-10-11 15:51:35', NULL, '1'),
(132, 15, 'Cañete', '2024-10-11 15:51:35', NULL, '1'),
(133, 15, 'Huaral', '2024-10-11 15:51:35', NULL, '1'),
(134, 15, 'Huarochirí', '2024-10-11 15:51:35', NULL, '1'),
(135, 15, 'Lima', '2024-10-11 15:51:35', NULL, '1'),
(136, 15, 'Oyon', '2024-10-11 15:51:35', NULL, '1'),
(137, 15, 'Yauyos', '2024-10-11 15:51:35', NULL, '1'),
(138, 16, 'Loreto', '2024-10-11 15:51:35', NULL, '1'),
(139, 16, 'Alto Nanay', '2024-10-11 15:51:35', NULL, '1'),
(140, 16, 'Fernando Lores', '2024-10-11 15:51:35', NULL, '1'),
(141, 16, 'Iquitos', '2024-10-11 15:51:35', NULL, '1'),
(142, 16, 'Maynas', '2024-10-11 15:51:35', NULL, '1'),
(143, 16, 'Nauta', '2024-10-11 15:51:35', NULL, '1'),
(144, 16, 'Requena', '2024-10-11 15:51:35', NULL, '1'),
(145, 16, 'Ucayali', '2024-10-11 15:51:35', NULL, '1'),
(146, 17, 'Madre de Dios', '2024-10-11 15:51:35', NULL, '1'),
(147, 17, 'Manu', '2024-10-11 15:51:35', NULL, '1'),
(148, 17, 'Madre de Dios', '2024-10-11 15:51:35', NULL, '1'),
(149, 17, 'Tambopata', '2024-10-11 15:51:35', NULL, '1'),
(150, 18, 'Moquegua', '2024-10-11 15:51:35', NULL, '1'),
(151, 18, 'Ilo', '2024-10-11 15:51:35', NULL, '1'),
(152, 18, 'Mariscal Nieto', '2024-10-11 15:51:35', NULL, '1'),
(153, 19, 'Pasco', '2024-10-11 15:51:35', NULL, '1'),
(154, 19, 'Pasco', '2024-10-11 15:51:35', NULL, '1'),
(155, 19, 'Daniel Alcides Carrión', '2024-10-11 15:51:35', NULL, '1'),
(156, 19, 'Oxapampa', '2024-10-11 15:51:35', NULL, '1'),
(157, 20, 'Piura', '2024-10-11 15:51:35', NULL, '1'),
(158, 20, 'Ayabaca', '2024-10-11 15:51:35', NULL, '1'),
(159, 20, 'Huancabamba', '2024-10-11 15:51:35', NULL, '1'),
(160, 20, 'Piura', '2024-10-11 15:51:35', NULL, '1'),
(161, 20, 'Sechura', '2024-10-11 15:51:35', NULL, '1'),
(162, 20, 'Sullana', '2024-10-11 15:51:35', NULL, '1'),
(163, 21, 'Puno', '2024-10-11 15:51:35', NULL, '1'),
(164, 21, 'Azángaro', '2024-10-11 15:51:35', NULL, '1'),
(165, 21, 'Carabaya', '2024-10-11 15:51:35', NULL, '1'),
(166, 21, 'Chucuito', '2024-10-11 15:51:35', NULL, '1'),
(167, 21, 'El Collao', '2024-10-11 15:51:35', NULL, '1'),
(168, 21, 'Huancané', '2024-10-11 15:51:35', NULL, '1'),
(169, 21, 'Lampa', '2024-10-11 15:51:35', NULL, '1'),
(170, 21, 'Melgar', '2024-10-11 15:51:35', NULL, '1'),
(171, 21, 'San Antonio de Putina', '2024-10-11 15:51:35', NULL, '1'),
(172, 21, 'San Román', '2024-10-11 15:51:35', NULL, '1'),
(173, 21, 'Yunguyo', '2024-10-11 15:51:35', NULL, '1'),
(174, 22, 'San Martín', '2024-10-11 15:51:35', NULL, '1'),
(175, 22, 'Bellavista', '2024-10-11 15:51:35', NULL, '1'),
(176, 22, 'El Dorado', '2024-10-11 15:51:35', NULL, '1'),
(177, 22, 'Huallaga', '2024-10-11 15:51:35', NULL, '1'),
(178, 22, 'Lamas', '2024-10-11 15:51:35', NULL, '1'),
(179, 22, 'Moyobamba', '2024-10-11 15:51:35', NULL, '1'),
(180, 22, 'Picota', '2024-10-11 15:51:35', NULL, '1'),
(181, 22, 'Rioja', '2024-10-11 15:51:35', NULL, '1'),
(182, 22, 'San Martín', '2024-10-11 15:51:35', NULL, '1'),
(183, 22, 'Tarapoto', '2024-10-11 15:51:35', NULL, '1'),
(184, 23, 'Tacna', '2024-10-11 15:51:35', NULL, '1'),
(185, 23, 'Candarave', '2024-10-11 15:51:35', NULL, '1'),
(186, 23, 'Jorge Basadre', '2024-10-11 15:51:35', NULL, '1'),
(187, 23, 'Tacna', '2024-10-11 15:51:35', NULL, '1'),
(188, 24, 'Tumbes', '2024-10-11 15:51:35', NULL, '1'),
(189, 24, 'Contralmirante Villar', '2024-10-11 15:51:35', NULL, '1'),
(190, 24, 'Tumbes', '2024-10-11 15:51:35', NULL, '1'),
(191, 25, 'Ucayali', '2024-10-11 15:51:35', NULL, '1'),
(192, 25, 'Atalaya', '2024-10-11 15:51:35', NULL, '1'),
(193, 25, 'Coronel Portillo', '2024-10-11 15:51:35', NULL, '1'),
(194, 25, 'Padre Abad', '2024-10-11 15:51:35', NULL, '1'),
(195, 25, 'Purús', '2024-10-11 15:51:35', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idrol` int(11) NOT NULL,
  `rol` varchar(100) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idrol`, `rol`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Administrador', '2024-10-11 16:04:10', NULL, '1'),
(2, 'Usuario', '2024-10-11 16:04:10', NULL, '1'),
(3, 'Moderador', '2024-10-11 16:04:10', NULL, '1'),
(4, 'Invitado', '2024-10-11 16:04:10', NULL, '1'),
(5, 'Conductor', '2024-10-11 16:04:10', NULL, '1'),
(6, 'Vendedor', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcategorias`
--

CREATE TABLE `subcategorias` (
  `idsubcategoria` int(11) NOT NULL,
  `idcategoria` int(11) NOT NULL,
  `subcategoria` varchar(150) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `subcategorias`
--

INSERT INTO `subcategorias` (`idsubcategoria`, `idcategoria`, `subcategoria`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 'Conservas', '2024-10-11 16:04:10', NULL, '1'),
(2, 1, 'Cereales', '2024-10-11 16:04:10', NULL, '1'),
(3, 1, 'Frutos Secos', '2024-10-11 16:04:10', NULL, '1'),
(4, 1, 'Aceites', '2024-10-11 16:04:10', NULL, '1'),
(5, 2, 'Bebidas Gaseosas', '2024-10-11 16:04:10', NULL, '1'),
(6, 2, 'Aguas Saborizadas', '2024-10-11 16:04:10', NULL, '1'),
(7, 2, 'Jugos y Néctares', '2024-10-11 16:04:10', NULL, '1'),
(8, 3, 'Detergentes', '2024-10-11 16:04:10', NULL, '1'),
(9, 3, 'Suavizantes', '2024-10-11 16:04:10', NULL, '1'),
(10, 4, 'Cuidado del Cabello', '2024-10-11 16:04:10', NULL, '1'),
(11, 4, 'Cuidado de la Piel', '2024-10-11 16:04:10', NULL, '1'),
(12, 5, 'Papel Higiénico', '2024-10-11 16:04:10', NULL, '1'),
(13, 6, 'Alimento para Perros', '2024-10-11 16:04:10', NULL, '1'),
(14, 6, 'Alimento para Gatos', '2024-10-11 16:04:10', NULL, '1'),
(15, 7, 'Bolsas Plásticas', '2024-10-11 16:04:10', NULL, '1'),
(16, 8, 'Licuadoras', '2024-10-11 16:04:10', NULL, '1'),
(17, 9, 'Tornillos y Clavos', '2024-10-11 16:04:10', NULL, '1'),
(18, 10, 'Papel', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_promociones`
--

CREATE TABLE `tipos_promociones` (
  `idtipopromocion` int(11) NOT NULL,
  `tipopromocion` varchar(150) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `tipos_promociones`
--

INSERT INTO `tipos_promociones` (`idtipopromocion`, `tipopromocion`, `descripcion`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Descuento de Temporada', 'Descuento especial aplicado durante la temporada de invierno.', '2024-10-11 16:04:11', NULL, '1'),
(2, 'Porcentaje', 'Se aplica un porcentaje de descuento por und.', '2024-10-11 16:04:11', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_comprobante_pago`
--

CREATE TABLE `tipo_comprobante_pago` (
  `idtipocomprobante` int(11) NOT NULL,
  `comprobantepago` varchar(150) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `tipo_comprobante_pago`
--

INSERT INTO `tipo_comprobante_pago` (`idtipocomprobante`, `comprobantepago`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Factura', '2024-10-11 16:04:10', NULL, '1'),
(2, 'Boleta', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_documento`
--

CREATE TABLE `tipo_documento` (
  `idtipodocumento` int(11) NOT NULL,
  `documento` char(6) NOT NULL,
  `descripcion` varchar(250) DEFAULT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `tipo_documento`
--

INSERT INTO `tipo_documento` (`idtipodocumento`, `documento`, `descripcion`, `create_at`, `update_at`, `estado`) VALUES
(1, 'DNI', 'Documento Nacional de Identidad', '2024-10-11 16:04:10', NULL, '1'),
(2, 'RUC', 'Registro Único de Contribuyentes', '2024-10-11 16:04:10', NULL, '1'),
(3, 'CE', 'Carné de Extranjería', '2024-10-11 16:04:10', NULL, '1'),
(4, 'PTP', 'Permiso Temporal de Permanencia', '2024-10-11 16:04:10', NULL, '1'),
(5, 'PAS', 'Pasaporte', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `unidades_medidas`
--

CREATE TABLE `unidades_medidas` (
  `idunidadmedida` int(11) NOT NULL,
  `unidadmedida` varchar(100) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `unidades_medidas`
--

INSERT INTO `unidades_medidas` (`idunidadmedida`, `unidadmedida`, `create_at`, `update_at`, `estado`) VALUES
(1, 'Unidad', '2024-10-11 16:04:10', NULL, '1'),
(2, 'Caja', '2024-10-11 16:04:10', NULL, '1'),
(3, 'Paquete', '2024-10-11 16:04:10', NULL, '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `idpersona` char(11) NOT NULL,
  `idrol` int(11) NOT NULL,
  `nombre_usuario` varchar(100) NOT NULL,
  `password_usuario` varchar(150) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuario`, `idpersona`, `idrol`, `nombre_usuario`, `password_usuario`, `create_at`, `update_at`, `estado`) VALUES
(1, '26558000', 2, 'admin', '$2y$10$JB.moLTAzz7XPbbcUMmQQuynsiKidarPMFFcQ1lfTDjIrrYwyphpm', '2024-10-11 16:04:21', '2024-10-11 16:04:21', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculos`
--

CREATE TABLE `vehiculos` (
  `idvehiculo` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `marca_vehiculo` varchar(100) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  `placa` varchar(7) NOT NULL,
  `capacidad` smallint(6) NOT NULL,
  `condicion` enum('operativo','taller','averiado') NOT NULL DEFAULT 'operativo',
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(10) NOT NULL DEFAULT 'Activo'
) ;

--
-- Volcado de datos para la tabla `vehiculos`
--

INSERT INTO `vehiculos` (`idvehiculo`, `idusuario`, `marca_vehiculo`, `modelo`, `placa`, `capacidad`, `condicion`, `create_at`, `update_at`, `estado`) VALUES
(1, 1, 'Toyota', 'Corolla', 'ABC123', 5, 'operativo', '2024-10-11 16:04:21', NULL, 'Activo'),
(2, 1, 'Honda', 'Civic', 'XYZ789', 5, 'operativo', '2024-10-11 16:04:21', NULL, 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `idventa` int(11) NOT NULL,
  `idpedido` char(15) NOT NULL,
  `idtipocomprobante` int(11) NOT NULL,
  `fecha_venta` datetime NOT NULL DEFAULT current_timestamp(),
  `subtotal` decimal(10,2) NOT NULL,
  `descuento` decimal(10,2) NOT NULL DEFAULT 0.00,
  `igv` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_venta` decimal(10,2) NOT NULL,
  `create_at` datetime NOT NULL DEFAULT current_timestamp(),
  `update_at` datetime DEFAULT NULL,
  `estado` char(1) NOT NULL DEFAULT '1'
) ;

--
-- Disparadores `ventas`
--
DELIMITER $$
CREATE TRIGGER `after_cancelar_venta` AFTER UPDATE ON `ventas` FOR EACH ROW BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE _idproducto INT;
    DECLARE _cantidad INT;

    -- Declara el cursor
    DECLARE cur CURSOR FOR 
        SELECT idproducto, cantidad_producto
        FROM detalle_pedidos
        WHERE idpedido = NEW.idpedido;

    -- Manejo del final del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Solo ejecuta si el estado es cancelado
    IF NEW.estado = '0' THEN
        OPEN cur;

        read_loop: LOOP
            FETCH cur INTO _idproducto, _cantidad;
            IF done THEN
                LEAVE read_loop;
            END IF;

            -- Llama al procedimiento para registrar el movimiento
            CALL sp_registrarmovimiento_kardex(1, _idproducto, '','', 'Ingreso', _cantidad, 'Venta Cancelada');
        END LOOP;
 
        CLOSE cur;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_actualizar_estado_pedido` AFTER INSERT ON `ventas` FOR EACH ROW BEGIN
    UPDATE pedidos
    SET estado = 'Enviado'
    WHERE idpedido = NEW.idpedido 
      AND estado <> 'Enviado';  
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_distritos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_distritos` (
`iddistrito` int(11)
,`distrito` varchar(250)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_empresas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_empresas` (
`idempresaruc` bigint(20)
,`razonsocial` varchar(100)
,`direccion` varchar(100)
,`email` varchar(100)
,`telefono` char(9)
,`iddistrito` int(11)
,`distrito` varchar(250)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `view_tipos_documentos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `view_tipos_documentos` (
`idtipodocumento` int(11)
,`documento` char(6)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_listar_categorias`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_listar_categorias` (
`categoria` varchar(150)
,`create_at` datetime
,`estado` char(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_listar_marcas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_listar_marcas` (
`idmarca` int(11)
,`marca` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_listar_productos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_listar_productos` (
`idproducto` int(11)
,`idmarca` int(11)
,`idsubcategoria` int(11)
,`nombreproducto` varchar(250)
,`descripcion` varchar(250)
,`codigo` char(30)
,`create_at` datetime
,`update_at` datetime
,`estado` char(1)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_listar_roles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_listar_roles` (
`idrol` int(11)
,`rol` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_listar_subcategorias`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_listar_subcategorias` (
`idsubcategoria` int(11)
,`subcategoria` varchar(150)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `view_distritos`
--
DROP TABLE IF EXISTS `view_distritos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_distritos`  AS SELECT `distritos`.`iddistrito` AS `iddistrito`, `distritos`.`distrito` AS `distrito` FROM `distritos` ORDER BY `distritos`.`distrito` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_empresas`
--
DROP TABLE IF EXISTS `view_empresas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_empresas`  AS SELECT `e`.`idempresaruc` AS `idempresaruc`, `e`.`razonsocial` AS `razonsocial`, `e`.`direccion` AS `direccion`, `e`.`email` AS `email`, `e`.`telefono` AS `telefono`, `d`.`iddistrito` AS `iddistrito`, `d`.`distrito` AS `distrito` FROM (`empresas` `e` join `distritos` `d` on(`e`.`iddistrito` = `d`.`iddistrito`)) ORDER BY `e`.`razonsocial` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `view_tipos_documentos`
--
DROP TABLE IF EXISTS `view_tipos_documentos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_tipos_documentos`  AS SELECT `tipo_documento`.`idtipodocumento` AS `idtipodocumento`, `tipo_documento`.`documento` AS `documento` FROM `tipo_documento` ORDER BY `tipo_documento`.`documento` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_listar_categorias`
--
DROP TABLE IF EXISTS `vw_listar_categorias`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_listar_categorias`  AS SELECT `cat`.`categoria` AS `categoria`, `cat`.`create_at` AS `create_at`, `cat`.`estado` AS `estado` FROM `categorias` AS `cat` WHERE `cat`.`estado` = 1 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_listar_marcas`
--
DROP TABLE IF EXISTS `vw_listar_marcas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_listar_marcas`  AS SELECT `marcas`.`idmarca` AS `idmarca`, `marcas`.`marca` AS `marca` FROM `marcas` WHERE `marcas`.`estado` = '1' ORDER BY `marcas`.`marca` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_listar_productos`
--
DROP TABLE IF EXISTS `vw_listar_productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_listar_productos`  AS SELECT `productos`.`idproducto` AS `idproducto`, `productos`.`idmarca` AS `idmarca`, `productos`.`idsubcategoria` AS `idsubcategoria`, `productos`.`nombreproducto` AS `nombreproducto`, `productos`.`descripcion` AS `descripcion`, `productos`.`codigo` AS `codigo`, `productos`.`create_at` AS `create_at`, `productos`.`update_at` AS `update_at`, `productos`.`estado` AS `estado` FROM `productos` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_listar_roles`
--
DROP TABLE IF EXISTS `vw_listar_roles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_listar_roles`  AS SELECT `roles`.`idrol` AS `idrol`, `roles`.`rol` AS `rol` FROM `roles` WHERE `roles`.`estado` = '1' ORDER BY `roles`.`rol` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_listar_subcategorias`
--
DROP TABLE IF EXISTS `vw_listar_subcategorias`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_listar_subcategorias`  AS SELECT `subcategorias`.`idsubcategoria` AS `idsubcategoria`, `subcategorias`.`subcategoria` AS `subcategoria` FROM `subcategorias` WHERE `subcategorias`.`estado` = '1' ORDER BY `subcategorias`.`subcategoria` ASC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `accesos`
--
ALTER TABLE `accesos`
  ADD PRIMARY KEY (`idacceso`),
  ADD UNIQUE KEY `uk_modulo` (`modulo`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`idcategoria`),
  ADD UNIQUE KEY `uk_categoria` (`categoria`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`idcliente`),
  ADD UNIQUE KEY `uk_idpersona_cliente` (`idpersona`),
  ADD UNIQUE KEY `uk_idempresa_cliente` (`idempresa`);

--
-- Indices de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD PRIMARY KEY (`idcomprobante`),
  ADD KEY `fk_idventa_comp` (`idventa`);

--
-- Indices de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`iddepartamento`),
  ADD UNIQUE KEY `uk_departamento_depa` (`departamento`);

--
-- Indices de la tabla `despacho`
--
ALTER TABLE `despacho`
  ADD PRIMARY KEY (`iddespacho`),
  ADD KEY `fk_idvehiculo_desp` (`idvehiculo`),
  ADD KEY `fk_idusuario_desp` (`idusuario`);

--
-- Indices de la tabla `detalle_meto_pago`
--
ALTER TABLE `detalle_meto_pago`
  ADD PRIMARY KEY (`iddetallemetodo`),
  ADD KEY `fk_idventa` (`idventa`),
  ADD KEY `fk_idmetodopago` (`idmetodopago`);

--
-- Indices de la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  ADD PRIMARY KEY (`id_detalle_pedido`),
  ADD KEY `fk_idpedido_det_ped` (`idpedido`),
  ADD KEY `fk_idproducto_det_ped` (`idproducto`);

--
-- Indices de la tabla `detalle_productos`
--
ALTER TABLE `detalle_productos`
  ADD PRIMARY KEY (`id_detalle_producto`),
  ADD UNIQUE KEY `uk_idproducto_deta_prod` (`idproducto`),
  ADD KEY `fk_idproveedor_deta_prod` (`idproveedor`);

--
-- Indices de la tabla `detalle_promociones`
--
ALTER TABLE `detalle_promociones`
  ADD PRIMARY KEY (`iddetallepromocion`),
  ADD KEY `id_promocion_deta_prom` (`idpromocion`),
  ADD KEY `id_producto_deta_prom` (`idproducto`);

--
-- Indices de la tabla `distritos`
--
ALTER TABLE `distritos`
  ADD PRIMARY KEY (`iddistrito`),
  ADD KEY `fk_idprovincia_dist` (`idprovincia`);

--
-- Indices de la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD PRIMARY KEY (`idempresaruc`),
  ADD UNIQUE KEY `uk_razonsocial_emp` (`razonsocial`),
  ADD KEY `fk_distrito_emp` (`iddistrito`);

--
-- Indices de la tabla `entidades_roles`
--
ALTER TABLE `entidades_roles`
  ADD PRIMARY KEY (`id_entidad_rol`),
  ADD KEY `fk_idrol_ent_rol` (`idrol`),
  ADD KEY `fk_idacceso_ent_rol` (`idacceso`);

--
-- Indices de la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD PRIMARY KEY (`idkardex`),
  ADD KEY `fk_idusuario_kardex` (`idusuario`),
  ADD KEY `fk_idproducto_kardex` (`idproducto`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`idmarca`),
  ADD UNIQUE KEY `uk_marca` (`marca`);

--
-- Indices de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  ADD PRIMARY KEY (`idmetodopago`),
  ADD UNIQUE KEY `uk_metodopago` (`metodopago`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`idpedido`),
  ADD KEY `fk_idusuario_pedi` (`idusuario`),
  ADD KEY `fk_idcliente_pedi` (`idcliente`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`idpersonanrodoc`),
  ADD UNIQUE KEY `uk_idpersonanrodoc_pers` (`idpersonanrodoc`),
  ADD KEY `fk_idtipodoc_pers` (`idtipodocumento`),
  ADD KEY `fk_distrito_pers` (`iddistrito`);

--
-- Indices de la tabla `precios_historicos`
--
ALTER TABLE `precios_historicos`
  ADD PRIMARY KEY (`id_precio_historico`),
  ADD KEY `fk_idproducto_prec_hist` (`idproducto`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`idproducto`),
  ADD UNIQUE KEY `uk_nombreproducto_unidad` (`nombreproducto`),
  ADD UNIQUE KEY `uk_codigo` (`codigo`),
  ADD KEY `fk_idmarca_prod` (`idmarca`),
  ADD KEY `fk_sbcategoria_prod` (`idsubcategoria`);

--
-- Indices de la tabla `promociones`
--
ALTER TABLE `promociones`
  ADD PRIMARY KEY (`idpromocion`),
  ADD KEY `fk_idtipopromociones` (`idtipopromocion`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`idproveedor`),
  ADD UNIQUE KEY `uk_nombre_proveedor` (`proveedor`),
  ADD KEY `fk_idempresa_prov` (`idempresa`);

--
-- Indices de la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD PRIMARY KEY (`idprovincia`),
  ADD KEY `fk_iddepartamento_prov` (`iddepartamento`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idrol`),
  ADD UNIQUE KEY `uk_rol` (`rol`);

--
-- Indices de la tabla `subcategorias`
--
ALTER TABLE `subcategorias`
  ADD PRIMARY KEY (`idsubcategoria`),
  ADD UNIQUE KEY `uk_subcategoria` (`subcategoria`),
  ADD KEY `fk_idcategoria_subc` (`idcategoria`);

--
-- Indices de la tabla `tipos_promociones`
--
ALTER TABLE `tipos_promociones`
  ADD PRIMARY KEY (`idtipopromocion`),
  ADD UNIQUE KEY `uk_tipopromocion` (`tipopromocion`);

--
-- Indices de la tabla `tipo_comprobante_pago`
--
ALTER TABLE `tipo_comprobante_pago`
  ADD PRIMARY KEY (`idtipocomprobante`),
  ADD UNIQUE KEY `uk_comprobantepago` (`comprobantepago`);

--
-- Indices de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  ADD PRIMARY KEY (`idtipodocumento`),
  ADD UNIQUE KEY `uk_documento` (`documento`);

--
-- Indices de la tabla `unidades_medidas`
--
ALTER TABLE `unidades_medidas`
  ADD PRIMARY KEY (`idunidadmedida`),
  ADD UNIQUE KEY `uk_unidadmedida` (`unidadmedida`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuario`),
  ADD UNIQUE KEY `uk_nombre_usuario_usua` (`nombre_usuario`),
  ADD KEY `fk_idpersona_usua` (`idpersona`);

--
-- Indices de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD PRIMARY KEY (`idvehiculo`),
  ADD UNIQUE KEY `placa` (`placa`),
  ADD UNIQUE KEY `uk_placa_vehi` (`placa`),
  ADD KEY `fk_idusuario_vehi` (`idusuario`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`idventa`),
  ADD UNIQUE KEY `uk_idpedido` (`idpedido`),
  ADD KEY `fk_idtipocomprobante_venta` (`idtipocomprobante`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `accesos`
--
ALTER TABLE `accesos`
  MODIFY `idacceso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `idcategoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  MODIFY `idcomprobante` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `iddepartamento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `despacho`
--
ALTER TABLE `despacho`
  MODIFY `iddespacho` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_meto_pago`
--
ALTER TABLE `detalle_meto_pago`
  MODIFY `iddetallemetodo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  MODIFY `id_detalle_pedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_productos`
--
ALTER TABLE `detalle_productos`
  MODIFY `id_detalle_producto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_promociones`
--
ALTER TABLE `detalle_promociones`
  MODIFY `iddetallepromocion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `distritos`
--
ALTER TABLE `distritos`
  MODIFY `iddistrito` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `entidades_roles`
--
ALTER TABLE `entidades_roles`
  MODIFY `id_entidad_rol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `kardex`
--
ALTER TABLE `kardex`
  MODIFY `idkardex` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `idmarca` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  MODIFY `idmetodopago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `precios_historicos`
--
ALTER TABLE `precios_historicos`
  MODIFY `id_precio_historico` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `idproducto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `promociones`
--
ALTER TABLE `promociones`
  MODIFY `idpromocion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `idproveedor` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `provincias`
--
ALTER TABLE `provincias`
  MODIFY `idprovincia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idrol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subcategorias`
--
ALTER TABLE `subcategorias`
  MODIFY `idsubcategoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipos_promociones`
--
ALTER TABLE `tipos_promociones`
  MODIFY `idtipopromocion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipo_comprobante_pago`
--
ALTER TABLE `tipo_comprobante_pago`
  MODIFY `idtipocomprobante` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipo_documento`
--
ALTER TABLE `tipo_documento`
  MODIFY `idtipodocumento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `unidades_medidas`
--
ALTER TABLE `unidades_medidas`
  MODIFY `idunidadmedida` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  MODIFY `idvehiculo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `idventa` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `fk_idempresa_cli` FOREIGN KEY (`idempresa`) REFERENCES `empresas` (`idempresaruc`),
  ADD CONSTRAINT `fk_idpersona_cli` FOREIGN KEY (`idpersona`) REFERENCES `personas` (`idpersonanrodoc`);

--
-- Filtros para la tabla `comprobantes`
--
ALTER TABLE `comprobantes`
  ADD CONSTRAINT `fk_idventa_comp` FOREIGN KEY (`idventa`) REFERENCES `ventas` (`idventa`);

--
-- Filtros para la tabla `despacho`
--
ALTER TABLE `despacho`
  ADD CONSTRAINT `fk_idusuario_desp` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `fk_idvehiculo_desp` FOREIGN KEY (`idvehiculo`) REFERENCES `vehiculos` (`idvehiculo`);

--
-- Filtros para la tabla `detalle_meto_pago`
--
ALTER TABLE `detalle_meto_pago`
  ADD CONSTRAINT `fk_idmetodopago` FOREIGN KEY (`idmetodopago`) REFERENCES `metodos_pago` (`idmetodopago`),
  ADD CONSTRAINT `fk_idventa` FOREIGN KEY (`idventa`) REFERENCES `ventas` (`idventa`);

--
-- Filtros para la tabla `detalle_pedidos`
--
ALTER TABLE `detalle_pedidos`
  ADD CONSTRAINT `fk_idpedido_det_ped` FOREIGN KEY (`idpedido`) REFERENCES `pedidos` (`idpedido`),
  ADD CONSTRAINT `fk_idproducto_det_ped` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idproducto`);

--
-- Filtros para la tabla `detalle_productos`
--
ALTER TABLE `detalle_productos`
  ADD CONSTRAINT `fk_idproducto_deta_prod` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idproducto`),
  ADD CONSTRAINT `fk_idproveedor_deta_prod` FOREIGN KEY (`idproveedor`) REFERENCES `proveedores` (`idproveedor`);

--
-- Filtros para la tabla `detalle_promociones`
--
ALTER TABLE `detalle_promociones`
  ADD CONSTRAINT `id_producto_deta_prom` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idproducto`),
  ADD CONSTRAINT `id_promocion_deta_prom` FOREIGN KEY (`idpromocion`) REFERENCES `promociones` (`idpromocion`);

--
-- Filtros para la tabla `distritos`
--
ALTER TABLE `distritos`
  ADD CONSTRAINT `fk_idprovincia_dist` FOREIGN KEY (`idprovincia`) REFERENCES `provincias` (`idprovincia`);

--
-- Filtros para la tabla `empresas`
--
ALTER TABLE `empresas`
  ADD CONSTRAINT `fk_distrito_emp` FOREIGN KEY (`iddistrito`) REFERENCES `distritos` (`iddistrito`);

--
-- Filtros para la tabla `entidades_roles`
--
ALTER TABLE `entidades_roles`
  ADD CONSTRAINT `fk_idacceso_ent_rol` FOREIGN KEY (`idacceso`) REFERENCES `accesos` (`idacceso`),
  ADD CONSTRAINT `fk_idrol_ent_rol` FOREIGN KEY (`idrol`) REFERENCES `roles` (`idrol`);

--
-- Filtros para la tabla `kardex`
--
ALTER TABLE `kardex`
  ADD CONSTRAINT `fk_idproducto_kardex` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idproducto`),
  ADD CONSTRAINT `fk_idusuario_kardex` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD CONSTRAINT `fk_idcliente_pedi` FOREIGN KEY (`idcliente`) REFERENCES `clientes` (`idcliente`),
  ADD CONSTRAINT `fk_idusuario_pedi` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `personas`
--
ALTER TABLE `personas`
  ADD CONSTRAINT `fk_distrito_pers` FOREIGN KEY (`iddistrito`) REFERENCES `distritos` (`iddistrito`),
  ADD CONSTRAINT `fk_idtipodoc_pers` FOREIGN KEY (`idtipodocumento`) REFERENCES `tipo_documento` (`idtipodocumento`);

--
-- Filtros para la tabla `precios_historicos`
--
ALTER TABLE `precios_historicos`
  ADD CONSTRAINT `fk_idproducto_prec_hist` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idproducto`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_idmarca_prod` FOREIGN KEY (`idmarca`) REFERENCES `marcas` (`idmarca`),
  ADD CONSTRAINT `fk_sbcategoria_prod` FOREIGN KEY (`idsubcategoria`) REFERENCES `subcategorias` (`idsubcategoria`);

--
-- Filtros para la tabla `promociones`
--
ALTER TABLE `promociones`
  ADD CONSTRAINT `fk_idtipopromociones` FOREIGN KEY (`idtipopromocion`) REFERENCES `tipos_promociones` (`idtipopromocion`);

--
-- Filtros para la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD CONSTRAINT `fk_idempresa_prov` FOREIGN KEY (`idempresa`) REFERENCES `empresas` (`idempresaruc`);

--
-- Filtros para la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD CONSTRAINT `fk_iddepartamento_prov` FOREIGN KEY (`iddepartamento`) REFERENCES `departamentos` (`iddepartamento`);

--
-- Filtros para la tabla `subcategorias`
--
ALTER TABLE `subcategorias`
  ADD CONSTRAINT `fk_idcategoria_subc` FOREIGN KEY (`idcategoria`) REFERENCES `categorias` (`idcategoria`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_idpersona_usua` FOREIGN KEY (`idpersona`) REFERENCES `personas` (`idpersonanrodoc`);

--
-- Filtros para la tabla `vehiculos`
--
ALTER TABLE `vehiculos`
  ADD CONSTRAINT `fk_idusuario_vehi` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `fk_idpedido_venta` FOREIGN KEY (`idpedido`) REFERENCES `pedidos` (`idpedido`),
  ADD CONSTRAINT `fk_idtipocomprobante_venta` FOREIGN KEY (`idtipocomprobante`) REFERENCES `tipo_comprobante_pago` (`idtipocomprobante`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
