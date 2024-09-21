<?php
require_once '../model/Pedido.php';
$pedido = new Pedidos();
header("Content-Type: application/json; charset=utf-8");

$verbo = $_SERVER["REQUEST_METHOD"];

switch ($verbo) {
  case 'GET':

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
