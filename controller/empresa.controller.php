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
      $entidades = $empresa->search($dato);

      echo json_encode($entidades);
      break;
  }
}



if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      $datos = [
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
    case 'upEstado':
      $datos = [
        'estado' => $_POST['estado'],
        'idempresaruc' => $_POST['idempresaruc']
      ];
      echo json_encode($empresa->upEstado($datos));
      break;

    case 'upEmpresa':
      $datos = [

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
      echo json_encode($empresa->getByID(['idempresaruc' => $_POST['idempresaruc']]));
      break;
  }
}
