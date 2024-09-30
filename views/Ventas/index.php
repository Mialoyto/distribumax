<?php
require_once '../../header.php';
?>


<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Empresas</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>
    <!-- Modal -->
    <div class="modal fade" id="generarReporte" tabindex="-1" aria-labelledby="generarReporte" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="generarReporte">Reporte de Venta</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <!-- Aquí puedes incluir los datos de la venta -->
            <div id="modal-content">
              <p><strong>ID Venta:</strong> <span id="venta-id"></span></p>
              <p><strong>Detalles de la Venta:</strong> <span id="venta-detalles"></span></p>
              <!-- Puedes agregar más campos según sea necesario -->
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            <button type="button" class="btn btn-primary" id="guardarCambios">Guardar Cambios</button>
          </div>
        </div>
      </div>
    </div>
    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de Empresas
      </div>
      <div class="card-body">

        <div class="table-responsive">
          <table id="table-ventas" class="table" tyle="width: 100%;">
            <thead>
              <tr>
                <th>ID Pedido</th>
                <th>Tipo Cliente</th>
                <th>Productos</th>
                <th>Cantidades</th>
                <th>Total Subtotal</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <!-- Las filas se llenarán aquí -->
            </tbody>
          </table>

        </div>
        <div class="card-footer">
          <a href="registrar.php" class="btn btn-primary">Registrar nueva Venta</a>
        </div>
      </div>
    </div>
  </div>
</main>
<script src="../../js/ventas/listar.js"></script>
<?php
require_once '../../footer.php';
?>