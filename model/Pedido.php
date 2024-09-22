<?php

require_once 'Conexion.php';

class Pedidos extends Conexion
{
  private $pdo;
  public function __construct()
  {
    $this->pdo = Conexion::getConexion();
  }

  // funcion para agregar pedido
  public function agregarPedido($params = []): int
  {
    $id = -1;
    try {

      $sql = "CALL sp_pedido_registrar( ?, ?)";
      $cmd = $this->pdo->prepare($sql);
      $cmd->execute(array(
        $params['idusuario'],
        $params['idcliente']
      ));
      $row = $cmd->fetch(PDO::FETCH_ASSOC);
      $id = $row['idpedido'];
    } catch (Exception $e) {
      // $this->pdo->rollBack();
      // echo $e->getMessage();
      return $id;
    }
    return $id;
  }

  
}
