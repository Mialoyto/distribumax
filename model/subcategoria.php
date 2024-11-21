<?php


require_once 'Conexion.php';

class Subcategoria extends Conexion
{
  private $pdo;

  public  function __construct()
  {
    $this->pdo = parent::getConexion();
  }

  // solo fatlta el agregar subcategorias
  public function addSubcategoria($params = []): array
  {
    try {
      $tsql = "CALL sp_registrar_subcategoria(?, ?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(array(
        $params['idcategoria'],
        $params['subcategoria']
      ));
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getAll()
  {
    try {
      $sql = "CALL sp_listar_subcategorias()";
      $query = $this->pdo->prepare($sql);
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getSubcategorias($params = [])
  {
    try {
      $sql = "CALL getSubcategorias(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(
        array(
          $params['idsubcategoria']
        )
      );
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function updateSubcategoria($params = [])
  {
    try {
      $query = $this->pdo->prepare("CALL sp_actualizar_subcategoria (?,?)");
      $query->execute(array(
        $params['idsubcategoria'],
        $params['subcategoria']
      ));
      $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
      return $resultado;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function UpdateEstado($params = [])
  {
    try {
      $tsql = "CALL sp_update_estado_subcategoria(?, ?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(array(
        $params['idsubcategoria'],
        $params['estado']
      ));
      $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
      return $resultado;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
