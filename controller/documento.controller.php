<?php

require_once '../model/Documento.php';

$documento = new Documento();
header("Content-Type: application/json; charset=utf-8");

$verbo = $_SERVER["REQUEST_METHOD"];

$input = file_get_contents('php://input');
$datosRecibidos = json_decode($input, true);

switch ($verbo) {
    case 'GET':
            echo json_encode($documento->getAllDocumentos());
        break;
}


