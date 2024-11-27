<?php $host = "http://localhost/distribumax";?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?=$ventas[0]['numero_comprobante'] ?></title>

    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            color: #333;
        }

        .container {
            width: 80%;
            margin: 30px auto;
            padding: 20px;
            background: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .header h1 {
            font-size: 24px;
            color: #007bff;
            margin: 0;
        }

        .header p {
            margin: 0;
            font-size: 14px;
            color: #555;
        }

        .client-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            font-size: 14px;
        }

        .client-info .col {
            flex: 1;
            margin-right: 10px;
        }

        .client-info p {
            margin: 5px 0;
        }

        .table-container {
            width: 100%;
            margin-top: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th {
            background-color: #007bff;
            color: white;
            text-transform: uppercase;
            font-weight: bold;
            padding: 8px;
        }

        td {
            padding: 8px;
            text-align: center;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .total {
            text-align: right;
            margin-top: 20px;
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }

        .total p {
            margin: 5px 0;
        }

        .footer {
            margin-top: 30px;
            font-size: 12px;
            text-align: center;
            color: #999;
            border-top: 1px solid #ddd;
            padding-top: 10px;
        }
    </style>
</head>

<body>
    <div class="container">
        <!-- Encabezado -->
        <div class="header">
            <div>
                <!-- <img src="../../../img/logo2.png" alt="Logo Empresa" style="max-height: 60px;"> -->
                <img src="<?=$host?>/img/logo2.png" alt="">
            </div>
            <div>
                <h1><?=$ventas[0]['numero_comprobante'] ?></h1>
                <p><strong>Fecha:</strong> <?= $ventas[0]['fecha_venta'] ?></p>
            </div>
        </div>

        <!-- Información del cliente -->
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

        <!-- Tabla de productos -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>UM</th>
                        <th>Precio</th>
                        <th>Descuento (%)</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    foreach ($ventas as $producto) {
                        echo "<tr>
                                <td>" . $producto['codigo'] . "</td>
                                <td>" . $producto['nombreproducto'] . "</td>
                                <td>" . $producto['cantidad_producto'] . "</td>
                                <td>" . $producto['unidad_medida'] . "</td>
                                <td>S/ " . $producto['precio_unitario'] . "</td>
                                <td>" . $producto['precio_descuento'] . "%</td>
                                <td>S/ " . $producto['subtotal'] . "</td>
                            </tr>";
                    }
                    ?>
                </tbody>
            </table>
        </div>

        <!-- Totales -->
        <div class="total">
            <p><strong>Subtotal:</strong> S/ <?= $ventas[0]['sub_venta'] ?></p>
            <p><strong>IGV (18%):</strong> S/ <?= $ventas[0]['igv'] ?></p>
            <p><strong>Total:</strong> S/ <?= $ventas[0]['total_venta'] ?></p>
        </div>

        <!-- Pie de página -->
        <div class="footer">
            <p>Gracias por su compra. DistribuMax - Todos los derechos reservados.</p>
        </div>
    </div>
</body>

</html>
