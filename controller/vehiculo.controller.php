<?php

require_once '../model/vehiculos.php';

$vehiculo= new Vehiculo();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case 'addVehiculo':
            $datos=[
                'idusuario' =>$_POST['idusuario'],
                'marca_vehiculo' =>$_POST['marca_vehiculo'],
                'modelo' =>$_POST['modelo'],
                'placa' =>$_POST['placa'],
                'capacidad' =>$_POST['capacidad'],
                'condicion' =>$_POST['condicion']
            ];
            echo json_encode($vehiculo->addVehiculo($datos));
        break;
        case 'searchConductor':
            $dato=[
               'item'=>$_POST['item']
            ];
            echo json_encode($vehiculo->searchConductor($dato));
       break;

       case 'getById_usuarioVe':
           $dato=[
               'idusuarioVe'=>$_POST['idusuarioVe']
           ];
           echo json_encode($vehiculo->getById_usuarioVe($dato));
       break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case 'getAll' :
            echo json_encode($vehiculo->getAll());
        break;
        
    }
}