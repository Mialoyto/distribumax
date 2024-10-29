<?php
require '../../vendor/autoload.php';  // Incluye PhpSpreadsheet

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

// Obtener los datos JSON desde el cuerpo de la solicitud POST
$requestPayload = file_get_contents('php://input');
$dataArray = json_decode($requestPayload, true)['data'] ?? null;

if ($dataArray) {
    $spreadsheet = new Spreadsheet();
    $sheet = $spreadsheet->getActiveSheet();

    // Definir encabezados de la hoja
    $sheet->setCellValue('A1', 'Marca');
    $sheet->setCellValue('B1', 'Categoria');
    $sheet->setCellValue('C1', 'Nombre del Producto');
    $sheet->setCellValue('D1', 'Codigo');

    // Llenar los datos en la hoja
    $row = 2;
    foreach ($dataArray as $cliente) {
        $sheet->setCellValue('A' . $row, $cliente['marca']);
        $sheet->setCellValue('B' . $row, $cliente['categoria']);
        $sheet->setCellValue('C' . $row, $cliente['nombreproducto']);
        $sheet->setCellValue('D' . $row, $cliente['codigo']);
        $row++;
    }

    // Configurar encabezados para la descarga de archivo
    header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    header('Content-Disposition: attachment;filename="clientes.xlsx"');
    header('Cache-Control: max-age=0');

    $writer = new Xlsx($spreadsheet);
    $writer->save('php://output');
    exit;
} else {
    echo "No se recibieron datos para exportar.";
}
