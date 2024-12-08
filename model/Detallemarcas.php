<?php
require_once 'Conexion.php';
class Detallemarca extends Conexion
{
    private $pdo;

    public function __construct()
    {
        $this->pdo = parent::getConexion();
    }

    public function addDetallemarca($params = [])
    {
        try {
            $sql = "call sp_registrar_detalle(?,?)";
            $stm = $this->pdo->prepare($sql);
            $stm->execute(array(
                $params['idmarca'],
                $params['idcategoria']
            ));
            return $stm->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
