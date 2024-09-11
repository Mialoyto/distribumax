<?php 
require_once 'Conexion.php';

class Documento extends Conexion
{
    private $pdo;

    public function __CONSTRUCT()
    {
        $this->pdo = parent::getConexion();
    }

    // funcion para listar todas las personas
    public function getAllDocumentos()
    {
        try {
            $tsql = "SELECT * FROM view_tipos_documentos";
            $query = $this->pdo->prepare($tsql);
            $query->execute();

            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getCode());
        }
    }
}