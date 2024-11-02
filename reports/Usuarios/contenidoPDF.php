<?php
require_once '../../vendor/autoload.php';
require_once '../../model/Usuario.php';
$usuario = new Usuario();

use Dompdf\Dompdf;
use Dompdf\Options;

$options = new Options();
$options->set('defaultFont', 'Arial');
$dompdf = new Dompdf($options);


$usuarios = $usuario ->getAll();



$html = '<h1>Listado de Usuarios</h1>';
$html .= '<table border="1" cellpadding="5" cellspacing="0">';
$html .= '<thead><tr><th>N. Documento</th><th>Nombre Rol</th><th>Nombre Usuario</th></tr></thead>';
$html .= '<tbody>';

foreach ($usuarios as $usuario) {
    $html .= '<tr>';
    $html .= '<td>' . htmlspecialchars($usuario['idpersonanrodoc']) . '</td>';
    $html .= '<td>' . htmlspecialchars($usuario['rol']) . '</td>';
    $html .= '<td>' . htmlspecialchars($usuario['nombre_usuario']) . '</td>';
    $html .= '</tr>';
}

$html .= '</tbody>';
$html .= '</table>';

$dompdf->loadHtml($html);

$dompdf->setPaper('A4', 'portrait');

$dompdf->render();

// Enviar el PDF al navegador
$dompdf->stream("usuarios.pdf", array("Attachment" => false));
