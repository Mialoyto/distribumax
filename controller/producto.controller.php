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
    case 'searchProducto':
      $datosEnviar = [
        "nombreproducto" => $_POST["nombreproducto"]
               
      ];
      $response = $producto->searchProducto($datosEnviar);
      echo json_encode($response);
    break;
    
    case 'getById':
      echo json_decode($producto->getBytId(['idproducto'=>$_POST['idproducto']]));
    break;
  }
}
if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($producto->getAll());
      break;
   
  }
}
