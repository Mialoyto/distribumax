<?php
 
 require_once 'Conexion.php';

 class Vehiculo extends Conexion{
    private $pdo;

    public function __construct()
    {
       $this->pdo=parent::getConexion(); 
    }

    public function addVehiculo($params=[]){
        try{
            $status=false;
            $query=$this->pdo->prepare("CALL sp_registrar_vehiculo (?,?,?,?,?,?)");
            $status=$query->execute(array(
                
                $params['idusuario'],
                $params['marca_vehiculo'],
                $params['modelo'],
                $params['placa'],
                $params['capacidad'],
                $params['condicion']
            ));
            
            return $status;
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
    public function getAll(){
        try{
            $query=$this->pdo->prepare("CALL sp_listar_vehiculo");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function searchConductor($params=[]){
        try{
            $query=$this->pdo->prepare("CALL sp_buscar_conductor (?)");
            $query->execute(array($params['item']));
            return  $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){   
            die($e->getMessage());
        }
    }
}