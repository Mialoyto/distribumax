<?php
require_once '../model/DetalleMetodoP.php';

$detallemetodo = new DetalleMetodo();
header('Content-Type: application/json; charset=utf-8');
$verbo = $_SERVER['REQUEST_METHOD'];

switch ($verbo) {
  case 'POST':
    if (isset($_POST['operation'])) {
      switch ($_POST['operation']) {
        case 'addDetalleMetodo':
          if (isset($_POST['idventa']) && isset($_POST['metodos']) && is_array($_POST['metodos'])) {
            $idventa = $_POST['idventa'];
            $metodos = $_POST['metodos'];
            $datos = [];

            foreach ($metodos as $item) {
              // Verifica que los campos requeridos existen en el array $item
              if (isset($item['idmetodopago'], $item['monto'])) {
                $datosEnviar = [
                  'idventa'       => $idventa,
                  'idmetodopago'  => $item['idmetodopago'],
                  'monto'         => $item['monto']
                ];

                // Captura el resultado de cada inserción
                $resultado = $detallemetodo->addDetalleMetodo($datosEnviar);

                // Verifica si hubo error en la inserción

              }
            }
            // Retorna el arreglo con los resultados de las inserciones
            echo json_encode(['id' => $datos]);
          }
          break;
      }
    }
    break;
}
