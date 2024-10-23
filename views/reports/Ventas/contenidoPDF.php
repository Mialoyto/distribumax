<?php
require_once '../../../vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);


$dsn = 'mysql:host=localhost;port=3306;dbname=distribumax;charset=utf8';
$username = 'root';
$password = '';

try {
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Error al conectar a la base de datos: " . $e->getMessage());
}


$query = "CALL sp_listar_ventas";
$stmt = $pdo->prepare($query);
$stmt->execute();
$ventas = $stmt->fetchAll(PDO::FETCH_ASSOC);


$html = '<h1>Listado de Ventas</h1>';
$html .= '<table border="1" cellpadding="5" cellspacing="0">';
$html .= '<thead><tr><th>Pedido</th><th>Tipo de Cliente</th><th>Cliente</th><th>Documento</th><th>Fecha Venta</th><th>Estado</th></tr></thead>';
$html .= '<tbody>';

foreach ($ventas as $venta) {
    $html .= '<tr>';
    $html .= '<td><b>' . htmlspecialchars($venta['idventa']) . '</b></td>';
    $html .= '<td>' . htmlspecialchars($venta['tipo_cliente']) . '</td>';
    $html .= '<td>' . htmlspecialchars($venta['cliente']) . '</td>';
    $html .= '<td>' . htmlspecialchars($venta['idpersona']) . '</td>';
    $html .= '<td>' . htmlspecialchars($venta['fecha_creacion']) . '</td>';
    $html .= '<td>' . htmlspecialchars($venta['estado_cliente']) . '</td>';
    $html .= '</tr>';
}

$html .= '</tbody>';
$html .= '</table>';

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'portrait');

$dompdf->render();

$dompdf->stream("ventas.pdf", array("Attachment" => false));
