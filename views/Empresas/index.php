<?php require_once '../../header.php'; ?>
<main>
<div class="container">
  <div class="card mt-4">
    <div class="card-body">
      <div class="table-responsive">
        <!-- DataTable requiere de manera obligatoria thead y tbody -->
        <table class="table" id="table-empresas" style="width: 100%;">
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
      <div class="card-footer">
        <a href="registrar.php" class="btn btn-primary">Registrar Empresa</a>
      </div>
    </div>
  </div>
</div><!-- Fin del container -->
</main>
<!-- Enlace del JavaScript de DataTable -->
<script src="../../js/empresas/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>