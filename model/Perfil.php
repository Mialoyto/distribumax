<?php

require_once 'Conexion.php';

class Perfil extends Conexion
{

  private $pdo;
  public function __construct()
  {
    $this->pdo = parent::getConexion();
  }


  public function listPeril(): array
  {
    try {
      $tsql = "CALL spu_listar_perfiles()";
      $query = $this->pdo->prepare($tsql);
      $query->execute();
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
