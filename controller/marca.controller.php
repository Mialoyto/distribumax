<?php


require_once '../model/Marcas.php';
$marca = new Marca();
header("Content-type: application/json; charset=utf-8");

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addMarca':
      if (empty($_POST['idproveedor']) || $_POST['idproveedor'] === null) {
        $datos = [
          "idmarca" => -1,
          "mensaje" => 'No se ha seleccionado un proveedor'
        ];
        echo json_encode($datos);
        return;
      } else {
        $datos = [
          'idproveedor'    => $_POST['idproveedor'],
          'marca'          => $_POST['marca'],
          'idcategoria'    => $_POST['idcategoria']
        ];
        $response = $marca->addMarca($datos);
        echo json_encode($response);
      }

      break;
  }
}
if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getMarcas':
      $dataEnviar = [
        'id' => $_GET['id']
      ];
      $datosRecibidos = $marca->getMarca($dataEnviar);
      echo json_encode(['marcas' => $datosRecibidos]);
      break;
    case 'getAll':
      $response = $marca->getAll();
      echo json_encode($response);
      break;
    case 'updateMarca':
      $idmarca = $_GET['idmarca'];
      $nombremarca = $_GET['marca'];

      if (empty($idmarca) || empty($marca)) {
        echo json_encode(['status' => 'error', 'message' => 'Faltan datos']);
        return;
      } else if (!is_numeric($idmarca)) {
        echo json_encode(['status' => 'error', 'message' => 'El id de la marca debe ser un número']);
        return;
      } else {
        $datos = [
          'idmarca' => $idmarca,
          'marca'   => $marca
        ];
        $response = $marca->updateMarca($datos);
        echo json_encode($response);
      }
      break;
    case 'updateEstado':
      $idmarca = $_GET['idmarca'];
      $estado = $_GET['estado'];
      $datos = [
        'idmarca' => $idmarca,
        'estado'  => $estado
      ];
      $response = $marca->updateEstado($datos);
      echo json_encode($response);
      break;
  }
}
