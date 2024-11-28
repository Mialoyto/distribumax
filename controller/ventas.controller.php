<?php

require_once '../model/ventas.php';
$venta = new Ventas();

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addVentas':
      $datos = [
        'idpedido' => $_POST['idpedido'],
        'idusuario'=>$_POST['idusuario'],
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
      // Si no se pasa 'fecha_venta', se listan todas las ventas
      if (isset($_GET['fecha_venta']) && !empty($_GET['fecha_venta'])) {
        // Si se pasa la fecha, se filtra por fecha
        $dato = ['fecha_venta' => $_GET['fecha_venta']];
        echo json_encode($venta->listar_fecha($dato)); // Llama a listar ventas por fecha
      } else {
        // Si no se pasa fecha, se listan todas las ventas
        echo json_encode($venta->getAll());
      }
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
      $dato = [
        'item' => $_GET['item']
      ];
      echo json_encode($venta->buscarventa($dato));
      break;
    case 'getventas':
      $dato = [
        'provincia' => $_GET['provincia']
      ];
      echo json_encode($venta->getventas($dato));
      break;
    case 'reporteVenta':
      $datos = [
        'idventa' => $_GET['idventa']
      ];
      echo json_encode($venta->reporteVenta($datos));
      break;
      case 'ventasDay':
        $dato=[
          'fecha'=>$_GET['fecha']
        ];
        echo json_encode($venta->ventasDay($dato));
      break;
  }
}



