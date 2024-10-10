<?php

use FFI\Exception;

require_once 'Conexion.php';

class Productos extends Conexion
{
  private $pdo;

  public function __construct()
  {
    $this->pdo = parent::getConexion();
  }

  public function addProducto($params = [])
  {
    try {
      $status = false;
      $query = $this->pdo->prepare("CALL sp_registrar_producto (?,?,?,?,?,?) ");
      $status = $query->execute(array(
        $params['idproveedor'], 
        $params['idmarca'],
        $params['idsubcategoria'],
        $params['nombreproducto'],
        $params['descripcion'],
        $params['codigo'],
        $params['preciounitario']

      ));
      if ($status) {
        return $status;
      } else {
        return false;
      }
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function getAll()
  {
    try {
      $sql = "SELECT * FROM";
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

  // nueva function 
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
}
