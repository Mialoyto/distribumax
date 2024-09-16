<?php 

require_once 'Conexion.php';

class Rol extends Conexion{
    private $pdo;

    function __CONSTRUCT(){
        $this->pdo = parent::getConexion();
    }

    function getAllRol(): array{
        try{
            $tsql = "SELECT * FROM vw_listar_roles";
            $query = $this->pdo->prepare($tsql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}