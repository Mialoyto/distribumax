<?php

require_once 'Conexion.php';

class Ventas extends Conexion{
    private $pdo;

    public function __construct()
    {
       $this->pdo=parent::getConexion(); 
    }
    public function addVentas($params=[]):bool{
        try{
            $estado = false;
            $query=$this->pdo->prepare("CALL sp_registrar_venta(?,?,?,?,?,?,?,?) ");
            $estado = $query->execute(array(
                $params['idpedido'],
                $params['idmetodopago'],
                $params['idtipocomprobante'],
                $params['fecha_venta'],
                $params['subtotal'],
                $params['descuento'],
                $params['igv'],
                $params['total_venta']
            ));
            $estado = $query->fetch(PDO::FETCH_ASSOC);
            return $estado;
        }catch(Exception $e){
            return $estado;
        }
    }

    public function getAll(){
        try{
            $query=$this->pdo->prepare("CALL sp_listar_ventas");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
    public function reporteVenta($params=[]){
        try{
            $query=$this->pdo->prepare("CALL sp_generar_reporte(?)");
            $query->execute(array(
                $params['idventa']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}