<?php 
require_once '../model/UnidadMedida.php';
$unidad = new UnidadMedida();

if(isset($_GET['operation'])){
  switch ($_GET['operation']) {
    case 'getUnidades':
      echo json_encode($unidad->getUnidadMedidas());
      break;
  }
}