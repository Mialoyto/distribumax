-- Active: 1726291702198@@localhost@3306@distribumax
USE distribuMax;
-- 02 personas
DROP PROCEDURE IF EXISTS spu_registrar_personas;
DROP PROCEDURE IF EXISTS sp_actualizar_persona;
DROP PROCEDURE IF EXISTS sp_desactivar_persona;
drop procedure if exists sp_buscarpersonadoc;
-- 02 empresas
DROP PROCEDURE IF EXISTS sp_empresa_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_empresa;
DROP PROCEDURE IF EXISTS sp_estado_empresa;
DROP VIEW IF EXISTS view_empresas;

-- 04 usuarios
drop procedure if exists sp_registrar_usuario;
DROP PROCEDURE IF EXISTS sp_actualizar_usuario;
DROP PROCEDURE IF EXISTS sp_desactivar_usuario;
drop procedure if exists sp_usuario_login;

-- 05 Clientes
DROP PROCEDURE IF EXISTS sp_cliente_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_cliente;
DROP PROCEDURE IF EXISTS sp_estado_cliente;

-- 06 Proveedores 
DROP PROCEDURE IF EXISTS sp_proovedor_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_proovedor;
DROP PROCEDURE IF EXISTS sp_estado_proovedor;

-- 07 Categorias
DROP PROCEDURE IF EXISTS sp_registrar_categoria;
DROP PROCEDURE IF EXISTS sp_actualizar_categoria;
DROP PROCEDURE IF EXISTS sp_desactivar_categoria;
DROP VIEW IF EXISTS vw_listar_categorias;

-- 08 Subcategorias
DROP PROCEDURE IF EXISTS sp_registrar_subcategoria;
DROP PROCEDURE IF EXISTS sp_actualizar_subcategoria;

-- 09 Marcas
DROP PROCEDURE IF EXISTS sp_registrar_marca;
DROP PROCEDURE IF EXISTS sp_actualizar_marca;
DROP PROCEDURE IF EXISTS sp_eliminar_marca;
DROP VIEW IF EXISTS vw_listar_marcas;

-- 10 Productos
DROP PROCEDURE IF EXISTS sp_registrar_producto;
DROP PROCEDURE IF EXISTS sp_actualziar_producto;
DROP PROCEDURE IF EXISTS sp_estado_producto;

-- 11 AA
DROP PROCEDURE IF EXISTS sp_pedido_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_pedido;
DROP PROCEDURE IF EXISTS sp_estado_pedido;

-- 12 tipo promocion
DROP PROCEDURE IF EXISTS sp_tipo_promocion_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_promocion;
DROP PROCEDURE IF EXISTS sp_actualizar_tipo_promocion;

-- 13 promociones
DROP PROCEDURE IF EXISTS sp_promocion_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_promocion;
DROP PROCEDURE IF EXISTS sp_estado_promocion;

-- 14 detalle promocion


-- 15 detalle pedidos
DROP PROCEDURE IF EXISTS sp_detalle_pedido;
DROP TRIGGER IF EXISTS trg_actualizar_stock;
DROP PROCEDURE IF EXISTS sp_actualizar_detalle_pedido;
DROP PROCEDURE IF EXISTS sp_estado_detalle_pedido;
DROP PROCEDURE IF EXISTS sp_buscar_productos;
DROP PROCEDURE IF EXISTS sp_getById_pedido;


-- 16 vehiculos
DROP PROCEDURE IF EXISTS sp_registrar_vehiculo;
DROP PROCEDURE IF EXISTS sp_actualizar_vehiculo;
DROP PROCEDURE IF EXISTS sp_buscar_vehiculos;

-- 17 metodos de pago
DROP PROCEDURE IF EXISTS sp_metodo_pago_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_metodo_pago;

-- 18 tipo comprobante
DROP PROCEDURE IF EXISTS sp_tipo_comprobantes_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_tipo_comprobantes;

-- 19 despacho
DROP PROCEDURE IF EXISTS sp_despacho_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_despacho;

-- 20 ventas 
DROP PROCEDURE IF EXISTS sp_registrar_venta;
DROP PROCEDURE IF EXISTS sp_actualizar_venta;
DROP PROCEDURE IF EXISTS sp_estado_venta;

-- 21 Comprobantes
DROP PROCEDURE IF EXISTS sp_comprobantes_registrar;
DROP PROCEDURE IF EXISTS sp_actualizar_comprobantes;
-- 22 Accesos

-- 23 Roles

-- 24 Entidad Roles

-- 25 Departamentos

-- 26 Provincias 

-- 27 distritos
DROP PROCEDURE IF EXISTS sp_buscardistrito;
DROP VIEW IF EXISTS view_distritos;

-- 28 Tipo Documentos 
DROP VIEW IF EXISTS view_tipos_documentos;

-- 29 Kardex
DROP PROCEDURE IF EXISTS sp_registrarmovimiento;

DROP PROCEDURE IF EXISTS sp_registrarmovimiento_detallepedido;






