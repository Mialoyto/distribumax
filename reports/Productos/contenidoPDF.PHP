<?php
require_once '../../vendor/autoload.php';
require_once '../../model/producto.php';

$producto = new Productos();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);

$productos = $producto->getAll();

// Agrupar productos por marca
$productosPorMarca = [];
foreach ($productos as $producto) {
    $productosPorMarca[$producto['marca']][] = $producto;
}

// Función para generar colores únicos para cada marca
function getColorForBrand($brand) {
    $hash = substr(md5($brand), 0, 6);
    return '#' . $hash;
}

// Leer el archivo CSS
$css = file_get_contents('./estilo.html');


$html = '<style>' . $css . '</style>';
$html .= '<h1>Listado de Productos por Marca</h1>';

foreach ($productosPorMarca as $marca => $productos) {
    $color = getColorForBrand($marca);
    
    $html .= '<h2 style="color:' . htmlspecialchars($color) . '; text-align: center;">Marca: ' . htmlspecialchars($marca) . '</h2>';
    $html .= '<table>';
    $html .= '<thead><tr><th>Marca</th><th>Categoria</th><th>Nombre del Producto</th><th>Código</th></tr></thead>';
    $html .= '<tbody>';

    foreach ($productos as $producto) {
        $html .= '<tr style="background-color: ' . htmlspecialchars($color) . '26;">'; // Color con transparencia
        $html .= '<td><b>' . htmlspecialchars($producto['marca']) . '</b></td>';
        $html .= '<td>' . htmlspecialchars($producto['categoria']) . '</td>';
        $html .= '<td>' . htmlspecialchars($producto['nombreproducto']) . '</td>';
        $html .= '<td>' . htmlspecialchars($producto['codigo']) . '</td>';
        $html .= '</tr>';
    }

    $html .= '</tbody>';
    $html .= '</table>';
}

$dompdf->loadHtml($html);
$dompdf->setPaper('A4', 'portrait');
$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("productos.pdf", array("Attachment" => false));
