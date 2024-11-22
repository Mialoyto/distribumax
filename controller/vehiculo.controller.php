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

       case 'searchVehiculo':
        $dato=[
            'item'=>$_POST['item']
        ];
        echo json_encode($vehiculo->searchVehiculo($dato));
        break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case 'getAll' :
            echo json_encode($vehiculo->getAll());
        break;
        
        case 'getVehiculo':
            $datosEnviar = [
                'idvehiculo' => $_GET['idvehiculo']
            ];
            $datosRecibidos = $vehiculo->getVehiculo($datosEnviar);
            echo json_encode($datosRecibidos);
            break;
        case 'updateVehiculo':
            $idvehiculo = $_GET['idvehiculo'];
            $marca = $_GET['marca_vehiculo'];
            $modelo = $_GET['modelo'];
            $placa = $_GET['placa'];
            $capacidad = $_GET['capacidad'];
            $condicion = $_GET['condicion'];

            if(empty($idvehiculo) || empty($marca) || empty($modelo) || empty($placa) || empty($capacidad) || empty($condicion)){
                echo json_encode(['status' => 'error', 'message' => 'Faltan datos']);
                return;
            } else if(!is_numeric($idvehiculo)){
                echo json_encode(['status' => 'error', 'message' => 'El id del vehiculo debe ser un número']);
                return;
            } else{
                $datos = [
                    'idvehiculo' => $idvehiculo,
                    'marca_vehiculo' => $marca,
                    'modelo' => $modelo,
                    'placa' => $placa,
                    'capacidad' => $capacidad,
                    'condicion' => $condicion
                ];
                $response = $vehiculo->updateVehiculo($datos);
                echo json_encode($response);
            }
    }
}