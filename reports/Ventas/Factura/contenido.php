<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Factura - <?= 'FC-0000' . $ventas[0]['idventa'] ?></title>

    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            width: 100%;
            
        }

        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            background-color: #fff;
            box-sizing: border-box;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #f2f2f2;
            padding-bottom: 10px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: bold;
            margin: 0;
            color: #2c3e50;
        }

        .header h2 {
            font-size: 18px;
            margin: 5px 0;
            color: #7f8c8d;
        }

        .client-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .client-info .col {
            width: 30%;
        }

        .client-info p {
            margin: 3px 0;
            font-size: 12px;
        }

        .table-container {
            width: 100%;
            margin-top: 10px;
            border-collapse: collapse;
        }

        table {
            width: 100%;
            border: 1px solid #ddd;
            margin-top: 10px;
            font-size: 12px;
            border-radius: 5px;
            overflow: hidden;
        }

        th,
        td {
            padding: 8px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #f2f2f2;
            font-weight: bold;
            text-transform: uppercase;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .total {
            text-align: right;
            margin-top: 20px;
            font-size: 14px;
            font-weight: bold;
            color: #2c3e50;
        }

        .total p {
            margin: 5px 0;
        }

        .footer {
            margin-top: 30px;
            font-size: 10px;
            color: #999;
            text-align: center;
            border-top: 1px solid #f2f2f2;
            padding-top: 10px;
        }

        .footer p {
            margin: 0;
        }

        .print-button {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #2980b9;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 14px;
            border-radius: 5px;
            width: 100%;
        }

        .print-button:hover {
            background-color: #3498db;
        }

    </style>

</head>

<body>

    <div class="container">
        <!-- Encabezado con logo a la izquierda -->
        <div class="header">
            <div>
                <h1><?= 'FC-0000' . $ventas[0]['idventa'] ?></h1>
                <p><strong>Fecha:</strong> <?= $ventas[0]['fecha_venta'] ?></p>
            </div>
        </div>

        <!-- Información del cliente (en una sola fila) -->
        <div class="client-info">
            <div class="col">
                <p><strong><?= $ventas[0]['cliente'] === 'Persona' ? 'Nombre Completo:' : 'Razón Social:' ?></strong>  
                    <?= $ventas[0]['nombre_cliente'] ?>
                </p>
            </div>
            <div class="col">
                <p><strong><?= $ventas[0]['cliente'] === 'Persona' ? 'DNI:' : 'RUC:' ?></strong> 
                    <?= $ventas[0]['documento_cliente'] ?>
                </p>
            </div>
            <div class="col">
                <p><strong>Dirección:</strong> <?= $ventas[0]['direccion'] ?></p>
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Cod</th>
                        <th>Producto</th>
                        <th>Cant.</th>
                        <th>UM</th>
                        <th>Precio</th>
                        <th>Des(%)</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    // Iterar sobre los productos de la venta
                    foreach ($ventas as $producto) {
                        echo "<tr>
                                <td>" . $producto['codigo'] . "</td>
                                <td>" . $producto['nombreproducto'] . "</td>
                                <td>" . $producto['cantidad_producto'] . "</td>
                                <td>" . $producto['unidad_medida'] . "</td>
                                <td>" . $producto['precio_unitario'] . "</td>
                                <td>" . $producto['precio_descuento'] . "</td>
                                <td>" . $producto['subtotal'] . "</td>
                            </tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>

        <div class="total">
            <p><strong>Venta:</strong> <?= $ventas[0]['sub_venta'] ?> </p>
            <p><strong>IGV:</strong> <?= $ventas[0]['igv'] ?> </p>
            <p><strong>Total:</strong> <?= $ventas[0]['total_venta'] ?> </p>
        </div>

        <div class="footer">
            <p>Gracias por su compra. DistribuMax - Todos los derechos reservados.</p>
        </div>

    </div>

</body>

</html>
