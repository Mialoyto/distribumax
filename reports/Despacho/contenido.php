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
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
		@page {
			margin: 0.3cm;
		}

		body {
			font-family: Arial, sans-serif;
			margin: 20px;
			color: #333;
		}

		.h1 {
			text-align: center;
			margin-bottom: 30px;
			color: #2c3e50;
		}

		/* Agregar al bloque de estilos existente */
		table {
			width: 100%;
			margin-bottom: 20px;
			font-size: 11px;
			/* Tamaño base para toda la tabla */
		}

		th {
			background-color: #f4f4f4;
			font-weight: bold;
			text-align: left;
			padding: 6px;
			border: 1px solid #ddd;
			font-size: 12px;
			/* Tamaño para encabezados */
		}

		td {
			padding: 6px;
			border: 1px solid #ddd;
			font-size: 12px;
			/* Tamaño más pequeño para el contenido */
		}

		/* Mantener los anchos de columna */
		th:nth-child(1),
		td:nth-child(1) {
			width: 15%;
		}

		th:nth-child(2),
		td:nth-child(2) {
			width: 45%;
		}

		th:nth-child(3),
		td:nth-child(3) {
			width: 20%;
		}

		th:nth-child(4),
		td:nth-child(4) {
			width: 10%;
		}

		th:nth-child(5),
		td:nth-child(5) {
			width: 10%;
		}

		/* Cantidad */
		caption {
			font-weight: bold;
			font-size: 18px;
			text-align: left;
			margin-bottom: 10px;
		}

		.footer {
			text-align: center;
			margin-top: 30px;
			font-size: 12px;
			color: #666;
		}

		/* Agregar estos estilos al bloque style existente */
		.logo {
			max-width: 200px;
			/* Ajusta el tamaño según necesites */
			height: auto;
			margin: 20px 0;
			display: block;
		}

		/* Para alinear logo y título */
		.header-container {
			text-align: center;
		}
	</style>
</head>

<body>
	<div class="container">
		<div class="row align-items-start">
			<img src="http://localhost/distribumax/img/logo2.png" alt="Logo Empresa" style="width:100px;" class="logo">
			<h1 class="h1">
				Reporte de Despacho
			</h1>
		</div>



		<!-- Información -->
		<div class="row mb-1">
			<div class="col-md-12">
				<div class="p-3 bg-white rounded shadow-sm">
					<h5 class="border-bottom pb-2 mb-3">Datos del Vehículo</h5>
					<div class="d-flex flex-wrap">
						<div class="me-4">
							<p class="mb-1"><strong>Conductor:</strong> <?= $despachos[0]['datos'] ?></p>
						</div>
						<div class="me-4">
							<p class="mb-1"><strong>Placa:</strong> <?= $despachos[0]['placa'] ?></p>
						</div>
						<div class="me-4">
							<p class="mb-1"><strong>Modelo:</strong> <?= $despachos[0]['modelo'] ?></p>
						</div>
						<div>
							<p class="mb-0"><strong>Marca:</strong> <?= $despachos[0]['marca_vehiculo'] ?></p>
						</div>
					</div>
				</div>
			</div>
		</div>


		<!-- Tablas por proveedor -->
		<?php foreach ($agrupados as $proveedor => $marcas): ?>
			<h6>Proveedor: <?= ($proveedor) ?></h6>
			<div></div>
			<table>

				<thead>
					<tr>
						<th>Código</th>
						<th>Producto</th>
						<th>Marca</th>
						<th>Unidad M.</th>
						<th>Cantidad</th>
					</tr>
				</thead>
				<tbody>
					<?php foreach ($marcas as $producto): ?>
						<tr>
							<td><?= ($producto['codigo']) ?></td>
							<td><?= ($producto['nombreproducto']) ?></td>
							<td><?= ($producto['marca']) ?></td>
							<td><?= ($producto['unidadmedida']) ?></td>
							<td><?= ($producto['total']) ?></td>
						</tr>
					<?php endforeach; ?>
				</tbody>
			</table>
		<?php endforeach; ?>


		<!-- Footer -->
		<div class="container-fluid fixed-bottom bg-light py-3 border-top">
			<div class="text-center text-muted">
				<small>DistribuMax - Todos los derechos reservados.</small>
			</div>
		</div>
	</div>
</body>

</html>