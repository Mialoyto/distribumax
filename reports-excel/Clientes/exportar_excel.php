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
    $sheet->setCellValue('A1', 'ID Cliente');
    $sheet->setCellValue('B1', 'Tipo de Cliente');
    $sheet->setCellValue('C1', 'Cliente');
    $sheet->setCellValue('D1', 'Fecha de Creación');
    $sheet->setCellValue('E1', 'Estado');

    // Llenar los datos en la hoja
    $row = 2;
    foreach ($dataArray as $cliente) {
        $sheet->setCellValue('A' . $row, $cliente['idcliente']);
        $sheet->setCellValue('B' . $row, $cliente['tipo_cliente']);
        $sheet->setCellValue('C' . $row, $cliente['cliente']);
        $sheet->setCellValue('D' . $row, $cliente['fecha_creacion']);
        $sheet->setCellValue('E' . $row, $cliente['estado_cliente'] == '1' ? 'Activo' : 'Inactivo');
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
