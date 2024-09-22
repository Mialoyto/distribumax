<?php

require_once '../model/Cliente.php';
$cliente = new Cliente();
header('Content-Type: application/json');
$verbos = $_SERVER['REQUEST_METHOD'];

switch ($verbos) {
  case 'GET':
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

          break;
      }
    }
    break;
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