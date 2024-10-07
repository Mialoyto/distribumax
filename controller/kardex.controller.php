<?php

require_once '../model/kardex.php';

$kardex = new Kardex();

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'add':
      if (
        empty($_POST['tipomovimiento']) || empty($_POST['idproducto']) ||
        empty($_POST['idusuario']) || empty($_POST['cantidad']) ||
        ($_POST['tipomovimiento'] != 'Ingreso' && $_POST['tipomovimiento'] != 'Salida')
      ) {
        echo json_encode(['estado' => false]);
        return;
      }
      $datosEnviar = [
        'idusuario'         => $_POST['idusuario'],
        'idproducto'        => $_POST['idproducto'],
        'fecha_vencimiento' => $_POST['fecha_vencimiento'],
        'numlote'           => $_POST['numlote'],
        'tipomovimiento'    => $_POST['tipomovimiento'],
        'cantidad'          => $_POST['cantidad'],
        'motivo'            => $_POST['motivo']
      ];
      $estado = $kardex->add($datosEnviar);
      echo json_encode(['estado' => $estado]);
      break;

    case 'getById':
      echo json_encode($kardex->getById(['idproducto' => $_POST['idproducto']]));
      break;
  }
}

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($kardex->getAll());
      break;
  }
}
