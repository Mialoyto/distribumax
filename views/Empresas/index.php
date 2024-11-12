<?php require_once '../../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
  <div class="card mb-4">
    <div class="card-header">
      <i class="fas fa-table me-1 fa-lg"></i>
      Listado de Empresas
      <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
          <div class="text-end">
            <a href="<?= $URL.'reports/Empresas/contenidoPDF.php' ?>" class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
              <i class="fas fa-file-pdf me-1"></i> Generar PDF
            </a>
            <a href="generar-excel.php" class="btn btn-success">
              <i class="fas fa-file-excel me-1"></i> Generar Excel
            </a>
          </div>
        </div>
    </div>
    <div class="card-body">
      <table id="table-empresas" class="table table-striped" style="width: 100%;">
        <thead>
          <tr>
            <th>Razón Social</th>
            <th>Dirección</th>
            <th>Email</th>
            <th>Telefono</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <!-- Las filas se llenarán aquí -->
        </tbody>
      </table>
      <div class="card-footer">
        <a href="registrar.php" class="btn btn-primary">Registrar Empresa</a>
      </div>
    </div>
  </div>
</main>
<script src="../../js/empresas/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>
