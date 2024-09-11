<?php

require_once '../model/Distrito.php';

header("Content-Type: application/json");
$distrito = new Distrito();
$verbo = $_SERVER["REQUEST_METHOD"];

switch ($verbo) {
    case 'GET':
        if (isset($_GET['operation'])) {
            switch ($_GET['operation']) {
                case 'searchDistrito':
                    $datosEnviar = ["distrito" => $_GET["distrito"]];
                    $response = $distrito->searchDistrito($datosEnviar);
                    echo json_encode($response);
                    break;
            }
        }
        break;
}
