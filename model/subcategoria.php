<?php


require_once 'Conexion.php';

class Subcategoria extends Conexion
{
  private $pdo;

  public  function __construct()
  {
    $this->pdo = parent::getConexion();
  }

  public function addSubcategoria($params = [])
  {
    try {
      $status = false;
      $query = $this->pdo->prepare("CALL sp_registrar_subcategoria (?,?)");
      $status = $query->execute(array(
        $params['idcategoria'],
        $params['subcategoria']
      ));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function getAll()
  {
    try {
      $sql = "SELECT * FROM vw_listar_subcategorias";
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
          $params['idcategoria']
        )
      );
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
