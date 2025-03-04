<?php require_once '../header.php'; ?>

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
        <form method="POST" action="#" id="formRegistrarProducto" autocomplete="off">
          <!-- FILA 01 -->
          <!-- Busador del proveedor -->
          <div class="row mt-3">
            <div class="col-md-12 mt-3">
              <div class="input-group">
                <div class="form-floating">
                  <input type="search" class="form-control" id="idproveedor" name="idproveedor" placeholder="Proveedor" required>
                  <label for="idproveedor" class="form-label"> <i class="bi bi-search"></i> Buscar proveedor</label>
                  <ul id="list-proveedor" class="list-group position-absolute w-100 listarDatos" style="z-index: 1000; display: none;"></ul>
                </div>
                <button class="btn btn-primary" type="button" id="btn-proveedor"><i class="bi bi-search"></i></button>
              </div>
            </div>
          </div>
          <!-- FILA 02 -->
          <!-- marca / categoría / subcategoría -->
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
          <!-- FILA 03 -->
          <!-- nombre / unidad / cantidad por presentacion -->
          <div class="row mt-3">
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="nombreproducto" name="nombreproducto" placeholder="Nombre del Producto" required>
                <label for="nombreproducto" class="form-label">Nombre del Producto</label>
              </div>
            </div>
            <div class="col-md-2 mb-3">
              <div class="form-floating">
                <select class="form-control" id="unidadmedida" name="unidadmedida" required>
                  <option value="">Seleccione presentación</option>
                  <!-- Agrega más opciones según sea necesario -->
                </select>
                <label for="unidad" class="form-label">Presentación</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="number" class="form-control numeros" id="cantidad" name="codigo" min="1" max="200" placeholder="Código del producto" required>
                <label for="cantidad" class="form-label">Cantidad por presentación</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="input-group">
                <div class="form-floating">
                  <input type="number" min="1" class="form-control numeros" id="peso" placeholder="20">
                  <label for="peso" class="form-label">Peso unitario (opcional)</label>
                </div>
                <!-- <label for="peso" class="form-label">Peso</label> -->
                <div class="form-floating">
                  <select class="form-control" id="unidad" name="unidad">
                    <option value="">Seleccione</option>
                    <option value="GR">GR</option>
                    <option value="ML">ML</option>
                    <option value="KG">KG</option>
                    <option value="LT">LT</option>
                    <!-- Agrega más opciones según sea necesario -->
                  </select>
                  <label for="unidad" class="form-label">Unidad medida</label>
                </div>
              </div>
            </div>
          </div>
          <!-- peso unitario -->
          <!-- FILA 04 -->
          <div class="row mt-3">
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="codigo" name="codigo" placeholder required>
                <label for="código" class="form-label">Código</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="number" step="0.01" class="form-control numeros" id="preciocompra" name="preciocompra" placeholder="Precio de compra" required>
                <label for="preciocompra" class="form-label">Precio de compra</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="number" step="0.01" class="form-control numeros" id="precio-mayorista" name="precio-mayorista" placeholder="Precio venta mayorista" required>
                <label for="precio-mayorista" class="form-label">Precio venta mayorista</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="number" step="0.01" class="form-control numeros" id="precio-minorista" name="precio-minorista" placeholder="Stock mínimo" required>
                <label for="precio-minorista" class="form-label">Precio venta minorista</label>
              </div>
            </div>

          </div>
          <!-- Botones -->
          <div class="d-flex justify-content-end mt-3">
            <button type="submit" class="btn btn-success me-2">Registrar</button>
            <button type="reset" class="btn btn-outline-danger">Cancelar</button>
          </div>
        </form>
      </div>
      <div class="card-footer">
        <a href="index.php" class="btn btn-primary mt-3">listar producto</a>
      </div>
    </div>
  </div>
</main>
<script src="http://localhost/distribumax/js/productos/registrar-productos.js"> </script>
<?php require_once '../footer.php'; ?>
</body>

</html>