<?php

require_once '../model/Proveedor.php';

$proveedor = new Proveedor();
$verbo = $_SERVER["REQUEST_METHOD"];

switch ($verbo) {
  case 'GET':
    // Operaciones GET para obtener información
    switch ($_GET['operation']) {
      case 'getAll':
        // Obtener todos los proveedores
        echo json_encode($proveedor->getAll());
        break;

      case 'getProveedor':
        $datosEnviar = [
          'idproveedor' => $_GET['idproveedor']
        ];
        $datosRecibidos = $proveedor->getProveedor($datosEnviar);
        echo json_encode(["data" => $datosRecibidos]);
        break;
    }
    break;

  case 'POST':
    // Operaciones POST para agregar y manejar proveedores
    switch ($_POST['operation']) {
      case 'addProveedor':
        // Agregar un nuevo proveedor
        $datos = [
          'idempresa'          => $_POST['idempresa'],
          'proveedor'          => $_POST['proveedor'],
          'contacto_principal' => $_POST['contacto_principal'],
          'telefono_contacto'  => $_POST['telefono_contacto'],
          'direccion'          => $_POST['direccion'],
          'email'              => $_POST['email']
        ];
        echo json_encode($proveedor->addProveedor($datos));
        break;

      case 'updateProveedor':
        // Actualizar información de un proveedor
        $datos = [
          'idproveedor'        => $_POST['idproveedor'],
          'idempresa'          => $_POST['idempresa'],
          'proveedor'          => $_POST['proveedor'],
          'contacto_principal' => $_POST['contacto_principal'],
          'telefono_contacto'  => $_POST['telefono_contacto'],
          'direccion'          => $_POST['direccion'],
          'email'              => $_POST['email']
        ];
        $response = $proveedor->updateProveedor($datos);
        echo json_encode($response);
        break;

      case 'updateEstado':
        // Cambiar estado (activar/desactivar) de un proveedor
        $datos = [
          'idproveedor' => $_POST['idproveedor'],
          'estado'      => $_POST['estado']
        ];
        $response = $proveedor->updateEstado($datos);
        echo json_encode($response);
      }
}

