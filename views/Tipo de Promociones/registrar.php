<?php require_once '../header.php'; ?>
<div class="container mt-5">
  <div class="card shadow-lg border-0 rounded-lg">
    <div class="card-header">
      <div class="text-center">Registro de Tipo de Promociones</div>
    </div>
    <div class="card-body">
      <!-- Sección de Registro de Tipos de Promociones -->
      <h5 class="mb-4">Registro de Tipo de Promoción</h5>
      <form method="POST" action="#" id="form-promocion">
        <div class="row">
          <div class="col-md-6 mb-3">
            <label for="tipopromocion" class="form-label">Tipo de Promoción</label>
            <input type="text" class="form-control" id="tipopromocion" name="tipopromocion" required>
          </div>
          <div class="col-md-6 mb-3">
            <label for="descripcion" class="form-label">Descripción</label>
            <input type="text" class="form-control" id="descripcion" name="descripcion_tipo" required>
          </div>
        </div>
        <!-- Botones -->
         <div class="d-flex justify-content-end">
          <button type="submit" class="btn btn-primary me-2">Registrar Tipo</button>
          <button type="reset" class="btn btn-secondary">Cancelar</button>
          <a href="index.php" class="btn btn-outline-primary">Listar Tipo de Promociones</a>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="http://localhost/distribumax/js/tipopromociones/registrar.js"> </script>
<?php require_once '../footer.php';?>
