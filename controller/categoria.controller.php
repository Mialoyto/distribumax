<?php

require_once '../model/Categoria.php';

$categoria = new Categoria();

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'addCategoria':
            $datos = [
                'categoria' => $_POST['categoria']
            ];
            $response = $categoria->addCategoria($datos);
            echo json_encode($response);
            break;
    }
}
if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'getAll':
            echo json_encode($categoria->getAll());
            break;
        case 'getCategorias':
            echo json_encode($categoria->getCategoria());
            break;
        case 'getCategoriaById':
            $datos = [
                'idcategoria' => $_GET['idcategoria']
            ];
            $response = $categoria->getCategoriaById($datos);
            echo json_encode($response);
            break;
        case 'updateCategoria':
            $idcategoria = $_GET['idcategoria'];
            $nombrecategoria = $_GET['categoria'];

            if (empty($idcategoria) || empty($categoria)) {
                echo json_encode(['status' => 'error', 'message' => 'Faltan datos']);
                return;
            } else if (!is_numeric($idcategoria)) {
                echo json_encode(['status' => 'error', 'message' => 'El id de la categoria debe ser un número']);
                return;
            } else {
                $datos = [
                    'idcategoria' => $idcategoria,
                    'categoria' => $nombrecategoria
                ];
                $response = $categoria->updateCategoria($datos);
                echo json_encode($response);
            }
            break;
        case 'updateEstado':
            $idcategoria = $_GET['idcategoria'];
            $estado = $_GET['estado'];
            $datos = [
                'idcategoria' => $idcategoria,
                'estado' => $estado
            ];
            $response = $categoria->updateEstado($datos);
            echo json_encode($response);
            break;
    }
}
