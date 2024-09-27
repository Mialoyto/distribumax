<?php require_once '../../header.php';?>
<main>
  <div class="container">
    <div class="card mt-4">
      <div class="card-body">
        <div class="table-responsive">
          <table class="table" id="tabla-proveedores" style="width: 100%;">
            <thead>
              <tr>
                <th>RUC</th>
                <th>Proveedor</th>
                <th>Contacto</th>
                <th>Teléfono</th>
                <th>Correo</th>
                <th>Dirección</th>
              </tr>
            </thead>
            <tbody>
              <!-- Aquí DataTables agregará las filas dinámicamente -->
            </tbody>
          </table>
        </div>
        <div class="mt-3 text-end">
          <a href="registrar.php" class="btn btn-primary">Registrar nuevo Proveedor</a>
        </div>
      </div>
    </div>
  </div><!-- Fin del container -->
</main>
<?php require_once '../../footer.php';?>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- DataTables Core -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<!-- DataTables Bootstrap 5 -->
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<!-- Incluye el script de JavaScript -->
<script src="../../js/proveedor/dataTable.js"></script>
</body>
</html>
