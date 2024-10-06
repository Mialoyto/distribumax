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
          <span class="badge text-bg-light text-uppercase text-end " id="iduser" data-id="<?= $_SESSION['login']['idusuario'] ?>">
            <?= $_SESSION['login']['rol']  ?> :
            <?= $_SESSION['login']['nombres']  ?>
            <?= $_SESSION['login']['appaterno']  ?>
            <?= $_SESSION['login']['apmaterno']  ?>
          </span>
          <!-- INICIO FILA 01 -->
          <div class="row">
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="searchProducto" list="datalistProducto" placeholder="">
                <label for="searchProducto" class="form-label"><i class="bi bi-search"></i> Buscar Producto</label>
                <ul id="listProductKardex" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
              </div>
            </div>
            <div class="col-md-4 mt-3 ">
              <div class="input-group" id="grupo">
                <div class="form-floating ">
                  <input type="number" step="0.01" class="form-control" id="stockactual" name="stockactual" placeholder="stockactual" required disabled>
                  <label for="stockactual" class="form-label">Stock actual</label>
                </div>
                <span id="medida" class="input-group-text w-50" aria-label="With textarea">Unidad Medida</span>
              </div>
            </div>
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <select class="form-control" id="tipomovimiento" name="tipomovimiento" required>
                  <option value="">Selecione</option>
                  <option value="Ingreso">Ingreso</option>
                  <option value="Salida">Salida</option>
                </select>
                <label for="tipomovimiento" class="form-label">Tipo de Movimiento</label>
              </div>
            </div>

            <div>
              <input type="hidden" value="<?= $_SESSION['login']['idusuario'] ?>" id="idusuario">
            </div>
          </div> <!-- FIN FILA 01 -->
          <!-- INICIO FILA 02 -->
          <div class="row">
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="number" step="1" min="0" class="form-control numeros" id="cantidad" name="cantidad" placeholder="" required>
                <label for="cantidad" class="form-label">Cantidad</label>
              </div>
            </div>
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="loteP" name="loteP" placeholder="" maxlength="255" minlength="">
                <label for="loteP" class="form-label">Lote del Producto</label>
              </div>
            </div>
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="date" class="form-control" id="fechaVP" name="fechaVP" placeholder="" maxlength="255" minlength="">
                <label for="fechaVP" class="form-label">Fecha vencimiento</label>
              </div>
            </div>

          </div> <!-- FIN FILA 02 -->
          <!-- INICIO FILA 03 -->
          <div class="row">
            <div class="col-md-12 mt-3">
              <div class="form-floating">
                <textarea class="form-control" placeholder="Motivo del movimiento" id="motivo" style="height: 100px"></textarea>
                <label for="motivo">Motivo del movimiento</label>
              </div>
            </div>

          </div> <!-- FIN FILA 03 -->

          <!-- Botones -->
          <div class="d-flex justify-content-end mt-3">
            <button type="submit" class="btn btn-primary me-2">Registrar</button>
            <button type="reset" class="btn btn-secondary">Cancelar</button>
          </div>
        </form>
        <div class="card-footer mt-3">
          <a href="index.php" class="btn btn-primary mt-3">Listar Kardex</a>
        </div>
      </div>
    </div>
  </div>
</main>

<script src="../../js/kardex/registrar.js"></script>

<?php require_once '../../footer.php'; ?>