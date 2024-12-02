<?php
// Incluir el autoloader de Composer
require_once '../../../vendor/autoload.php';

require_once '../../../model/ventas.php';
require_once '../../../model/metodoP.php';
// Instanciar la clase Ventas
$venta = new Ventas();
$metodo=new MetodoPago();
// Obtener los datos de la venta con el idventa pasado por GET
$ventas = $venta->reporteVenta(['idventa' => $_GET['idventa']]);
$metodos=$metodo->obtenerMetodopago(['idventa' => $_GET['idventa']]);
// Crear una instancia de Dompdf
use Dompdf\Dompdf;
use Dompdf\Options;

// Configurar Dompdf
$options = new Options();
$options->set('isHtml5ParserEnabled', true);  // Habilitar el parser HTML5
$options->set('isPhpEnabled', true);          // Habilitar PHP dentro de HTML (si es necesario)
$options->set('isCssFloatEnabled', true);     // Habilitar flotantes en CSS
$dompdf = new Dompdf($options);

// Iniciar el almacenamiento en búfer
ob_start();

// Incluir el archivo de contenido HTML
require_once './contenido.php';  // Este archivo generará el contenido HTML de la factura

// Capturar el contenido HTML generado
$content = ob_get_clean();

// Cargar el contenido HTML al documento
$dompdf->loadHtml($content);

// (Opcional) Configurar el tamaño de página
$dompdf->setPaper('A4', 'portrait');

// Renderizar el PDF (esto genera el archivo)
$dompdf->render();

// Salida del PDF al navegador
$dompdf->stream("boleta.pdf", array("Attachment" => 0));  // 0 para visualizar, 1 para descargar
?>
