<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
	<div class="container-fluid px-4 mt-4" >
	
			<!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
		</ol>
		<!-- TARJETA -->
		<div class="card mb-4">
			<div class="card-header">
				<div class="d-flex justify-content-between align-items-center">
					<div>
						<i class="bi bi-clipboard-check fs-3 fw-bold"> Listado de Proveedores</i>
					</div>
					<div>
						<a href="<?= $URL . 'reports/Proveedores/contenidoPDF.php' ?>" 
						   type="button" 
						   class="me-2 btn btn-danger" 
						   data-bs-toggle="tooltip" 
						   data-bs-placement="bottom" 
						   data-bs-title="Generar PDF">
							<i class="bi bi-file-earmark-pdf fs-6"></i>
						</a>
					</div>
				</div>
			</div>
			<div class="card-body">
				<div class="table-responsive">
					<table id="table-proveedores" class="table" style="width: 100%;">
						<thead>
							<tr>
								<th>RUC</th>
								<th>Proveedor</th>
								<th>Contacto</th>
								<th>Teléfono</th>
								<th>Correo</th>
								<th>Dirección</th>
								<th>Estado</th>
								<th>Acciones</th>
							</tr>
						</thead>
						<tbody>
							<!-- Las filas se llenarán aquí -->
						</tbody>
					</table>
					<!-- Modal de edición -->
					<div class="modal fade edit-proveedor"
						data-bs-backdrop="static"
						data-bs-keyboard="false"
						tabindex="-1"
						role="dialog"
						aria-labelledby="staticBackdropLabel">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h1 class="modal-title fs-5" id="staticBackdropLabel">Editar Proveedor</h1>
									<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
								</div>
								<form id="form-prov" autocomplete="off" method="POST">
									<div class="modal-body">
										<div class="mb-3">
											<label for="editIdEmpresa" class="form-label">RUC</label>
											<input type="text" id="editIdEmpresa" class="form-control" name="idempresa" disabled>
										</div>
										<div class="mb-3">
											<label for="editProveedor" class="form-label">Proveedor</label>
											<input type="text" id="editProveedor" class="form-control" name="proveedor" required>
										</div>
										<div class="mb-3">
											<label for="editDireccion" class="form-label">Dirección</label>
											<input type="text" id="editDireccion" class="form-control" name="direccion" required>
										</div>
										<div class="mb-3">
											<label for="editCorreo" class="form-label">Correo</label>
											<input type="email" id="editCorreo" class="form-control" name="email" required>
										</div>
										<div class="mb-3">
											<label for="editContacto" class="form-label">Contacto</label>
											<input type="text" id="editContacto" class="form-control" name="contacto_principal" required>
										</div>
										<div class="mb-3">
											<label for="editTelefono" class="form-label">Teléfono</label>
											<input type="text" id="editTelefono" class="form-control" name="telefono_contacto" required>
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
					<a href="registrar.php" class="btn btn-primary">Registrar Proveedor</a>
				</div>
			</div>
		</div>
	</div>
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/proveedor/listar-proveedor.js"></script>
<script src="http://localhost/distribumax/js/proveedor/editar-proveedor.js"></script>
<script src="http://localhost/distribumax/js/proveedor/disabled-proveedor.js"></script>
</body>
</html>
