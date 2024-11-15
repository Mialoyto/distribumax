<?php


require_once '../model/Marcas.php';
$marca = new Marca();

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
        case 'getAll':
            echo json_encode($marca->getAll());
            break;
        case 'getMarcas':
            $dataEnviar = [
                'id' => $_GET['id']
            ];
            $datosRecibidos = $marca->getMarca($dataEnviar);
            echo json_encode(['marcas' => $datosRecibidos]);
            break;
    }
}
