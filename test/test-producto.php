<?php
require_once '../model/Producto.php';
$producto = new Productos();

$datosEnviar = [
  'idproveedor' => 2,
  'idmarca' => 5,
  'idsubcategoria' => 5,
  'nombreproducto' => 'Galleta Casino chocolate',
  'idunidadmedida' => 2,
  'cantidad_presentacion' =>12 ,
  'peso_unitario' => '500 GR',
  'codigo' => 'CAS-00003',
  'precio_compra' => 12.50,
  'precio_minorista' => 17.20,
  'precio_mayorista' => 20.80
];
$datosRecibidos = $producto->addProducto($datosEnviar);
if($datosRecibidos){
  echo json_encode(["id" => $datosRecibidos]);
  echo "Producto registrado";
}else{
  echo json_encode(["id" => 0]);
  echo "Error al registrar producto";
}