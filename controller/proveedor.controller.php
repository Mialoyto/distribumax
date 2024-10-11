<?php

require_once '../model/Proveedor.php';

$proveedor = new Proveedor();
$verbo = $_SERVER["REQUEST_METHOD"];

switch ($verbo) {
  case 'GET':
    switch ($_GET['operation']) {
      case 'getAll':
        echo json_encode($proveedor->getAll());
        break;
      case 'getProveedor':
        $datosEnviar = [
          'proveedor' => $_GET['proveedor']
        ];
        $datosRecibidos = $proveedor->getProveedor($datosEnviar);
        echo json_encode(["data" => $datosRecibidos]);
        break;
    }
    break;

  case 'POST':
    switch ($_POST['operation']) {
      case 'addProveedor':
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
      default:
        echo json_encode(['error' => 'Operación POST no válida']);
        break;
    }
    break;
}
