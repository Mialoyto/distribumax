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
  public function searchCliente($params = []): array
  {
    try {
      $tsql = "CALL sp_buscar_cliente (?)";
      $cmd = $this->pdo->prepare($tsql);
      $cmd->execute(array(
        $params['_nro_documento']
      ));
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getCode());
    }
  }

  public function getAll(){
    try{
        $query=$this->pdo->prepare("CALL sp_listar_clientes");
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }catch(Exception $e){
        die($e->getMessage());
    }
}
}