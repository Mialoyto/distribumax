<?php
require_once '../header.php';
?>
<main>
  <div class="container">
    <div class="card mt-4">
      <div class="card-header">
        <h3>
          <i class="bi bi-clipboard-check fs-2"></i>
          Listado de subcategorías
        </h3>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table" id="table-subcategorias" style="width: 100%;">
            <thead>
              <tr>
                <th>Categoría</th>
                <th>Subategoría</th>
                <th>Estado</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>
              <!--Las filas se llenarán aqui-->
            </tbody>
          </table>
        </div>
        <!-- Botón ubicado dentro del DataTable en la parte inferior derecha -->
        <div class="d-flex justify-content-end mt-3">
          <a href="http://localhost/distribumax/views/marcas/registrar-marca.php" class="btn btn-primary"><i class="bi bi-arrow-left-circle"></i></a>
        </div>
      </div>
    </div>
  </div><!-- Fin del container -->
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/subcategorias/listar-subcategoria.js"></script>
</body>

</html>