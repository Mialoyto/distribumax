<?php
require_once '../model/Pedido.php';
$pedido = new Pedidos();
header("Content-Type: application/json; charset=utf-8");

$verbo = $_SERVER["REQUEST_METHOD"];

switch ($verbo) {
  case 'GET':
    if (isset($_GET['operation'])) {
      switch ($_GET['operation']) {
        case 'searchPedido':
          $datos = [
            '_idpedido' => $_GET['_idpedido']
          ];

          echo json_encode($pedido->searchPedido($datos));
          break;

        case 'getById':
          $datos = [
            'idpedido' => $_GET['idpedido']
          ];
          echo json_encode($pedido->getById($datos));
          break;
      }
    }
    break;
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
      }
    }
    break;
}
