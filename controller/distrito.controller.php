<?php

require_once '../model/Distrito.php';

$distrito = new Distrito();
header("Content-Type: application/json");
$verbo = $_SERVER["REQUEST_METHOD"];
$input = file_get_contents('php://input');

switch ($verbo) {
    case 'POST':
        if (isset($_POST['operation'])) {
            switch ($_POST['operation']) {
                case 'searchDistrito':
                    $datosEnviar = ["distrito" => $_POST["distrito"]];
                    $response = $distrito->searchDistrito($datosEnviar);
                    echo json_encode($response);
                    break;
                case 'getAll':   
                        echo json_encode($distrito->getAll());
                break;
            }
        }

        break;
}
