<?php

require_once '../model/Persona.php';

$persona = new Persona();
header("Content-Type: application/json; charset=utf-8");
$verbo = $_SERVER["REQUEST_METHOD"];
$input = file_get_contents('php://input');

switch ($verbo) {
    case 'GET':
        if (isset($_GET['operation'])) {
            switch ($_GET['operation']) {
                case 'searchDni':
                    $datosEnviar = [
                        'idtipodocumento' => $_GET['idtipodocumento'],
                        'idpersonanrodoc' => $_GET['idpersonanrodoc']
                    ];
                    $send = $persona->getById($datosEnviar);
                    echo json_encode($send);
                    break;
                case 'getAll':
                    // Llama a la función getAll() y devuelve el resultado
                    $result = $persona->getAll();
                    echo json_encode($result);
                    break;
            }
        }
        break;

    case 'POST':
        if (isset($_POST['operation'])) {
            switch ($_POST['operation']) {
                case 'addPersona':
                    $datosEnviar = [
                        "idtipodocumento"   => $_POST['idtipodocumento'],
                        "idpersonanrodoc"   => $_POST['idpersonanrodoc'],
                        "iddistrito"        => $_POST['iddistrito'],
                        "nombres"           => $_POST['nombres'],
                        "appaterno"         => $_POST['appaterno'],
                        "apmaterno"         => $_POST['apmaterno'],
                        "telefono"          => $_POST['telefono'],
                        "direccion"         => $_POST['direccion']
                    ];
                    $id = $persona->addPersona($datosEnviar);
                    $resultado = ['id' => $id];
                    echo json_encode($resultado);
                    break;
            }
        }
        break;

    case 'PUT':
        $datosRecibidos = json_decode($input, true);
        if (isset($datosRecibidos['operation'])) {
            switch ($datosRecibidos['operation']) {
                case 'updatePersona':
                    $datosActualizar = [
                        "idtipodocumento"   => $datosRecibidos['idtipodocumento'],
                        "iddistrito"        => $datosRecibidos['iddistrito'],
                        "nombres"           => $datosRecibidos['nombres'],
                        "appaterno"         => $datosRecibidos['appaterno'],
                        "apmaterno"         => $datosRecibidos['apmaterno'],
                        "telefono"          => $datosRecibidos['telefono'],
                        "direccion"         => $datosRecibidos['direccion'],
                        "idpersonanrodoc"   => $datosRecibidos['idpersonanrodoc']
                    ];
                    $estado = $persona->updatePersona($datosActualizar);
                    if($estado){
                        $resultado = ['Actualizado' => true];
                    } else {
                        $resultado = ['error' => 'No se pudo desactivar la persona.'];
                    }
                    echo json_encode($resultado);
                    break;

                case 'inactivePersona':
                    $datoActualizar = [
                        "estado"            => $datosRecibidos["estado"],
                        "idpersonanrodoc"   => $datosRecibidos["idpersonanrodoc"]
                    ];
                    $estado = $persona->inactivePersona($datoActualizar);
                    $resultado = ['Actualizado' => $estado];
                    echo json_encode($resultado);
                    break;
            }
        }
        break;
}