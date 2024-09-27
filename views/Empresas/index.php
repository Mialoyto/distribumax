<?php require_once '../../header.php'; ?>
<main>
<div class="container">
  <div class="card mt-4">
    <div class="card-body">
      <div class="table-responsive">
        <!-- DataTable requiere de manera obligatoria thead y tbody -->
        <table
          class="table"
          id="tabla-empresas"
          style="width: 100%;">
          <thead>
            <tr>
              <th>Razón Social</th>
              <th>Dirección</th>
              <th>Email</th>
              <th>Teléfono</th>
            </tr>
          </thead>
          <tbody>
            <!-- Aquí DataTables agregará las filas dinámicamente -->
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div><!-- Fin del container -->
</main>
<?php require_once '../../footer.php'; ?>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- DataTables Core -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<!-- DataTables Bootstrap 5 -->
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<!-- Enlace del JavaScript de DataTable -->
<script src="../../js/empresas/dataTable.js"></script>
</body>
</html>