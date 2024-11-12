<?php require_once '../../header.php';?>
<?php require_once '../../app/config/App.php'; ?>
<main>
  <div class="container-fluid px-4">
    <div class="mt-4">Proveedores</div>
    <ol class="breadcrumb mb-4">

    </ol>
    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de Vehiculos
        <div class="ms-auto">
          <div class="text-end">
          <a href=<?= $URL . 'reports/Proveedores/contenidoPDF.php' ?> class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
                        <i class="fas fa-file-pdf me-1"></i> Generar PDF
                    </a>
                    <a href="generar-excel.php" class="btn btn-success">
                        <i class="fas fa-file-excel me-1"></i> Generar Excel
                    </a>
          </div>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="table-proveedores" class="table" style="width: 100%;">
          <thead>
            <tr>
              <th>RUC</th>
              <th>Proveedor</th>
              <th>Contacto</th>
              <th>Telefono</th>
              <th>Correo</th>
              <th>Direccion</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>

          </tbody>
          </table>
          <div class="card-footer">
            <a href="registrar.php" class="btn btn-primary">Registrar Proveedor</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>
<script src="../../js/proveedor/listar.js"></script>
<?php require_once '../../footer.php'; ?>