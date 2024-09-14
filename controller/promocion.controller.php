<?php

require_once '../model/Promocion.php';

$promocion = new Promocion();

if(isset($_POST['operation'])){
  switch(isset($_POST['operation'])){
    case 'addPromocion':
      $datos=[
          'tipopromocion' =>$_POST ['tipopromocion'],
          'descripcion'   =>$_POST['descripcion']
      ];

    echo json_encode($promocion->addPromocion($datos));  
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