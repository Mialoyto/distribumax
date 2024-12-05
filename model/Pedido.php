<?php

require_once 'Conexion.php';

class Pedidos extends Conexion
{
  private $pdo;
  public function __construct()
  {
    $this->pdo = Conexion::getConexion();
  }

  // funcion para agregar pedido
  public function agregarPedido($params = []): string
  {
    $id = -1;
    try {

      $sql = "CALL sp_pedido_registrar( ?, ?)";
      $cmd = $this->pdo->prepare($sql);
      $cmd->execute(array(
        $params['idusuario'],
        $params['idcliente']
      ));
      $row = $cmd->fetch(PDO::FETCH_ASSOC);
      $id = $row['idpedido'];
    } catch (Exception $e) {
      return $id;
    }
    return $id;
  }

  public function searchPedido($params = [])
  {
    try {
      $sql = "CALL sp_buscar_pedido(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['_idpedido']
      ));

      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getById($params = [])
  {
    try {
      $sql = "CALL sp_getById_pedido(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(array(
        $params['idpedido']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function UpdateEstadoPedido($params = [])
  {
    try {
      $sql = "CALL sp_update_estado_pedido(?,?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(
        array(
          $params['idpedido'],
          $params['estado']
        )
      );
      $response = $query->fetchAll(PDO::FETCH_ASSOC);
      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function getAll()
  {
    try {
      $query = $this->pdo->prepare("call sp_listar_pedidos");
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function GetPedido($params = [])
  {
    try {
      $query = $this->pdo->prepare("call sp_obtener_pedido(?)");
      $query->execute(array($params['idpedido']));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
  public function pediosDay()
  {
    try {
      $query = $this->pdo->prepare("call sp_contar_pedidos");
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }


  public function pedidosForProvincia()
  {
    try {
      $query = $this->pdo->prepare("call sp_listado_pedidos_provincias");
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function cancelarPedidoAll($params = []):array
  {
    try {
      $sql = "CALL sp_cancelar_pedido(?)";
      $query = $this->pdo->prepare($sql);
      $query->execute(
        array(
          $params['idpedido']
        )
      );
      $response = $query->fetchAll(PDO::FETCH_ASSOC);

      return $response;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }
}
