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

    case 'UpdateEstado':
      $datosEnviar=[
        'estado'=>$_POST['estado'],
        'idproducto'=>$_POST['idproducto']
      ];
      echo json_encode($producto->UpdateEstado($datosEnviar));
    break;
    case 'updateProducto':
      $datosEnviar=[
        'idmarca'=>$_POST['idmarca'],
        '_ombreproducto'=>$_POST['nombreproducto'],
        'idunidadmedida'=>$_POST['idunidadmedida'],
        'cantidad_presentacion'=>$_POST['cantidad_presentacion'],
        'codigo'=>$_POST['codigo'],
        'precio_compra'=>$_POST['precio_compra'],
        'precio_mayorista'=>$_POST['precio_mayorista'],
        'precio_minorista'=>$_POST['precio_minorista'],
        'idproducto'=>$_POST['idproducto'],
      ];
      echo json_encode($producto->updateProducto($datosEnviar));
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
      
      case 'ObtenerProducto':
        $datos=['idproducto'=>$_GET['idproducto']];
        echo json_encode($producto->ObtenerProducto($datos));
       break;
  }
}
