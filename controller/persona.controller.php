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
                case 'search':
                    $datosEnviar = [
                        'idtipodocumento' => $_GET['idtipodocumento'],
                        'idpersonanrodoc' => $_GET['idpersonanrodoc']
                    ];
                    $send = $persona->search($datosEnviar);
                    echo json_encode($send);
                break;

                case 'updateEstado':
                    $datos = [
                        'idpersonanrodoc' => $_GET['idpersonanrodoc'],
                        'estado' => $_GET['estado']
                    ];
                    $response = $persona->updateEstado($datos);
                    echo json_encode($response);
                    break;

                case 'getPersona':
                    $datos = [
                        'idpersonanrodoc' => $_GET['idpersonanrodoc']
                    ];
                    $response = $persona->getPersona($datos);
                    echo json_encode($response);
                    break;

                case 'updatePersona':
                    $idpersonanrodoc = $_GET['idpersonanrodoc'];
                    $idtipodocumento = $_GET['idtipodocumento'];
                    $nombres      = $_GET['nombres'];
                    $appaterno    = $_GET['appaterno'];
                    $apmaterno    = $_GET['apmaterno'];
                    $telefono     = $_GET['telefono'];
                    $direccion    = $_GET['direccion'];
                    $distrito     = $_GET['distrito'];

                    if(empty($idpersonanrodoc) ||empty($idtipodocumento) || empty($nombres) || empty($appaterno) || empty($apmaterno) || empty($telefono) || empty($direccion) || empty($distrito)){
                        echo json_encode(['estado' => 'error', 'message' => 'Faltan datos']);
                        return;
                    } else if (!is_numeric($idpersonanrodoc)) {
                        echo json_encode(['mensaje' => 'error', 'message' => 'El id del vehiculo debe ser un número']);
                        return;
                    } else {
                        $datos = [
                            'idpersonanrodoc' => $idpersonanrodoc,
                            'idtipodocumento' => $idtipodocumento,
                            'nombres'      => $nombres,
                            'appaterno'    => $appaterno,
                            'apmaterno'    => $apmaterno,
                            'telefono'     => $telefono,
                            'direccion'    => $direccion,
                            'distrito'     => $distrito
                        ];
                        $response = $persona->updatePersona($datos);
                        echo json_encode($response);
                    }
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