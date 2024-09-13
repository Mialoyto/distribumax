<?php


require_once '../model/Marca.php';
$marca = new Mara();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case 'addMarca':
            $datos=[
                'marca' =>$_POST['marca']
            ];
            echo json_encode($marca->addMarca($datos));
        break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case 'getAll' :
            echo json_encode($marca->getAll());

        break; 
    }
}