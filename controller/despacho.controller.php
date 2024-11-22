<?php
require_once '../model/Despacho.php';


$despacho = new Despachos();


if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case'add':
            $datos=
            [
                'idventa'=>$_POST['idventa'],
                'idvehiculo'=>$_POST['idvehiculo'],
                'idusuario'=>$_POST['idusuario'],
                'fecha_despacho'=>$_POST['fecha_despacho']
            ];
            echo json_encode($despacho->add($datos));
        break;
        case 'updateEstado':
            $datoEnviar=[
                'iddespacho'=>$_POST['iddespacho'],
                'estado'    =>$_POST['estado']
            ];
            echo json_encode($despacho->updateEstado($datoEnviar));
        break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case'listar':
            echo json_encode($despacho->listar());
        break;
        case 'reporte':
            $dato=[
                'iddespacho'=>$_GET['iddespacho']
            ];
            echo json_encode($despacho->reporte($dato));
        break;
        
        case 'listarventas':
            $dato=[
                'iddespacho'=>$_GET['iddespacho']
            ];
            echo json_encode($despacho->listarventas($dato));
        break;
    }   
}
