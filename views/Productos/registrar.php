<?php
require_once '../../header.php';
?>




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

        <form method="POST" action="#" id="form-registrar-producto">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="idmarca" class="form-label">Marca</label>
              <select class="form-control" id="idmarca" name="idmarca" required>
                <option value="">Seleccione una marca</option>
                <!-- Agrega más opciones según sea necesario -->
              </select>
            </div>
            <div class="col-md-6 mb-3">
              <label for="idsubcategoria" class="form-label">Subcategoría</label>
              <select class="form-control" id="idsubcategoria" name="idsubcategoria" required>

                <!-- Agrega más opciones según sea necesario -->
              </select>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="nombreproducto" class="form-label">Nombre del Producto</label>
              <input type="text" class="form-control" id="nombreproducto" name="nombreproducto" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="codigo" class="form-label">Código del Producto</label>
              <input type="text" class="form-control" id="codigo" name="codigo" maxlength="11" required>
            </div>
          </div>

          <div class="col-md-6">
            <label for="preciounitario" class="form-label">Precio Unitario</label>
            <input type="number" step="0.01" class="form-control" id="preciounitario" name="preciounitario" min="0.01" required>
          </div>

          <div class="mb-3">
            <label for="descripcion" class="form-label">Descripción</label>
            <textarea class="form-control" id="descripcion" name="descripcion" rows="3" required></textarea>
          </div>

          <!-- Botones -->
          <div class="d-flex justify-content-end">
            <button type="submit" class="btn btn-primary me-2">Registrar</button>
            <button type="reset" class="btn btn-secondary">Cancelar</button>
          </div>
        </form>
        <div class="card-footer">
          <a href="index.php" class="btn btn-primary">listar producto</a>
        </div>
      </div>
    </div>
  </div>
</main>
<script src="../../js/producto/registrar.js"> </script>
<?php
require_once '../../footer.php';
?>

