<?php
require_once '../model/Despacho.php';


$despacho = new Despachos();

// TODO: USANDO POST
if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addDespacho':
      $datos = [
        'status' => false,
        'message' => ''
      ];

      $idvehiculo = $_POST['idvehiculo'];
      $idusuario = $_POST['idusuario'];
      $fecha_despacho = $_POST['fecha_despacho'];
      $jefe_mercaderia=$_POST['idjefe_mercaderia'];

      if (!empty($idvehiculo) && !empty($idusuario) && !empty($fecha_despacho) && !empty($jefe_mercaderia)) {
        if ($fecha_despacho <= date('Y-m-d')) {
          $datos['message'] = 'La fecha de despacho no puede ser menor o igual a la fecha actual';
          echo json_encode($datos);
          return;
        }
        // Validar fin de semana
        $diaSemana = date('N', strtotime($fecha_despacho));
        if ($diaSemana > 6) {
          $datos['message'] = 'No se pueden programar despachos en fin de semana';
          echo json_encode($datos);
          return;
        }
        $dataEnviar = [
          'idvehiculo' => $idvehiculo,
          'idusuario' => $idusuario,
          'fecha_despacho' => $fecha_despacho,
          'idjefe_mercaderia' => $jefe_mercaderia
        ];
        $response = $despacho->addDespacho($dataEnviar);
        // echo $response ? true : false;
        if (!$response) {
          $datos['message'] = 'Error al registrar el despacho';
          echo json_encode($datos);
        } else {
          $datos['status'] = true;
          $datos['message'] = 'Despacho registrado correctamente';
          $datos['iddespacho'] = $response;
          echo json_encode($datos);
        }
      } else {
        $datos['message'] = 'Faltan datos';
        echo json_encode($datos);
      }
      break;
    case 'updateEstado':
      $datoEnviar = [
        'iddespacho' => $_POST['iddespacho'],
        'estado'    => $_POST['estado']
      ];
      echo json_encode($despacho->updateEstado($datoEnviar));
      break;
  }
}


// TODO: USANDO GET
if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'listar':
      echo json_encode($despacho->listar());
      break;
    case 'reporte':
      $dato = [
        'iddespacho' => $_GET['iddespacho']
      ];
      echo json_encode($despacho->reporte($dato));
      break;

    case 'listarventas':
      $dato = [
        'iddespacho' => $_GET['iddespacho']
      ];
      echo json_encode($despacho->listarventas($dato));
      break;
    case 'listProvinciasVentas':
      $response = $despacho->listarProvinciasVentasPendientes();
      echo json_encode($response);
      break;
    case 'listVentasPorProvincia':
      $provincia = $_GET['provincia'];
      $datos = [
        'status' => 0,
        'message' => ''
      ];

      if (!empty($provincia)) {
        $datosEnviar = [
          'provincia' => $provincia
        ];
        $response = $despacho->listVentasPendientes($datosEnviar);
        echo json_encode($response);
      } else {
        $datos['message'] = 'Faltan datos';
        echo json_encode($datos);
      }

      break;
      case 'buscarJefeMercaderia':
      $dato = [
        'item' => $_GET['item']
      ];
      echo json_encode($despacho->buscarJefeMercaderia($dato));
      break;
  }
}
