<?php
require_once 'Conexion.php';

class Usuario extends Conexion
{

    private $pdo;

    
    public function __CONSTRUCT()
    {
        $this->pdo = parent::getConexion();
    }

    public function login($params = []): array
    {
        try {
            $tsql = "CALL sp_usuario_login (?)";
            $cmd = $this->pdo->prepare($tsql);
            $cmd->execute(array(
                $params['nombre_usuario']
            ));
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }


    public function addUsuario($params= []): int
    {
        $idusuario = null;
        try {
            $tsql = "CALL sp_registrar_usuario (?, ?, ?, ?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(
                array(
                    $params["idpersona"],
                    $params["idrol"],
                    $params["nombre_usuario"],
                    password_hash($params["password_usuario"], PASSWORD_BCRYPT)
                )
            );
            $row = $query->fetch(PDO::FETCH_ASSOC);
            $idusuario = $row['idusuario'];
        } catch (Exception $e) {
            $idusuario = -1;
        }
        return $idusuario;
    }
}
