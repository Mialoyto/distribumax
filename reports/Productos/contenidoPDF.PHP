<?php
require_once '../../vendor/autoload.php';
require_once '../../model/producto.php';
$producto = new Productos();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);


$productos = $producto ->getAll();



$html = '<h1>Listado de Producos</h1>';
$html .= '<table border="1" cellpadding="5" cellspacing="0">';
$html .= '<thead><tr><th>Marca</th><th>Categoria</th><th>Nombre del Producto</th><th>Código</th></tr></thead>';
$html .= '<tbody>';

foreach ($productos as $producto) {
    $html .= '<tr>';
    $html .= '<td><b>' . htmlspecialchars($producto['marca']) . '</b></td>';
    $html .= '<td>' . htmlspecialchars($producto['categoria']) . '</td>';
    $html .= '<td>' . htmlspecialchars($producto['nombreproducto']) . '</td>';
    $html .= '<td>' . htmlspecialchars($producto['codigo']) . '</td>';
    $html .= '</tr>';
}

$html .= '</tbody>';
$html .= '</table>';

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'portrait');

$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("productos.pdf", array("Attachment" => false));
