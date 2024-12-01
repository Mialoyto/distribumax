<?php

require_once '../model/metodoP.php';

$metodo=new MetodoPago();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case 'addMetodo':
            $datos=[
                'metodopago'=>$_POST['metodopago']
            ];
            echo json_encode($metodo->addMetodo($datos));
        break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case 'getAll':
            echo json_encode($metodo->getAll());
        break;
        case 'sp_obtenerMetodopago':
            $datos=[
                'idventa'=>$_GET['idventa']
            ];
            echo json_encode($metodo->obtenerMetodopago($datos));
    }
}