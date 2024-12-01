<?php

require_once '../model/Perfil.php';

$perfil = new Perfil();

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'listarPerfil':
      $response = $perfil->listPeril();
      echo json_encode($response);
      break;
  }
}
