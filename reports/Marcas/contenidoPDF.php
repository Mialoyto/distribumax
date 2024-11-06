<?php
require_once '../../vendor/autoload.php';
require_once '../../model/Marcas.php';

use Dompdf\Dompdf;
use Dompdf\Options;

// Crear objeto Marca
$marca = new Marca();

// Configuración de Dompdf
$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);

// Obtener todas las marcas
$marcas = $marca->getAll();

// Organizar las marcas por nombre
$MarcasPor = [];
foreach ($marcas as $marca) {
    $MarcasPor[$marca['marca']][] = $marca;
}

// Función para generar un color a partir de la marca
function getColorForBrand($brand) {
    $hash = substr(md5($brand), 0, 6);
    return '#' . $hash;
}

// Leer el archivo CSS
$css = file_get_contents('./estilo.html');

// Crear el contenido HTML para el PDF
$html = '<style>' . $css . '</style>';
$html .= '<h1>Listado de Marcas</h1>';

foreach ($MarcasPor as $marca => $marcas) {
    // Generar color único para cada marca
    $color = getColorForBrand($marca);

    // Agregar título para la marca
    $html .= '<h2 style="color:' . htmlspecialchars($color) . '; text-align: center;">Marca: ' . htmlspecialchars($marca) . '</h2>';
    $html .= '<table>';
    $html .= '<thead><tr><th>Nombre Proveedor</th><th>Contacto Principal</th><th>Marca</th></tr></thead>';
    $html .= '<tbody>';

    // Recorrer proveedores de esta marca
    foreach ($marcas as $marcaDetalle) {
        $html .= '<tr style="background-color: ' . htmlspecialchars($color) . '26;">'; // Color con transparencia
        $html .= '<td><b>' . htmlspecialchars($marcaDetalle['nombre_proveedor']) . '</b></td>';
        $html .= '<td>' . htmlspecialchars($marcaDetalle['contacto_principal']) . '</td>';
        $html .= '<td>' . htmlspecialchars($marcaDetalle['marca']) . '</td>';
        $html .= '</tr>';
    }

    $html .= '</tbody>';
    $html .= '</table>';
}

// Inicializar Dompdf
$dompdf->loadHtml($html);
$dompdf->setPaper('A4', 'portrait');
$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("productos.pdf", array("Attachment" => false));
?>
