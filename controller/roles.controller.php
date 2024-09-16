<?php

require_once '../model/Roles.php';
header("Content_Type: application/json");
$verbo = $_SERVER['REQUEST_METHOD'];
$input = file_get_contents("php://input");
$rol = new Rol();

switch ($verbo) {
    case 'GET':
        echo json_encode($rol->getAllRol());
        break;
}
