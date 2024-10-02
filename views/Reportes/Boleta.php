<?php
// Incluir la librería DOMPDF usando Composer
require_once '../../vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

// Crear instancia de DOMPDF y establecer opciones
$options = new Options();
$options->set('isHtml5ParserEnabled', true);
$options->set('isRemoteEnabled', true);

$dompdf = new Dompdf($options);

// Contenido HTML del ticket
$html = '


<div class="ticket">
    <h1>Boleta Electronica</h1>
    <p class="fecha"></p>
    
    <div class="datos">
        <p><strong>Cliente:Nombre de la empresa</strong></p>
        <p><strong>RUC 0 DNI:</strong> Ruc</p>
        <p><strong>Fecha:</strong> ' . date('l, d/M/Y') . '</p>
        <p><strong>Hora:</strong> ' . date('H:i:s') . '</p>
    </div>

    <table>
        <thead>
            <tr>
                <th>Producto</th>
                <th>Cant.</th>
                <th>P. UNIT.</th>
                <th>Importe</th>
            </tr>
        </thead>
        <tbody>
            <tr>                
            </tr>
        </tbody>
    </table>
    
    <table style="margin-top: 10px;">
        <tbody>
            <tr>
                <td>OP. GRAVADAS</td>
                <td class="total">S/ 2.03</td>
            </tr>
            <tr>
                <td>OP. GRATUITAS</td>
                <td class="total">S/ 0.00</td>
            </tr>
            <tr>
                <td>OP. EXONERADAS</td>
                <td class="total">S/ 0.00</td>
            </tr>
            <tr>
                <td>OP. INAFECTAS</td>
                <td class="total">S/ 0.00</td>
            </tr>
            <tr>
                <td>I.G.V</td>
                <td class="total">S/ 0.37</td>
            </tr>
            <tr>
                <td>SUB TOTAL</td>
                <td class="total">S/ 2.03</td>
            </tr>
            <tr>
                <td class="total-final">TOTAL VENTA</td>
                <td class="total-final">S/ 2.40</td>
            </tr>
        </tbody>
    </table>

    <p class="pie">DOS 40/100 PEN</p>
    <p class="pie">VENDEDOR(A): ANDRES P.C.</p>
    <p class="pie">Gracias por su preferencia</p>
</div>
';

// Cargar el HTML a DOMPDF
$dompdf->loadHtml($html);

// Establecer tamaño de papel y orientación
$dompdf->setPaper('A4', 'portrait');  // Cambia a 'landscape' si prefieres horizontal

// Renderizar el PDF
$dompdf->render();

// Enviar el PDF al navegador (puedes cambiar a 'D' para forzar descarga)
$dompdf->stream('factura_venta.pdf', array("Attachment" => false));
?>
