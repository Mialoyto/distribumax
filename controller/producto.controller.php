<?php

require_once '../model/producto.php';

$producto = new Productos();

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addProducto':
      $datos = [
        'idmarca'        => $_POST['idmarca'],
        'idsubcategoria' => $_POST['idsubcategoria'],
        'nombreproducto' => $_POST['nombreproducto'],
        'descripcion'    => $_POST['descripcion'],
        'codigo'         => $_POST['codigo'],
        'preciounitario' => $_POST['preciounitario']

      ];
      $estado = $producto->addProducto($datos);
      echo json_encode(["estado" => $estado]);
      break;
  }
}
if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($producto->getAll());
      break;
      
    case 'searchProducto':
      $datos = [
        '_item' => $_GET['_item']
      ];
      $lista = $producto->searchProducto($datos);
      echo json_encode(["data" => $lista]);
      break;

      case 'getProducto':
        $datos = [
          '_cliente_id' => $_GET['_cliente_id'],
          '_item' => $_GET['_item']
        ];
        echo json_encode($producto->ObtenerPrecioProducto($datos));
        break;
  }
}
