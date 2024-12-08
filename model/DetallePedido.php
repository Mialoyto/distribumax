<?php

require_once 'Conexion.php';

class DetallePedido extends Conexion
{
  private $pdo;
  public function __construct()
  {
    $this->pdo = Conexion::getConexion();
  }

  public function addDetallePedido($params = []): int
  {
    $id = -1;
    try {
      $sql = "CALL sp_detalle_pedido(?,?,?,?,?,?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['idpedido'],
        $params['idproducto'],
        $params['cantidad_producto'],
        $params['unidad_medida'],
        $params['precio_unitario'],
        $params['descuento']
      ));
      $id = $query->fetch(PDO::FETCH_ASSOC);
      return $id['iddetallepedido'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
    // return $id;
  }

  // REVIEW : ESTA FUNCION SE ENCARGA DE CANCELAR EL ITEM DE UN PEDIDO

  public function cancelarItemPedido($params = []): array
  {
    try {
      $sql = "CALL sp_cancelar_item_pedido(?,?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['iddetallepedido'],
        $params['idpedido']
      ));
      $response =  $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
