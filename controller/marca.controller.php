<?php


require_once '../model/Marcas.php';
$marca = new Marca();

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'addMarca':
            $datos = [
                'idproveedor'    => $_POST['idproveedor'],
                'marca'          => $_POST['marca'],
                'idcategoria'    => $_POST['idcategoria']
            ];
            echo json_encode($marca->addMarca($datos));
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
