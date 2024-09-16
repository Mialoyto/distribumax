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
                case 'searchDni': {
                        $datosEnviar = [
                            'idtipodocumento' => $_GET['idtipodocumento'],
                            'idpersonanrodoc' => $_GET['idpersonanrodoc']
                        ];
                        $send = $persona->getById($datosEnviar);
                        echo json_encode($send);
                    }
            }
            break;
        }
    case 'POST':
        if (isset($_POST['operation'])) {
            switch ($_POST['operation']) {
                case 'addPersona':
                    $datosRecibidos = json_decode($input, true);
                    $datosEnviar = [
                        "idtipodocumento"   => $datosRecibidos['idtipodocumento'],
                        "idpersonanrodoc"   => $datosRecibidos['idpersonanrodoc'],
                        "iddistrito"        => $datosRecibidos['iddistrito'],
                        "nombres"           => $datosRecibidos['nombres'],
                        "appaterno"         => $datosRecibidos['appaterno'],
                        "apmaterno"         => $datosRecibidos['apmaterno'],
                        "telefono"          => $datosRecibidos['telefono'],
                        "direccion"         => $datosRecibidos['direccion']
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
                    }else{
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
    case 'DELETE':
        break;
}
