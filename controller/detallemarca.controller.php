<?php

require_once '../model/Detallemarcas.php';

$detallemarca = new Detallemarca();

if (isset($_POST['operation'])) {
    switch ($_POST['operation']) {
        case  'addDetallemarca':

            $marca = $_POST['idmarca'];
            // $categoria = $_POST['idcategoria'];
            $id = $_POST['ids'];
            $ids = [];

            $datos = [
                'estado' => 0,
                'message' => '',
                'success' => false
            ];
            if (empty($marca) || empty($id)) {
                $datos['estado'] = 0;
                $datos['message'] = ' faltan datos';
                echo json_encode($datos);
            } else {
                if (is_array($id) && count($id) > 0) {
                    foreach ($id as $i) {
                        $datosEnviar = [
                            'idmarca' => $marca,
                            'idcategoria' => $i['idcategoria']

                        ];
                        $response = $detallemarca->addDetallemarca($datosEnviar);
                        // var_dump($response);
                        // var_dump($response[0]['mensaje']);

                        if ($response[0]['estado']) {
                            $datos['estado'] = $response[0]['estado'];
                            $datos['message'] = $response[0]['mensaje'];
                            $datos['success'] = true;
                            $ids[] = $response;
                        } else {
                            $datos['estado'] = $response[0]['estado'];
                            $datos['message'] = $response[0]['mensaje'];
                            $datos['success'] = false;
                        }
                    }
                    echo json_encode($datos);
                }

            }

            break;
    }
}
