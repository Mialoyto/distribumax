<?php


require_once 'Conexion.php';

class Promocion extends Conexion{
  private $pdo;

  public function __construct()
  {
    $this->pdo=parent::getConexion(); 
  }

  public function addPromocion($params=[]){
    try{
      $sql="CALL sp_tipo_promocion_registrar (?,?)";
      $query=$this->pdo->prepare($sql);
      $query->execute(array(
         $params['tipopromocion'],
         $params['descripcion']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
      die($e->getMessage());

    }
  }

  public function getAll(){
    try{
      $sql="CALL sp_listar_promociones";
      $query=$this->pdo->prepare($sql);
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);

    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}
