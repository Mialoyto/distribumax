<?php
// Aquí puedes agregar funciones adicionales que necesites para manejar el PDF
function enviarPDF($dompdf, $filename) {
    $dompdf->stream($filename, array("Attachment" => false));
}
?>
