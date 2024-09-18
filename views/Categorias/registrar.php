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
        Registro de Empresas
      </div>
      <div class="card-body">

        <form method="POST" action="#" id="form-categoria">
          <div class="mb-3">
            <label for="categoria" class="form-label">Categoría</label>
            <input type="text" class="form-control" id="categoria" name="categoria" required>
          </div>

          <!-- Botones del formulario dentro del modal -->
          <div class="d-flex justify-content-end">
            <button type="submit" class="btn btn-primary me-2">Registrar Categoría</button>
            <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </form>
        <div class="card-footer">
          <a href="index.php" class="btn btn-primary">Listar empresa</a>
        </div>
      </div>
    </div>
  </div>
</main>

<script src="../../js/categorias/registrar.js"></script>
<?php
require_once '../../footer.php';
?>