<?php

require_once 'Conexion.php';

class Despachos  extends Conexion
{

  private $pdo;

  public function __construct()
  {
    $this->pdo = parent::getConexion();
  }

  // ? ESTA FUNCION REGISTRA UN DESPACHO
  public function addDespacho($params = []): int
  {
    $id = -1;
    try {
      $tsql = "CALL sp_despacho_registrar (?,?,?,?,?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(array(
        $params['idvehiculo'],
        $params['idusuario'],
        $params['fecha_despacho'],
        $params['idjefe_mercaderia'],
        $params['idconductor']
      ));
      $id = $query->fetch(PDO::FETCH_ASSOC);
      return $id['iddespacho'];
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function listar()
  {
    try {
      $query = $this->pdo->prepare("CALL sp_listar_despacho");
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function reporte($params = [])
  {
    try {
      $query = $this->pdo->prepare("CALL sp_reporte_despacho_por_proveedor (?)");
      $query->execute(array($params['iddespacho']));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function listarventas($params = [])
  {
    try {
      $query = $this->pdo->prepare("CALL sp_listar_detalle_despacho(?)");
      $query->execute(array($params['iddespacho']));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function updateEstado($params = [])
  {
    try {
      $status = -1;
      $query = $this->pdo->prepare("call sp_actualizar_estado(?,?)");
      $status = $query->execute(array(
        $params['estado'],
        $params['iddespacho']
      ));
      return $status;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // ? FUNCION PARA LISTAR PROVINCIAS CON VENTAS PENDIENTES
  public function listarProvinciasVentasPendientes()
  {
    try {
      $tsql = "CALL sp_getListProvinciaVentas()";
      $query = $this->pdo->prepare($tsql);
      $query->execute();
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  // ? FUNCION PARA LISTAR LAS VENTAS POR PROVINCIAS

  public function listVentasPendientes($params = [])
  {
    try {
      $tsql = "CALL sp_getventas(?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['provincia']
        )
      );
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function buscarJefeMercaderia($params = [])
  {
    try {
      $tsql = "CALL sp_buscar_jefe_mercaderia(?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['item']
        )
      );
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
