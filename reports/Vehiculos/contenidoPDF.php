<?php
require_once '../../vendor/autoload.php';
require_once '../../model/vehiculos.php';
$vehiculo = new Vehiculo();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);


$vehiculos = $vehiculo ->getAll();



$html = '<h1>Listado de Vehiculos</h1>';
$html .= '<table border="1" cellpadding="5" cellspacing="0">';
$html .= '<thead><tr><th>Conductor</th><th>Marca</th><th>Modelo</th><th>Placa</th><th>Condicion</th></tr></thead>';
$html .= '<tbody>';

foreach ($vehiculos as $vehiculo) {
    $html .= '<tr>';
    $html .= '<td>' . htmlspecialchars($vehiculo['datos']) . '</td>';
    $html .= '<td>' . htmlspecialchars($vehiculo['marca_vehiculo']) . '</td>';
    $html .= '<td>' . htmlspecialchars($vehiculo['modelo']) . '</td>';
    $html .= '<td>' . htmlspecialchars($vehiculo['placa']) . '</td>';
    $html .= '<td>' . htmlspecialchars($vehiculo['condicion']) . '</td>';
    $html .= '</tr>';
}

$html .= '</tbody>';
$html .= '</table>';

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'portrait');

$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("vehiculos.pdf", array("Attachment" => false));
