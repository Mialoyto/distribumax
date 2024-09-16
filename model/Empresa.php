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
    $sql="SELECT E.idempresaruc, E.razonsocial, E.direccion,E.email,E.telefono, D.iddistrito,D.distrito
    FROM empresas E
    INNER JOIN  distritos D ON E.iddistrito=D.iddistrito
    ORDER BY razonsocial ASC";
    $query=$this->pdo->prepare($sql);
    $query->execute();
    
    return $query->fetchAll(PDO::FETCH_ASSOC);

   }catch(Exception $e){
    die($e->getCode());
   }
  }
  public function getByID($params = []) {
    try {
        $sql = "SELECT * FROM empresas WHERE idempresaruc = ?";
        $query = $this->pdo->prepare($sql);

        // Usar el valor del array $params directamente
        $query->execute([$params['idempresaruc']]);
        
        return $query->fetch(PDO::FETCH_ASSOC); // Se asume que obtendrás un solo resultado
    } catch (Exception $e) {
        die($e->getMessage());
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

  public function upEstado($params=[]){
    try{
      $query=$this->pdo->prepare("CALL sp_estado_empresa (?,?)");
      $query->execute(array(
        $params['estado'],
        $params['idempresaruc']
      ));
      return $query;
    }catch(Exception $e){
      die($e->getMessage());
    
  }
 }
}
