<?php


require_once '../model/Empresa.php';
$empresa = new Empresas();


if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($empresa->getAll());
    break;

    case 'search':
      // Preparar el RUC que viene en la solicitud
      $dato = [
        'ruc' => $_GET['ruc']
      ];

      // Llamada al método de búsqueda (usando el procedimiento almacenado)
      $entidades = $empresa->search($dato);

      // Preparar la respuesta
      $response = [];

      if (count($entidades) > 0) {
        // Recorrer los resultados de búsqueda
        foreach ($entidades as $entidad) {
          // Si el estado es 'No data', indicar que no está registrada
          if ($entidad['estado'] == 'No data') {
            $response[] = [
              'estado' => 'No data',  // No hay datos, la empresa no está registrada
              'message' => 'La empresa no está registrada. Puedes agregarla como nueva empresa.'
            ];
          } else {
            // Si está registrada (como empresa y/o cliente), devolver los detalles
            $response[] = [
              'tipo_cliente' => $entidad['tipo_cliente'],
              'idempresaruc' => $entidad['idempresaruc'],
              'razonsocial'  => $entidad['razonsocial'],
              'direccion'    => $entidad['direccion'],
              'email'        => $entidad['email'],
              'telefono'     => $entidad['telefono'],
              'distrito'     => $entidad['distrito'],
              'estado'       => $entidad['estado'] // Registrado o No registrado
            ];
          }
        }
      }

      // Enviar la respuesta como JSON
      echo json_encode($response);
    break;
  }
}



if(isset($_POST['operation'])){
  switch($_POST['operation']){
    case 'add':
      $datos=[
        'idempresaruc' => $_POST['idempresaruc'],
        'iddistrito'   => $_POST['iddistrito'],
        'razonsocial'  => $_POST['razonsocial'],
        'direccion'    => $_POST['direccion'],
        'email'        => $_POST['email'],
        'telefono'     => $_POST['telefono']
      ];
      
 
       $id=$empresa->add($datos);
       $resultado= ['idempresas'=>$id];
       echo json_encode($resultado);
    break;
    case 'upEstado':
      $datos=[
        'estado' =>$_POST['estado'],
        'idempresaruc' =>$_POST['idempresaruc']
      ];
      echo json_encode($empresa->upEstado($datos));
    break;

    case 'upEmpresa':
      $datos=[
        
        'iddistrito'   => $_POST['iddistrito'],
        'razonsocial'  => $_POST['razonsocial'],
        'direccion'    => $_POST['direccion'],
        'email'        => $_POST['email'],
        'telefono'     => $_POST['telefono'],
        'idempresaruc' => $_POST['idempresaruc']
      ];
      
 
        echo json_encode($empresa->UpEmpresa($datos));
    break;
    case 'getByID':
      echo json_encode($empresa->getByID(['idempresaruc'=>$_POST['idempresaruc']]));
    break;

    

   
  }
}


