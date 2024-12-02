<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
  <div class="container-fluid px-4">
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>
    
    <!-- Modal para ver pedidos del cliente -->
    <div class="modal fade" id="generarReporte" tabindex="-1" aria-labelledby="generarReporteLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              <input type="text" id="datos" value="Nombre del Cliente" class="form-control" readonly style="border: none; outline: none; background: transparent; font-weight: bold;">
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="table-responsive">
              <table id="table-pedidos" class="table" style="width: 100%;">
                <thead>
                  <tr>
                    <th>Productos</th>
                    <th>Cantidades</th>
                  </tr>
                </thead>
                <tbody>
                  <!-- Las filas se llenarán aquí -->
                </tbody>
              </table>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Tarjeta de Listado de Empresas -->
    <div class="card mb-4">
      <div class="card-header d-flex justify-content-between align-items-center">
        <div>
          <i class="fas fa-table me-1 fa-lg"></i> Listado de Empresas
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
      </div>

<!-- Modal para la edición de la empresa -->
 <div class="modal fade" id="edit-empresa"
 data-bs-backdrop="static"
 data-bs-keyboard="false"
 tabindex="-1"
 role="dialog"
 aria-labelledby="staticBackdropLabel"
 aria-hidden="true">
 <div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header">
      <h1 class="modal-title fs-5" id="staticBackdropLabel">EDITAR EMPRESA</h1>
      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
    </div>

<!--DATOS EN EL FORMULARIO-->
    <form class="edit-empresa" autocomplete="off">
      <div class="modal-body">
        <div class="form-floating mb-3">
        <input type="text" id="id-empresa-ruc" name="edit-razonsocial" class="form-control edit-razonsocial" placeholder="Ej. Razón Social" autocomplete="off" required>
          <label for="razonsocial" class="form-label">
            <i class="bi bi-tag"></i>
            Razon Social
          </label>
        </div>

        <div class="form-floating mb-3">
        <input type="text" id="id-direccion" name="edit-direccion" class="form-control edit-direccion" placeholder="Ej. Dirección" autocomplete="off" required>
          <label for="direccion" class="form-label">
            <i class="bi bi-tag"></i>
            Dirección
          </label>
        </div>

        <div class="form-floating mb-3">
        <input type="text" id="id-email" name="edit-email" class="form-control edit-email" placeholder="Ej. Email" autocomplete="off" required>
          <label for="email" class="form-label">
            <i class="bi bi-tag"></i>
            Email
          </label>
        </div>

        <div class="form-floating mb-3">
        <input type="text" id="id-telefono" name="edit-telefono" class="form-control edit-telefono" placeholder="Ej. Telefono" autocomplete="off" required>
          <label for="telefono" class="form-label">
            <i class="bi bi-tag"></i>
            Telefono
          </label>
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
</main>
<?php require_once '../footer.php'; ?>
<!-- Archivo JavaScript que controla la funcionalidad de listado y exportación de empresas -->
<script src="http://localhost/distribumax/js/empresas/listar.js"></script>
<script src="http://localhost/distribumax/js/empresas/editar-empresa.js"></script>
<script src="http://localhost/distribumax/js/empresas/disabled-empresa.js"></script>
</body>
</html>
