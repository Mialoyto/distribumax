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

  public function add($params = []): string
  {
    try{
      $tsql = "CALL sp_cliente_registrar (?,?,?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params["idpersona"],
          $params["idempresa"],
          $params["tipo_cliente"]
        )
      );

      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch(Exception $e){

      die($e->getMessage());
    }
  }

  public function UpdateCliente($params = []){
    try{
      $status = false;
      $query = $this->pdo->prepare("CALL sp_actualizar_cliente(?,?,?,?)");
      $status = $query->execute(array(
        $params['idcliente'],
        $params['idpersona'],
        $params['idempresa'],
        $params['tipo_cliente']
      ));
      return $status;
    }catch(Exception $e){
      die($e->getCode());
    }
  }
}