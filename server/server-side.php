<?php

require_once '../controller/kardex.controller.php';
require_once '../model/Conexion.php';

$productos = new Kardex();

foreach ($productos->getAll() as $producto) {
    $data[] = array(
        $producto->idkardex,
        $producto->idusuario,
        $producto->idproducto,
        $producto->numlote
    );
}

echo json_encode(['data' => $data]);

$conexion = new Conexion();

$sql_details = array(
  'user' => 'root',          // Nombre de usuario de la base de datos
  'pass' => '',              // Contraseña (vacío en este caso)
  'db'   => 'distribumax',    // Nombre de la base de datos
  'host' => 'localhost'       // Servidor
);

$table = 'kardex';
$primaryKey = 'idkardex';
$columns = array(
    array( 'db' => 'idkardex', 'dt' => 0 ),
    array( 'db' => 'idusuario', 'dt' => 1 ),
    array( 'db' => 'idproducto', 'dt' => 2 ),
    array( 'db' => 'numlote', 'dt' => 3 )
);

$sql_details = array(
    'user' => $conexion->getConexion(),
    'pass' => $conexion->getConexion(),
    'db'   => $conexion->getConexion(),
    'host' => $conexion->getConexion()
);