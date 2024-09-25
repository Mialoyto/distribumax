<?php

require_once 'Conexion.php';

class ComprobantePago extends Conexion{
    private $pdo;

    public function __construct()
    {
     $this->pdo=parent::getConexion();   
    }

    public function addComprobante($params=[]) {
        try{
            $query=$this->pdo->prepare("CALL sp_tipo_comprobantes_registrar(?)");
            $query->execute(array(
            $params['comprobantepago']
        ));
        return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
    public function getAll(){
        try{
            $query=$this->pdo->prepare("CALL sp_listar_comprobate ");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){   
            die($e->getMessage());
        }
    }
}