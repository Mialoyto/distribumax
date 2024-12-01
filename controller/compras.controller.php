<?php

require_once '../model/Compras.php';

$compras = new Compras();
header('Content-Type: application/json, charset=utf-8');

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getProductosProveedor':
      $idProveedor = $_GET['idproveedor'];
      $Producto = $_GET['producto'];
      if (!isset($idProveedor) || !isset($Producto)) {
        echo json_encode(["error" => "Faltan parametros"]);
        return;
      } else if ($idProveedor == "" || $Producto == "") {
        echo json_encode(["error" => "Parametros vacios"]);
        return;
      }
      $datosEnviar = [
        'idproveedor' => $idProveedor,
        'producto' => trim($Producto)
      ];
      $response = $compras->getProductosProveedor($datosEnviar);
      echo json_encode($response);
      break;
      case 'getAll':
        echo json_encode($compras->getAll());
      break;
  }
}

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addCompra':
      $idusuario = $_POST['idusuario'];
      $idproveedor = $_POST['idproveedor'];
      $idcomprobante = $_POST['idcomprobante'];
      $numcomprobante = $_POST['numcomprobante'];
      $fechaemision = $_POST['fechaemision'];
      $datos = [
        'status' => false,
        'message' => '',
        'idcompra' => 0
      ];

      if (!isset($idusuario) || !isset($idproveedor) || !isset($idcomprobante) || !isset($numcomprobante) || !isset($fechaemision)) {
        $datos['message'] = "Faltan parametros";
        echo json_encode($datos);
        return;
      } else if ($idusuario == "" || $idproveedor == "" || $idcomprobante == "" || $numcomprobante == "" || $fechaemision == "") {
        $datos['message'] = "Parametros vacios";
        echo json_encode($datos);
        return;
      } else {
        $datosEnviar = [
          'idusuario' => $idusuario,
          'idproveedor' => $idproveedor,
          'idcomprobante' => $idcomprobante,
          'numcomprobante' => $numcomprobante,
          'fechaemision' => $fechaemision
        ];
        $response = $compras->addCompra($datosEnviar);
        if (!$response) {

          $datos['message'] = "Error al registrar la compra";
          $datos['idcompra'] = $response;
          echo json_encode($datos);
          return;
        }
        $datos['status'] = true;
        $datos['message'] = 'Compra registrada correctamente';
        $datos['idcompra'] = $response;
        echo json_encode($datos);
      }
      break;
    case 'addDetalleCompra':
      $datos = [
        'status' => false,
        'message' => '',
        'iddetallecompra' => []
      ];

      // Validar que existan los datos necesarios
      if (!isset($_POST['productos']) || !isset($_POST['idcompra'])) {
        $datos['message'] = "Faltan parámetros requeridos";
        echo json_encode($datos);
        return;
      }

      $idcompra = $_POST['idcompra'];
      $productos = $_POST['productos']; // Ya es un array, no necesita json_decode

      // Validar que productos sea un array y no esté vacío
      if (!is_array($productos) || empty($productos)) {
        $datos['message'] = "No hay productos para registrar";
        echo json_encode($datos);
        return;
      }

      try {
        foreach ($productos as $producto) {
          // Validar datos requeridos de cada producto
          if (
            !isset($producto['idlote']) ||
            !isset($producto['idproducto']) ||
            !isset($producto['cantidad']) ||
            !isset($producto['preciocompra'])
          ) {
            throw new Exception("Datos incompletos en uno de los productos");
          }

          $datosEnviar = [
            'idcompra' => $idcompra,
            'idlote' => $producto['idlote'],
            'idproducto' => $producto['idproducto'],
            'cantidad' => $producto['cantidad'],
            'preciocompra' => $producto['preciocompra']
          ];

          $response = $compras->addDetalleCompra($datosEnviar);
          $datos['iddetallecompra'][] = $response;
        }

        $datos['status'] = true;
        $datos['message'] = 'Detalle de compra registrado correctamente';
      } catch (Exception $e) {
        $datos['message'] = $e->getMessage();
      }

      echo json_encode($datos);
      break;

      case 'updateEstado':
         $datosEnviar=[
          'estado'=>$_POST['estado'],
          'idcompra'=>$_POST['idcompra']
         ];
         echo json_encode($compras->updateEstado($datosEnviar));
        break;
  }
}
