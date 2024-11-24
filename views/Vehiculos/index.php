<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
	<div class="container-fluid px-4">
		<h1 class="mt-4">Vehiculos</h1>
		<ol class="breadcrumb mb-4">
			<!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
		</ol>
		<!-- TARJETA -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="d-flex justify-content-between align-items-center">
					<div>
						<i class="bi bi-clipboard-check fs-3 fw-bold"> Listado de Vehiculos</i>
					</div>
					<div>
						<a href=<?= $URL . 'reports/Vehiculos/contenidoPDF.php' ?> type="button" class="me-2 btn btn-danger" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="Generar PDF">
							<i class="bi bi-file-earmark-pdf fs-3"></i>
						</a>
					</div>
				</div>
			</div>
			<div class="card-body">

				<div class="table-responsive">
					<table id="table-vehiculos" class="table" style="width: 100%;">
						<thead>
							<tr>
								<!-- <th>Vehiculo</th> -->
								<th>Conductor</th>
								<th>Marca</th>
								<th>Modelo</th>
								<th>Placa</th>
								<th>Capacidad</th>
								<th>Condicion</th>
								<th>Estado</th>
								<th>Acciones</th>
							</tr>
						</thead>
						<tbody>
							<!-- Las filas se llenarán aquí -->
						</tbody>
					</table>
					<!-- Modal de edición -->
					<div class="modal fade edit-vehiculo"
						data-bs-backdrop="static"
						data-bs-keyboard="false"
						tabindex="-1"
						role="dialog"
						aria-labelledby="staticBackdropLabel">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h1 class="modal-title fs-5" id="staticBackdropLabel">Editar Vehículo</h1>
									<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
								</div>
								<form id="form-veh" autocomplete="off" required method="POST">
									<div class="modal-body">
										<div class="mb-3">
											<label for="editConductor" class="form-label">Conductor</label>
											<input type="text" class="form-control" id="editConductor" name="conductor" disabled>
										</div>
										<div class="mb-3">
											<label for="editMarca" class="form-label">Marca</label>
											<input type="text" class="form-control" id="editMarca" name="marca_vehiculo" required>
										</div>
										<div class="mb-3">
											<label for="editModelo" class="form-label">Modelo</label>
											<input type="text" class="form-control" id="editModelo" name="modelo" required>
										</div>
										<div class="mb-3">
											<label for="editPlaca" class="form-label">Placa</label>
											<input type="text" class="form-control" id="editPlaca" name="placa" required>
										</div>
										<div class="mb-3">
											<label for="editCapacidad" class="form-label">Capacidad</label>
											<input type="number" class="form-control" id="editCapacidad" name="capacidad" required>
										</div>
										<div class="mb-3">
											<label for="editCondicion" class="form-label">Condición</label>
											<select class="form-select" id="editCondicion" name="condicion" required>
												<option value="operativo">Operativo</option>
												<option value="taller">Taller</option>
												<option value="averiado">Averiado</option>
											</select>
										</div>
									</div>
									<div class="modal-footer">
										<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
										<button type="submit" class="btn btn-primary">Guardar cambios</button>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
				<div class="card-footer">
					<a href="registrar.php" class="btn btn-primary">Registrar nuevo Vehiculo</a>
				</div>
			</div>
		</div>
	</div>
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/vehiculos/listar.js"> </script>
<script src="http://localhost/distribumax/js/vehiculos/editar-vehiculo.js"> </script>
<script src="http://localhost/distribumax/js/vehiculos/disabled-vehiculo.js"></script>
</body>

</html>