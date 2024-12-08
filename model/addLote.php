<?php

require_once 'Conexion.php';

class addLote extends Conexion
{


  private $pdo;
  public function __construct()
  {
    $this->pdo = Conexion::getConexion();
  }

  public function addLote()
  {
    try {

      $sql = "CALL procesar_detalle_pedidos_temp()";
      $result = $this->pdo->prepare($sql);
      $result->execute();
      return $result->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
