<?php

use PhpOffice\PhpSpreadsheet\Calculation\Statistical\Distributions\F;

require_once 'Conexion.php';
class Proveedor extends Conexion
{
    private $pdo;

    public function __construct()
    {
        $this->pdo = parent::getConexion();
    }
    public function addProveedor($params = [])
    {

        try {
            $query = $this->pdo->prepare("CALL sp_proovedor_registrar (?,?,?,?,?,?)");
            $query->execute(array(
                $params['idempresa'],
                $params['proveedor'],
                $params['contacto_principal'],
                $params['telefono_contacto'],
                $params['direccion'],
                $params['email']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
    public function getAll()
    {
        try {
            $sql = "CALL sp_listar_proveedor";
            $query = $this->pdo->prepare($sql);
            $query->execute();
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function searchProveedor($params = []): array
    {
        try{
            $query = $this->pdo->prepare("CALL sp_buscar_proveedor(?)");
            $query->execute(array($params['item']));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function ObtenerProveedorbyRuc($params = []): array
    {
        try{
            $query = $this->pdo->prepare("CALL spu_get_proveedor_by_ruc(?)");
            $query->execute(array($params['ruc']));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        }catch(Exception $e){
            die($e->getMessage());
        }
    }

    public function updateProveedor($params = [])
    {
        try {
            $query = $this->pdo->prepare("CALL sp_actualizar_proovedor (?,?,?,?,?,?,?)");
            $query->execute(array(
                $params['idproveedor'],
                $params['idempresa'],
                $params['proveedor'],
                $params['contacto_principal'],
                $params['telefono_contacto'],
                $params['direccion'],
                $params['email']
            ));
            return $query->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function updateEstado($params = [])
    {
        try {
            $query = $this->pdo->prepare("CALL sp_estado_proveedor (?,?)");
            $query->execute(array(
                $params['idproveedor'],
                $params['estado']
            ));
            $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
            return $resultado;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getProveedor($params = [])
    {
        try {
            $tsql = "CALL sp_buscar_proveedor (?)";
            $query = $this->pdo->prepare($tsql);
            $query->execute(
                array(
                    $params['idproveedor']
                )
            );
            $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
            if (count($resultado) > 0) {
                return $resultado;
            } else {
                return [];
            }
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getProveedores($params = [])
    {
        try {
            $sql = "CALL sp_getProveedor(?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(
                array(
                    $params['idproveedor']
                )
            );
            $response = $query->fetchAll(PDO::FETCH_ASSOC);
            return $response;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function getProductosProveedor($params = [])
    {
        try {
            $sql = "CALL sp_get_proveedor(?)";
            $query = $this->pdo->prepare($sql);
            $query->execute(
                array(
                    $params['proveedor']
                )
            );
            $response = $query->fetchAll(PDO::FETCH_ASSOC);
            return $response;
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}
