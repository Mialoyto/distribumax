<?php

require_once '../model/addLote.php';

$addLote = new addLote();

$verbo = $_SERVER['REQUEST_METHOD'];
if ($verbo == 'POST') {
  $addLote->addLote();
} else {
  echo json_encode(array('mensaje' => 'Metodo no permitido'));
}
