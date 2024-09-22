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
      $status=false;
      $query=$this->pdo->prepare("CALL sp_registrar_producto (?,?,?,?,?,?) ");
      $status=$query->execute(array(
        $params['idmarca'],
        $params['idsubcategoria'],
        $params['nombreproducto'],
        $params['descripcion'],
        $params['codigo'],
        $params['preciounitario']

     ));
     if($status){
      return $status;
     }else{
      return false;
     }
      
    
    }catch(Exception $e){
      die($e->getMessage());
      
    }
  
  }
  public function getAll(){
    try{
      $sql="SELECT * FROM";
      $query=$this->pdo->prepare($sql);
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  
  }

  public function searchProducto($params=[])  {
     try{
        $sql="CALL sp_buscarproducto (?)";
        $query=$this->pdo->prepare($sql);
        $query->execute(array(
          $params['nombreproducto']
        
        ));

        return $query->fetchAll(PDO::FETCH_ASSOC);
      }catch(Exception $e){
      die($e->getMessage());
     }
  }

  public function getBytId($params=[]){
    try{
      $sql="SELECT * FROM productos WHERE idproducto=?";
      $query=$this->pdo->prepare($sql);
      $query->execute(array($params['idproducto']));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}