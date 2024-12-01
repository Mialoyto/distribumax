<?php

require_once 'Conexion.php';

class Lotes extends Conexion
{
  private $pdo;

  function __CONSTRUCT()
  {
    $this->pdo = parent::getConexion();
  }

  public function add($params = []): array
  {
    $Datos = [
      'status' => '',
      'message' => '',
      'id' => ''
    ];
    $id = 0;
    try {
      $tsql = 'CALL sp_registrar_lote(?,?,?)';
      $query = $this->pdo->prepare($tsql);
      $query->execute(array(
        $params['idproducto'],
        $params['numlote'],
        $params['fecha_vencimiento']
      ));
      $resultado = $query->fetch(PDO::FETCH_ASSOC);
      $id = $resultado['idlote'];
      // var_dump($id);
      if ($id == -1) {

        $Datos['status'] = 'error';
        $Datos['message'] = 'Este producto ya tiene un lote con el número de lote ingresado';
        $Datos['id'] = $id;
        return $Datos;
      } else {
        $Datos['status'] = 'success';
        $Datos['message'] = 'Lote registrado';
        $Datos['id'] = $id;
        return $Datos;
      }
    } catch (Exception $e) {
      // die($e->getMessage());
      $Datos['status'] = 'error';
      $errorMessage = $e->getMessage();
      $Datos['message'] = $this->extractTriggerMessage($errorMessage);
      $Datos['id'] = $id;
      return $Datos;
    }
  }

  private function extractTriggerMessage($errorMessage)
  {
    // Extraer el mensaje del trigger sin el número 1644
    $pattern = "/SQLSTATE\[45000\]:.*: (\d+ )?(.*)/";
    preg_match($pattern, $errorMessage, $matches);
    return $matches[2] ?? $errorMessage;
  }


  public function searchLote($params = [])
  {
    try {
      $tsql = 'CALL spu_buscar_lote(?)';
      $query = $this->pdo->prepare($tsql);
      $query->execute(array(
        $params['_idproducto']
      ));
      $datos = $query->fetchAll(PDO::FETCH_ASSOC);
      return $datos;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function Agotados_vencidos(){
    try {
      $tsql = 'CALL sp_productos_por_agotarse_o_vencimiento()';
      $query = $this->pdo->prepare($tsql);
      $query->execute();
      $datos = $query->fetchAll(PDO::FETCH_ASSOC);
      return $datos;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}

/* $lote = new Lotes();
$data = [
  'idusuario' => 1,
  'idproducto' => 1,
  'numlote' => '123456',
  'fecha_vencimiento' => '2021-12-31'
];
echo json_encode($lote->add($data)); */
