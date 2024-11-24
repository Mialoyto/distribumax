<?php

require_once '../model/Compras.php';

$compras = new Compras();

if (isset($_GET['operation'])) {
  if ($_GET['operation'] == 'getProductosProveedor') {
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
  }
}
