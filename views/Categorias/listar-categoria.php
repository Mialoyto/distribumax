<?php
require_once '../header.php';
?>
<main>
	<div class="container">
		<div class="card mt-4">
			<div class="card-header">
				<h2>
					<i class="bi bi-clipboard-check fs-2"></i>
					Listado de Categorías
				</h2>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table class="table" id="table-categorias" style="width: 100%;">
						<thead>
							<tr>
								<th>Nombre de Categoría</th>
								<th>Estado</th>
								<th>Acciones</th>
							</tr>
						</thead>
						<tbody>
							<!--Las filas se llenarán aqui-->
						</tbody>
					</table>
				</div>

			</div>
			<div class="card-footer">
				<!-- Botón ubicado dentro del DataTable en la parte inferior derecha -->
				<div class="d-flex justify-content-end mt-3">
					<a href="http://localhost/distribumax/views/marcas/registrar-marca.php" class="btn btn-primary"><i class="bi bi-arrow-left-circle"></i></a>
				</div>
			</div>
		</div>
	</div><!-- Fin del container -->
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/categorias/listar-categoria.js"></script>
</body>

</html>