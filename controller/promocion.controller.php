<?php

require_once '../model/Promocion.php';

$promocion = new Promocion();

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
      case 'addPromocion':
          $datos = [
              'idtipopromocion' => $_POST['idtipopromocion'],
              'descripcion'     => $_POST['descripcion_promocion'],
              'fechainicio'     => $_POST['fechainicio'],
              'fechafin'        => $_POST['fechafin'],
              'valor_descuento' => $_POST['valor_descuento']
          ];

          $response = $promocion->addPromocion($datos);
          echo json_encode($response);
          break;
  }
}



if(isset($_GET['operation'])){
  switch(isset($_GET)){
    case 'getAll':
      echo json_encode($promocion->getAll());
    break;
  }
}