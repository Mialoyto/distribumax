<?php

require_once '../model/Cliente.php';
$cliente = new Cliente();
header('Content-Type: application/json');


if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'searchCliente':
      if (isset($_GET['nro_documento'])) {
        echo json_encode($cliente->searchCliente(['_nro_documento' => $_GET['nro_documento']]));
      } else {
        echo json_encode(["error" => "Falta el número de documento."]);
      }
      break;
    case 'getAll':
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
  }
}

if (isset($_POST['operation'])) {

  switch ($_POST['operation']) {
    case 'addcliente':
      $datos = [
        'idpersona' => $_POST['idpersona'],
        'idempresa' => $_POST['idempresa'],
        'tipo_cliente' => $_POST['tipo_cliente']
      ];
      $datos = $cliente->addcliente($datos);
      echo json_encode(['id' => $datos]);
      break;
  }
}



// if(isset($_POST['operation'])){
//   switch ($_POST['operation']){
//   case 'addCliente': //Registrar un cliente
//       if (isset($data['idpersona'], $data['idempresa'], $data['tipo_cliente'])) {
//           $resultado = $cliente->addCliente(
//               $data['idpersona'],
//               $data['idempresa'],
//               $data['tipo_cliente']
//           );
//           echo json_encode($resultado);
//       } else {
//           echo json_encode(["error" => "Datos incompletos."]);
//       }
//       break;
// }
// }