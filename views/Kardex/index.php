<?php require_once '../header.php'; ?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Kardex</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <i class="fas fa-table me-1"></i>
            Registrar Movimiento
          </div>
          <!-- Button trigger modal -->
          <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#add-lote">
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
            <div class="col-md-6 mt-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="searchProducto" list="datalistProducto" placeholder="">
                <label for="searchProducto" class="form-label"><i class="bi bi-search"></i> Buscar Producto</label>
                <ul id="listProductKardex" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
              </div>
            </div>
            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <select name="loteP" id="loteP" class="form-select" aria-label="Default select example" required>
                  <option value="">Seleccione lote</option>
                  <!-- render desde la base de datos -->
                </select>
                <label for="loteP" class="form-label">Lote del Producto</label>
                <!-- <input type="text" class="form-control" id="loteP" name="loteP" placeholder="" maxlength="255"> -->
              </div>
            </div>
            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <input type="date" class="form-control" id="fechaVP" name="fechaVP" placeholder="" maxlength="255" minlength="" disabled>
                <label for="fechaVP" class="form-label">Fecha vencimiento</label>
              </div>
            </div>
            <div>
              <input type="hidden" value="<?= $_SESSION['login']['idusuario'] ?>" id="idusuario">
            </div>
          </div>
          <!-- FIN FILA 01 -->
          <!-- INICIO FILA 02 -->
          <div class="row">
            <!-- <span class="badge text-bg-light text-uppercase text-end " id="user" data-id="<?= $_SESSION['login']['idusuario'] ?>"></span> -->
            <div class="col-md-3 mt-3 ">
              <div class="input-group" id="grupo">
                <div class="form-floating ">
                  <input type="number" step="0.01" class="form-control" id="stockactual" name="stockactual" placeholder="stockactual" required disabled>
                  <label for="stockactual" class="form-label">Stock actual</label>
                </div>
                <span id="medida" class="input-group-text w-50 text-truncate" aria-label="With textarea">Unidad Medida</span>
              </div>
            </div>
            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <select class="form-control" id="tipomovimiento" name="tipomovimiento" required>
                  <option value="">Selecione</option>
                  <option value="Ingreso">Ingreso</option>
                  <option value="Salida">Salida</option>
                </select>
                <label for="tipomovimiento" class="form-label">Tipo de Movimiento</label>
              </div>
            </div>
            <!-- Motivo de Salida -->
            <div class="col-md-3 mt-3" id="motivoSalidaDiv">
              <div class="form-floating">
                <select class="form-select" id="motivoSalida" name="motivoSalida">
                  <option value="">Seleccione el motivo</option>
                  <option value="Mal Estado">Mal Estado</option>
                  <option value="Merma">Merma</option>
                  <option value="Producto Vencido">Producto Vencido</option>
                  <option value="Otro">Otro</option>
                </select>
                <label for="motivoSalida" class="form-label">Motivo de Salida</label>
              </div>
            </div>

            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <input type="number" step="1" min="1" class="form-control numeros" id="cantidad" name="cantidad" placeholder="">
                <label for="cantidad" class="form-label">Cantidad</label>
              </div>
            </div>
          </div>
          <!-- FIN FILA 02 -->
        </div>
        <div class="card-footer mt-3">
          <!-- Botones -->
          <div class="mb-2 mt-2">
            <!-- <a href="index.php" class="btn btn-primary mt-3 text-end">Listar Kardex</a> -->
            <div class="d-flex justify-content-end mt-3">
              <button type="submit" class="btn btn-primary me-2">Registrar</button>
              <button type="reset" class="btn btn-secondary" id="btnCancelar">Cancelar</button>
            </div>
          </div>
        </div>
      </form>
    </div>
    <div class="container-sm">
      <!-- tabla para mostrar los ultimos Movimientos -->
      <table id="table-productos" class="table table-striped" style="width: 100%;">
        <thead>
          <tr>
            <!-- <th>Lote</th> -->
            <th>Producto</th>
            <th>Tipo Movimiento</th>
            <th>Fecha</th>
            <th>Motivo</th>
            <th>Cantidad</th>
            <th>Stock Actual</th>
          </tr>
        </thead>
        <tbody>

        </tbody>
      </table>

    </div>
  </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/kardex/registrar.js"></script>
<script src="http://localhost/distribumax/js/kardex/listar-producto-kardex.js"></script>
<script src="http://localhost/distribumax/js/kardex/registrar-lote.js"></script>
</body>

</html>