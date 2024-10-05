<?php


require_once '../model/DetalleMetodoP.php';

$detallemetodo = new DetalleMetodo();
header('Content-Type: application/json, charset=utf-8');
$verbo = $_SERVER['REQUEST_METHOD'];

switch($verbo){
    case 'POST':
        if(isset($_POST['operation'])){
            switch ($_POST['operation']){
                case 'addDetalleMetodo':
                    if(isset($_POST['idventa'])){
                        $idventa=$_POST['idventa'];
                        $metodos=$_POST['metodos'];
                        $datos=[];

                        if(is_array($metodos)&&count($metodos)>0){
                           
                            foreach($metodos AS $item){
                                $datosEnviar=[
                                    'idventa' =>$idventa,
                                    'idmetodopago'=> $item['idmetodopago'],
                                    'monto'=> $item['monto']
                                ];
                                $dato=$detallemetodo->addDetalleMetodo($datosEnviar);
                                $datos[]=$dato;
                            }
                        }}
                        echo json_encode(['id'=>$datos]);
            }
                break;
        }
}
