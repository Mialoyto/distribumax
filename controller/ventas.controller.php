<?php

require_once '../model/ventas.php';
$venta = new Ventas();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case 'addVentas':
            $datos=[
                'idpedido' =>$_POST['idpedido'],
                'idmetodopago' =>$_POST['idmetodopago'],
                'idtipocomprobante' =>$_POST['idtipocomprobante'],
                'fecha_venta' =>$_POST['fecha_venta'],
                'subtotal' =>$_POST['subtotal'],
                'descuento' =>$_POST['descuento'],
                'igv' =>$_POST['igv'],
                'total_venta'=>$_POST['total_venta']
            ];
            echo json_encode($venta->addVentas($datos));
        break;
    }
}
if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case 'getAll':
            echo json_encode($venta->getAll());
        break;
    }
}