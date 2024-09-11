<?php
require_once '../model/Persona.php';
$persona = new Persona();
$datos = $persona->inactivePersona([
    "estado" => 0,
    "idpersonanrodoc" => '12345678'
]);
$response = json_encode($datos);
echo $response;