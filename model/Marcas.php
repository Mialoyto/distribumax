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
            $tsql = "CALL sp_registrar_marca (?,?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(array(
                $params['idproveedor'],
                $params['marca'],
            ));
            $resultados = $query->fetchAll(PDO::FETCH_ASSOC);
            return $resultados;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function getAll()
    {
        try {
            $sql = "CALL sp_listar_marcas";
            $query = $this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getMarcaById($params = []): array
    {
        try {
            $sql = "CALL sp_getMarcasEdit(?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(
                array(
                    $params['idmarca']
                )
            );
            $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
            return $resultado;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function updateMarca($params = []): array
    {
        try {
            $tsql = "CALL sp_actualizar_marca(?,?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(
                array(
                    $params['idmarca'],
                    $params['marca']
                )
            );
            $response = $query->fetchAll(PDO::FETCH_ASSOC);
            return $response;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function updateEstado($params = [])
    {
        try {
            $sql = "CALL sp_update_estado_marca(?,?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(
                array(
                    $params['idmarca'],
                    $params['estado']
                )
            );
            $response = $query->fetchAll(PDO::FETCH_ASSOC);
            return $response;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getMarca($params = []): array
    {
        try{
            $sql = "CALL sp_getMarcas(?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(array(
                $params['id']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
         // ! No toques esto ctmr
    public function getmarcas_categorias($params = [])
    {
        try{
            $sql = "CALL sp_getMarcas_Categorias(?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(array(
                $params['idmarca']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch(Exception $e){
            die($e->getMessage());
        }
    }
    public function searchMarcas($params=[]){
        try{
            $sql = "CALL sp_buscar_marca(?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(array($params['item']));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}
