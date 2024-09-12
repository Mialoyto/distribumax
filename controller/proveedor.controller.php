<?php


require_once '../model/Proveedor.php';
require_once '../model/proveedor.php';

  $proveedor = new Proveedor();

if(isset($_POST['operation'])){
    switch($_POST['operation']){
        case 'addProveedor':
            $datos=[
                'idempresa'          => $_POST['idempresa'],
                'proveedor'          => $_POST['proveedor'],
                'contacto_principal' => $_POST['contacto_principal'],
                'telefono_contacto'  => $_POST['telefono_contacto'],
                'direccion'          => $_POST['direccion'],
                'email'              => $_POST['email']
            ];
            echo json_encode($proveedor->addProveedor($datos));
        break;
    }
}

if(isset($_GET['operation'])){
    switch($_GET['operation']){
        case 'getAll':
            echo json_encode($proveedor->getAll());
        break;
    }
}