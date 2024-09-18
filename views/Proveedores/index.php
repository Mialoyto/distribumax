<?php
require_once '../../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Proveedores</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de Proveedores
      </div>
      <div class="card-body">
        <div class="modal fade" id="actualizarProveedorModal" tabindex="-1" aria-labelledby="actualizarProveedorModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-lg">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="actualizarProveedorModalLabel">Actualizar Proveedor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <!-- Formulario de Actualización de Proveedor dentro del modal -->
                <form method="POST" action="#" id="form-actualizar-proveedor">
                  <input type="hidden" id="idproveedor_update" name="idproveedor">

                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <label for="idempresa_update" class="form-label">Empresa</label>
                      <select class="form-control" id="idempresa_update" name="idempresa" required>
                        <option value="">Seleccione una empresa</option>
                        <!-- Las opciones se cargarán dinámicamente con JavaScript -->
                      </select>
                    </div>
                    <div class="col-md-6 mb-3">
                      <label for="proveedor_update" class="form-label">Nombre del Proveedor</label>
                      <input type="text" class="form-control" id="proveedor_update" name="proveedor" required>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <label for="contacto_principal_update" class="form-label">Contacto Principal</label>
                      <input type="text" class="form-control" id="contacto_principal_update" name="contacto_principal" required>
                    </div>
                    <div class="col-md-6 mb-3">
                      <label for="telefono_contacto_update" class="form-label">Teléfono de Contacto</label>
                      <input type="text" class="form-control" id="telefono_contacto_update" name="telefono_contacto" maxlength="9" required pattern="[0-9]+" title="Solo números">
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <label for="direccion_update" class="form-label">Dirección</label>
                      <input type="text" class="form-control" id="direccion_update" name="direccion" required>
                    </div>
                    <div class="col-md-6 mb-3">
                      <label for="email_update" class="form-label">Correo Electrónico</label>
                      <input type="email" class="form-control" id="email_update" name="email">
                    </div>
                  </div>

                  <!-- Botones -->
                  <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary me-2" id="btnactualizarproveedor">Actualizar</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <table class="table table-striped table-sm" id="table-proveedores">
          <thead>
            <tr>
              <th>RUC</th>
              <th>Proveedor</th>
              <th>Contacto</th>
              <th>Teléfono</th>
              <th>Correo</th>
              <th>Dirección</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <!-- Los datos de los proveedores se llenarán dinámicamente -->
          </tbody>
        </table>

        <div class="card-footer">
          <a href="registrar.php" class="btn btn-primary">Registrar nuevo Proveedor</a>
        </div>
      </div>
    </div>
  </div>
</main>
<!-- Incluye el script de JavaScript -->
<script src="../../js/proveedor/listar-actualizar.js"></script>

<?php
require_once '../../footer.php';
?>
