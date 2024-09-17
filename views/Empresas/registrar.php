<?php require_once '../../header.php'; ?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Empresas</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de Empresas
      </div>
      <div class="card-body">
        <form method="POST" action="#" id="form-registrar-empresa">
          <div class="row">
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="idempresaruc" name="idempresaruc"
                  pattern="^[0-9]{10}$|^[0-9]{20}$"
                  title="Debe tener 10 o 20 dígitos" required>
                <label for="idempresaruc">RUC</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="razonsocial" name="razonsocial" maxlength="100" minlength="3" required>
                <label for="razonsocial">
                  <i class="fa fa-building me-2"></i> Razón Social
                </label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="direccion" name="direccion" maxlength="100" minlength="3" required>
                <label for="direccion">
                  <i class="fa fa-map-marker-alt me-2"></i> Dirección
                </label>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="email" class="form-control" id="email" name="email" maxlength="100">
                <label for="email">
                  <i class="fa fa-envelope me-2"></i> Email
                </label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="telefono" name="telefono" maxlength="9" minlength="9" pattern="[0-9]+" title="Solo números" required>
                <label for="telefono">
                  <i class="fa fa-phone me-2"></i> Teléfono
                </label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">

                <input type="search" class="form-control" id="searchDistrito" list="datalistDistrito" required>
                <div class="error-container" style="display: none;"></div>
                <label for="" class="form-label">Buscar Distrito</label>
                <datalist id="datalistDistrito"></datalist>


              </div>
            </div>
          </div>

          <!-- Botones dentro del formulario -->
          <div class="d-flex justify-content-end mt-4">
            <button type="submit" class="btn btn-primary me-2">
              <i class="fa fa-check me-2"></i> Registrar
            </button>
            <button type="reset" class="btn btn-outline-secondary">
              <i class="fa fa-times me-2"></i> Cancelar
            </button>
          </div>
        </form>
      </div>
      <div class="card-footer">
        <a href="index.php" class="btn btn-outline-primary">Listar empresa</a>
      </div>
    </div>
  </div>
</main>
<script src="../../js/empresas/registrar.js"></script>
<?php require_once '../../footer.php'; ?>