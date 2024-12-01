<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
  <div class="card mb-4">
    <div class="card-header">
      <i class="fas fa-table me-1"></i>
      Listado de Clientes
      <div class="ms-auto">
        <div class="text-end">
          <a href="<?= $URL.'reports/Clientes/contenidoPDF.php' ?>" class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
            <i class="fas fa-file-pdf me-1"></i> Generar PDF
          </a>
        </div>
      </div>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table id="table-clientes" class="table" style="width: 100%;">
          <thead>
            <tr class="text-center">
              <th>ID Cliente</th>
              <th>Tipo de Cliente</th>
              <th>Cliente</th>
              <th>Estado</th>
              <th class="text-center">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <!-- Las filas se llenarán aquí -->
          </tbody>
        </table>
      </div>


      <!-- MODAL -->
       <div class="modal fade" id="edit-cliente"
        data-bs-backdrop="static"
        data-bs-keyboard="false"
        tabindex="-1"
        aria-labelledby="staticBackdropLabel"
        aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h1 class="modal-title fs-5" id="staticBackdropLabel">EDITAR CLIENTE</h1>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form class="edit-cliente" autocomplete="off">
              <div class="modal-body">
                <div class="form-floating mb-3">
                  <input type="text" id="id-cliente" name="edit-cliente" class="form-control edit-cliente" placeholder="Ej. Clientes." autocomplete="off" required>
                  <label for="cliente" class="form-label">
                    <i class="bi bi-person"></i>
                    Cliente
                  </label>
                </div>
                <div class="form-floating mb-3">
                  <input type="text" id="tipo-cliente" name="edit-cliente" class="form-control edit-cliente" placeholder="Ej. Clientes." autocomplete="off" required>
                  <label for="tipo-cliente" class="form-label">
                    <i class="bi bi-person"></i>
                    Tipo de Cliente
                  </label>

                <div class="form-floating mb-3">
                  <input type="text" id="cliente" name="edit-cliente" class="form-control edit-cliente" placeholder="Ej. Clientes." autocomplete="off" required>
                  <label for="cliente" class="form-label">
                    <i class="bi bi-person"></i>
                    Cliente
                  </label>
                </div>
              </div>
              <div class="modal-footer">
                <button type="submit" class="btn btn-success">Registrar</button>
                <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
              </div>
            </form>
          </div>
        </div>
    </div>
    <!-- FIN DEL MODAL -->
    </div>
    <div class="card-footer">
      <div class="mt-3 text-end">
        <a href="<?= $URL.'views/Clientes/registrar-clientes.php' ?>" class="btn btn-primary"><i class="bi bi-arrow-left-circle"></i></a>
      </div>
  </div>
</main>
<?php require_once '../footer.php'; ?>
<!-- Archivo JavaScript que controla la funcionalidad de listado y exportación de clientes -->
<script src="http://localhost/distribumax/js/clientes/listar-clientes.js"></script>
<script src="http://localhost/distribumax/js/clientes/editar-clientes.js"></script>
<script src="http://localhost/distribumax/js/clientes/disabled-cliente.js"></script>
</body>
</html>