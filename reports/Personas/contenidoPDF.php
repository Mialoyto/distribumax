<?php
require_once '../../vendor/autoload.php';
require_once '../../model/Persona.php';
$persona = new Persona();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);

// Obtener todas las personas
$personas = $persona->getAll();

// Agrupar personas por distrito
$personasPorDistrito = [];
foreach ($personas as $persona) {
    $personasPorDistrito[$persona['distrito']][] = $persona;
}

// Función para generar colores únicos para cada distrito
function getColorForDistrito($distrito) {
    $hash = substr(md5($distrito), 0, 6);
    return '#' . $hash;
}

// Leer el archivo CSS
$css = file_get_contents('./estilo.html');

// Iniciar el contenido HTML del PDF
$html = '<style>' . $css . '</style>';
$html .= '<h1>Listado de Personas por Distrito</h1>';

// Generar el listado de personas agrupadas por distrito
foreach ($personasPorDistrito as $distrito => $personas) {
    $color = getColorForDistrito($distrito); // Color para cada distrito

    // Título del distrito
    $html .= '<h2 style="color:' . htmlspecialchars($color) . '; text-align: center;">Distrito: ' . htmlspecialchars($distrito) . '</h2>';

    // Tabla de personas en el distrito
    $html .= '<table border="1" cellpadding="5" cellspacing="0">';
    $html .= '<thead><tr><th>Dni</th><th>Nombres</th><th>Apellido P.</th><th>Apellido M.</th></tr></thead>';
    $html .= '<tbody>';

    // Listar personas en el distrito
    foreach ($personas as $persona) {
        $html .= '<tr style="background-color: ' . htmlspecialchars($color) . '26;">'; // Color con transparencia
        $html .= '<td><b>' . htmlspecialchars($persona['nro_documento']) . '</b></td>';
        $html .= '<td>' . htmlspecialchars($persona['nombres']) . '</td>';
        $html .= '<td>' . htmlspecialchars($persona['appaterno']) . '</td>';
        $html .= '<td>' . htmlspecialchars($persona['apmaterno']) . '</td>';
        $html .= '</tr>';
    }

    $html .= '</tbody>';
    $html .= '</table>';
}

$dompdf->loadHtml($html);
$dompdf->setPaper('A4', 'portrait');
$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("personas_por_distrito.pdf", array("Attachment" => false));
?>
