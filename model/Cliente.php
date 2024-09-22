<?php

require_once 'Conexion.php';

class Cliente extends Conexion
{
  private $pdo;

  public function __CONSTRUCT()
  {
    $this->pdo = parent::getConexion();
  }

  //Función para poder listar a todos los clientes
  public function getAll()
  {
    try{
      $sql = "SELECT * FROM view_clientes";
      $consulta = $this->pdo->prepare($sql);
      $consulta->execute();

      return $consulta->fetchAll(PDO::FETCH_ASSOC);
    }
    catch(Exception $e){
      die($e->getCode());
    }
  }


}