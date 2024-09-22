<?php

require_once '../model/kardex.php';

$kardex = new Kardex();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case 'add':

            $datos=[
                'idusuario' =>$_POST['idusuario'],
                'idproducto' =>$_POST['idproducto'],
                'stockactual' =>$_POST['stockactual'],
                'tipomovimiento'=>$_POST['tipomovimiento'],
                'cantidad'=>$_POST['cantidad'],
                'motivo'=>$_POST['motivo']
            ];

        echo json_encode($kardex->add($datos)); 
        break;

        case 'getById':
            echo json_encode($kardex->getById(['idproducto'=>$_POST['idproducto']]));
        break; 
    }
    
}

if (isset($_GET['operation'])) {
    switch ($_GET['operation']) {
        case 'getAll':
            echo json_encode($kardex->getAll());
            break;
    }
}
