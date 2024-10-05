<?php


require_once 'Conexion.php';

class DetalleMetodo extends Conexion{
    private $pdo;
    public function __construct()
    {
        $this->pdo=parent::getConexion();
    }

    public function addDetalleMetodo($params=[]){
        $id=-1;
        try{
            $sql="CALL sp_registrar_detalleMetodo";
            $query=$this->pdo->prepare($sql);
            $query->execute(array(
                $params['idventa'],
                $params['idmetodopago'],
                $params['monto']
            ));
            $id=$query->fetch(PDO::FETCH_ASSOC);
            return $id['iddetallemetodo'];
        }catch(Exception $e){
                return $id;
        }
    }
}