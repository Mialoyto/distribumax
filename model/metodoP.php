<?php

require_once 'Conexion.php';

class MetodoPago extends Conexion{
    private $pdo;

    public function __construct()
    {
        $this->pdo=parent::getConexion();
    }

    public function addMetodo($params=[]){
        try{
            $query=$this->pdo->prepare("CALL sp_metodo_pago_registrar(?)");
            $query->execute(array(
                $params['metodopago']
            ));
            return $query;
        }catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function getAll(){
        try{
            $query=$this->pdo->prepare("CALL sp_listar_mePago");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}