<?php

require_once '../model/DetallePedido.php';
$detallepedido = new DetallePedido();
header('Content-Type: application/json, charset=utf-8');
$verbo = $_SERVER['REQUEST_METHOD'];

switch ($verbo) {
  case 'POST':
    if (isset($_POST['operation'])) {
      switch ($_POST['operation']) {
        case 'addDetallePedido':
          if (isset($_POST['idpedido'])) {
            $idpedido = $_POST['idpedido'];

            $productos = $_POST['productos'];
            $datos = [];
            if (is_array($productos) && count($productos) > 0) {
              foreach ($productos as $item) {
                $datosEnviar = [
                  'idpedido'          => $idpedido,
                  'idproducto'        => $item['idproducto'],
                  'cantidad_producto' => $item['cantidad_producto'],
                  'unidad_medida'     => $item['unidad_medida'],
                  'precio_unitario'   => $item['precio_unitario'],
                  'descuento'         => $item['descuento']
                ];

                $dato = $detallepedido->addDetallePedido($datosEnviar);
                $datos[] = $dato;
              }
            }
            echo json_encode(['id' => $datos]);
          }

          break;
        case 'cancelarItemPedido':
          $idDetallePedido = trim($_POST['iddetallepedido']);
          $idPedido = trim($_POST['idpedido']);

          $datos = [
            'estado'  => '0',
            'message' => '',
            'success' => false
          ];

          if (empty($idDetallePedido) || empty($idPedido)) {
            $datos['message'] = 'Faltan datos';
            return;
          } else {
            $datosEnviar = [
              'iddetallepedido' => $idDetallePedido,
              'idpedido'        => $idPedido
            ];
            $response = $detallepedido->cancelarItemPedido($datosEnviar);
            if ($response[0]['estado']) {
              $datos['estado'] = $response[0]['estado'];
              $datos['message'] = $response[0]['mensaje'];
              $datos['success'] = true;
            } else {
              $datos['message'] = $response[0]['mensaje'];
            }
          }
          echo json_encode($datos);
      }
    }
    break;
}
