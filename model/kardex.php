<?php
require_once 'Conexion.php';
class Kardex  extends Conexion{
    private $pdo;

    public function __construct()
    {
        $this->pdo=parent::getConexion();
    }

    public function add($params=[]) {
        try{
            $sql="CALL sp_registrarmovimiento(?,?,?,?,?,?)";
            $query=$this->pdo->prepare($sql);
            $query->execute(array(
                $params['idusuario'],
                $params['idproducto'],
                $params['stockactual'],
                $params['tipomovimiento'],
                $params['cantidad'],
                $params['motivo']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
          die($e->getMessage());
        }
    }
    public function getAll(){
        try{
            $query=$this->pdo->prepare("select * from kardex");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }

    }

    public function getById($params=[]){
        try{
            $sql="SELECT k.idkardex, k.stockactual, p.idproducto, p.nombreproducto 
                FROM kardex k
                INNER JOIN productos p ON k.idproducto = p.idproducto
                WHERE p.idproducto = ?";
            $query=$this->pdo->prepare($sql);
            $query->execute(array($params['idproducto']));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
        
    }
}
