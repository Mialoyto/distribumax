<?php

require_once 'Conexion.php';

class Categoria extends Conexion{
    private $pdo;

    public function __construct()
    {
        $this->pdo=parent::getConexion();
    }

    public function addCategoria($params=[]){
        try{
            
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}