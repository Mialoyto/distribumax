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
  public function agregarPedido($params = []): string
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
      return $id;
    }
    return $id;
  }

  public function searchPedido($params=[]){
    try{
      $sql="CALL sp_buscar_pedido(?)";
      $query=$this->pdo->prepare($sql);
      $query->execute(array(
        $params['_idpedido']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }

  public function getById($params=[]){
    try{
      $sql="CALL sp_getById_pedido(?)";
      $query=$this->pdo->prepare($sql);
      $query->execute(array(
        $params['idpedido']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());

    }
  }

  
}
