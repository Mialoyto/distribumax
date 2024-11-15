<?php


require_once 'Conexion.php';

class Promocion extends Conexion{
  private $pdo;

  public function __construct()
  {
    $this->pdo=parent::getConexion(); 
  }

  public function addPromocion($params = []) {
    try {
        $sql = "CALL sp_promocion_registrar (?, ?, ?, ?, ?)";
        $query = $this->pdo->prepare($sql);
        $query->execute([
            $params['idtipopromocion'],
            $params['descripcion'],
            $params['fechainicio'],
            $params['fechafin'],
            $params['valor_descuento']
        ]);
        return ['status' => 'success'];
    } catch (Exception $e) {
        return ['status' => 'error', 'message' => $e->getMessage()];
    }
}


  public function getAll(){
    try{
      $sql="CALL sp_listar_promociones";
      $query=$this->pdo->prepare($sql);
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);

    }catch(Exception $e){
      die($e->getMessage());
    }
  }
}
