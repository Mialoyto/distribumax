<?php
// Incluir la librería DOMPDF usando Composer
require_once '../../vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

// Crear instancia de DOMPDF y establecer opciones
$options = new Options();
$options->set('isHtml5ParserEnabled', true);  // Soporte para HTML5
$options->set('isRemoteEnabled', true);  // Permitir cargar imágenes remotas

$dompdf = new Dompdf($options);

// Contenido HTML del reporte
$html = '
<style>
    h1 { text-align: center; color: #333; }
    table {
        width: 100%;
        border-collapse: collapse;
    }
    table, th, td {
        border: 1px solid black;
    }
    th, td {
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #f2f2f2;
    }
</style>
<h1>Reporte de Ventas</h1>
<p>Fecha: ' . date('Y-m-d') . '</p>
<table>
    <tr>
        <th>Producto</th>
        <th>Cantidad</th>
        <th>Precio Unitario</th>
        <th>Total</th>
    </tr>
    <tr>
        <td>Producto A</td>
        <td>10</td>
        <td>$15.00</td>
        <td>$150.00</td>
    </tr>
    <tr>
        <td>Producto B</td>
        <td>5</td>
        <td>$20.00</td>
        <td>$100.00</td>
    </tr>
    <tr>
        <td>Producto C</td>
        <td>3</td>
        <td>$30.00</td>
        <td>$90.00</td>
    </tr>
    <tr>
        <th colspan="3">Total General</th>
        <th>$340.00</th>
    </tr>
</table>
<p>Reporte generado automáticamente.</p>
';

// Cargar el HTML a DOMPDF
$dompdf->loadHtml($html);

// Establecer tamaño de papel y orientación
$dompdf->setPaper('A4', 'portrait');  // Cambia a 'landscape' si prefieres horizontal

// Renderizar el PDF
$dompdf->render();

// Enviar el PDF al navegador (puedes cambiar a 'D' para forzar descarga)
$dompdf->stream('reporte_ventas.pdf', array("Attachment" => false));
?>
