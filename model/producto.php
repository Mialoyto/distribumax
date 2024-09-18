<?php

use FFI\Exception;

require_once 'Conexion.php';

class Productos extends Conexion{
  private $pdo;

  public function __construct()
  {
    $this->pdo=parent::getConexion();
  }

  public function addProducto($params=[]){
    try{
      $query=$this->pdo->prepare("CALL sp_registrar_producto (?,?,?,?,?,?) ");
      
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}