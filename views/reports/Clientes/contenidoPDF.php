<?php
require_once '../../../vendor/autoload.php';
require_once '../../../model/Cliente.php';
$cliente = new Cliente();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);


$clientes = $cliente ->getAll();



$html = '<h1>Listado de Clientes</h1>';
$html .= '<table border="1" cellpadding="5" cellspacing="0">';
$html .= '<thead><tr><th>ID Cliente</th><th>Tipo de Cliente</th><th>Cliente</th><th>Fecha de Creación</th><th>Estado</th></tr></thead>';
$html .= '<tbody>';

foreach ($clientes as $cliente) {
    $html .= '<tr>';
    $html .= '<td><b>' . htmlspecialchars($cliente['idcliente']) . '</b></td>';
    $html .= '<td>' . htmlspecialchars($cliente['tipo_cliente']) . '</td>';
    $html .= '<td>' . htmlspecialchars($cliente['cliente']) . '</td>';
    $html .= '<td>' . htmlspecialchars($cliente['fecha_creacion']) . '</td>';
    $html .= '<td>' . htmlspecialchars($cliente['estado_cliente']) . '</td>';
    $html .= '</tr>';
}

$html .= '</tbody>';
$html .= '</table>';

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'portrait');

$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("clientes.pdf", array("Attachment" => false));
