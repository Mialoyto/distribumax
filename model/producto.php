<?php

require_once 'Conexion.php';

class Productos extends Conexion
{
  private $pdo;

  public function __construct()
  {
    $this->pdo = parent::getConexion();
  }

  public function addProducto($params = []): int|null
  {
    $id = null;
    try {
      $sql = "CALL sp_registrar_producto (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['idproveedor'],
        $params['idmarca'],
        $params['idsubcategoria'],
        $params['nombreproducto'],
        $params['idunidadmedida'],
        $params['cantidad_presentacion'],
        $params['peso_unitario'],
        $params['codigo'],
        $params['precio_compra'],
        $params['precio_mayorista'],
        $params['precio_minorista']
      ));
      $id = $query->fetch(PDO::FETCH_ASSOC);
      return $id['idproducto'];
    } catch (Exception $e) {
      return $id;
    }
  }

  public function getAll()
  {
    try {
      $sql = "CALL sp_listar_productos";
      $query = $this->pdo->prepare($sql);
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function searchProducto($params = [])
  {
    try {
      $sql = "CALL sp_buscar_productos(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['_item']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function ObtenerPrecioProducto($params = [])
  {
    try {
      $sql = "CALL ObtenerPrecioProducto(?,?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['_cliente_id'],
        $params['_item']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getCodigoProducto($params = [])
  {
    try {
      $sql = "CALL sp_get_codigo_producto(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['codigo']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // Método para eliminar producto
  public function UpdateEstado($params = [])
  {
    try {
      $status = -1;
      $sql = "CALL sp_estado_producto(?,?)";
      $query = $this->pdo->prepare($sql);
      $status = $query->execute(array(
        $params['estado'],
        $params['idproducto']
      ));
      return $status;
    } catch (Exception $e) {
      return false;
    }
  }

  public function updateProducto($params = [])
  {

    try {
      $query = $this->pdo->prepare("call sp_registrar_producto(?,?,?,?,?,?,?,?,?,?)");
      $query->execute(
        $params['idmarca'],
        $params['idsubcategoria'],
        $params['nombreproducto'],
        $params['idunidadmedida'],
        $params['cantidad_presentacion'],
        $params['codigo'],
        $params['precio_compra'],
        $params['precio_mayorista'],
        $params['precio_minorista'],
        $params['idproducto']
      );
      return $query->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function ObtenerProducto($params=[]){
    try{
        $query=$this->pdo->prepare("call sp_obtener_producto(?)");
        $query->execute(array($params['idproducto']));
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}
