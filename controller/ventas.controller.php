<?php

require_once '../model/ventas.php';
$venta = new Ventas();

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addVentas':
      $datos = [
        'idpedido' => $_POST['idpedido'],
        'idtipocomprobante' => $_POST['idtipocomprobante'],
        'fecha_venta' => $_POST['fecha_venta'],
        'subtotal' => $_POST['subtotal'],
        'descuento' => $_POST['descuento'],
        'igv' => $_POST['igv'],
        'total_venta' => $_POST['total_venta']
      ];
      $id = $venta->addVentas($datos);
      echo json_encode(['id' => $id]);
      break;
    case 'reporteVenta':
      $datos = [
        'idventa' => $_POST['idventa']
      ];
      echo json_encode($venta->reporteVenta($datos));
      break;
    case 'upVenta':
      $dato = [
        'estado' => $_POST['estado'],
        'idventa' => $_POST['idventa']
      ];
      echo json_encode($venta->upVenta($dato));
      break;
  }
}

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($venta->getAll());
      break;
    case 'historial':
      echo json_encode($venta->historial());
      break;
    case 'getByID':
      $dato = [
        'idventa' => $_GET['idventa']
      ];
      echo json_encode($venta->getByID($dato));
      break;
    case 'buscarventa':
      $dato=[
        'item'=>$_GET['item']
      ];
      echo json_encode($venta->buscarventa($dato));
      break;
  }
}
