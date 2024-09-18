<?php
require_once '../../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Empresas</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Registro de Empresas
      </div>
      <div class="card-body">
        <!-- Formulario de Registro de Marca -->
        <form method="POST" action="#" id="form-registrar-marca" autocomplete="off">

          <div class="row">
            <div class="mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="marca" minlength="1" maxlength="100" required>
                <label for="marca">
                  Marca
                </label>
              </div>
            </div>
          </div>
          <!-- Botones -->
          <div class="d-flex justify-content-end">
            <button type="submit" class="btn btn-primary me-2">
              <i class="fa fa-check me-2"></i> Registrar Marca
            </button>
            <button type="reset" class="btn btn-secondary" >
              <i class="fa fa-times me-2"></i> Cancelar
            </button>
          </div>
        </form>
        <div class="card-footer">
          <a href="index.php" class="btn btn-primary">Listar empresa</a>
        </div>
      </div>
    </div>
  </div>
</main>



<script src="../../js/marca/registrar.js"></script>
<?php
require_once '../../footer.php';
?>