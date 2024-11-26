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
        'idproveedor' => $_GET['idproveedor']
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

      case 'updateProveedor':
        $idproveedor = $_GET['idproveedor'];
        $idempresa = $_GET['idempresa'];
        $proveedor = $_GET['proveedor'];
        $contacto_principal = $_GET['contacto_principal'];
        $telefono_contacto = $_GET['telefono_contacto'];
        $direccion = $_GET['direccion'];
        $email = $_GET['email'];

        if(empty($idproveedor) || empty($idempresa) || empty($proveedor) || empty($contacto_principal || empty($telefono_contacto) || empty($direccion) || empty($email))){
          echo json_encode(['status' => 'error', 'message' => 'Faltan datos']);
          return;
        } else if(!is_numeric($idproveedor)){
          echo json_encode(['status' => 'error','message' => 'El id del proveedor debe ser un número']);
          return;
        } else{
          $datos = [
            'idproveedor'         => $idproveedor,
            'idempresa'           => $idempresa,
            'proveedor'           => $proveedor,
            'contacto_principal'  => $contacto_principal,
            'telefono_contacto'   => $telefono_contacto,
            'direccion'           => $direccion,
            'email'               => $email
          ];
          $response = $proveedor->updateProveedor($datos);
          echo json_encode($response);
        }
        break;
  
      case 'updateEstado':
        // Cambiar estado (activar/desactivar) de un proveedor
        $idproveedor = $_GET['idproveedor'];
        $estado = $_GET['estado'];
        $datos = [
          'idproveedor' => $idproveedor,
          'estado'      => $estado
        ];
        $response = $proveedor->updateEstado($datos);
        echo json_encode($response);
        break;

      case 'searchProveedor':
          if (isset($_GET['item'])) {
              $datos = [
                  'item' => $_GET['item']
              ];
              echo json_encode($proveedor->searchProveedor($datos));
          } else {
              echo json_encode(["error" => "Falta el término de búsqueda."]);
          }
          break;
  }
}
