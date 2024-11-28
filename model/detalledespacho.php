<?php

require_once 'Conexion.php';

class DetalleDespacho extends Conexion
{

  private $pdo;

  public function __construct()
  {
    $this->pdo = parent::getConexion();
  }

  public function add($params = [])
  {
    $id = -1;
    try {
      $tsql = "CALL sp_registrar_detalledespacho (?,?,?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(array(
        $params['iddespacho'],
        $params['idventa'],
        $params['idproducto']
      ));
      $id  = $query->fetch(PDO::FETCH_ASSOC);
      return $id['iddetalle_despacho'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}


/* $prueba = new DetalleDespacho();
$params = [
  'iddespacho' => 45,
  'idventa' => 2,
  'idproducto' => 3
];
$id = $prueba->add($params);
echo json_encode(['id' => $id]); */
