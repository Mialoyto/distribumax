<?php require_once '../../header.php'; ?>
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
        <div>
          <a href="<?= $URL.'reports/Empresas/contenidoPDF.php' ?>" id="generarPDF" class="btn btn-danger me-2">
            <i class="fas fa-file-pdf me-1"></i> Generar PDF
          </a>
          <a href="generar-excel.php" id="generarExcel" class="btn btn-success">
            <i class="fas fa-file-excel me-1"></i> Generar Excel
          </a>
        </div>
      </div>
      
      <div class="card-body">
        <table id="table-empresas" class="table table-striped" style="width: 100%;">
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

      <div class="card-footer text-end">
        <a href="registrar.php" class="btn btn-primary">Registrar Empresa</a>
      </div>
    </div>
  </div>
</main>

<script src="../../js/empresas/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>
