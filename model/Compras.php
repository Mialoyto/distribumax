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

  public function addCompra($params = [])
  {
    try {
      $tsql = "CALL sp_registrar_compra (?,?,?,?,?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['idusuario'],
          $params['idproveedor'],
          $params['idcomprobante'],
          $params['numcomprobante'],
          $params['fechaemision']
        )
      );
      $response = $query->fetch(PDO::FETCH_ASSOC);
      return $response['idcompra'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }


  public function addDetalleCompra($params = [])
  {
    try {
      $tsql = "CALL sp_registrar_detalle_compra (?,?,?,?,?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['idcompra'],
          $params['idlote'],
          $params['idproducto'],
          $params['cantidad'],
          $params['preciocompra']
        )
      );
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getAll(){
    try {
      $tsql = "CALL sp_listar_compras ()";
      $query = $this->pdo->prepare($tsql);
      $query->execute();
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function updateEstado($params=[]){
    try {
      $status = -1;
      $tsql = "CALL sp_update_estadocompras(?,?)";
      $query = $this->pdo->prepare($tsql);
      $status=$query->execute(
        array(
  
          $params['estado'],
          $params['idcompra']
        )
      );
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}

// ********** TEST **********
// TODO: HASTA EL MODELO FUNCIONA CORRECTAMENTE
/* $prueba = new Compras();

$datos = [
  'idcompra' => 1,
  'idlote' => 1,
  'idproducto' => 1,
  'cantidad' => 1,
  'preciocompra' => 1
];

$response = $prueba->addDetalleCompra($datos);
echo json_encode($response);
 */