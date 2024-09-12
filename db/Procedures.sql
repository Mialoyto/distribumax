USE distribuMax;

-- PROCEDIMIENTOS PARA TABLA PERSONAS ------------------------------------------------------------------------
/* REGISTRAR  ✔️ */
DELIMITER $$
DROP PROCEDURE IF EXISTS spu_registrar_personas;
CREATE PROCEDURE spu_registrar_personas(
	IN  _idtipodocumento	INT,
    IN 	_idpersonanrodoc	CHAR(11),
    IN 	_iddistrito			INT,	
	IN  _nombres			VARCHAR(250),
	IN  _apellidoP			VARCHAR(250),
    IN  _apellidoM			VARCHAR(250),
    IN  _telefono			CHAR(9),
    IN  _direccion			VARCHAR(250)	
)
BEGIN
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

/* ACTUALIZAR  ✔️ */
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_actualizar_persona;
CREATE PROCEDURE sp_actualizar_persona(
    IN  _idtipodocumento	INT,
    IN 	_iddistrito			INT,	
	IN  _nombres			VARCHAR(250),
	IN  _apellidoP			VARCHAR(250),
    IN  _apellidoM			VARCHAR(250),
    IN  _telefono			CHAR(9),
    IN  _direccion			VARCHAR(250),
    IN 	_idpersonanrodoc	CHAR(11)
)
BEGIN
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

-- DESACTIVAR PERSONA 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_desactivar_persona;
CREATE PROCEDURE sp_desactivar_persona(
	IN  _estado				BIT,
    IN 	_idpersonanrodoc 	CHAR(11)
)
BEGIN
	UPDATE personas
		SET
			estado = _estado
		WHERE idpersonanrodoc = _idpersonanrodoc;
        
        select row_count() as filas_afectadas;
END $$


-- BUSCAR PERSONA POR DOCUMENTO
DELIMITER $$
drop procedure if exists sp_buscarpersonadoc;
CREATE PROCEDURE sp_buscarpersonadoc(
IN _idtipodocumento 	INT ,
IN _idpersonanrodoc CHAR(11)
)
BEGIN
	SELECT 
		DIST.distrito,
        PER.nombres,
        PER.appaterno,
        PER.apmaterno,
        PER.telefono,
        PER.direccion
        FROM personas PER
        INNER JOIN distritos DIST ON PER.iddistrito = DIST.iddistrito
        INNER JOIN tipo_documento TDOC ON PER.idtipodocumento = TDOC.idtipodocumento
		WHERE PER.idtipodocumento = _idtipodocumento
        AND PER.idpersonanrodoc = _idpersonanrodoc;
END $$

-- PROCEDIMIENTOS PARA USUARIOS ********************************************************************************************
-- USUARIOS
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_registrar_usuario;
CREATE PROCEDURE sp_registrar_usuario(
   IN   _idpersona			VARCHAR(11),
   IN 	_idrol				INT,
   IN   _nombre_usuario		VARCHAR(100),
   IN   _password_usuario	VARCHAR(150)	
)
BEGIN
	INSERT INTO usuarios 
    (idpersona, idrol, nombre_usuario, password_usuario) 
    VALUES (_idpersona, _idrol, _nombre_usuario, _password_usuario);
    SELECT LAST_INSERT_ID() AS idusuario;
END$$

-- login 
DELIMITER $$
drop procedure if exists sp_usuario_login;
CREATE PROCEDURE sp_usuario_login(IN _nombre_usuario	VARCHAR(100))
BEGIN
SELECT
	USU.idusuario,
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
END$$;

-- Actualizar 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_actualizar_usuario;
CREATE PROCEDURE sp_actualizar_usuario(

   IN     _nombre_usuario		VARCHAR(100),
   IN     _password_usuario		VARCHAR(50),
   IN     _idusuario            INT 
)
BEGIN
	UPDATE usuarios
		SET
            nombre_usuario = _nombre_usuario,
            password_usuario = _password_usuario,
            update_at = NOW()
		WHERE idusuario = _idusuario;
END$$

-- ESTADO 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_desactivar_usuario;
CREATE PROCEDURE sp_desactivar_usuario(
     IN  _estado	BIT,
    IN 	_nombre_usuario VARCHAR(100)
    )
BEGIN
	UPDATE usuarios
		SET
			estado = _estado
		WHERE _nombre_usuario = nombre_usuario;
END$$

-- PROCEDURE DE PRODCUTOS ********************************************************************************************
-- REGISTRAR PRODUCTOS

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_registrar_producto;
CREATE PROCEDURE sp_registrar_producto(
IN _idmarca         INT,
IN _idsubcategoria  INT,
IN _nombreproducto  VARCHAR(250),
IN _descripcion     VARCHAR(250),
IN _codigo          CHAR(30),
IN _preciounitario  DECIMAL(8, 2)	
)BEGIN
	INSERT INTO productos 
    (idmarca,idsubcategoria,nombreproducto,descripcion,codigo,preciounitario) 
    VALUES
    (_idmarca,_idsubcategoria,_nombreproducto,_descripcion,_codigo,_preciounitario);
