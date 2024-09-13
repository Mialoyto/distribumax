<?php
require_once 'Conexion.php';
class Proveedor extends Conexion{
    private $pdo;

    public function __construct()
    {
        $this->pdo=parent::getConexion();

    }
    public function addProveedor($params=[]){

        try{
            $query=$this->pdo->prepare("CALL sp_proovedor_registrar (?,?,?,?,?,?)");
            $query->execute(array(
                $params['idempresa'],
                $params['proveedor'],
                $params['contacto_principal'],
                $params['telefono_contacto'],
                $params['direccion'],
                $params['email']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
        
    }
    public function getAll(){
        try{
            $sql="SELECT * FROM proveedores;";
            $query=$this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
    public function upProveedor($params=[]){
        try{
            $query=$this->pdo->prepare("CALL sp_actualizar_proovedor (?,?,?,?,?,?,?)");
            $query->execute(array(

                $params['idempresa'],
                $params['proveedor'],
                $params['contacto_principal'],
                $params['telefono_contacto'],
                $params['direccion'],
                $params['email'],
                $params['idproveedor']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function upEstado($params=[]){
        try{
          
            $query=$this->pdo->prepare("CALL sp_estado_proovedor (?,?)");
            $query->execute(array(
                $params['estado'],
                $params['idproveedor']
            ));
            
           return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }

    }
}