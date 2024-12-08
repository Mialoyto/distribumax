
<?php

require_once '../model/Notificacion.php';

$notificacion = new Notificacion();

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case 'generar':
            echo json_encode($notificacion->GenerarNotificacion());
         
        break;

        case 'leido':
            $datosEnviar=[
                'leido'=>$_POST['leido'],
                'idnotificacion'=>$_POST['idnotificacion']
            ];
            echo json_encode($notificacion->updatenotificar($datosEnviar));
        break;
    
    }
}

if(isset($_GET['operation'])){
    switch ($_GET['operation']){
        case 'notificar':
           echo json_encode(  $notificacion->notificar());   
        break;

        case 'getAll':
            echo json_encode($notificacion->getAll());
        break;

    }
}

?>