END$$

-- ACTUALIZA PRODUCTOS
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_actualziar_producto;
CREATE PROCEDURE sp_actualziar_producto(
IN _idmarca         INT,
IN _idsubcategoria  INT,
IN _nombreproducto  VARCHAR(250),
IN _descripcion     VARCHAR(250),
IN _codigo          CHAR(30),
IN _preciounitario  DECIMAL(8, 2),
IN _idproducto		INT
)
BEGIN
	UPDATE productos
		SET 
			idmarca=_idmarca,
			idsubcategoria=_idsubcategoria,
			nombreproducto=_nombreproducto,
			descripcion=_descripcion,
			codigo=_codigo,
			preciounitario=_preciounitario,
			update_at=now()
        WHERE idproducto=_idproducto;
END$$

-- ESTADO producto

DELIMITER $$
DROP PROCEDURE IF EXISTS sp_estado_producto;
CREATE PROCEDURE sp_estado_producto(
IN  _estado BIT,
IN  _idproducto INT 
)
BEGIN
	UPDATE productos SET
      estado=_estado
      WHERE idproducto=_idproducto;
END$$


-- PROCEDURE DE EMPRESAS ********************************************************************************************
-- REGISTRAR EMPRESAS 
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_empresa_registrar;
CREATE PROCEDURE sp_empresa_registrar(
	IN _idempresaruc INT,
    IN _iddistrito INT,
    IN _razonsocial VARCHAR(100),
    IN _direccion VARCHAR(100),
    IN _email VARCHAR(100),
    IN _telefono CHAR(9)
)
BEGIN
    INSERT INTO empresas 
    (idempresaruc, iddistrito, razonsocial, direccion, email, telefono) 
    VALUES 
    (_idempresaruc, _iddistrito, _razonsocial, _direccion, _email, _telefono);
END$$
DELIMITER ;

-- ACTUALIZAR EMPRESAS
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_actualizar_empresa;
CREATE PROCEDURE sp_actualizar_empresa(
IN _idempresaruc 		INT,
IN _iddistrito         	INT,
IN _razonsocial  		VARCHAR(100),
IN _direccion 			VARCHAR(100),
IN _email 				VARCHAR(100),
IN _telefono 			CHAR(9)
)
BEGIN
	UPDATE empresas
		SET 
			iddistrito =_iddistrito,
			razonsocial =_razonsocial,
			direccion =_direccion,
			email =_email,
			telefono =_telefono,
			update_at=now()
        WHERE idempresaruc=_idempresaruc;
END$$

-- DESACTIVAR ESTADO EMPRESA
DELIMITER $$
CREATE PROCEDURE sp_estado_empresa(
IN  _estado BIT,
IN  _idempresaruc INT 
)
BEGIN
	UPDATE empresas SET
      estado=_estado
      WHERE idempresaruc=_idempresaruc;
END$$
-- PROCEDURE DE CLIENTES ********************************************************************************************
-- REGISTRAR CLIENTES
DELIMITER $$
CREATE PROCEDURE sp_cliente_registrar(
	IN _idpersona INT,
    IN _idempresa INT,
    IN _tipo_cliente     ENUM('Persona', 'Empresa')
)
BEGIN
    INSERT INTO clientes 
    (idpersona, idempresa, tipo_cliente) 
    VALUES 
    (_idpersona, _idempresa, _tipo_cliente);
END$$

-- ACTUALIZAR CLIENTES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_cliente(
IN _idcliente 			INT,
IN _idpersona        	INT,
IN _idempresa       	INT,
IN _tipo_cliente     ENUM('Persona', 'Empresa')
)
BEGIN
	UPDATE clientes
		SET 
			idcliente =_idcliente,
			idpersona =_idpersona,
			idempresa =_idempresa,
			tipo_cliente =_tipo_cliente,
			update_at=now()
        WHERE idcliente=_idcliente;
END$$

-- DESACTIVAR CLIENTE
DELIMITER $$
CREATE PROCEDURE sp_estado_cliente(
IN  _estado BIT,
IN  _idcliente INT 
)
BEGIN
	UPDATE clientes SET
      estado=_estado
      WHERE idcliente=_idcliente;
END$$

