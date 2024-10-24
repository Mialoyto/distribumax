<?php
require_once '../../../vendor/autoload.php';
require_once '../../../model/Empresa.php';
$empresa = new Empresas();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);


$empresas = $empresa ->getAll();



$html = '<h1>Listado de Empresas</h1>';
$html .= '<table border="1" cellpadding="5" cellspacing="0">';
$html .= '<thead><tr><th>Razón Social</th><th>Direccion</th><th>Telefono</th></tr></thead>';
$html .= '<tbody>';

foreach ($empresas as $empresa) {
    $html .= '<tr>';
    $html .= '<td><b>' . htmlspecialchars($producto['razon_social']) . '</b></td>';
    $html .= '<td>' . htmlspecialchars($producto['direccion']) . '</td>';
    $html .= '<td>' . htmlspecialchars($producto['telefono']) . '</td>';
    $html .= '</tr>';
}

$html .= '</tbody>';
$html .= '</table>';

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'portrait');

$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("empresas.pdf", array("Attachment" => false));
