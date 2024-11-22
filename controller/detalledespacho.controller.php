<?php
require_once '../model/detalledespacho.php';

$detalle_despacho = new DetalleDespacho();

header('Content-Type: application/json; charset=utf-8');
$verbo = $_SERVER['REQUEST_METHOD'];

switch ($verbo) {
    case 'POST':
        if (isset($_POST['operation'])) {
            switch ($_POST['operation']) {
                case 'add':
                    if (isset($_POST['iddespacho']) && isset($_POST['idventa'])) {
                        $iddespacho = $_POST['iddespacho'];
                        $idventas = $_POST['idventa']; // Se espera que este campo sea un arreglo de ventas
                        $datos = [];

                        // Verifica que idventas es un arreglo y tiene elementos
                        if (is_array($idventas) && count($idventas) > 0) {
                            foreach ($idventas as $idventa) {
                                $datosEnviar = [
                                    'iddespacho' => $iddespacho,
                                    'idventa' => $idventa
                                ];

                                // Captura el resultado de cada inserción
                                $resultado = $detalle_despacho->add($datosEnviar);
                                $datos[] = ["iddetalle_despacho" => $resultado];
                            }

                            // Retorna el arreglo con los resultados de las inserciones
                            echo json_encode([
                                'success' => true,
                                'data' => $datos
                            ]);
                        } else {
                            // Si idventas no es un arreglo o está vacío
                            echo json_encode([
                                'success' => false,
                                'message' => 'No se recibió una lista válida de ventas.'
                            ]);
                        }
                    } else {
                        // Si faltan los datos de iddespacho o idventa
                        echo json_encode([
                            'success' => false,
                            'message' => 'Datos incompletos. iddespacho y idventa son requeridos.'
                        ]);
                    }
                    break;

                // Puedes agregar más operaciones aquí si es necesario
            }
        }
        break;

    // Puedes manejar otros métodos HTTP si lo deseas
}
?>
