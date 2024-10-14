<?php

require_once 'Conexion.php';

class UnidadMedida extends Conexion
{
  private $pdo;

  public function __CONSTRUCT()
  {
    $this->pdo = parent::getConexion();
  }

  public function getUnidadMedidas()
  {
    try {
      $sql = "SELECT * FROM vw_unidades_medidas";
      $query = $this->pdo->prepare($sql);
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}