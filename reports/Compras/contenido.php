<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reporte de Compra</title>
    <style>
        body {
    font-family: Arial, sans-serif;
    margin: 20px;
    color: #333;
}

h1 {
    text-align: center;
    font-size: 24px;
    margin-bottom: 30px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

table, th, td {
    border: 1px solid #ddd;
}

th, td {
    padding: 10px;
    text-align: left;
    font-size: 12px;  /* Tamaño de texto de la tabla */
}

th {
    background-color: #f2f2f2;
    font-weight: bold;
}

caption {
    font-weight: bold;
    font-size: 18px;
    text-align: left;
    margin-bottom: 10px;
}

.table-header {
    background-color: #f4f4f4;
    color: #333;
}

.total-row {
    background-color: #f9f9f9;
    font-weight: bold;
}

td {
    vertical-align: middle; /* Alineación vertical de las celdas */
}

tr:nth-child(even) {
    background-color: #f9f9f9;  /* Fila con fondo alternado */
}

tr:hover {
    background-color: #f1f1f1;  /* Fondo cuando el ratón pasa sobre la fila */
}

    </style>
</head>
<body>
    <h1>Reporte de Compra</h1>
    <p><?= $compras[0]['fechaemision'] ?></p>
    <table>
        <caption>Detalle de la Compra</caption>
       
        <thead>
            <tr class="table-header">

                <th>Comprobante</th>
                <th>Proveedor</th>
                <th>Ruc</th>
                <th>Lote</th>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio de Compra</th>
       
            </tr>
        </thead>
        <tbody>
            <?php foreach ($compras as $compra): ?>
                <tr>

                    <td><?= $compra['numcomprobante'] ?></td>
                    <td><?= $compra['proveedor'] ?></td>
                    <td><?= $compra['idempresa'] ?></td>
                    <td><?= $compra['numlote'] ?></td>
                    <td><?= $compra['nombreproducto'] ?></td>
                    <td><?= $compra['cantidad'] ?></td>
                    <td><?= $compra['precio_compra'] ?></td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</body>
</html>
