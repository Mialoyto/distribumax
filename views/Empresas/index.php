<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Empresas</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>
    <!-- Tarjeta de Listado de Empresas -->
    <div class="card mb-4">
      <div class="card-hader">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <i class="fas fa-table me-1 fa-lg"></i> Listado de Empresas
        </div>
        <div>
						<a href="<?= $URL . 'reports/Proveedores/contenidoPDF.php' ?>" 
						   type="button" 
						   class="me-2 btn btn-danger" 
						   data-bs-toggle="tooltip" 
						   data-bs-placement="bottom" 
               data-bs-title="Generar PDF">
               <i class="bi bi-file-earmark-pdf fs-3"></i>
            </a>
          </div>
      </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
        <table id="table-empresas" class="table" style="width: 100%;">
          <thead>
            <tr>
              <th>Razón Social</th>
              <th>Dirección</th>
              <th>Email</th>
              <th>Teléfono</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <!-- Las filas se llenarán aquí dinámicamente -->
          </tbody>
</table>
<!-- Modal para la edición de la empresa -->
 <div class="modal fade edit-empresa"
 data-bs-backdrop="static"
 data-bs-keyboard="false"
 tabindex="-1"
 role="dialog"
 aria-labelledby="staticBackdropLabel">
 <div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header">
      <h1 class="modal-title fs-5" id="staticBackdropLabel">EDITAR EMPRESA</h1>
      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>

<!--DATOS EN EL FORMULARIO-->
    <form id="form-emp" autocomplete="off" method="POST">
      <div class="modal-body">

        <div class="mb-3">
        <label for="razonsocial" class="form-label">Razon Social</label>
        <input type="text" id="editRazonSocial" name="razonsocial" class="form-control" required>
        </div>

        <div class="mb-3">
        <label for="direccion" class="form-label">Dirección</label>
        <input type="text" id="editDireccion" name="direccion" class="form-control" required>
        </div>

        <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="text" id="editEmail" name="email" class="form-control" required>
        </div>

        <div class="mb-3">
        <label for="telefono" class="form-label">Telefono</label>
        <input type="number" id="editTelefono" name="telefono" class="form-control" required>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
      </div>
    </form>
  </div>
 </div>
 </div>
</div>
<div class="card-footer">
  <a href="registrar.php" class="btn btn-primary">Registrar Empresa</a>
</div>
</div>
</div>
  </div>
</main>
<?php require_once '../footer.php'; ?>
<!-- Archivo JavaScript que controla la funcionalidad de listado y exportación de empresas -->
<script src="http://localhost/distribumax/js/empresas/listar.js"></script>
<script src="http://localhost/distribumax/js/empresas/editar-empresa.js"></script>
<script src="http://localhost/distribumax/js/empresas/disabled-empresa.js"></script>
</body>
</html>
