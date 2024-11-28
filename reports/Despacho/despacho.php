<?php
// Incluir el autoloader de Composer
require_once '../../vendor/autoload.php';

require_once '../../model/Despacho.php';

// Crear una instancia de Dompdf
use Dompdf\Dompdf;
use Dompdf\Options;

// Instanciar la clase Ventas
$despacho = new Despachos();

// Obtener los datos de la venta con el idventa pasado por GET
$despachos=$despacho->reporte(['iddespacho'=>$_GET['iddespacho']]);


// Configurar Dompdf
$options = new Options();
$options->set('isHtml5ParserEnabled', true);  // Habilitar el parser HTML5
$options->set('isPhpEnabled', true);          // Habilitar PHP dentro de HTML (si es necesario)
$options->set('isCssFloatEnabled', true);     // Habilitar flotantes en CSS
$options->set('isRemoteEnabled', true); // Habilitar imágenes remotas
$options->setChroot(__DIR__); // Establecer el directorio raíz para las imágenes

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
$dompdf->stream("Hojadespacho.pdf", array("Attachment" => 0));  // 0 para visualizar, 1 para descargar
?>
