<?php

require_once '../model/Categoria.php';

$categoria = new Categoria();

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'addCategoria':
            $datos = [
                'categoria' => $_POST['categoria']
            ];
            echo json_encode($categoria->addCategoria($datos));
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
    }
}
