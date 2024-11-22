<?php

require_once 'Conexion.php';

class Despachos  extends Conexion{

    private $pdo;

    public function __construct()
    {
    $this->pdo=parent::getConexion();
    }

    public function add($params){
        $id=-1;
        try{
            $query=$this->pdo->prepare("CALL sp_despacho_registrar (?,?,?,?)");
            $query->execute(array(
                $params['idventa'],
                $params['idvehiculo'],
                $params['idusuario'],
                $params['fecha_despacho']
            ));
            $row = $query->fetch(PDO::FETCH_ASSOC);
            // var_dump($row);

            return $row['iddespacho'];
        }catch(Exception $e){
            return $id;
        }
    }

    public function listar(){
        try{
            $query=$this->pdo->prepare("CALL sp_listar_despacho");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function reporte($params=[]){
        try{    
            $query=$this->pdo->prepare("CALL sp_reporte_despacho_por_proveedor (?)");
            $query->execute(array($params['iddespacho']));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
    public function listarventas($params=[]){
        try{
           $query=$this->pdo->prepare("CALL sp_listar_detalle_despacho(?)");
           $query->execute(array($params['iddespacho']));
           return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function updateEstado($params=[]){
        try{
            $status=-1;
            $query=$this->pdo->prepare("call sp_actualizar_estado(?,?)");
            $status=$query->execute(array(
                $params['iddespacho'],
                $params['estado']
            ));
            return $status;
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}