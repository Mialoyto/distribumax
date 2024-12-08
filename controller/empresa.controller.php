<?php


require_once '../model/Empresa.php';
$empresa = new Empresas();


if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($empresa->getAll());
      break;

    case 'getEmpresaById':
      $datos = [
        'idempresaruc' => $_GET['idempresaruc']
      ];
      $response = $empresa->getEmpresaById($datos);
      echo json_encode($response);
      break;

    case 'search':
      $dato = [
        'ruc' => $_GET['ruc']
      ];
      $entidades = $empresa->search($dato);

      echo json_encode($entidades);
      break;

    
    case 'updateEstado':
      $datos = [
        
        'idempresaruc' => $_GET['idempresaruc'],
        'estado' => $_GET['estado']
        ];
        $response = $empresa->updateEstado($datos);
        echo json_encode($response);
        break;
  
    case 'updateEmpresa':
      $idempresaruc = $_GET['idempresaruc'];
      $razonsocial = $_GET['razonsocial'];
      $direccion = $_GET['direccion'];
      $email = $_GET['email'];
      $telefono = $_GET['telefono'];

      if(empty($idempresaruc || empty($razonsocial) || empty($direccion) || empty($email) || empty($telefono))){
        echo json_encode(['status' => 'error','message' => 'Faltan datos']);
        return;
      } else if(!is_numeric($idempresaruc)){
        echo json_encode(['status' => 'error','message' => 'El id de la empresa debe ser un número']);
        return;
      } else{
        $datos = [
          'idempresauc' => $idempresaruc,
          'razonsocial' => $razonsocial,
          'direccion'   => $direccion,
          'email'       => $email,
          'telefono'    => $telefono
        ];
        $response = $empresa->updateEmpresa($datos);
        echo json_encode($response);
      }
      break;
  }
}



if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $datos = [
        'idtipodocumento' => $_POST['idtipodocumento'],
        'idempresaruc' => $_POST['idempresaruc'],
        'iddistrito'   => $_POST['iddistrito'],
        'razonsocial'  => $_POST['razonsocial'],
        'direccion'    => $_POST['direccion'],
        'email'        => $_POST['email'],
        'telefono'     => $_POST['telefono']
      ];


      $id = $empresa->add($datos);
      $resultado = ['idempresa' => $id];
      echo json_encode($resultado);
      break;
  }
}
