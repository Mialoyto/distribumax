<?php 
require_once 'Conexion.php';

class Usuarios extends Conexion{

    private $pdo;

    public function __CONSTRUCT(){
        $this->pdo = parent::getConexion();
    }

    public function addUsuario($params = []){
        
    }
}