<?php

require_once '../model/Subcategoria.php';

$subcategoria = new Subcategoria();

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addSubcategoria':
      $datos = [
        'idcategoria' => $_POST['idcategoria'],
        'subcategoria' => $_POST['subcategoria']
      ];
      echo json_encode($subcategoria->addSubcategoria($datos));
      break;
  }
}

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      $response = $subcategoria->getAll();
      echo json_encode($response);
      break;
    case 'getSubcategoria':
      $datosEnviar = [
        'idsubcategoria' => $_GET['idsubcategoria']
      ];
      $datosRecibidos = $subcategoria->getSubcategorias($datosEnviar);
      echo json_encode($datosRecibidos);
  }
}
