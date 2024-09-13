<?php

require_once '../model/Cliente.php';

$cliente = new Cliente();

if(isset($_GET['operation'])){
    switch($_GET['operation']){
      case 'getAll':
        echo json_encode($cliente->getAll());
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