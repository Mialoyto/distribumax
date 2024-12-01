<?php
require_once '../header.php';
require_once '../../app/config/App.php';
?>
<main>
  <div class="container-fluid px-4">
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header d-flex justify-content-between align-items-center">
        <div>
          <i class="fas fa-table me-1"></i>
          Ventas del día
        </div>
        <div class="col-4 mb-4">
          <!-- Campo para filtrar por fecha con botón -->
          <div class="input-group">
            <input type="date" id="fecha-venta" class="form-control" placeholder="Seleccionar fecha">
          </div>
        </div>

        <div class="text-end">
          <a href="<?= $URL . 'reports/Clientes/contenidoPDF.php' ?>" class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
            <i class="fas fa-file-pdf me-1"></i> Generar PDF
          </a>
          <a href="generar-excel.php" class="btn btn-success">
            <i class="fas fa-file-excel me-1"></i> Generar Excel
          </a>
        </div>
      </div>
      <div class="modal fade" id="cambiarestado" tabindex="-1" aria-labelledby="cambiarestado" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Cambiar estado</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="form-cambiarestado">
              <div class="modal-body">
                <select class="form-select" id="estado">
                  <option value="">Seleccione...</option>
                  <option value="0">Cancelar</option>
                </select>
              </div>
            </form>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
              <button type="submit" class="btn btn-primary" id="actualizar">Actualizar</button>
            </div>
          </div>
        </div>
      </div>
      <!-- Modal para ver reporte -->
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
                      <th>Unidad Medida</th>
                      <th>Cantidades</th>
                      <th>Total</th>
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

      <!-- Tabla de ventas -->
      <div class="card-body">
        <div class="table-responsive">
          <table id="table-ventas" class="table" style="width: 100%;">
            <thead>
              <tr>
                <th>Pedido</th>
                <th>Tipo Cliente</th>
                <th>Cliente</th>
                <th>Documento</th>
                <th>Fecha Venta</th>
                <th>Estado</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody id="contenido-venta">
              <!-- Las filas se llenarán aquí -->
            </tbody>
          </table>
        </div>

      </div>
       <div class="card-footer">
          <a href="registrar.php" class="btn btn-primary">Registrar nueva Venta</a>
          <a href="listar.php" class="btn btn-success">Historial de Ventas</a>

        </div>
    </div>

  </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/ventas/listar.js"></script>
</body>

</html>