-- REGISTRAR PROOVEDORES
DELIMITER $$
CREATE PROCEDURE sp_proovedor_registrar(
    IN _idempresa 				INT,
    IN _proveedor		VARCHAR(50),
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
    IN _idempresa 				INT,
    IN _nombre_proveedor		VARCHAR(50),
    IN _contacto_principal		VARCHAR(50),
    IN _telefono_contacto		CHAR(9),
    IN _direccion				VARCHAR(100),
    IN _email               	VARCHAR(100)
)
BEGIN
	UPDATE proveedores
		SET 
			idproveedor =_idproveedor,
			idempresa =_idempresa,
			nombre_proveedor =_nombre_proveedor,
			contacto_principal =_contacto_principal,
            telefono_contacto = _telefono_contacto,
            direccion = _direccion,
            email = _email,
			update_at=now()
        WHERE idproveedor =_idproveedor;
END$$

-- DESACTIVAR PROOVEDOR
DELIMITER $$
CREATE PROCEDURE sp_estado_proovedor(
IN  _estado BIT,
IN  _idproveedor INT 
)
BEGIN
	UPDATE proveedores SET
      estado=_estado
      WHERE idproveedor =_idproveedor;
END$$

--  REGISTRAR PEDIDOS
DELIMITER $$
CREATE PROCEDURE sp_pedido_registrar(
    IN _idpedido        INT,
    IN _idusuario       INT,
    IN _idcliente       INT,
    IN _fecha_pedido    DATETIME,
    IN _estado          ENUM('Pendiente', 'Enviado', 'Cancelado', 'Entregado')
)
BEGIN
    INSERT INTO pedidos
    (idpedido, idusuario, idcliente, fecha_pedido, estado) 
    VALUES 
    (_idpedido, _idusuario, _idcliente, _fecha_pedido, _estado);
END$$

-- ACTUALIZAR PEDIDOS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_pedido(
	IN _idpedido        INT,
    IN _idusuario       INT,
    IN _idcliente       INT,
    IN _fecha_pedido    DATETIME,
    IN _estado          ENUM('Pendiente', 'Enviado', 'Cancelado', 'Entregado')
)
BEGIN
	UPDATE pedidos
		SET 
			idpedido =_idpedido,
			idusuario =_idusuario,
			idcliente =_idcliente,
			fecha_pedido =_fecha_pedido,
            estado = _estado,
			update_at=now()
        WHERE idpedido =_idpedido;
END$$

-- DESACTIVAR PEDIDO
DELIMITER $$
CREATE PROCEDURE sp_estado_pedido(
IN  _estado BIT,
IN  _idpedido INT 
)
BEGIN
	UPDATE pedidos SET
      estado=_estado
      WHERE idpedido =_idpedido;
END$$


-- KARDEX (NO LO ENTIENDO MUY BIEN, QUEDA PENDIENTE)


-- REGISTRAR PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_promocion_registrar(
	IN _idpromocion      	INT,
    IN _idtipopromocion       INT,
    IN _descripcion       	  VARCHAR(250),
    IN _fechaincio    		  DATETIME,
    IN _fechafin			  DATETIME,
    IN _valor_descuento  	  DECIMAL(8, 2),
    IN _estado				  BIT
)
BEGIN
    INSERT INTO promociones
    (idpromocion,idtipopromocion, descripcion, fechaincio, fechafin, valor_descuento, estado) 
    VALUES 
    (_idpromocion,_idtipopromocion, _descripcion, _fechaincio, _fechafin, _valor_descuento, _estado);
END$$

-- ACTUALIZAR PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_promocion(
	IN _idpromocion      	INT,
	IN _idtipopromocion    	INT,
	IN _descripcion      	VARCHAR(250),
    IN _fechaincio			DATETIME,
    IN _fechafin			DATETIME,
	IN _valor_descuento  	DECIMAL(8, 2),
	IN _estado					BIT
)
BEGIN
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

-- DESACTIVAR PROMOCIÓN
DELIMITER $$
CREATE PROCEDURE sp_estado_promocion(
IN  _estado BIT,
IN  _idpromocion INT 
)
BEGIN
	UPDATE promociones SET
      estado=_estado
      WHERE idpromocion =_idpromocion;
END$$

-- REGISTRAR TIPO DE PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_tipo_promocion_registrar(
    IN _tipopromocion       VARCHAR(150),
    IN _descripcion         VARCHAR(250),
    IN _estado              BIT
)
BEGIN
    INSERT INTO tipos_promociones (tipopromocion, descripcion, estado) 
    VALUES (_tipopromocion, _descripcion, _estado);
END$$

-- ACTUALIZAR TIPO DE PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_promocion(
	IN _idtipopromocion INT,
    IN _tipopromocion   VARCHAR(150),
    IN _descripcion     VARCHAR(250),
 	IN _estado			BIT
)
BEGIN
	UPDATE tipos_promociones
		SET
			idtipopromocion =_idtipopromocion,
            tipopromocion = _tipopromocion,
			descripcion =_descripcion,
            estado = _estado,
			update_at=now()
        WHERE idtipopromocion =_idtipopromocion;
END$$

