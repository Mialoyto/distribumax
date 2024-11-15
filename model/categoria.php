<?php

require_once 'Conexion.php';

class Categoria extends Conexion
{
    private $pdo;

    public function __construct()
    {
        $this->pdo = parent::getConexion();
    }

    public function addCategoria($params = []): array
    {
        try {
            $tsql = "CALL sp_registrar_categoria(?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(array($params['categoria']));
            $resultados = $query->fetchAll(PDO::FETCH_ASSOC);
            return $resultados;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getAll()
    {
        try {
            $sql = "SELECT * FROM vw_listar_categorias ";
            $query = $this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getCategoria()
    {
        try {
            $sql = "CALL sp_listar_categorias()";
            $query = $this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function DeleteCategoria()
    {
        try{
            $sql = "CALL sp_desactivar_categoria()";
            $query = $this->pdo->prepare($sql);
            $query->execute();
        } catch(Exception $e){
            die($e->getMessage());
        }
    }
}
