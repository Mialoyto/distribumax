<?php

require_once 'Conexion.php';

class DetalleDespacho extends Conexion {

    private $pdo;

    public function __construct()
    {
        $this->pdo = parent::getConexion();
    }

    public function add($params = [])
    {
        $id = -1;
        try {
            $query = $this->pdo->prepare("CALL sp_registrar_detalledespacho (?,?)");
            $query->execute(array(
                $params['idventa'],
                $params['iddespacho']
            ));

            // Verifica si se obtuvo algún resultado
            $row = $query->fetch(PDO::FETCH_ASSOC);
            if ($row && isset($row['iddetalle_despacho'])) {
                return $row['iddetalle_despacho'];  // Devuelve el ID del detalle de despacho
            } else {
                return $id;  // Si no se obtuvo un resultado válido
            }
        } catch (Exception $e) {
            // Manejo de excepciones
            return $id;
        }
    }
}

?>
