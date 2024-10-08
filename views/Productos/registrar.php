<?php require_once '../../header.php'; ?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Productos</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>Registrar producto
      </div>
      <div class="card-body">
        <form method="POST" action="#" id="formRegistrarProducto">
          <!-- FILA 01 -->
          <div class="row mt-3">
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <select class="form-control" id="idmarca" name="idmarca">
                  <option value="">Seleccione una marca</option>
                  <!-- Agrega más opciones según sea necesario -->
                </select>
                <label for="idmarca" class="form-label">Marca</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <select class="form-control" id="idcategoria" name="idcategoria" required>
                  <option value="">Seleccione una categoría</option>
                  <!-- Agrega más opciones según sea necesario -->
                </select>
                <label for="idcategoria" class="form-label">Categoría</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <select class="form-control" id="idsubcategoria" name="idsubcategoria" required>
                  <option value="">Seleccione una subcategoría</option>
                  <!-- Agrega más opciones según sea necesario -->
                </select>
                <label for="idsubcategoria" class="form-label">Subcategoría</label>
              </div>
            </div>
          </div>
          <!-- FILA 02 -->
          <div class="row mt-3">
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="nombreproducto" name="nombreproducto" placeholder="Nombre del Producto" required>
                <label for="nombreproducto" class="form-label">Nombre del Producto</label>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="codigo" name="codigo" maxlength="11" placeholder="Código del producto" required>
                <label for="codigo" class="form-label">Código del Producto</label>
              </div>
            </div>
          </div>
          <!-- FILA 03 -->
          <div class="row mt-3">
            <div class="col-md-12 mb-3">
              <div class="form-floating">
                <textarea class="form-control" id="descripcion" name="descripcion" rows="3" placeholder="Descripcion" style="height: 100px" required></textarea>
                <label for="descripcion" class="form-label">Descripción</label>
              </div>
            </div>
          </div>
          <h5>Detalle del producto</h5>
          <hr>
          <!-- FILA 04 -->
          <div class="row mt-3">
            <div class="col-md-12 mt-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="idproveedor" name="idproveedor" placeholder="Proveedor" required>
                <label for="idproveedor" class="form-label">Buscar proveedor</label>
              </div>
            </div>
          </div>
          <!-- FILA 05 -->
          <div class="row mt-3">
            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <select class="form-control" id="idunidadmedida" name="idunidadmedida" required>
                  <option value="">Seleccione unidad medida</option>
                  <!-- Agrega más opciones según sea necesario -->
                </select>
                <label for="stockminimo" class="form-label">Unidad medida</label>
              </div>
            </div>

            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <input type="number" step="0.05" class="form-control" id="preciocompra" name="preciocompra" placeholder="Precio de compra" required>
                <label for="preciocompra" class="form-label">Precio de compra</label>
              </div>
            </div>

            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <input type="number" step="0.05" class="form-control" id="precio-minorista" name="precio-minorista" placeholder="Stock mínimo" required>
                <label for="precio-minorista" class="form-label">Precio venta minorista</label>
              </div>
            </div>

            <div class="col-md-3 mt-3">
              <div class="form-floating">
                <input type="number" step="0.05" class="form-control" id="precio-mayorista" name="precio-mayorista" placeholder="Precio venta mayorista" required>
                <label for="precio-mayorista" class="form-label">Precio venta mayorista</label>
              </div>
            </div>

          </div>


          <!-- Botones -->
          <div class="d-flex justify-content-end mt-3">
            <button type="submit" class="btn btn-primary me-2">Registrar</button>
            <button type="reset" class="btn btn-secondary">Cancelar</button>
          </div>
        </form>
      </div>
      <div class="card-footer">
        <a href="index.php" class="btn btn-primary mt-3">listar producto</a>
      </div>
    </div>
  </div>
</main>
<?php require_once '../../footer.php'; ?>
<script src="../../js/producto/registrar.js"> </script>
</body>

</html>