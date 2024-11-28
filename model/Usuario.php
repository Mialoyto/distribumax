<?php

use PhpOffice\PhpSpreadsheet\Calculation\MathTrig\Arabic;

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


    public function addUsuario($params = []): int
    {
        $idusuario = null;
        try {
            $tsql = "CALL sp_registrar_usuario (?, ?, ?, ?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(
                array(
                    $params["idpersona"],
                    $params[" idperfil"],
                    $params["nombre_usuario"],
                    password_hash($params["password_usuario"], PASSWORD_BCRYPT)
                )
            );
            $row = $query->fetch(PDO::FETCH_ASSOC);
            return $idusuario = $row['idusuario'];
        } catch (Exception $e) {
            $idusuario = -1;
        }
        return $idusuario;
    }

    function searchUser($params = []): array
    {
        try {
            $tsql = "CALL sp_buscarusuarios_registrados (?, ?)";
            $cmd = $this->pdo->prepare($tsql);
            $cmd->execute(array(
                $params['idtipodocumento'],
                $params['idpersonanrodoc']
            ));
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    function getUser($params = []): bool
    {
        $user = false;
        try {
            $tsql = "SELECT count(nombre_usuario) AS username FROM usuarios WHERE nombre_usuario = ? ";
            $cmd = $this->pdo->prepare($tsql);
            $cmd->execute(
                array($params['username'])
            );
            $user = $cmd->fetch(PDO::FETCH_ASSOC);
            return $user['username'] > 0;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getAll()
    {
        try {
            $query = $this->pdo->prepare("CALL spu_listar_usuarios");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function obtenerPermisos($params = []): array
    {
        try {
            $cmd = $this->pdo->prepare("CALL spu_obtener_acceso_usuario(?)");
            $cmd->execute(
                array($params['idperfil'])
            );
            return $cmd->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            error_log("Error: " . $e->getMessage());
            return [];
        }
    }
    
    public function updatepassword($params=[]){
        try{
            $status=-1;
            $query=$this->pdo->prepare("CALL sp_actualizar_contraseña (?,?)");
            $status=$query->execute(array(
                $params['idusuario'],
                password_hash($params["password_usuario"], PASSWORD_BCRYPT)
            ));
            return $status;
        }catch(Exception $e){
            die($e->getMessage());
        }
    }
}
