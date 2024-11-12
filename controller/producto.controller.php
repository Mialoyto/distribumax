<?php

require_once '../model/Producto.php';

$producto = new Productos();

if (isset($_POST['operation'])) {
  switch ($_POST['operation']) {
    case 'addProducto':
      $campos = [
        'idproveedor',
        'idmarca',
        'idsubcategoria',
        'nombreproducto',
        'idunidadmedida',
        'cantidad_presentacion',
        'codigo',
        'precio_compra',
        'precio_minorista',
        'precio_mayorista'
      ];
      foreach ($campos as $campo) {
        if (!isset($_POST[$campo])) {
          echo json_encode(["id" => 0]);
          return;
        }
      }
      $datosEnviar = [
        'idproveedor'           => trim($_POST['idproveedor']),
        'idmarca'               => trim($_POST['idmarca']),
        'idsubcategoria'        => trim($_POST['idsubcategoria']),
        'nombreproducto'        => trim($_POST['nombreproducto']),
        'idunidadmedida'        => trim($_POST['idunidadmedida']),
        'cantidad_presentacion' => trim($_POST['cantidad_presentacion']),
        'peso_unitario'         => isset($_POST['peso_unitario']) ? trim($_POST['peso_unitario']) : null,
        'codigo'                => trim($_POST['codigo']),
        'precio_compra'         => trim($_POST['precio_compra']),
        'precio_mayorista'      => trim($_POST['precio_mayorista']),
        'precio_minorista'      => trim($_POST['precio_minorista'])
      ];
      $datosRecibidos = $producto->addProducto($datosEnviar);
      echo json_encode(["id" => $datosRecibidos]);
      break;

    case 'delete':
      if (isset($_POST['idproducto'])) {
        $idproducto = $_POST['idproducto'];
        $resultado = $producto->deleteProducto($idproducto);
        echo json_encode(["success" => $resultado]);
      } else {
        echo json_encode(["success" => false, "error" => "ID del producto no especificado."]);
      }
      break;
  }
}

if (isset($_GET['operation'])) {
  switch ($_GET['operation']) {
    case 'getAll':
      echo json_encode($producto->getAll());
      break;

    case 'searchProducto':
      $datos = [
        '_item' => $_GET['_item']
      ];
      $lista = $producto->searchProducto($datos);
      echo json_encode(["data" => $lista]);
      break;

    case 'getProducto':
      $datos = [
        '_cliente_id' => $_GET['_cliente_id'],
        '_item' => $_GET['_item']
      ];
      echo json_encode($producto->ObtenerPrecioProducto($datos));
      break;

    case 'getCodeProducto':
      $datosEnviar = [
        'codigo' => $_GET['codigo']
      ];
      $datosRecibidos = $producto->getCodigoProducto($datosEnviar);
      echo json_encode($datosRecibidos);
      break;
  }
}
