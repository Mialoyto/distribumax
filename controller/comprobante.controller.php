<?php

require_once '../model/comprobante.php';

$comprobante = new ComprobantePago();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case  'addComprobante':
            $datos=[
                'comprobantepago'=>$_POST['comprobantepago']
            ];
            echo json_encode($comprobante->addComprobante($datos));
        break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
       case 'getAll':
        echo json_encode($comprobante->getAll());
        break;
    }
}