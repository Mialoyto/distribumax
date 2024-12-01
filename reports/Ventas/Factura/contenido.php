<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <title><?= $ventas[0]['numero_comprobante'] ?></title>

    <style>
        body {
            font-family: 'Courier New', monospace; /* Tipo de letra ideal para tickets */
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
        }

        .ticket-header h1 {
            font-size: 18px;
            margin: 0;
            text-transform: uppercase;
        }

        .ticket-header p {
            margin: 3px 0;
        }

        .ticket-section {
            margin-bottom: 10px;
            text-align: left;
        }

        .ticket-section p {
            margin: 3px 0;
            font-size: 11px;
        }

        .ticket-section strong {
            display: inline-block;
            width: 80px;
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
            background-color: #f9f9f9;
            font-size: 10px;
            text-transform: uppercase;
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
        <div class="row align-items-start">
			<img src="https://i.ibb.co/zrNYCfL/logo2.png" alt="Logo Empresa" style="width:100px;">
			<h1 class="h1">
				DISTRIBUMAX
			</h1>
		</div>
            <p><strong><h1><?= $ventas[0]['numero_comprobante'] ?></h1></strong> </p>
            <p><strong>Fecha:</strong> <?= $ventas[0]['fecha_venta'] ?></p>
        </div>

        <!-- Datos del cliente -->
        <div class="ticket-section">
            <p><strong><?= $ventas[0]['tipo_cliente'] === 'Persona' ? 'Cliente:' : 'Razón Social:' ?></strong> <?= $ventas[0]['nombre_cliente'] ?></p>
            <p><strong><?= $ventas[0]['tipo_cliente'] === 'Persona' ? 'DNI:' : 'RUC:' ?></strong> <?= $ventas[0]['documento_cliente'] ?></p>
            <p><strong>Dirección:</strong> <?= $ventas[0]['direccion'] ?></p>
       
        </div>
 
        <!-- Detalles de productos -->
        <table class="ticket-table">
            <thead>
                <tr>
                    <th></th>
                
                   <th></th>
                    <th></th>
                    <th></th>
                  
                 
                </tr>
            </thead>
            <tbody>
                <?php
                foreach ($ventas as $producto) {
                    echo "<tr>
                            <td>" . $producto['nombreproducto'] . "</td>
                              <td>" . $producto['codigo']. " </td>
                              <td>" . $producto['cantidad_producto']. " </td>
                              <td>" . $producto['precio_unitario']. " </td>
                               <td>" . $producto['subtotal']. " </td>
                       
                          </tr>";
                }
                ?>
            </tbody>
        </table>

        <!-- Totales -->
        <div class="ticket-total">
            <p>Subtotal:</span> S/ <?=$ventas[0]['sub_venta'] ?></p>
            <p>IGV:</span> S/ <?= $ventas[0]['igv'] ?></p>
            <p>Total:</span> S/ <?= $ventas[0]['total_venta'] ?></p>
        </div>
        

        <!-- Footer -->
        <div class="ticket-footer">

        <div>
            <h5>Datos entrega</h5>
            <p>Vendedor:</p>
            <p>Vehiculo: <?=$ventas[0]['marca_vehiculo']?></p>
            <p>Placa: <?=$ventas[0]['placa']?></p>
        </div>

            <p>¡Gracias por su compra!</p>
            <p>DistribuMax - Todos los derechos reservados</p>
        </div>
        
    </div>
</body>

</html>
