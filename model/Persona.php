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
    public function addPersona($params = []): int
    {
        try {
            $id = -1;
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
            $id = $row['idpersona'];
            return $id;
        } catch (Exception $e) {
            error_log("Error al registrar a la persona" . $e->getMessage());
            return $id;
        }
    }
    // ACTUALIZAR PERSONA
    public function updatePersona($params = [])
    {
        try {
            $query = $this->pdo->prepare("CALL sp_actualizar_persona (?, ?, ?, ?, ?, ?, ?,?)");
            $query->execute(
                array(
                    $params["idpersonanrodoc"],
                    $params["idtipodocumento"],
                    $params["nombres"],
                    $params["appaterno"],
                    $params["apmaterno"],
                    $params["telefono"],
                    $params["direccion"],
                    $params["distrito"],
                )
            );
            $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
            return $resultado;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    
    public function getPersona($params = []){
        try{
            $query = $this->pdo->prepare("CALL sp_getPersona(?)");
            $query->execute(array(
                $params['idpersonanrodoc']
            ));
            $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
            return $resultado;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    // DESACTIVAR PERSONA
    public function inactivePersona($params = [])
    {
        $estado = false;
        try {
            $tsql = "CALL sp_desactivar_persona (?,?)";
            $cmd = $this->pdo->prepare($tsql);
            $cmd->execute(
                array(
                    $params["estado"],
                    $params["idpersonanrodoc"]
                )
            );
            $resultado  = $cmd->fetch(PDO::FETCH_ASSOC);
            return isset($resultado['filas_afectadas']) && $resultado["filas_afectadas"] > 0;
        } catch (Exception) {
            return $estado;
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
    public function search($params = [])
    {
        try {
            $tsql = "CALL sp_buscar_persona_cliente (?, ?)";
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



    public function getAll()
    {
        try {
            $query = $this->pdo->prepare("CALL sp_listar_personas");
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function updateEstado($params = [])
    {
        try{
            $query = $this->pdo->prepare("CALL sp_estado_persona (?,?)");
            $query->execute(array(
                $params['idpersonanrodoc'],
                $params['estado']
            ));
            $response = $query->fetchAll(PDO::FETCH_ASSOC);
            return $response;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}

// $persona = new Persona();
// $datos = array(
//     'idpersonanrodoc' => 26558004,
//     'idtipodocumento' => 1,
//     'nombres' => 'Juan',
//     'appaterno' => 'Perez',
//     'apmaterno' => 'Gomez',
//     'telefono' => '123456789',
//     'direccion' => 'Av. Los Alamos',
//     'distrito' => 'Chincha Alta'
// );

// $respuesta =  $persona->updatePersona($datos);
// echo json_encode($respuesta);