<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>

<main>
  <div class="container-fluid px-4 mt-4">
    <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    <ol class="breadcrumb mb-4">
      <!-- Opcional: Agregar breadcrumbs -->
    </ol>

    <!-- Tarjeta de Listado de Empresas -->
    <div class="card mb-4">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <i class="bi bi-clipboard-check fs-3 fw-bold">Listado de Empresas</i>
          </div>
          <div>
            <a href="<?= $URL . 'reports/Empresas/contenidoPDF.php' ?>" 
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
          <table id="table-empresas" class="table" style="width: 100%;">
            <thead>
              <tr>
                <th>Razón Social</th>
                <th>Dirección</th>
                <th>Email</th>
                <th>Teléfono</th>
                <th>Estado</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <!-- Las filas se llenarán aquí dinámicamente -->
            </tbody>
          </table>
        </div>
      </div>

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
              <h1 class="modal-title fs-5" id="staticBackdropLabel">Editar Empresa</h1>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <!-- Datos en el formulario -->
            <form id="form-emp" autocomplete="off" method="POST">
              <div class="modal-body">
                <div class="mb-3">
                  <label for="razonsocial" class="form-label">Razón Social</label>
                  <input type="text" id="editRazonSocial" name="razonsocial" class="form-control" disabled>
                </div>

                <div class="mb-3">
                  <label for="direccion" class="form-label">Dirección</label>
                  <input type="text" id="editDireccion" name="direccion" class="form-control" required>
                </div>

                <div class="mb-3">
                  <label for="email" class="form-label">Email</label>
                  <input type="email" id="editEmail" name="email" class="form-control" required>
                </div>

                <div class="mb-3">
                  <label for="telefono" class="form-label">Teléfono</label>
                  <input type="tel" id="editTelefono" name="telefono" class="form-control" maxlength="9" required>
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

      <div class="card-footer">
        <a href="registrar.php" class="btn btn-primary">Registrar Empresa</a>
      </div>
    </div>
  </div>
</main>

<?php require_once '../footer.php'; ?>

<!-- Archivos JavaScript para funcionalidades -->
<script src="http://localhost/distribumax/js/empresas/listar.js"></script>
<script src="http://localhost/distribumax/js/empresas/editar-empresa.js"></script>
<script src="http://localhost/distribumax/js/empresas/disabled-empresa.js"></script>
</body>
</html>
