<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php' ?>
<main>
  <div class="container-fluid px-4">
    <h1>Productos</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>
    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de Productos
        <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
          <div class="text-end">
            <a href="<?= $URL . 'reports/Productos/contenidoPDF.php' ?>" class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
              <i class="fas fa-file-pdf me-1"></i> Generar PDF
            </a>
            <button class="btn btn-success" id="exportExcel" style="color: white;">
              <i class="fas fa-file-excel me-1"></i> Generar Excel
            </button>
          </div>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="table-productos" class="table" style="width: 100%;">
            <thead>
              <tr class="text-center">
                <th>Marca</th>
                <th>Categoría</th>
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

            <input type="text" id="idproducto">
            <input type="text" id="idproveedor">
            <div class="mb-3">
              <label for="marca" class="form-label">Marca</label>
              <select name="" id="idmarca" class="form-select" required>
                <option value="">Seleccione una Marca</option>
                <!-- Opciones se llenarán dinámicamente -->
              </select>
            </div>
            <div class="mb-3">
              <label for="categoria" class="form-label">Categoría</label>
              <select name="categoria" id="idcategoria" class="form-select" required>
                <option value="">Seleccione una categoría</option>
                <!-- Opciones se llenarán dinámicamente -->
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
            <div class="mb-3">
              <label for="codigo" class="form-label">Código</label>
              <input type="text" class="form-control" id="codigo" name="codigo" required>
            </div>
            <div class="mb-3">
              <label for="codigo" class="form-label">Cantidad Presentación</label>
              <input type="text" class="form-control" id="cantidad_presentacion" name="codigo" required>
            </div>
            <div class="mb-3">
              <label for="precio_compra" class="form-label">Precio de Compra</label>
              <input type="number" step="0.01" class="form-control" id="precio_compra" name="precio_compra" required>
            </div>
            <div class="mb-3">
              <label for="precio_mayorista" class="form-label">Precio Mayorista</label>
              <input type="number" step="0.01" class="form-control" id="precio_mayorista" name="precio_mayorista" required>
            </div>
            <div class="mb-3">
              <label for="precio_minorista" class="form-label">Precio Minorista</label>
              <input type="number" step="0.01" class="form-control" id="precio_minorista" name="precio_minorista" required>
            </div>
            <div class="mb-3">
              <label for="unidadmedida" class="form-label">Unidad de Medida</label>
              <select name="unidadmedida" id="idunidadmedida" class="form-select" required>
                <option value="">Seleccione una unidad de medida</option>
                <!-- Opciones se llenarán dinámicamente -->
              </select>
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