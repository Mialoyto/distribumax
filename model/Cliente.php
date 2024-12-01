<?php

require_once 'Conexion.php';

class Cliente extends Conexion
{
  private $pdo;

  public function __CONSTRUCT()
  {
    $this->pdo = parent::getConexion();
  }

  //Función para poder listar a todos los clientes
  public function searchCliente($params = []): array
  {
    try {
      $tsql = "CALL sp_buscar_cliente (?)";
      $cmd = $this->pdo->prepare($tsql);
      $cmd->execute(array(
        $params['_nro_documento']
      ));
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getCode());
    }
  }

  public function addcliente($params = []): int
  {
    $resultado = -1;  // Valor por defecto en caso de fallo
    try {
      $query = $this->pdo->prepare("CALL sp_cliente_registrar(?, ?, ?)");

      // Determinar los valores de idpersona y idempresa según el tipo de cliente
      $idpersona = $params['tipo_cliente'] === 'Empresa' ? null : $params['idpersona'];
      $idempresa = $params['tipo_cliente'] === 'Persona' ? null : $params['idempresa'];

      // Ejecutar el procedimiento almacenado con los parámetros
      $query->execute([$idpersona, $idempresa, $params['tipo_cliente']]);

      // Obtener el valor devuelto (1 si fue exitoso, -1 si falló)
      $resultado = $query->fetch(PDO::FETCH_ASSOC);
      $resultado = $resultado['idcliente'];
      return $resultado;
    } catch (Exception $e) {
      // Manejar el error y devolver -1 en caso de fallo
      // Puedes agregar un log del error si es necesario
      return $resultado;
    }
  }

  public function getAll()
  {
    try {
      $tsql = "CALL sp_listar_clientes()";
      $query = $this->pdo->prepare($tsql);
      $query->execute();
      $datos = $query->fetchAll(PDO::FETCH_ASSOC);

      return $datos;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function getClienteById($params = []): array
  {
    try {
      $tsql = "CALL sp_getClienteById(?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['idcliente']
        )
      );
      $resultado = $query->fetchAll(PDO::FETCH_ASSOC);
      return $resultado;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }

  public function updateEstado($params = [])
  {
    try {
      $tsql = "CALL sp_update_estado_cliente(?, ?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['idcliente'],
          $params['estado']
        )
      );
      $resultado = $query->rowCount();
      return $resultado;
    } catch (Exception $e) {
      die($e->getMessage());
    }
  }



  public function activeCliente($params = []): bool
  {
    $resultado = false;  // Valor por defecto en caso de fallo
    try {
      $tsql = "CALL sp_estado_cliente(?, ?)";
      $query = $this->pdo->prepare($tsql);
      $query->execute(
        array(
          $params['estado'],
          $params['idcliente']
        )
      );
      $resultado = $query->rowCount();
      return $resultado;
    } catch (Exception $e) {
      return $resultado;
    }
    // return $resultado;
  }

  public function searProspecto($params = [])
  {
    try {

      $query = $this->pdo->prepare("CALL sp_buscar_prospectos(?,?)");
      $query->execute(array(
        $params['item'],
        $params['tipo_cliente']
      ));
      return $query->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception  $e) {
      die($e->getMessage());
    }
  }
  
  public function obtenerCliente($params = [])
  {
    try {
      $tsql = "CALL sp_obtener_cliente(?)";
      $cmd = $this->pdo->prepare($tsql);
      $cmd->execute(array(
        $params['idcliente']
      ));
      return $cmd->fetch(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getCode());
    }
  }

  public function activos(){
    try {
      $tsql = "SELECT * FROM  vw_listar_clientes_activos";
      $cmd = $this->pdo->prepare($tsql);
      $cmd->execute();
      return $cmd->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
      die($e->getCode());
    }
  }
}
