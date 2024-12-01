<?php 
require_once '../model/Lotes.php';
$lote = new Lotes();


if(isset($_POST['operation'])){

    switch ($_POST['operation']){
        case 'addLote':
            $datos = [
                'idproducto' => $_POST['idproducto'],
                'numlote' => $_POST['numlote'],
                'fecha_vencimiento' => $_POST['fecha_vencimiento']
            ];
            $datos = $lote->add($datos);
            echo json_encode($datos);
            break;
    }
}

if(isset($_GET['operation'])){

    switch ($_GET['operation']){
        case 'searchLote':
            $datos = [
                '_idproducto' => $_GET['_idproducto']
            ];
            $datos = $lote->searchLote($datos);
            echo json_encode($datos);
        break;
        case 'Agotados_vencidos':
            $datos = $lote->Agotados_vencidos();
            echo json_encode($datos);
    }
}



