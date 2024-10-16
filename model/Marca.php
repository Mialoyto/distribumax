<?php
require_once 'Conexion.php';
class Mara extends Conexion{
    private $pdo;

    public function __construct()
    {
            $this->pdo=parent::getConexion();
    }

    public function addMarca($params=[]){
        try{
            $query=$this->pdo->prepare("CALL sp_registrar_marca (?)");
            $query->execute(array(
                $params['marca']
            ));
            return $query;
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
    public function getAll() {
        try{
            $sql="SELECT * FROM marcas";
            $query=$this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}