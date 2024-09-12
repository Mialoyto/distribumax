<?php
require_once 'Conexion.php';

class Distrito extends Conexion
{
    private $pdo;

    function __CONSTRUCT()
    {
        $this->pdo = parent::getConexion();
    }

    public function searchDistrito($params = [])
    {
        try {
            $tsql = "CALL sp_buscardistrito (?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(array(
                $params['distrito']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function getAll(){
        try{
            $sql="SELECT * FROM view_distritos";
            $query=$this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}
