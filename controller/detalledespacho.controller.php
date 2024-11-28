<?php
require_once '../model/detalledespacho.php';

$detalle_despacho = new DetalleDespacho();

header('Content-Type: application/json; charset=utf-8');
$verbo = $_SERVER['REQUEST_METHOD'];

switch ($verbo) {
	case 'POST':
		if (isset($_POST['operation'])) {
			switch ($_POST['operation']) {
				case 'addDetalleDespacho':
					$iddespacho = $_POST['iddespacho'];
					$productos = $_POST['productos'];
					$detalles = [];
					$datos = [
						'status' => false,
						'message' => ''
					];

					if (!isset($iddespacho) || !isset($productos) || !is_array($productos)) {
						$datos['message'] = 'Faltan datos o formato incorrecto';
						echo json_encode($datos);
						break;
					}

					if (count($productos) > 0) {
						foreach ($productos as $item) {
							if (isset($item['idventa']) && isset($item['idproducto'])) {
								$datosEnviar = [
									'iddespacho' => $iddespacho,
									'idventa' => $item['idventa'],
									'idproducto' => $item['idproducto']
								];
								$dato = $detalle_despacho->add($datosEnviar);
								$detalles[] = $dato;
							}
						}
						$datos['status'] = true;
						$datos['message'] = 'Detalle despacho registrado';
						$datos['detalles'] = $detalles;
					} else {
						$datos['message'] = 'No hay productos para registrar';
					}
					echo json_encode($datos);
					break;
			}
		}
		break;
}
