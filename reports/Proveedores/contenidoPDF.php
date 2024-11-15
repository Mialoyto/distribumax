<?php
require_once '../../vendor/autoload.php';
require_once '../../model/Proveedor.php';

$proveedor = new Proveedor();

use Dompdf\Dompdf;
use Dompdf\Options;

// Configuración de Dompdf
$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);

// Obtener datos de proveedores
$proveedores = $proveedor->getAll();

// Leer el archivo CSS externo y agregar al contenido HTML
$cssFilePath = './estilo.css';
$css = file_exists($cssFilePath) ? file_get_contents($cssFilePath) : '';

// Inicio del contenido HTML
$html = '<style>' . $css . '</style>';
$html .= '<h1 style="text-align: center; color: #333;">Listado de Proveedores</h1>';

// Función para asignar colores únicos a cada proveedor
function getColorForProvider($provider) {
    $hash = substr(md5($provider), 0, 6);
    return '#' . $hash;
}

// Generar una tabla por cada proveedor
foreach ($proveedores as $prov) {
    $color = getColorForProvider($prov['nombre']);
    
    // Encabezado de cada tabla
    $html .= '<h2 style="color:' . htmlspecialchars($color) . '; text-align: center;">Proveedor: ' . htmlspecialchars($prov['nombre']) . '</h2>';
    $html .= '<table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">';
    $html .= '<thead style="background-color:' . htmlspecialchars($color) . '; color: white;">';
    $html .= '<tr>';
    $html .= '<th style="padding: 8px; text-align: left;">RUC</th>';
    $html .= '<th style="padding: 8px; text-align: left;">Contacto</th>';
    $html .= '<th style="padding: 8px; text-align: left;">Teléfono</th>';
    $html .= '<th style="padding: 8px; text-align: left;">Correo</th>';
    $html .= '<th style="padding: 8px; text-align: left;">Dirección</th>';
    $html .= '</tr>';
    $html .= '</thead>';

    // Datos del proveedor
    $html .= '<tbody>';
    $html .= '<tr style="background-color: ' . htmlspecialchars($color) . '26;">';  // Color con transparencia
    $html .= '<td style="padding: 8px;">' . htmlspecialchars($prov['idempresaruc']) . '</td>';
    $html .= '<td style="padding: 8px;">' . htmlspecialchars($prov['contacto_principal']) . '</td>';
    $html .= '<td style="padding: 8px;">' . htmlspecialchars($prov['telefono_contacto']) . '</td>';
    $html .= '<td style="padding: 8px;">' . htmlspecialchars($prov['correo']) . '</td>';
    $html .= '<td style="padding: 8px;">' . htmlspecialchars($prov['direccion']) . '</td>';
    $html .= '</tr>';
    $html .= '</tbody>';
    $html .= '</table>';
}

// Renderizar el PDF
$dompdf->loadHtml($html);
$dompdf->setPaper('A4', 'portrait');
$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("proveedores.pdf", array("Attachment" => false));
