<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= $ventas[0]['numero_comprobante'] ?></title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            margin: 0;
            padding: 0;
            width: 100%;
        }

        .ticket {
            width: 240px;
            margin: 0 auto;
            padding: 10px;
            border: 1px solid #000;
            background-color: #fff;
            font-size: 12px;
            box-sizing: border-box;
            text-align: center;
        }

        .ticket-header {
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px dashed #000;
        }

        .ticket-header h1 {
            font-size: 18px;
            margin: 0;
            text-transform: uppercase;
        }

        .ticket-header img {
            max-width: 80px;
            margin-bottom: 5px;
        }

        .ticket-header p {
            margin: 3px 0;
            font-size: 12px;
        }

        .ticket-section {
            margin-bottom: 10px;
            text-align: left;
        }

        .ticket-section p {
            margin: 3px 0;
            font-size: 11px;
        }

        .ticket-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            text-align: left;
        }

        .ticket-table th,
        .ticket-table td {
            padding: 4px 2px;
            border-bottom: 1px dashed #000;
        }

        .ticket-table th {
            font-size: 10px;
            text-transform: uppercase;
            background-color: #f9f9f9;
        }

        .ticket-table .product-name {
            border-bottom: none;
            font-weight: bold;
            text-align: left;
        }

        .ticket-total {
            text-align: right;
            margin-top: 10px;
            font-size: 12px;
        }

        .ticket-total p {
            margin: 1px 0;
            font-weight: bold;
        }

        .ticket-footer {
            border-top: 1px dashed #000;
            padding-top: 5px;
            margin-top: 10px;
            font-size: 10px;
        }

        .ticket-footer p {
            margin: 2px 0;
        }

        .payment-section,
        .delivery-section {
            text-align: left;
            font-size: 11px;
            margin-top: 10px;
        }

        .payment-section p,
        .delivery-section p {
            margin: 2px 0;
        }

        .highlight {
            font-weight: bold;
            text-transform: uppercase;
        }
    </style>
</head>

<body>
    <div class="ticket">
        <!-- Encabezado -->
        <div class="ticket-header">
            <img src="<?= $host ?>/img/logo2.png" alt="Logo Empresa">
            <h1>DistribuMax</h1>
            <p><strong><?= $ventas[0]['numero_comprobante'] ?></strong></p>
            <p>Fecha: <?= $ventas[0]['fecha_venta'] ?></p>
        </div>

        <!-- Datos del cliente -->
        <div class="ticket-section">
            <p><strong><?= $ventas[0]['tipo_cliente'] === 'Persona' ? 'Cliente:' : 'Razón Social:' ?></strong> <?= $ventas[0]['nombre_cliente'] ?></p>
            <p><strong><?= $ventas[0]['tipo_cliente'] === 'Persona' ? 'DNI:' : 'RUC:' ?></strong> <?= $ventas[0]['documento_cliente'] ?></p>
            <p><strong>Dirección:</strong> <?= $ventas[0]['direccion'] ?></p>
        </div>

        <!-- Método de pago -->
        <div class="payment-section">
        <p><strong>Metodo(s) de pago:</strong></p>
        <?php foreach ($metodos as $metodo) { ?>
                   
                  <p><?=$metodo['metodopago']?> <strong><?=$metodo['monto']?></strong></p> 
        <?php } ?>
        </div>

        <!-- Detalles de productos -->
        <table class="ticket-table">
            <thead>
                <tr></tr>
            </thead>
            <tbody>
                <?php foreach ($ventas as $producto) { ?>
                    <tr class="product-name">
                        <!-- Nombre del producto -->
                        <td colspan="5"><?= $producto['nombreproducto'] ?></td>
                    </tr>
                    <tr>
                        <!-- Código, cantidad, precio y subtotal -->
                        <td><?= $producto['codigo'] ?></td>
                        <td><?= $producto['cantidad_producto'] ?></td>
                        <td><?= $producto['precio_unitario'] ?></td>
                        <td><?= $producto['subtotal'] ?></td>
                    </tr>
                <?php } ?>
            </tbody>
        </table>

        <!-- Totales -->
        <div class="ticket-total">
            <p><strong>Subtotal:</strong> S/ <?= $ventas[0]['sub_venta'] ?></p>
            <p><strong>IGV (18%):</strong> S/ <?= $ventas[0]['igv'] ?></p>
            <p><strong>Total:</strong> S/ <?= $ventas[0]['total_venta'] ?></p>
        </div>

        <!-- Datos de entrega -->
        <div class="delivery-section">
            <p><strong>Conductor:</strong><?=$ventas[0]['chofer']?></p>
            <p><strong>Vehículo:</strong> <?= $ventas[0]['marca_vehiculo'] ?></p>
            <p><strong>Placa:</strong> <?= $ventas[0]['placa'] ?></p>
        </div>

        <!-- Pie de página -->
        <div class="ticket-footer">
            <p>¡Gracias por su compra!</p>
            <p>DistribuMax - Todos los derechos reservados</p>
        </div>
    </div>
</body>

</html>
