<?php require_once '../../header.php'; ?>

<main>
  <div class="container-fluid px-4">
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>
    <!--Modal -->
    <div class="modal fade" id="generarReporte" tabindex="-1" aria-labelledby="generarReporte" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              <input type="text" id="datos" value="Nombre del Cliente" class="form-control"
                style="border: none; outline: none; background: transparent; font-weight: bold;" readonly>
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

    <div class="card mb-4">
      <div class="card-header d-flex align-items-center">
        <i class="fas fa-table me-1 fa-lg"></i> Listado de Clientes
        <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
          <div class="text-end">
            <a href="../reports/Clientes/contenidoPDF.php" class="me-2 btn btn-danger" style="color: white;">
              <i class="fas fa-file-pdf me-1"></i> Generar PDF
            </a>
            <button class="btn btn-success" id="exportExcel" style="color: white;">
              <i class="fas fa-file-excel me-1"></i> Generar Excel
            </button>

          </div>
        </div>
      </div>
      <div class="card-body">
        <table id="table-clientes" class="table table-striped" style="width: 100%;">
          <thead>
            <tr>
              <th class="text-start">ID cliente</th>
              <th>Tipo de Cliente</th>
              <th>Cliente</th>
              <th class="text-end">Fecha de Creación</th>
              <th>Estado</th>
              <th>Acciones</th>
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

<?php require_once '../../footer.php'; ?>

<!-- Archivo JavaScript que controla la funcionalidad de listado y exportación de clientes -->
<script src="../../js/clientes/listar-clientes.js"></script>

</body>
</html>
