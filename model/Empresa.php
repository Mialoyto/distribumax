<?php

require_once 'Conexion.php';

class Empresas extends Conexion{

  private $pdo;
  public function __construct()
  {
    $this->pdo=parent::getConexion();
  }
  public function add($params = []) {

    try {
      
        $sql = "CALL sp_empresa_registrar(?, ?, ?, ?, ?, ?)";
        $query = $this->pdo->prepare($sql);
        $query->execute([
            $params['idempresaruc'],
            $params['iddistrito'],
            $params['razonsocial'],
            $params['direccion'],
            $params['email'],
            $params['telefono']
        ]);
      return $query->fetchAll(PDO::FETCH_ASSOC);

    } catch (Exception $e) {
    
        die($e->getMessage());
    }
}
  public function getAll() {
   try{
    $query="SELECT * FROM empresas";
    $cmd=$this->pdo->prepare($query);
    $cmd->execute();
    
    return $cmd->fetchAll(PDO::FETCH_ASSOC);

   }catch(Exception $e){
    die($e->getCode());
   }
  }

  public function UpdateEmpresa($params=[]){
    try{  
      $status=false;
      $query=$this->pdo->prepare("CALL sp_actualizar_empresa  (?,?,?,?,?,?) ");
      $status=$query->execute(array(
    
        $params['iddistrito'],
        $params['razonsocial'],
        $params['direccion'],
        $params['email'],
        $params['telefono'],
        $params['idempresaruc']

      ));
      return $status;
    }catch(Exception $e){
      die($e->getCode());
    }
  }
}
