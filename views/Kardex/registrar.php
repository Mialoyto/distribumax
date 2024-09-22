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
        Registrar Movimiento
      </div>
      <div class="card-body">

        <form method="POST" action="#" id="form-registrar-kardex" autocomplete="off">
          <div class="row">

          <div class=" mb-3">
              <div class="form-floating">

                <input type="search" class="form-control" id="searchProducto" list="datalistProducto" required>
                <div class="error-container" style="display: none;"></div>
                <label for="" class="form-label">Buscar Producto</label>
                <datalist id="datalistProducto"></datalist>


              </div>
            </div>
            <div>
              <input type="hidden" value="<?= $_SESSION['login']['idusuario'] ?>" id="idusuario">
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="stockactual" class="form-label">Stock Actual</label>
              <input type="number" step="0.01" class="form-control" id="stockactual" name="stockactual" required disabled>
            </div>
            <div class="col-md-6 mb-3">
              <label for="tipomovimiento" class="form-label">Tipo de Movimiento</label>
              <select class="form-control" id="tipomovimiento" name="tipomovimiento" required>
              <option value="">Selecione</option>
                <option value="Ingreso">Ingreso</option>
                <option value="Salida">Salida</option>
              </select>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="cantidad" class="form-label">Cantidad</label>
              <input type="number" step="0.01" class="form-control" id="cantidad" name="cantidad" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="motivo" class="form-label">Motivo</label>
              <input type="text" class="form-control" id="motivo" name="motivo" maxlength="255" minlength="">
            </div>
          </div>

          <!-- Botones -->
          <div class="d-flex justify-content-end">
            <button type="submit" class="btn btn-primary me-2">Registrar</button>
            <button type="reset" class="btn btn-secondary">Cancelar</button>
          </div>
        </form>
        <div class="card-footer">
          <a href="index.php" class="btn btn-primary">Listar Kardex</a>
        </div>
      </div>
    </div>
  </div>
</main>

<script src="../../js/kardex/registrar.js"></script>

<?php require_once '../../footer.php'; ?>