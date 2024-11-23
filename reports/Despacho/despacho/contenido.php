<?php

// Agrupar los datos por proveedor y luego por marca
$agrupados = [];
foreach ($despachos as $item) {
    $proveedor = $item['proveedor'];
   

    // Inicializar el proveedor y la marca si no existen
    if (!isset($agrupados[$proveedor])) {
        $agrupados[$proveedor] = [];
    }
   

    // Añadir el producto a la marca
    $agrupados[$proveedor][] = $item;
}
?>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <title>Reporte de Despacho</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; color: #333; }
        h1 { text-align: center; margin-bottom: 30px; color: #2c3e50; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f4f4f4; }
        caption { font-weight: bold; font-size: 18px; text-align: left; margin-bottom: 10px; }
        .footer { text-align: center; margin-top: 30px; font-size: 12px; color: #666; }
    </style>
</head>

<body>
    <h1>Reporte de Despacho</h1>
     <header>fecha</header>
     <p><strong>Conductor:</strong> <?=$despachos[0]['datos']?></p>
     <p><strong>Datos Vehiculo:</strong></p>
     <p><?=$despachos[0]['placa']?> / <?=$despachos[0]['modelo']?> / <?=$despachos[0]['marca_vehiculo']?> </p>
    <?php foreach ($agrupados as $proveedor => $marcas): ?>
        <h2>Proveedor: <?=($proveedor) ?></h2>
            <table>
            
                <thead>
                    <tr>
                        <th>Marca</th>
                        <th>Producto</th>
                        <th>Unidad M.</th>
                        <th>Código</th>
                        <th>Cantidad</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($marcas as $producto): ?>
                        <tr>
                            <td><?= ($producto['marca']) ?></td>
                            <td><?= ($producto['nombreproducto']) ?></td>
                            <td><?= ($producto['unidadmedida']) ?></td>
                            <td><?= ($producto['codigo']) ?></td>
                            <td><?= ($producto['total']) ?></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        <?php endforeach; ?>


    <div class="footer">
        <p>DistribuMax - Todos los derechos reservados.</p>
    </div>
</body>

</html>
