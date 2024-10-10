<?php

require_once 'Conexion.php';

class TipoPromocion extends Conexion {
    private $pdo;

    public function __construct() {
        $this->pdo = parent::getConexion(); 
    }

    public function addTipoPromocion($params = []):array {
    
        try {
            // El procedimiento requiere 2 parámetros: tipopromocion, descripcion
            $sql = "CALL sp_tipo_promocion_registrar (?, ?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(array(
                $params['tipopromocion'],
                $params['descripcion']
            ));
            $id = $query->fetchAll(PDO::FETCH_ASSOC);
            return $id;
        } catch (Exception $e) {
             die($e->getMessage());
        }
    }

    public function getAll() {
        try {
            $sql = "CALL sp_listar_tipo_promociones";
            $query = $this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
