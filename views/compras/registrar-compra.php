<?php require_once '../header.php'; ?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Compras</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <i class="bi bi-basket-fill fa-lg"></i>
            Registrar compras
          </div>
          <!-- Button trigger modal -->
          <a type="button" href="http://localhost/distribumax/views/productos/registrar.php" class="btn btn-primary btn-sm align-items-center">
            <i class="bi bi-plus-circle fa-lg"></i>
            Registrar producto
          </a>
        </div>
      </div>
      <!-- formulario de compras -->
      <form method="POST" action="#" id="form-registrar-kardex" autocomplete="off">
        <div class="card-body">

          <span class="badge text-bg-light text-uppercase text-end " id="iduser" data-id="<?= $_SESSION['login']['idusuario'] ?>">
            <?= $_SESSION['login']['perfil']  ?> :
            <?= $_SESSION['login']['nombres']  ?>
            <?= $_SESSION['login']['appaterno']  ?>
            <?= $_SESSION['login']['apmaterno']  ?>
          </span>
          <!-- INICIO FILA 01 -->
          <div class="row">
            <div class="col-md-12 mt-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="searchProveedor" list="datalistProducto" placeholder="">
                <label for="searchProveedor" class="form-label"><i class="bi bi-search"></i> Buscar proveedor</label>
                <ul id="listProveedor" class="list-group position-absolute w-100" style="z-index: 1000;"></ul>
              </div>
            </div>

          </div>
          <!-- FIN FILA 01 -->
          <!-- INICIO FILA 02 -->
          <div class="row mb-3">
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <select name="loteP" id="loteP" class="form-select" aria-label="Default select example" required>
                  <option value="">Seleccione tipo de documento</option>
                  <option value="">Factura</option>
                  <option value="">Boleta</option>
                  <!-- render desde la base de datos -->
                </select>
                <label for="loteP" class="form-label">Seleccione documento</label>
                <!-- <input type="text" class="form-control" id="loteP" name="loteP" placeholder="" maxlength="255"> -->
              </div>
            </div>
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="number" class="form-control" id="fechaVP" name="fechaVP" placeholder="" maxlength="255" minlength="">
                <label for="fechaVP" class="form-label">Nro factura</label>
              </div>
            </div>
            <!-- <span class="badge text-bg-light text-uppercase text-end " id="user" data-id="<?= $_SESSION['login']['idusuario'] ?>"></span> -->
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="date" class="form-control" id="fechaVP" name="fechaVP" placeholder="" maxlength="255" minlength="">
                <label for="fechaVP" class="form-label">Fecha Emisión</label>
              </div>
            </div>
          </div>
          <!-- FIN FILA 02 -->
          <!-- <hr> -->
          <hr>
          <div class="row mt-3">
            <h4 class="mb-3">Detalle de compras</h4>
            <div class="col-md-12">
              <div class="form-floating align-items-center">
                <input type="search" class="form-control" id="searchProducto" name="cantidad" placeholder="cantidad" required>
                <label for="cantidad" class="form-label"><i class="bi bi-search fa-lg"></i> Agregar Producto</label>
                <ul id="listProduct" class="list-group position-absolute w-100" style="z-index: 1000;"></ul>

              </div>
            </div>
          </div>
          <hr>
          <!-- INICIO FILA 03 -->
          <div class="row">
            <div class="container">
              <!-- tabla para mostrar los ultimos Movimientos -->
              <table id="table-productos" class="table table-striped table-hover" style="width: 100%;">
                <thead>
                  <tr>
                    <th>Cantidad</th>
                    <th>Producto</th>
                    <th>Unidad Medida</th>
                    <th>Precio Unitario</th>
                    <th>Valor compra</th>
                  </tr>
                </thead>
                <tbody>


                </tbody>
              </table>
            </div>

          </div>
          <!-- FIN DE LA FILA 03 -->
        </div>
        <div class="card-footer mt-3">
          <!-- Botones -->
          <div class="d-flex justify-content-between mt-3">
            <a href="index.php" class="btn btn-primary mt-3 text-end">Listar Kardex</a>
            <div class="d-flex justify-content-end mt-3">
              <button type="submit" class="btn btn-primary me-2">Registrar</button>
              <button type="reset" class="btn btn-secondary" id="btnCancelar">Cancelar</button>
            </div>
          </div>
        </div>
      </form>
    </div>
  </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/compras/registrar-compra.js"></script>
<!-- <script src="http://localhost/distribumax/js/kardex/listar-producto-kardex.js"></script> -->
<!-- <script src="http://localhost/distribumax/js/kardex/registrar-lote.js"></script> -->
</body>

</html>