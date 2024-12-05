<?php require_once '../header.php'; ?>

<main>
  <div class="container-fluid px-4 mt-4">
   
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
          <div>
            <a type="button" href="http://localhost/distribumax/views/productos/registrar.php" class="btn btn-primary btn-sm align-items-center">
              <i class="bi bi-plus-circle fa-lg"></i>
              Registrar producto
            </a>
            <!-- Button trigger modal -->
            <button type="button" class="btn btn-primary  btn-sm" data-bs-toggle="modal" data-bs-target="#add-lote">
              <i class="bi bi-bookmark-plus"></i>
              Registrar lote
            </button>
            <!-- Modal -->
            <div class="modal fade" id="add-lote"
              data-bs-backdrop="static"
              data-bs-keyboard="false"
              tabindex="-1"
              aria-labelledby="staticBackdropLabel"
              aria-hidden="true">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title fs-5" id="staticBackdropLabel">REGISTRAR LOTE - KARDEX</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <form method="" action="#" id="form-registrar-lote" autocomplete="off">
                      <span class="badge text-bg-light text-uppercase text-end " id="user" data-id="<?= $_SESSION['login']['idusuario'] ?>"></span>

                      <div class="dropdown">
                        <div class="form-floating mb-3">
                          <input type="text" id="productoSearch" name="productoSearch" class="form-control" placeholder="Buscar producto..." autocomplete="off" required>
                          <label for="productoSearch" class="form-label">
                            <i class="bi bi-search"></i>
                            Buscar producto
                          </label>
                          <ul id="productoList" class="dropdown-menu  w-100" style="max-height: 200px;">
                            <!-- Opciones de productos se llenan dinámicamente -->
                          </ul>
                        </div>
                      </div>

                      <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="numlote" name="numlote" placeholder="numlote" required>
                        <label for="numlote" class="form-label"><i class="bi bi-tag"></i> Número de Lote</label>
                      </div>

                      <div class="form-floating mb-3">
                        <input type="date" class="form-control" id="fecha_vencimiento" name="fecha_vencimiento" required>
                        <label for="fecha_vencimiento" class="form-label">
                          <i class="bi bi-calendar4-week"></i>
                          Fecha de Vencimiento
                        </label>
                      </div>

                  </div>
                  <div class="modal-footer">
                    <button type="submit" id="btn-add-lote" class="btn btn-success">Registrar</button>
                    <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
                  </div>
                  </form>
                </div>
              </div>
            </div>
            <!-- FIN DEL MODAL -->
          </div>
        </div>
      </div>
      <!-- formulario de compras -->
      <form method="POST" action="#" id="form-registrar-compras" autocomplete="off">
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
                <select name="id-comprobante" id="id-comprobante" class="form-select" aria-label="Default select example" required>
                  <option value="">Seleccione tipo de documento</option>
                  <!-- render desde la base de datos -->
                </select>
                <label for="loteP" class="form-label">Seleccione documento</label>
                <!-- <input type="text" class="form-control" id="loteP" name="loteP" placeholder="" maxlength="255"> -->
              </div>
            </div>
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="number" class="form-control" id="nro-fac" name="fechaVP" placeholder="" maxlength="255" minlength="">
                <label for="nro-fac" class="form-label">Nro factura</label>
              </div>
            </div>
            <!-- <span class="badge text-bg-light text-uppercase text-end " id="user" data-id="<?= $_SESSION['login']['idusuario'] ?>"></span> -->
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input type="date" class="form-control" id="fecha-emision" name="fechaVP" placeholder="" maxlength="255" minlength="">
                <label for="fecha-emision" class="form-label">Fecha Emisión</label>
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
                <input type="search" class="form-control" id="searchProducto" name="cantidad" placeholder="cantidad">
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
              <table id="table-productos" class="table table-striped table-responsive table-hover" style="width: 100%;">
                <thead>
                  <tr>
                    <th>Lote</th>
                    <th>Stock</th>
                    <th>Cantidad</th>
                    <th>Producto</th>
                    <th>Unid. Medida</th>
                    <th>Precio compra</th>
                    <th>Valor compra</th>
                    <th>Acciones</th>
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
          <div class="mt-2 mb-2">

            <!-- <a href="index.php" class="btn btn-primary mt-3 text-end">Listar Kardex</a> -->
            <div class="d-flex justify-content-between">
              <div class="d-flex justify-content-start mt-3">
                <a class="btn btn-primary" href="listar-compras.php">Listar Compra</a>
              </div>
              <!-- Botones -->
              <div class="d-flex justify-content-end mt-3">
                <button type="submit" class="btn btn-success me-2 transition">Registrar Compra </button>
                <button type="reset" class="btn btn-outline-danger" id="btnCancelar">Cancelar</button>
              </div>
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
<script src="http://localhost/distribumax/js/kardex/registrar-lote.js"></script>
</body>

</html>