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
	<title>Hoja de Carga</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<style>
		@page {
			margin: 0.3cm;
		}

		body {
			font-family: Arial, sans-serif;
			margin: 20px;
			color: #333;
		}.parrafo{
			font-size: 14px;
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

		/* Estilo específico para las tablas de despacho */
		#tabla-despacho th {
			background-color: #f4f4f4;
			font-weight: bold;
			text-align: left;
			padding: 6px;
			border: 1px solid #ddd;
			font-size: 12px;
			/* Tamaño para encabezados */
		}

		#tabla-despacho td {
			padding: 6px;
			border: 1px solid #ddd;
			font-size: 12px;
			/* Tamaño más pequeño para el contenido */
		}

		/* Mantener los anchos de columna */
		#tabla-despacho th:nth-child(1),
		#tabla-despacho td:nth-child(1) {
			width: 15%;
		}

		#tabla-despacho th:nth-child(2),
		#tabla-despacho td:nth-child(2) {
			width: 45%;
		}

		#tabla-despacho th:nth-child(3),
		#tabla-despacho td:nth-child(3) {
			width: 20%;
		}

		#tabla-despacho th:nth-child(4),
		#tabla-despacho td:nth-child(4) {
			width: 10%;
		}

		#tabla-despacho th:nth-child(5),
		#tabla-despacho td:nth-child(5) {
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
		<h1>Hoja de carga  </h1> 
	      <span><?php echo date("Y:m:d");?></span>
		<img src="http://localhost/distribumax/img/logo2.png" alt="Logo Empresa" style="width:100px;" class="logo">
		
	</div>

	<div class="container">
		<div class="row justify-content-center">
			<div class="col-md-8">
				<div class="p-3 bg-white rounded shadow-sm">
					<!-- Información de la hoja de carga -->
					<table class="table  ">
						<thead></thead>
						<tbody>
							<tr>
								<!-- Quiero que cada dato este en un columa  -->
								<td>
									<p class="mb-1 parrafo"><strong>Programado:</strong> </p>
									<p><?=$despachos[0]['fecha_venta']?></p>
								</td>
								<td>
									<p class="mb-1"><strong>Despacho:</strong> </p>
									<p><?= $despachos[0]['fecha_despacho'] ?></p>
								</td>
								<td>
									<p class="mb-1"><strong>Placa:</p>
									<p></strong> <?= $despachos[0]['placa'] ?></p>
								</td>
								<td>
									<p class="mb-1"><strong>Marca:</p>
									<p></strong> <?= $despachos[0]['marca_vehiculo'] ?></p>
								</td>




							</tr>
							<tr>
								<td>
									<p class="mb-1"><strong>Jefe de reparto:</p>
									<p></strong> <?= $despachos[0]['datos'] ?></p>
								</td>
								<td>
									<p class="mb-1"><strong>DNI:</strong> </p>
									<p><?= $despachos[0]['idpersonanrodoc'] ?></p>
								</td>
								<td>
									<p class="mb-1"><strong>Placa:</p>
									</strong> <?= $despachos[0]['placa'] ?>
								</td>
								<td>
									<p class="mb-1"><strong>Encargado de Mercaderia:</strong></p>
									<p><?= $despachos[0]['encargado_mercaderia'] ?></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- Tablas por proveedor -->
	<?php foreach ($agrupados as $proveedor => $marcas): ?>
		<h6>Proveedor: <?=$marcas[0]['idempresa']?> - <?= ($proveedor) ?></h6>
		<div></div>
		<table id="tabla-despacho">
			<thead>
				<tr>
					<th id="codigo">Código</th>
					<th id="producto">Producto</th>
					<th id="marca">Marca</th>
					<th id="unidad">Unidad M.</th>
					<th id="cantidad">Cantidad</th>
				</tr>
			</thead>
			<tbody>
				<?php foreach ($marcas as $producto): ?>
					<tr>
						<td id="codigo"><?= ($producto['codigo']) ?></td>
						<td id="producto"><?= ($producto['nombreproducto']) ?></td>
						<td id="marca"><?= ($producto['marca']) ?></td>
						<td id="unidad"><?= ($producto['unidadmedida']) ?></td>
						<td id="cantidad"><?= ($producto['total']) ?></td>
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
</body>

</html>