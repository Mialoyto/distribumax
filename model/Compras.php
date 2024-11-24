<?php
require_once 'Conexion.php';

class Compras extends Conexion
{
  private $pdo;


  public function __CONSTRUCT()
  {
    $this->pdo = parent::getConexion();
  }

  public function getProductosProveedor($params = [])
  {
    try {
      $sql = "CALL sp_get_productos_proveedor (?,?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(
        array(
          $params['idproveedor'],
          $params['producto']
        )
      );
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
