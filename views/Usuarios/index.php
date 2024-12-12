<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>

<main>
  <div class="container-fluid px-4 mt-4">
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>
    <!-- Tarjeta de Listado de Usuarios -->
     <div class="card mb-4">
      <div class="card-header">
        <div class="d-flex justify-content-between aling-items-center">
          <div>
            <i class="bi bi-clipboard-check fs-3 fw-bold">Listado de Usuarios</i> 
          </div>
          <div>
            <a href="<?= $URL . 'reports/Usuarios/contenidoPDF.php' ?>" 
               type="button" 
               class="me-2 btn btn-danger" 
               data-bs-toggle="tooltip" 
               data-bs-placement="bottom" 
               data-bs-title="Generar PDF">
               <i class="bi bi-file-earmark-pdf fs-3"></i>
            </a>
          </div>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="table-usuarios" class="table" style="width: 100%;">
            <thead>
              <tr>
                <th>Nombre</th>
                <th>Apellido M.</th>
                <th>Apellido P.</th>
                <th>Nombre Rol</th>
                <th>Nombre Usuario</th>
                <th>Estado</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <!-- Las filas se llenarán aquí dinámicamente -->
            </tbody>
          </table>
        </div>
      </div>
      <div class="card-footer">
      <a href="registrar.php" class="btn btn-primary">Registrar Usuario</a>
    </div>
     </div>
<script src="http://localhost/distribumax/js/usuarios/listar.js"></script>
<script src="http://localhost/distribumax/js/usuarios/disabled-usuario.js"></script>
<?php require_once '../footer.php'; ?>
</body>
</html>
