<?php

require_once 'Conexion.php';

class Empresas extends Conexion
{

  private $pdo;
  public function __construct()
  {
    $this->pdo = parent::getConexion();
  }
  public function add($params = []): int
  {
    $id = -1;
    try {
      $sql = "CALL sp_empresa_registrar(?,?, ?, ?, ?, ?, ?)";
      $query = $this->pdo->prepare($sql);
      $query->execute([
        $params['idtipodocumento'],
        $params['idempresaruc'],
        $params['iddistrito'],
        $params['razonsocial'],
        $params['direccion'],
        $params['email'],
        $params['telefono']
      ]);

      // Usar fetch en lugar de fetchAll para obtener el primer resultado
      $row = $query->fetch(PDO::FETCH_ASSOC);
      if ($row) {
        $id = $row['idempresa']; // Asegúrate de usar el nombre correcto de la columna
        return $id;
      }
    } catch (Exception $e) {
      die($e->getMessage());
    }
    return $id;
  }

  public function getAll()
  {
    try {
      $sql = "CALL sp_listar_empresas";
      $query = $this->pdo->prepare($sql);
      $query->execute();

      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // public function UpEmpresa($params = [])
  // {
  //   try {
  //     $status = false;
  //     $query = $this->pdo->prepare("CALL sp_actualizar_empresa  (?,?,?,?,?,?) ");
  //     $status = $query->execute(array(

  //       $params['iddistrito'],
  //       $params['razonsocial'],
  //       $params['direccion'],
  //       $params['email'],
  //       $params['telefono'],
  //       $params['idempresaruc']

  //     ));

  //     return $status;
  //   } catch (Exception $e) {
  //     die($e->getCode());
  //   }
  // }

  public function getEmpresaById($params = []):array
  {
    try {
      $sql = "CALL sp_getEmpresasEdit(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(
        array(
          $params['idempresaruc']
        )
        );
        $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
        return $resultado;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function updateEstado($params = [])
  {
    try {
      $query = $this->pdo->prepare("CALL sp_estado_empresa (?,?)");
      $query->execute(array(
        $params['idempresaruc'],
        $params['estado']
      )
    );
    $response = $query->fetchAll(PDO::FETCH_ASSOC);
    return $response;   
  } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function search($params = [])
  {
    try {
      $sql = "CALL sp_buscar_empresa(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(
        array(
          $params['ruc']
        )
      );
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function updateEmpresa($params = [])
  {
    try{
      $tsql = "CALL sp_actualizar_empresa(?,?,?,?,?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['idempresaruc'],
          $params['razonsocial'],
          $params['direccion'],
          $params['email'],
          $params['telefono']
        )
        );
        $response = $query->fetchAll(PDO::FETCH_ASSOC);
        return $response;
    } catch(Exception $e){
      die($e->getMessage());
    }
  }

  
}
