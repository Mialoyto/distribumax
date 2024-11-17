<?php
require_once '../header.php';
?>
<main>
  <div class="container mb-3">
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
          <div class="modal fade edit-categoria"
            data-bs-backdrop="static"
            data-bs-keyboard="false"
            tabindex="-1"
            role="dialog"
            aria-labelledby="staticBackdropLabel"
            >
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="staticBackdropLabel">Editar subcategoría</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form class="edit-subcategoria" id="form-edit" autocomplete="off">
                  <div class="modal-body">
                    <div class="form-floating mb-3">
                      <input type="text" name="categoria" class="form-control categoria" disabled>
                      <label for="categoria" class="form-label">
                        <i class="bi bi-tag"></i>
                        Categoría
                      </label>
                    </div>
                    <div class="form-floating mb-3">
                      <input type="text" name="subcategoria" id="id-subcategoria" class="form-control subcategoria" placeholder="Ej. Alimentos" autocomplete="off" required>
                      <label for="categoria" class="form-label">
                        <i class="bi bi-tag"></i>
                        Subcategoría
                      </label>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="submit" class="btn btn-success"><i class="bi bi-floppy"></i></button>
                    <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal"><i class="bi bi-x-square"></i></button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
        <!-- modal -->

      </div>
      <!-- Botón ubicado dentro del DataTable en la parte inferior derecha -->
      <div class="card-footer">
        <div class="d-flex justify-content-end mt-2 mb-2">
          <a href="http://localhost/distribumax/views/marcas/registrar-marca.php" class="btn btn-primary"><i class="bi bi-arrow-left-circle"></i></a>
        </div>
      </div>
    </div>
  </div><!-- Fin del container -->
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/subcategorias/listar-subcategoria.js"></script>
<script src="http://localhost/distribumax/js/subcategorias/editar-subcategoria.js"></script>
</body>

</html>