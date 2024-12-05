<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
  <div class="container-fluid px-4">
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <!-- Modal para actualizar cliente -->
    <div class="modal fade" id="actualizarClienteModal" tabindex="-1" aria-labelledby="actualizarClienteModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="actualizarClienteModalLabel">Actualizar Cliente</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form id="formActualizarCliente">
              <input type="hidden" id="idcliente" name="idcliente">
              <div class="mb-3">
                <label for="tipo_cliente" class="form-label">Tipo de Cliente</label>
                <select class="form-select" id="tipo_cliente" name="tipo_cliente" required>
                  <option value="Persona">Persona</option>
                  <option value="Empresa">Empresa</option>
                </select>
              </div>
              <div id="personaFields" style="display: none;">
                <div class="mb-3">
                  <label for="nombres" class="form-label">Nombres</label>
                  <input type="text" class="form-control" id="nombres" name="nombres">
                </div>
                <div class="mb-3">
                  <label for="appaterno" class="form-label">Apellido Paterno</label>
                  <input type="text" class="form-control" id="appaterno" name="appaterno">
                </div>
                <div class="mb-3">
                  <label for="apmaterno" class="form-label">Apellido Materno</label>
                  <input type="text" class="form-control" id="apmaterno" name="apmaterno">
                </div>
              </div>
              <div id="empresaFields" style="display: none;">
                <div class="mb-3">
                  <label for="razonsocial" class="form-label">Razón Social</label>
                  <input type="text" class="form-control" id="razonsocial" name="razonsocial">
                </div>
              </div>
              <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email">
              </div>
              <div class="mb-3">
                <label for="telefono" class="form-label">Teléfono</label>
                <input type="text" class="form-control" id="telefono" name="telefono">
              </div>
              <div class="mb-3">
                <label for="direccion" class="form-label">Dirección</label>
                <input type="text" class="form-control" id="direccion" name="direccion">
              </div>
              <button type="submit" class="btn btn-primary">Actualizar</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- card para listar los clientes -->
    <div class="card mb-4">
      <div class="card-header d-flex align-items-center">
        <i class="fas fa-table me-1 fa-lg"></i> Listado de Clientes
        <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
          <div class="text-end">
            <a href=<?= $URL . 'reports/Vehiculos/contenidoPDF.php' ?> type="button" class="me-2 btn btn-danger" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="Generar PDF">
              <i class="bi bi-file-earmark-pdf fs-6"></i>
            </a>

          </div>
        </div>
      </div>
      <div class="card-body">
        <table id="table-clientes" class="table table-striped" style="width: 100%;">
          <thead>
            <tr>
              <th>Documento</th>
              <th>Tipo de Cliente</th>
              <th>Cliente</th>
              <th>Provincia</th>
              <th>Fecha de Creación</th>
              <th>Estado</th>
              <th class="text-center">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <!-- Las filas se llenarán aquí -->
          </tbody>
        </table>
        <div class="card-footer">
          <a href="registrar-clientes.php" class="btn btn-primary">Registrar Nuevo Cliente</a>
        </div>
      </div>
    </div>
</main>

<!-- Archivo JavaScript que controla la funcionalidad de listado y exportación de clientes -->
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/clientes/listar-clientes.js"></script>
<script src="http://localhost/distribumax/js/clientes/disabled-cliente.js"></script>

</body>

</html>