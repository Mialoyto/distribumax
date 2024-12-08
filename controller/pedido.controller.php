<?php
require_once '../model/Pedido.php';
$pedido = new Pedidos();
header("Content-Type: application/json; charset=utf-8");

$verbo = $_SERVER["REQUEST_METHOD"];

switch ($verbo) {
    // REVIEW: METODO GET
  case 'GET':
    if (isset($_GET['operation'])) {
      switch ($_GET['operation']) {
        case 'searchPedido':
          $datos = [
            '_idpedido' => $_GET['_idpedido']
          ];
          $id = $pedido->searchPedido($datos);

          echo json_encode($id);
          break;

        case 'getById':
          $datos = [
            'idpedido' => $_GET['idpedido']
          ];
          echo json_encode($pedido->getById($datos));
          break;


        case 'getAll':
          echo json_encode($pedido->getAll());
          break;

        case 'GetPedido':
          $datosEnviar = [
            'idpedido' => $_GET['idpedido']
          ];
          echo json_encode($pedido->GetPedido($datosEnviar));
          break;
        case 'pediosDay':
          echo json_encode($pedido->pediosDay());
          break;
        case 'pedidosProvincia':
          echo json_encode($pedido->pedidosForProvincia());
          break;
      }
    }
    break;
    // REVIEW: METODO POST
  case 'POST':
    if (isset($_POST['operation'])) {
      switch ($_POST['operation']) {
        case 'addPedido':
          $datosEnviar = [
            "idusuario" => $_POST["idusuario"],
            "idcliente" => $_POST["idcliente"]
          ];
          $idobtenido = $pedido->agregarPedido($datosEnviar);
          echo json_encode(["idpedido" => $idobtenido]);
          break;

        case 'UpdateEstadoPedido':

          $idpedido = $_POST['idpedido'];
          $estado = $_POST['estado'];
          
          $datos = [
            'idpedido' => $idpedido,
            'estado'   => $estado
          ];
          $response = $pedido->UpdateEstadoPedido($datos);
          echo json_encode($response);
          break;
        case 'cancelarPedidoAll':
          $idpedido = trim($_POST['idpedido']);
          $datos = [
            'status' => 'error',
            'message' => '',
            'success' => false
          ];

          if (empty($idpedido)) {
            $datos['message'] = 'No se ha enviado el id del pedido';
          } else {
            $datosEnviar = [
              'idpedido' => $idpedido
            ];

            $response = $pedido->cancelarPedidoAll($datosEnviar);
            if ($response[0]['estado']) {
              $datos['status'] = 'success';
              $datos['message'] = $response[0]['mensaje'];
              $datos['success'] = true;
            } else {
              $datos['message'] = $response[0]['mensaje'];
            }
          }
          echo json_encode($datos);

          break;
      }
    }
    break;
}
