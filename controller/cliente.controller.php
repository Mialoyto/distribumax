<?php

require_once '../model/Cliente.php';
$cliente = new Cliente();
header('Content-Type: application/json');


if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'searchCliente':
      if (isset($_GET['_nro_documento'])) {
        echo json_encode($cliente->searchCliente(['_nro_documento' => $_GET['_nro_documento']]));
      } else {
        echo json_encode(["error" => "Falta el número de documento."]);
      }
      break;
    case 'getAll':;
      echo json_encode($cliente->getAll());
      break;

    case 'searProspecto':
      $dato = [
        'item' => $_GET['item'],
        'tipo_cliente' => $_GET['tipo_cliente']
      ];

      // Llamar al método y obtener los prospectos
      $prospectos = $cliente->searProspecto($dato);

      // Crear un array para la respuesta
      $response = [];

      // Recorrer los prospectos y agregar a la respuesta
      foreach ($prospectos as $prospecto) {
        $response[] = [
          'tipo_cliente' => $prospecto['tipo_cliente'],
          'identificador' => $prospecto['identificador'],
          'nombre_razon_social' => $prospecto['nombre_razon_social'],
          'apellido_direccion' => $prospecto['apellido_direccion'],
          'nombres' => $prospecto['nombres'],
          'direccion' => $prospecto['direccion'],
          'email' => $prospecto['email'],
          'distrito' => $prospecto['distrito'],
          'estado' => $prospecto['estado'] // Agregar el estado aquí
        ];
      }

      // Convertir la respuesta a JSON y enviarla
      echo json_encode($response);
      break;

    case 'getClienteById':
      $datos = [
        'idcliente' => $_GET['idcliente']
      ];
      $response = $cliente->getClienteById($datos);
      echo json_encode($response);
      break;

    case 'updateEstado':
      $idCliente = $_GET['idcliente'];
      $estado = $_GET['estado'];
      $datos = [
        'idcliente' => $idCliente,
        'estado' => $estado
      ];
      $response = $cliente->updateEstado($datos);
      echo json_encode($response);
      break;
  }
}

if (isset($_POST['operation'])) {

  switch ($_POST['operation']) {
    case 'addcliente':
      if (isset($_POST['tipo_cliente']) && ($_POST['tipo_cliente'] === 'Persona' || $_POST['tipo_cliente'] === 'Empresa')) {
        $datos = [
          'idpersona' => $_POST['tipo_cliente'] === 'Persona' ? $_POST['idpersona'] : null,
          'idempresa' => $_POST['tipo_cliente'] === 'Empresa' ? $_POST['idempresa'] : null,
          'tipo_cliente' => $_POST['tipo_cliente']
        ];

        try {
          $idCliente = $cliente->addcliente($datos);
          // var_dump($idCliente);
          echo json_encode(['id' => $idCliente]);
        } catch (Exception $e) {
          error_log("Error al agregar cliente: " . $e->getMessage());
          echo json_encode(['error' => 'Error al agregar cliente']);
        }
      } else {
        echo json_encode(['error' => 'Datos inválidos']);
      }
      break;
  }
}
