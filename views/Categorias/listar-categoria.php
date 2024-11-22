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

				<!-- MODAL -->
				<div class="modal fade" id="edit-categoria"
					data-bs-backdrop="static"
					data-bs-keyboard="false"
					tabindex="-1"
					aria-labelledby="staticBackdropLabel"
					aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h1 class="modal-title fs-5" id="staticBackdropLabel">EDITAR CATEGORIA</h1>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>
							<form class="edit-categoria" autocomplete="off">
								<div class="modal-body">
									<div class="form-floating mb-3">
										<input type="text" id="id-categoria" name="edit-categoria" class="form-control edit-categoria" placeholder="Ej. Alimentos" autocomplete="off" required>
										<label for="categoria" class="form-label">
											<i class="bi bi-tag"></i>
											Categoría
										</label>
									</div>
								</div>
								<div class="modal-footer">
									<button type="submit" class="btn btn-success">Registrar</button>
									<button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
								</div>
							</form>
						</div>
					</div>
				</div>
				<!-- FIN DEL MODAL -->
			</div>
			<div class="card-footer">
				<!-- Botón ubicado dentro del DataTable en la parte inferior derecha -->
				<div class="mt-3 text-end">
					<a href="http://localhost/distribumax/views/marcas/registrar-marca.php" class="btn btn-primary"><i class="bi bi-arrow-left-circle"></i></a>
				</div>
			</div>
		</div>
	</div><!-- Fin del container -->
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/categorias/listar-categoria.js"></script>
<script src="http://localhost/distribumax/js/categorias/editar-categoria.js"></script>
<script src="http://localhost/distribumax/js/categorias/disabled-categoria.js"></script>
</body>

</html>