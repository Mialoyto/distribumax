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

  // Registrar clientes
//   public function addCliente($params = []): string
//   {
//     try{
//       $id = '';
//       $tsql = "CALL sp_cliente_registrar (?,?,?)";
//       $query = $this->pdo->prepare($tsql);
//       $query->execute(
//         array(
//           $params["idpersona"],
//           $params["idempresa"],
//           $params["tipo_cliente"]
//         )
//       );
//     } catch(Exception $e){
//       error_log("Error al registrar al cliente" . $e->getMessage());
//     }
//     return $id;
//   }
}