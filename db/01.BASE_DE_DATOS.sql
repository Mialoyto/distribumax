DROP DATABASE IF EXISTS distribumax;
CREATE DATABASE distribuMax;
USE distribuMax;

-- -----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS departamentos;
CREATE TABLE departamentos(
		iddepartamento	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        departamento	VARCHAR(250)	NOT NULL,
        create_at		DATETIME NOT NULL DEFAULT NOW(),
        update_at		DATETIME NULL,
        estado			CHAR(1) NOT NULL DEFAULT "1",
        
        CONSTRAINT uk_departamento_depa UNIQUE (departamento),
        CONSTRAINT fk_estado_depa CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS provincias;
CREATE TABLE provincias(
		idprovincia		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        iddepartamento	INT NOT NULL,
        provincia		VARCHAR(250)		NOT NULL,
        
		create_at		DATETIME NOT NULL DEFAULT NOW(),
        update_at		DATETIME NULL,
        estado			CHAR(1) NOT NULL DEFAULT "1",
        CONSTRAINT fk_iddepartamento_prov FOREIGN KEY(iddepartamento) REFERENCES departamentos(iddepartamento),
        CONSTRAINT fk_estado_prov CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS distritos;
CREATE TABLE distritos(
		iddistrito		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        idprovincia		INT NOT NULL,
        distrito		VARCHAR(250)	NOT NULL,
        
        create_at		DATETIME NOT NULL DEFAULT NOW(),
        update_at		DATETIME NULL,
        estado			CHAR(1) NOT NULL DEFAULT "1",
        
        CONSTRAINT fk_idprovincia_dist FOREIGN KEY(idprovincia) REFERENCES provincias(idprovincia),
        CONSTRAINT fk_estado_dist CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS categorias;
CREATE TABLE categorias(
		idcategoria		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        categoria		VARCHAR(150)	NOT NULL,
        
        create_at		DATETIME NOT NULL DEFAULT NOW(),
        update_at		DATETIME NULL,
        estado			CHAR(1) NOT NULL DEFAULT "1",
        CONSTRAINT uk_categoria UNIQUE(categoria),
        CONSTRAINT fk_estado_categ CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS subcategorias;
CREATE TABLE subcategorias(
	idsubcategoria	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idcategoria		INT NOT NULL,
	subcategoria 	VARCHAR(150) NOT NULL,
	
	create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado			CHAR(1) NOT NULL DEFAULT "1",
	CONSTRAINT fk_idcategoria_subc FOREIGN KEY (idcategoria) REFERENCES categorias(idcategoria),
	CONSTRAINT uk_subcategoria UNIQUE(subcategoria),
    CONSTRAINT fk_estado_subcat CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS tipo_comprobante_pago;
CREATE TABLE tipo_comprobante_pago(
	idtipocomprobante	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    comprobantepago		VARCHAR(150) NOT NULL,
    
    create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado			CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT uk_comprobantepago UNIQUE(comprobantepago),
    CONSTRAINT fk_estado_tip_comp_pag CHECK(estado IN ("0", "1"))    
)ENGINE = INNODB;

DROP TABLE IF EXISTS metodos_pago;
CREATE TABLE metodos_pago(
	idmetodopago	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    metodopago		VARCHAR(150) NOT NULL,
    
    create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado			CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT uk_metodopago UNIQUE(metodopago),
    CONSTRAINT fk_estado_met_pag CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS accesos;
CREATE TABLE accesos(
	idacceso	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	modulo		VARCHAR(100)	NOT NULL,
    
	create_at	DATETIME NOT NULL DEFAULT NOW(),
	update_at	DATETIME NULL,
	estado		CHAR(1) NOT NULL DEFAULT "1",
	CONSTRAINT uk_modulo UNIQUE(modulo),
    CONSTRAINT fk_estado_acce CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS roles;
CREATE TABLE roles(
	idrol		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	rol			VARCHAR(100)	NOT NULL,
        
	create_at	DATETIME NOT NULL DEFAULT NOW(),
	update_at	DATETIME NULL,
	estado		CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT uk_rol UNIQUE(rol),
    CONSTRAINT fk_estado_rol CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS entidad_roles;
CREATE TABLE entidades_roles(
	id_entidad_rol	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idrol			INT NOT NULL,
	idacceso		INT NOT NULL,
    
	create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado			CHAR(1) NOT NULL DEFAULT "1",
	CONSTRAINT fk_idrol_ent_rol FOREIGN KEY (idrol) REFERENCES roles(idrol),
	CONSTRAINT fk_idacceso_ent_rol FOREIGN KEY (idacceso) REFERENCES accesos(idacceso),
    CONSTRAINT fk_estado_ent_rol CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;


DROP TABLE IF EXISTS tipo_documento;
CREATE TABLE tipo_documento(
	idtipodocumento 	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    documento 			CHAR(6) NOT NULL,
    descripcion			VARCHAR(250) NULL,
    
    create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado			CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT uk_documento UNIQUE(documento),
    CONSTRAINT fk_estado_tip_doc CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLES IF EXISTS personas;
CREATE TABLE personas(
	idtipodocumento		INT NOT NULL,
	idpersonanrodoc		CHAR(11) NOT NULL PRIMARY KEY,
	iddistrito			INT NOT NULL,
	nombres				VARCHAR(80)	NOT NULL,
	appaterno			VARCHAR(80)	NOT NULL,
	apmaterno			VARCHAR(80)	NOT NULL,
	telefono			CHAR(9)			NULL,
	direccion			VARCHAR(250)	NOT NULL,
	
	create_at		    DATETIME NOT NULL DEFAULT NOW(),
	update_at		    DATETIME NULL,
	estado			    CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT fk_idtipodoc_pers FOREIGN KEY (idtipodocumento) REFERENCES tipo_documento (idtipodocumento),
	CONSTRAINT fk_distrito_pers FOREIGN KEY(iddistrito) REFERENCES distritos(iddistrito),
	CONSTRAINT uk_idpersonanrodoc_pers UNIQUE(idpersonanrodoc), 
    CONSTRAINT ck_idpersonanrodoc_pers CHECK (idpersonanrodoc <>''),
    CONSTRAINT fk_estado_pers CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

/* modificaciones en la base tabla tipo doc por defecto la empresas se registraran con ruc */
DROP TABLES IF EXISTS empresas;
CREATE TABLE empresas(
		idempresaruc	BIGINT	NOT NULL PRIMARY KEY,
        iddistrito		INT NOT NULL,
        razonsocial		VARCHAR(100)	NOT NULL,
        direccion		VARCHAR(100)	NOT NULL,
        email			VARCHAR(100)	NULL,
        telefono		CHAR(9)			NOT NULL,
        
        create_at		DATETIME NOT NULL DEFAULT NOW(),
		update_at		DATETIME NULL,
        inactive_at		DATETIME NULL,
		estado			CHAR(1) NOT NULL DEFAULT "1",
        CONSTRAINT fk_distrito_emp FOREIGN KEY(iddistrito) REFERENCES distritos(iddistrito),
        CONSTRAINT uk_razonsocial_emp UNIQUE(razonsocial),
        CONSTRAINT fk_estado_emp CHECK(estado IN ("0", "1"))
) ENGINE = INNODB;

DROP TABLES IF EXISTS usuarios;
CREATE TABLE usuarios(
		idusuario			INT	PRIMARY KEY AUTO_INCREMENT,
        idpersona			CHAR(11) NOT NULL,
        idrol				INT NOT NULL,
        nombre_usuario		VARCHAR(100)	NOT NULL,
        password_usuario	VARCHAR(150)		NOT NULL,
        
		create_at		    DATETIME NOT NULL DEFAULT NOW(),
		update_at		    DATETIME NULL,
		estado			    CHAR(1) NOT NULL DEFAULT "1",
        CONSTRAINT fk_idpersona_usua FOREIGN KEY(idpersona) REFERENCES personas(idpersonanrodoc),
        CONSTRAINT uk_nombre_usuario_usua UNIQUE(nombre_usuario),
        CONSTRAINT fk_estado_usuario CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLES IF EXISTS clientes;
CREATE TABLE clientes (
    idcliente       INT         NOT NULL PRIMARY KEY AUTO_INCREMENT,
    idpersona       CHAR(11)    DEFAULT NULL,
    idempresa       BIGINT      DEFAULT NULL,
    tipo_cliente    CHAR(10)    NOT NULL,
    
    create_at       DATETIME    NOT NULL DEFAULT NOW(),
	update_at		DATETIME    NULL,
	estado			CHAR(1)     NOT NULL DEFAULT "1",
    CONSTRAINT fk_idpersona_cli FOREIGN KEY (idpersona) REFERENCES personas(idpersonanrodoc),
    CONSTRAINT fk_idempresa_cli FOREIGN KEY (idempresa) REFERENCES empresas(idempresaruc),
    CONSTRAINT uk_idpersona_cliente UNIQUE(idpersona),
    CONSTRAINT uk_idempresa_cliente UNIQUE(idempresa),
    CONSTRAINT fk_tipo_cliente_cli CHECK (tipo_cliente IN ('Persona', 'Empresa')),
    CONSTRAINT fk_estado_cli CHECK(estado IN ("0", "1"))
) ENGINE=INNODB;

DROP TABLES IF EXISTS proveedores;
CREATE TABLE proveedores(
	idproveedor			 	INT	NOT NULL AUTO_INCREMENT PRIMARY KEY,
	idempresa				BIGINT NOT NULL,
	proveedor				VARCHAR(100)    NOT NULL,
	contacto_principal		VARCHAR(50)		NOT NULL,
	telefono_contacto		CHAR(9)			NOT NULL,
	direccion				VARCHAR(100)	NOT NULL,
	email               	VARCHAR(100)    NULL,
    
	create_at				DATETIME NOT NULL DEFAULT NOW(),
	update_at				DATETIME NULL,
    inactive_at				DATETIME NULL,
	estado					CHAR(1) NOT NULL DEFAULT "1",
	CONSTRAINT fk_idempresa_prov FOREIGN KEY(idempresa) REFERENCES empresas(idempresaruc),
    CONSTRAINT uk_nombre_proveedor UNIQUE(proveedor),
    CONSTRAINT fk_estado_proveedor CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS marcas;
CREATE TABLE marcas(
		idmarca		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        idproveedor INT NOT NULL,
        marca		VARCHAR(150) NOT NULL,
        
        create_at		DATETIME NOT NULL DEFAULT NOW(),
        update_at		DATETIME NULL,
        estado			CHAR(1) NOT NULL DEFAULT "1",
        CONSTRAINT uk_marca UNIQUE(marca),
        CONSTRAINT fk_estado_mar CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS tipos_promociones;
CREATE TABLE tipos_promociones (
    idtipopromocion   INT	NOT NULL PRIMARY KEY AUTO_INCREMENT,
    tipopromocion     VARCHAR(150)	NOT NULL,
    descripcion       VARCHAR(250) NOT NULL,
    create_at         DATETIME NOT NULL DEFAULT NOW(),
	update_at         DATETIME NULL,
	estado            CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT uk_tipopromocion UNIQUE(tipopromocion),
    CONSTRAINT fk_estado_tip_prom  CHECK(estado IN ("0", "1"))
) ENGINE=INNODB;

DROP TABLE IF EXISTS promociones;
CREATE TABLE promociones(
	idpromocion      	INT	            NOT NULL PRIMARY KEY AUTO_INCREMENT,
	idtipopromocion     INT             NOT NULL,
	descripcion      	VARCHAR(250)    NOT NULL,
    fechainicio			DATE            NOT NULL,
    fechafin			DATE            NOT NULL,
	valor_descuento  	DECIMAL(8, 2)   NOT NULL,
    create_at		    DATE            NOT NULL DEFAULT NOW(),
	update_at		    DATE            NULL,
	estado			    CHAR(1)         NOT NULL DEFAULT "1",
	CONSTRAINT fk_idtipopromociones FOREIGN KEY(idtipopromocion) REFERENCES tipos_promociones(idtipopromocion),
    CONSTRAINT ck_valor_descuento CHECK (valor_descuento > 0),
    CONSTRAINT fk_estado_prom  CHECK(estado IN ("0", "1")),
    CONSTRAINT ck_fecha_fin_mayor_inicio CHECK (fechafin > fechainicio)
) ENGINE=INNODB;

DROP TABLE IF EXISTS unidades_medidas;
CREATE TABLE unidades_medidas(
    idunidadmedida	INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
    unidadmedida	VARCHAR(100)	NOT NULL,
    
    create_at		DATETIME        NOT NULL DEFAULT NOW(),
    update_at		DATETIME        NULL,
    estado			CHAR(1)         NOT NULL DEFAULT "1",
    CONSTRAINT uk_unidadmedida UNIQUE(unidadmedida),
    CONSTRAINT fk_estado_uni_med CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;


-- TABLA PRODUCTOS
DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
    idproducto              INT             PRIMARY KEY AUTO_INCREMENT,
    idproveedor             INT             NOT NULL,
    idmarca                 INT             NOT NULL,
    idsubcategoria          INT             NOT NULL,
    nombreproducto          VARCHAR(250)   	NOT NULL,
    idunidadmedida          INT             NOT NULL,
    cantidad_presentacion   INT             NOT NULL,
    peso_unitario           VARCHAR(10)     NULL,
    codigo                  CHAR(30)        NOT NULL,
    precio_compra           DECIMAL(10,2)   NOT NULL,
    precio_mayorista        DECIMAL(10,2)   NOT NULL,
    precio_minorista        DECIMAL(10,2)   NOT NULL,
	create_at		        DATETIME        NOT NULL DEFAULT NOW(),
	update_at		        DATETIME NULL,
    inactive_at             DATETIME NULL,
    estado                  CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT fk_idproveedor_prod  FOREIGN KEY (idproveedor) REFERENCES proveedores (idproveedor),
    CONSTRAINT fk_idmarca_prod      FOREIGN KEY(idmarca) REFERENCES marcas(idmarca),
    CONSTRAINT fk_sbcategoria_prod  FOREIGN KEY(idsubcategoria) REFERENCES subcategorias(idsubcategoria),
    CONSTRAINT uk_codigo_prod       UNIQUE (codigo),
    CONSTRAINT ck_precio_compra_prod CHECK (precio_compra > 0),
    CONSTRAINT ck_precio_mayorista_prod CHECK (precio_mayorista > 0),
    CONSTRAINT ck_precio_minorista_prod CHECK (precio_minorista > 0),
    CONSTRAINT fk_estado_prod       CHECK(estado IN ("0", "1"))
) ENGINE=INNODB;


DROP TABLE IF EXISTS detalle_promociones;
CREATE TABLE detalle_promociones(
		iddetallepromocion	INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
        idpromocion			INT NOT NULL,
        idproducto			INT NOT NULL,
        descuento           DECIMAL(8, 2) NOT NULL,
        
		create_at			DATETIME NOT NULL DEFAULT NOW(),
		update_at			DATETIME NULL,
        estado          	CHAR(1) NOT NULL DEFAULT "1",
        CONSTRAINT id_promocion_deta_prom FOREIGN KEY(idpromocion) REFERENCES promociones(idpromocion), 
        CONSTRAINT id_producto_deta_prom FOREIGN KEY(idproducto) REFERENCES productos(idproducto),
        CONSTRAINT fk_estado_deta_prom  CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;


DROP TABLE IF EXISTS precios_historicos;
CREATE TABLE precios_historicos(
		id_precio_historico			INT			PRIMARY KEY AUTO_INCREMENT,
        idproducto					INT			NOT NULL,
		precio_antiguo        		DECIMAL(10, 2)  NOT NULL, 
        
		create_at			DATETIME NOT NULL DEFAULT NOW(),
		update_at			DATETIME NULL,
        estado          	CHAR(1) NOT NULL DEFAULT "1",
		CONSTRAINT fk_idproducto_prec_hist FOREIGN KEY(idproducto) REFERENCES productos(idproducto),
        CONSTRAINT ck_precio_antiguo CHECK (precio_antiguo > 0),
        CONSTRAINT fk_estado_prec_hist   CHECK(estado IN ("0", "1"))
)ENGINE = INNODB;

DROP TABLE IF EXISTS pedidos;
CREATE TABLE pedidos (
    idpedido        CHAR(15)        NOT NULL PRIMARY KEY,
    idusuario       INT             NOT NULL,
    idcliente       INT             NOT NULL,
    fecha_pedido    DATETIME        NOT NULL DEFAULT NOW(),
	create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
    estado          CHAR(10) NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT fk_idusuario_pedi FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario),
    CONSTRAINT fk_idcliente_pedi FOREIGN KEY (idcliente) REFERENCES clientes(idcliente),
    CONSTRAINT ck_estado_pedi CHECK (estado IN ('Pendiente', 'Enviado', 'Cancelado', 'Entregado'))
) ENGINE=INNODB;

DROP TABLES IF EXISTS detalle_pedidos;
CREATE TABLE detalle_pedidos (
    id_detalle_pedido    INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idpedido             CHAR(15)        NOT NULL,
    idproducto           INT             NOT NULL,
    cantidad_producto    INT             NOT NULL,
    unidad_medida		 CHAR(20)        NOT NULL,  -- unidad, caja,
    precio_unitario      DECIMAL(10, 2)  NOT NULL,
    precio_descuento     DECIMAL(10, 2)  NOT NULL,
    subtotal             DECIMAL(10, 2)  NOT NULL,
	create_at			DATETIME NOT NULL DEFAULT NOW(),
	update_at			DATETIME NULL,
	estado          	CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT fk_idpedido_det_ped FOREIGN KEY (idpedido)   REFERENCES pedidos(idpedido),
    CONSTRAINT fk_idproducto_det_ped FOREIGN KEY (idproducto) REFERENCES productos(idproducto),
    CONSTRAINT ck_cantidad_producto CHECK (cantidad_producto > 0),
    CONSTRAINT ck_precio_unitario CHECK (precio_unitario > 0),
    CONSTRAINT ck_precio_descuento CHECK (precio_descuento >= 0),
    CONSTRAINT ck_subtotal CHECK (subtotal > 0),
    CONSTRAINT fk_estado_det_ped CHECK(estado IN ("0", "1"))
) ENGINE = INNODB;


DROP TABLE IF EXISTS kardex;
CREATE TABLE kardex(
	idkardex			INT	NOT NULL PRIMARY KEY AUTO_INCREMENT,
	idusuario			INT NOT NULL,
	idproducto			INT NOT NULL,
    fecha_vencimiento   DATE  NULL,
    numlote				VARCHAR(60) NULL,
	stockactual     	INT NULL DEFAULT 0,
    tipomovimiento  	ENUM('Ingreso', 'Salida') NOT NULL,
	cantidad        	INT NOT NULL,
	motivo          	VARCHAR(255),
    
	create_at			DATETIME NOT NULL DEFAULT NOW(),
	update_at			DATETIME NULL,
	estado          	CHAR(1) NOT NULL DEFAULT '1',
	CONSTRAINT fk_idusuario_kardex FOREIGN KEY(idusuario) REFERENCES usuarios(idusuario),
	CONSTRAINT fk_idproducto_kardex FOREIGN KEY(idproducto) REFERENCES productos(idproducto),
    CONSTRAINT ck_stockactual CHECK (stockactual >= 0),
    CONSTRAINT ck_cantidad CHECK (cantidad > 0),
    CONSTRAINT fk_estado_kardex CHECK(estado IN ('0', '1'))
)ENGINE  = INNODB;

DROP TABLE IF EXISTS vehiculos;
CREATE TABLE vehiculos (
    idvehiculo 			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idusuario 			INT NOT NULL,
    marca_vehiculo 		VARCHAR(100) NOT NULL,
    modelo 				VARCHAR(100) NOT NULL,
    placa 				VARCHAR(7) NOT NULL UNIQUE,
    capacidad 			SMALLINT NOT NULL,
    condicion 			ENUM('operativo', 'taller', 'averiado') NOT NULL DEFAULT 'operativo',
	create_at			DATETIME NOT NULL DEFAULT NOW(),
	update_at			DATETIME NULL,
    estado           	CHAR(10) NOT NULL DEFAULT 'Activo',
    CONSTRAINT fk_idusuario_vehi FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario),
    CONSTRAINT uk_placa_vehi UNIQUE(placa),
    CONSTRAINT ck_capacidad_veh CHECK(capacidad > 0),
    CONSTRAINT ck_estado_veh CHECK (estado IN('Activo', 'Inactivo'))
) ENGINE = INNODB;

DROP TABLE IF EXISTS despacho;
CREATE TABLE despacho (
    iddespacho 		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idvehiculo 		INT NOT NULL,
    idusuario 		INT NOT NULL,
    fecha_despacho	DATE NOT NULL,
    
	create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado          CHAR(1) NOT NULL DEFAULT "1",	-- 1 : pendiente	0: despachado
    CONSTRAINT fk_idvehiculo_desp FOREIGN KEY (idvehiculo) REFERENCES vehiculos(idvehiculo),
    CONSTRAINT fk_idusuario_desp FOREIGN KEY (idusuario) REFERENCES usuarios(idusuario),
    CONSTRAINT fk_estado_desp   CHECK(estado IN ("0", "1"))
) ENGINE = INNODB;

DROP TABLE IF EXISTS ventas;
CREATE TABLE ventas (
    idventa 				INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idpedido 				CHAR(15) NOT NULL,
    idtipocomprobante		INT NOT NULL,
    fecha_venta 			DATETIME NOT NULL DEFAULT NOW(),
    subtotal 				DECIMAL(10, 2) NOT NULL,
    descuento 				DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    igv 					DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_venta 			DECIMAL(10, 2) NOT NULL,
	create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado          CHAR(1) NOT NULL DEFAULT "1",		-- 1: VENTA 	0: CANCELADO
    CONSTRAINT fk_idpedido_venta FOREIGN KEY (idpedido) REFERENCES pedidos(idpedido),
    CONSTRAINT fk_idtipocomprobante_venta FOREIGN KEY (idtipocomprobante) REFERENCES tipo_comprobante_pago(idtipocomprobante),
    CONSTRAINT fk_estado_venta   CHECK(estado IN ("0", "1")),
    CONSTRAINT ck_subtotal_venta CHECK(subtotal > 0),
    CONSTRAINT ck_descuento CHECK (descuento >= 0),
    CONSTRAINT ck_igv CHECK(igv > 0),
    CONSTRAINT ck_totalventa CHECK(total_venta > 0),
    CONSTRAINT uk_idpedido UNIQUE (idpedido)
) ENGINE = INNODB;


DROP TABLE IF EXISTS detalle_meto_Pago;
CREATE TABLE detalle_meto_Pago(
	iddetallemetodo   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idventa           INT NOT NULL,
    idmetodopago      INT NOT NULL,
    monto 			  DECIMAL(10.2) NOT NULL,
	create_at		  DATETIME NOT NULL DEFAULT NOW(),
    update_at		  DATETIME NULL,
    estado           CHAR(1) NOT NULL DEFAULT "1",
    CONSTRAINT fk_idventa FOREIGN KEY (idventa) REFERENCES ventas(idventa),
    CONSTRAINT fk_idmetodopago FOREIGN KEY (idmetodopago)REFERENCES metodos_pago(idmetodopago),
    CONSTRAINT fk_estado_deta_me  CHECK(estado IN ("0", "1"))
)ENGINE=INNODB;

DROP TABLE IF EXISTS comprobantes;
CREATE TABLE comprobantes (
    idcomprobante 	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    idventa 		INT NOT NULL,
   
	create_at		DATETIME NOT NULL DEFAULT NOW(),
	update_at		DATETIME NULL,
	estado          CHAR(1) NOT NULL DEFAULT "1", -- 	1: EMITIDO 	0: CANCELADO
    CONSTRAINT fk_idventa_comp FOREIGN KEY (idventa) REFERENCES ventas(idventa),
    CONSTRAINT fk_estado_comp   CHECK(estado IN ("0", "1"))
) ENGINE = INNODB;
-- ------------------------------------------------------------------------------------------------------