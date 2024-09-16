<?php

require_once '../model/Cliente.php';
$cliente = new Cliente();



if(isset($_GET['operation'])){
    switch($_GET['operation']){
      case 'getAll':
        echo json_encode($cliente->getAll());
        break;
    }
  }

 if(isset($_POST['operation'])){
   switch ($_POST['operation']){
   case 'add': //Registrar un cliente
    $datos = [
      'idcliente' => $_POST['idcliente'],
      'idempresa' => $_POST['idempresa'],
      'tipo_cliente' => $_POST['tipo_cliente']
    ];

    echo json_encode($cliente->add($datos));

    break;
 }
}