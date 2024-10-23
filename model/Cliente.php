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

      // Si el tipo de cliente es 'Empresa', establecer idpersona como NULL
      if ($params['tipo_cliente'] === 'Empresa') {
        $params['idpersona'] = null;
      }

      // Ejecutar el procedimiento almacenado con los parámetros
      $query->execute([
        $params['idpersona'],    // Este valor será NULL para 'Empresa'
        $params['idempresa'],    // Este valor será NULL para 'Persona'
        $params['tipo_cliente']
      ]);

      // Obtener el valor devuelto (1 si fue exitoso, -1 si falló)
      $resultado = $query->fetchColumn();
    } catch (Exception $e) {
      // Manejar el error y devolver -1 en caso de fallo
      return $resultado;
    }

    return $resultado;  // Devolver el resultado obtenido del procedimiento
  }

  public function getAll()
  {
    try {
      $query = $this->pdo->prepare("CALL sp_listar_clientes()");
      $query->execute();
      return $query->fetchAll(PDO::FETCH_ASSOC);
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

}