-- DESACTIVAR TIPO DE PROMOCIONES
DELIMITER $$
CREATE PROCEDURE sp_estado_tipo_promocion(
IN  _estado BIT,
IN  _idtipopromocion INT 
)
BEGIN
	UPDATE tipos_promociones SET
      estado=_estado
      WHERE idtipopromocion =_idtipopromocion;
END$$

-- REGISTRAR DESPACHO
DELIMITER $$
CREATE PROCEDURE sp_despacho_registrar(
    IN _idvehiculo 		INT,
    IN _idusuario 		INT,
    IN _fecha_despacho	DATE,
	IN _estado          BIT	-- 1 : pendiente	0: despachado
)
BEGIN
    INSERT INTO despacho (idvehiculo, idusuario,fecha_despacho, estado) 
    VALUES (_idvehiculo, _idusuario, _fecha_despacho, _estado);
END$$

-- ACTUALIZAR DESPACHO
DELIMITER $$
CREATE PROCEDURE sp_actualizar_despacho(
	IN _iddespacho		INT,
	IN _idvehiculo 		INT,
    IN _fecha_despacho	DATE,
    IN _estado          BIT	-- 1 : pendiente	0: despachado
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
END$$

-- REGISTRAR TIPO DE COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_tipo_comprobantes_registrar(
    IN _comprobantepago		VARCHAR(150),
	IN _estado					BIT
)
BEGIN
    INSERT INTO tipo_comprobante_pago (comprobantepago, estado) 
    VALUES (_comprobantepago, _estado);
END$$

-- ACTUALIZAR TIPO DE COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_actualizar_tipo_comprobantes(
	IN _idtipocomprobante			INT,
	IN _comprobantepago		VARCHAR(150),
	IN _estado					BIT
)
BEGIN
	UPDATE tipo_comprobante_pago
		SET
			idtipocomprobante =_idtipocomprobante,
            comprobantepago = _comprobantepago,
            estado = _estado,
			update_at=now()
        WHERE idtipocomprobante =_idtipocomprobante;
END$$

-- REGISTRAR COMPROBANTES
DELIMITER $$
CREATE PROCEDURE sp_comprobantes_registrar(
    IN _idventa 		INT,
	IN _estado          BIT-- 	1: EMITIDO 	0: CANCELADO
)
BEGIN
    INSERT INTO comprobantes (idventa, estado) 
    VALUES (_idventa , _estado);
END$$

-- ACTUALIZAR COMPROBANTES 
DELIMITER $$
CREATE PROCEDURE sp_actualizar_comprobantes(
	IN _idcomprobante			INT,
	IN _estado					BIT
)
BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idcomprobante =_idcomprobante;
END$$

-- REGISTRAR METODO DE PAGO
DELIMITER $$
CREATE PROCEDURE sp_metodo_pago_registrar(
    IN _metodopago		VARCHAR(150)
)
BEGIN
    INSERT INTO metodos_pago (metodopago) 
    VALUES (_metodopago);
END$$

-- ACTUALIZAR METODO DE PAGO
DELIMITER $$
CREATE PROCEDURE sp_actualizar_metodo_pago(
	IN _idmetodopago			INT,
	IN _estado					BIT
)
BEGIN
	UPDATE comprobantes
		SET
            estado = _estado
        WHERE idmetodopago =_idmetodopago;
END$$

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

-- REGISTRAR MARCAS
DELIMITER $$
CREATE PROCEDURE sp_registrar_marca(
    IN _marca VARCHAR(150)
)
BEGIN
    INSERT INTO marcas (marca) 
    VALUES (_marca);
END$$

-- ACTUALIZAR MARCAS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_marca(
    IN _idmarca INT,
    IN _marca VARCHAR(150)
)
BEGIN
    UPDATE marcas
    SET marca = _marca,
        update_at = NOW()
    WHERE idmarca = _idmarca;
END$$

-- REGISTRAR SUBCATEGORIAS
DELIMITER $$
CREATE PROCEDURE sp_registrar_subcategoria(
    IN _idcategoria INT,
    IN _subcategoria VARCHAR(150)
)
BEGIN
    INSERT INTO subcategorias (idcategoria, subcategoria)
    VALUES (_idcategoria, _subcategoria);
END$$


-- ACTUALIZAR SUBCATEGORIAS
DELIMITER $$
CREATE PROCEDURE sp_actualizar_subcategoria(
    IN _idsubcategoria INT,
    IN _idcategoria INT,
    IN _subcategoria VARCHAR(150)
)
BEGIN
    UPDATE subcategorias
    SET idcategoria = _idcategoria,
        subcategoria = _subcategoria,
        update_at = NOW()
    WHERE idsubcategoria = _idsubcategoria;
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


DELIMITER $$
CREATE PROCEDURE sp_buscardistrito(IN _distrito VARCHAR(100))
BEGIN
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
 
