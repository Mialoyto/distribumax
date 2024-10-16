<?php


require_once 'Conexion.php';


class DetalleMetodo extends Conexion
{
    private $pdo;
    public function __construct()
    {
        $this->pdo = parent::getConexion();
    }

    public function addDetalleMetodo($params = []): int
    {
        $id = -1;
        try {

            $sql = "CALL sp_registrar_detalleMetodo (?,?,?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(array(
                $params['idventa'],
                $params['idmetodopago'],
                $params['monto']
            ));

            $row = $query->fetch(PDO::FETCH_ASSOC);
            // var_dump($row);

            return $row['iddetalle_pago'];
        } catch (Exception $e) {
            return $id;
        }
    }
}
