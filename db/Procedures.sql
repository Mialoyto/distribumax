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
IN _idempresaruc VARCHAR(11),
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
DROP PROCEDURE IF EXISTS sp_actualizar_cliente;
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

-- PROOVEDORES
-- PEDIDOS
-- KARDEX
-- PROMOCIONES
-- TIPOS DE PROMOCIONES
-- DESPACHO
-- TIPO DE COMPROBANTE
-- COMPROBANTES
-- METODO DE PAGO
--  VEHICULOS
-- MARCAS
-- SUBCATEGORIAS
-- BUSQUEDAS 
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
 
