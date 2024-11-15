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
      $sql = "CALL sp_detalle_pedido(?,?,?,?,?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['idpedido'],
        $params['idproducto'],
        $params['cantidad_producto'],
        $params['unidad_medida'],
        $params['precio_unitario']
      ));
      $id = $query->fetch(PDO::FETCH_ASSOC);
      return $id['iddetallepedido'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
    // return $id;
  }
}

/* $prueba = new DetallePedido();
$params = [
  'idpedido' => 1,
  'idproducto' => 1,
  'cantidad' => 1,
  'unidad_medida' => 'kg',
  'precio_unitario' => 10.5
];
$id = $prueba->addDetallePedido($params);
echo json_encode(['id' => $id]); */
