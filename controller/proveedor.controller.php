<?php

require_once '../model/Proveedor.php';

$proveedor = new Proveedor();
$verbo = $_SERVER["REQUEST_METHOD"];

if (isset($_POST['operation'])) {
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

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      $response = $proveedor->getAll();
      echo json_encode($response);
      break;
    case 'getProveedores':
      $datosEnviar = [
        'idproveedor' => $_GET['idproveedor']
      ];
      $datosRecibidos = $proveedor->getProveedores($datosEnviar);
      echo json_encode($datosRecibidos);
      break;
    case 'getProveedor':
      $datosEnviar = [
        'proveedor' => $_GET['proveedor']
      ];
      $datosRecibidos = $proveedor->getProveedor($datosEnviar);
      echo json_encode($datosRecibidos);
      break;
    case 'getProductosProveedor':
      $datosEnviar = [
        'proveedor' => $_GET['proveedor']
      ];
      $datosRecibidos = $proveedor->getProductosProveedor($datosEnviar);
      echo json_encode($datosRecibidos);
      break;
  }
}
