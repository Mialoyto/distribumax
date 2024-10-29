<?php
require_once '../../vendor/autoload.php';
require_once '../../model/Persona.php';
$persona = new Persona();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);


$persona = $persona ->getAll();



$html = '<h1>Listado de Personas</h1>';
$html .= '<table border="1" cellpadding="5" cellspacing="0">';
$html .= '<thead><tr><th>Dni</th><th>Nombres</th><th>Apellido P.</th><th>Apellido M.</th></tr></thead>';
$html .= '<tbody>';

foreach ($persona as $persona) {
    $html .= '<tr>';
    $html .= '<td><b>' . htmlspecialchars($persona['nro_documento']) . '</b></td>';
    $html .= '<td>' . htmlspecialchars($persona['nombres']) . '</td>';
    $html .= '<td>' . htmlspecialchars($persona['appaterno']) . '</td>';
    $html .= '<td>' . htmlspecialchars($persona['apmaterno']) . '</td>';
    $html .= '</tr>';
}

$html .= '</tbody>';
$html .= '</table>';

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'portrait');

$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("personas.pdf", array("Attachment" => false));
