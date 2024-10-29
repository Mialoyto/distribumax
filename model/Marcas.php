<?php
require_once 'Conexion.php';
class Marca extends Conexion
{
    private $pdo;

    public function __construct()
    {
        $this->pdo = parent::getConexion();
    }

    public function addMarca($params = [])
    {
        try {
            $status=false;
            $query = $this->pdo->prepare("CALL sp_registrar_marca (?,?,?)");
           $status= $query->execute(array(
                $params['idproveedor'],
                $params['marca'],
                $params['idcategoria']

            ));
            return $status;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function getAll()
    {
        try {
            $sql = "CALL sp_listar_marca";
            $query = $this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getMarca($params = []): array
    {
        try {
            $sql = "CALL sp_getMarcas(?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(array(
                $params['id']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
