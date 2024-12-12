<?php
require_once '../header.php';
require_once '../../app/config/App.php';
?>

<main>
  <div class="container-fluid px-4 mt-4">
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <!-- TARJETA -->
    <div class="card mb-4">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <i class="bi bi-clipboard-check fs-3 fw-bold"> Ventas del Día</i>
          </div>
          <div>
            <a href="<?= $URL . 'reports/Vehiculos/contenidoPDF.php' ?>" type="button" class="me-2 btn btn-danger" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="Generar PDF">
              <i class="bi bi-file-earmark-pdf fs-6"></i>
            </a>
          </div>
        </div>
      </div>

      <!-- Modal Cambiar Estado -->
      <div class="modal fade" id="cambiarestado" tabindex="-1" aria-labelledby="cambiarestado" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Cambiar Estado</h5>
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

      <!-- Modal para Ver Reporte -->
      <div class="modal fade" id="generarReporte" tabindex="-1" aria-labelledby="generarReporte" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">
                <input type="text" id="datos" value="Nombre del Cliente" class="form-control" style="border: none; outline: none; background: transparent; font-weight: bold;" readonly>
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

      <!-- Tabla de Ventas -->
      <div class="card-body">
        <div class="table-responsive">
          <!-- Filtro centrado sobre la tabla -->
          <div class="row mb-3 justify-content-center">
            <div class="col-md-4">
              <input type="date" id="fecha-venta" class="form-control" placeholder="Seleccionar fecha">
            </div>
          </div>

          <table id="table-ventas" class="table" style="width: 100%;">
            <thead>
              <tr>
                <th>N° Comprobante</th>
                <th>Pedido</th>
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
