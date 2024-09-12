<?php


require_once '../model/Empresa.php';
$empresa = new Empresas();


if(isset($_GET['operation'])){
  switch($_GET['operation']){
    case 'getAll':
      echo json_encode($empresa->getAll());
      break;
  }
}


if(isset($_POST['operation'])){
  switch($_POST['operation']){
    case 'add':
      $datos=[
        'idempresaruc' => $_POST['idempresaruc'],
        'iddistrito'   => $_POST['iddistrito'],
        'razonsocial'  => $_POST['razonsocial'],
        'direccion'    => $_POST['direccion'],
        'email'        => $_POST['email'],
        'telefono'     => $_POST['telefono']
      ];
      
 
        echo json_encode($empresa->add($datos));
  
      break;
   
  }
}


