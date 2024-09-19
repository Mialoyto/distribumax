<?php

require_once '../model/subcategoria.php';

  $subcategoria = new Subcategoria();

  if(isset($_POST['operation'])){
    switch($_POST['operation']){
      case 'addSubcategoria':
        $datos=[
          'idcategoria' =>$_POST['idcategoria'],
          'subcategoria'=>$_POST['subcategoria']
        ];
        echo json_encode($subcategoria->addSubcategoria($datos));
      break;
    }
  }

  if(isset($_GET['operation'])){
    switch($_GET['operation']){
      case 'getAll':
        echo json_encode($subcategoria->getAll());
      break;
    }
  }