<?php

require_once '../model/Distrito.php';

$distrito = new Distrito();
header("Content-Type: application/json");
$verbo = $_SERVER["REQUEST_METHOD"];
$input = file_get_contents('php://input');

switch ($verbo) {
    case 'GET':
        if (isset($_GET['operation'])) {
            switch ($_GET['operation']) {
                case 'searchDistrito':
                    $datosEnviar = ["distrito" => $_GET["distrito"]];
                    $response = $distrito->searchDistrito($datosEnviar);
                    echo json_encode($response);
                    break;
                case 'getAll':
                    echo json_encode($distrito->getAll());
                    break;
                case 'getbyId':
                    $datosEnviar = ["iddistrito" => $_GET["iddistrito"]];
                    $response = $distrito->getbyId($datosEnviar);
                    echo json_encode($response);
                    break;
            }
        }

        break;
    case 'POST':
        if (isset($_POST['operation'])) {
            switch ($_POST['operation']) {
                case 'searchDistrito':
                    $datosEnviar = ["distrito" => $_POST["distrito"]];
                    $response = $distrito->searchDistrito($datosEnviar);
                    echo json_encode($response);
                    break;
            }
        }
        break;
}
