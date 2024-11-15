<?php

require_once '../model/TipoPromocion.php';

$tipopromocion = new TipoPromocion();

// Establece el tipo de contenido de la respuesta como JSON
header('Content-Type: application/json');

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'addTipoPromocion':
            $datos = [
                'tipopromocion' => $_POST['tipopromocion'],
                'descripcion'   => $_POST['descripcion']
            ];
            $id = $tipopromocion->addTipoPromocion($datos);
            echo json_encode($id);
            break;
    }
}

if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'getAll':
            echo json_encode($tipopromocion->getAll());
            break;
    }
}
