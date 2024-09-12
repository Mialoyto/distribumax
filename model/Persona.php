<?php
require_once 'Conexion.php';

class Persona extends Conexion
{
    private $pdo;

    public function __CONSTRUCT()
    {
        $this->pdo = parent::getConexion();
    }

    // funcion para listar todas las personas
    public function getAllPersonas()
    {
        try {
        } catch (Exception $e) {
        }
    }
    // registrar persona
    public function addPersona($params = []): string
    {
        try {
            $id = '';
            $tsql = "CALL spu_registrar_personas (?, ?, ?, ?, ?, ?, ?, ?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(
                array(
                    $params["idtipodocumento"],
                    $params["idpersonanrodoc"],
                    $params["iddistrito"],
                    $params["nombres"],
                    $params["appaterno"],
                    $params["apmaterno"],
                    $params["telefono"],
                    $params["direccion"]
                )
            );
            $row = $query->fetch(PDO::FETCH_ASSOC);
            $id = $row["id"];
        } catch (Exception $e) {
            error_log("Error al registrar a la persona" . $e->getMessage());
        }
        return $id;
    }
    // ACTUALIZAR PERSONA
    public function updatePersona($params = []): bool
    {
        $estado = false;
        try {
            $tsql = "CALL sp_actualizar_persona (?, ?, ?, ?, ?, ?, ?, ?)";
            $cmd = $this->pdo->prepare($tsql);
            $estado = $cmd->execute(
                array(
                    $params["idtipodocumento"],
                    $params["iddistrito"],
                    $params["nombres"],
                    $params["appaterno"],
                    $params["apmaterno"],
                    $params["telefono"],
                    $params["direccion"],
                    $params["idpersonanrodoc"]
                )
            );
            $estado = $cmd->rowCount() > 0;
            if ($estado) {
                return $estado;
            }
        } catch (Exception $e) {
            die($e->getMessage());
        }
        return $estado;
    }
    // DESACTIVAR PERSONA
    public function inactivePersona($params = [])
    {
        //$estado = false;
        try {
            $tsql = "CALL sp_desactivar_persona (?,?)";
            $cmd = $this->pdo->prepare($tsql);
            $cmd->execute(
                array(
                    $params["estado"],
                    $params["idpersonanrodoc"]
                )
            );
            $estado = $cmd->fetch(PDO::FETCH_ASSOC);
            return isset($estado['filas_afectadas']) && $estado['filas_afectadas'] > 0;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getById($params = [])
    {
        try {
            $tsql = "CALL sp_buscarpersonadoc (?, ?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(array(
                $params['idtipodocumento'],
                $params['idpersonanrodoc']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            $e->getCode();
        }
    }
}
