<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php' ?>
<main>
  <div class="container-fluid px-4 mt-4">

    <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->

    <div class="card mb-4">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <i class="bi bi-clipboard-check fs-3 fw-bold">Listado de Productos</i>
          </div>
          <div>
            <a href="<?= $URL . 'reports/Productos/contenidoPDF.php' ?>" type="button" class="me-2 btn btn-danger" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="Generar PDF">
              <i class="bi bi-file-earmark-pdf fs-6"></i>
            </a>
          </div>
        </div>

        <!-- Utilizamos ms-auto para alinear a la derecha -->

      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="table-productos" class="table" style="width: 100%;">
            <thead>
              <tr class="text-center">
                <th>Marca</th>
                <th>Categoría</th>
                <th>Subcategoría</th>
                <th>Nombre del Producto</th>
                <th>Código</th>
                <th>Estado</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <!-- Las filas se llenarán aquí -->
            </tbody>
          </table>
        </div>
        <div class="card-footer">
          <a href="registrar.php" class="btn btn-primary">Registrar</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal para actualizar producto -->
  <div class="modal fade edit-categoria" tabindex="-1" aria-labelledby="editCategoriaLabel" aria-hidden="true" id="edit-producto">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="editCategoriaLabel">Actualizar Producto</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form id="formActualizarProducto">

            <input type="hidden" id="idproducto">
            <input type="hidden" id="idproveedor">

            <div class="mb-3">
              <label for="marca" class="form-label">Marca</label>
              <select name="" id="idmarca" class="form-select" required disabled>
                <option value="">Seleccione una Marca</option>
                <!-- Opciones se llenarán dinámicamente -->
              </select>
            </div>

            <div class="mb-3">
              <label for="categoria" class="form-label">Categoría</label>
              <select name="categoria" id="idcategoria" class="form-select" required>
                <option value="">Seleccione una categoría</option>
                <!-- Opciones se llenarán dinámicamente -->
              </select>
            </div>

            <div class="mb-3">
              <label for="subcategoria" class="form-label">Subcategoría</label>
              <select name="subcategoria" id="idsubcategoria" class="form-select" required>
                <option value="">Seleccione una subcategoría</option>
                <!-- Opciones se llenarán dinámicamente -->
              </select>
            </div>

            <div class="mb-3">
              <label for="nombreproducto" class="form-label">Nombre del Producto</label>
              <input type="text" class="form-control" id="nombreproducto" name="nombreproducto" required>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="codigo" class="form-label">Código</label>
                <input type="text" class="form-control" id="codigo" name="codigo" required>
              </div>
              <div class="col-md-6 mb-3">
                <label for="cantidad_presentacion" class="form-label">Cantidad Presentación</label>
                <input type="text" class="form-control" id="cantidad_presentacion" name="codigo" required>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="precio_compra" class="form-label">Precio de Compra</label>
                <input type="number" step="0.01" class="form-control" id="precio_compra" name="precio_compra" required>
              </div>
              <div class="col-md-6 mb-3">
                <label for="precio_mayorista" class="form-label">Precio Mayorista</label>
                <input type="number" step="0.01" class="form-control" id="precio_mayorista" name="precio_mayorista" required>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6 mb-3">
                <label for="precio_minorista" class="form-label">Precio Minorista</label>
                <input type="number" step="0.01" class="form-control" id="precio_minorista" name="precio_minorista" required>
              </div>
              <div class="col-md-6 mb-3">
                <label for="unidadmedida" class="form-label">Unidad de Medida</label>
                <select name="unidadmedida" id="idunidadmedida" class="form-select" required>
                  <option value="">Seleccione una unidad de medida</option>
                  <!-- Opciones se llenarán dinámicamente -->
                </select>
              </div>
            </div>

            <input type="hidden" id="idproducto" name="idproducto">
            <button type="submit" class="btn btn-primary">Actualizar</button>
          </form>
        </div>
      </div>
    </div>
  </div>

</main>
<script src="http://localhost/distribumax/js/productos/listar.js"></script>
<script src="http://localhost/distribumax/js/productos/editar-productos.js"></script>
<?php require_once '../footer.php'; ?>
</body>

</html>