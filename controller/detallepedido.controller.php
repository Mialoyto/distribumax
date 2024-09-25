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
                  'precio_unitario'   => $item['precio_unitario']
                ];

                $dato = $detallepedido->addDetallePedido($datosEnviar);
                $datos[] = $dato;
              }
            }
            echo json_encode(['id' => $datos]);
          }

          break;
      }
    }
    break;
}
