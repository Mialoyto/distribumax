<?php


require_once 'Conexion.php';
class Notificacion extends Conexion
{
    private $pdo;

    public function __construct()
    {
        $this->pdo = Conexion::getConexion();
    }

    public function notificar()
    {
        try {
            $sql = "SELECT * FROM vw_lotes";
            $cmd = $this->pdo->prepare($sql);
            $cmd->execute();
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function  updatenotificar($params = [])
    {
        try {
            $sql = "CALL sp_leer_notificacion(?,?)";
            $cmd = $this->pdo->prepare($sql);
            $cmd->execute(array($params['leido'], $params['idnotificacion']));
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function GenerarNotificacion()
    {
        try {
            $sql = "CALL sp_generar_notificaciones()";
            $cmd = $this->pdo->prepare($sql);
            $cmd->execute();
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function getAll()
    {
        try {
            $sql = "SELECT * FROM notificaciones where leido=0;";
            $cmd = $this->pdo->prepare($sql);
            $cmd->execute();
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
