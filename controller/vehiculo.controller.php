<?php

require_once '../model/vehiculos.php';

$vehiculo= new Vehiculo();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case 'addVehiculo':
        break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case 'getAll' :
            echo json_encode($vehiculo->getAll());
        break;
        case 'searchConductor':
             $dato=[
                'item'=>$_GET['item']
             ];
             echo json_encode($vehiculo->searchConductor($dato));
        break;
    }
}