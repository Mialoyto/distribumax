<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Compra</title>
    <style>
        body {
            font-family: 'Verdana', sans-serif;
            margin: 30px;
        }
        h1 {
            text-align: center;
            font-size: 22px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #444;
        }
        .info-container {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 20px;
        }
        .info-item {
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #ddd;
            text-transform: uppercase;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .total-row {
            font-weight: bold;
        }
        .total-cell {
            font-size: 16px;
            background-color: #ddd;
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>Reporte de Compra</h1>
    <div class="info-container">
        <div class="info-item">Proveedor: <?= $compras[0]['proveedor'] ?></div>
        <div class="info-item">Empresa: <?= $compras[0]['idempresa'] ?></div>
        <div class="info-item">Fecha de Emisión: <?= $compras[0]['fechaemision'] ?></div>
    </div>
    <table>
        <thead>
            <tr>
                <th>Lote</th>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio</th>
                <th>Subtotal</th>
            </tr>
        </thead>
        <tbody>
            <?php $total = 0; foreach ($compras as $compra): $subtotal = $compra['cantidad'] * $compra['precio_compra']; $total += $subtotal; ?>
            <tr>
                <td><?= $compra['numlote'] ?></td>
                <td><?= $compra['nombreproducto'] ?></td>
                <td><?= $compra['cantidad'] ?></td>
                <td><?= number_format($compra['precio_compra'], 2) ?></td>
                <td><?= number_format($subtotal, 2) ?></td>
            </tr>
            <?php endforeach; ?>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="4" class="total-row">Total General</td>
                <td class="total-cell"><?= number_format($total, 2) ?></td>
            </tr>
        </tfoot>
    </table>
</body>
</html>
