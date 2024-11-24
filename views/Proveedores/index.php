<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
  <div class="container-fluid px-4">
    <div class="mt-4">Proveedores</div>
    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de Proveedores
        <div class="ms-auto">
          <div class="text-end">
            <a href=<?= $URL . 'reports/Proveedores/contenidoPDF.php' ?> class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
              <i class="fas fa-file-pdf me-1"></i> Generar PDF
            </a>
            <a href="generar-excel.php" class="btn btn-success">
              <i class="fas fa-file-excel me-1"></i> Generar Excel
            </a>
          </div>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table id="table-proveedores" class="table" style="width: 100%;">
            <thead>
              <tr>
                <th>RUC</th>
                <th>Proveedor</th>
                <th>Contacto</th>
                <th>Telefono</th>
                <th>Correo</th>
                <th>Direccion</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>

            </tbody>
          </table>
          <!--Modal para editar el nombre del proovedor -->
          <div class="modal fade edit-proveedor"
            data-bs-backdrop="static"
            data-bs-keyboard="false"
            tabindex="-1"
            role="dialog"
            aria-labelledby="staticBackdropLabel">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="staticBackdropLabel">Editar Proveedor</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="form-prov" id="form-edit" autocomplete="off">
                  <div class="modal-body">
                    <div class="form-floating mb-3">
                      <input type="text" name="proveedor" id="editIdEmpresa" class="form-control proveedor" placeholder="Ej. Dijisa" autocomplete="off" required>
                      <label for="editIdEmpresa" class="form-label">
                        <i class="bi bi-tag"></i>
                        Ruc
                      </label>
                    </div>
                    <div class="form-floating mb-3">
                      <input type="text" name="proveedor" id="editProveedor" class="form-control" placeholder="Ej. Dijisa" autocomplete="off" required>
                      <label for="editProveedor" class="form-label">
                        <i class="bi bi-tag"></i>
                        Proveedor
                      </label>
                    </div>

                    <div class="form-floating mb-3">
                      <input type="text" name="proveedor" id="editDireccion" class="form-control proveedor" placeholder="Ej. Dijisa" autocomplete="off" required>
                      <label for="editDireccion" class="form-label">
                        <i class="bi bi-tag"></i>
                        Direccion
                      </label>
                    </div>
                    <div class="form-floating mb-3">
                      <input type="text" name="proveedor" id="editCorreo" class="form-control proveedor" placeholder="Ej. Dijisa" autocomplete="off" required>
                      <label for="editCorreo" class="form-label">
                        <i class="bi bi-tag"></i>
                        Email
                      </label>
                    </div>
                    <div class="form-floating mb-3">
                      <input type="text" name="proveedor" id="editContacto" class="form-control proveedor" placeholder="Ej. Dijisa" autocomplete="off" required>
                      <label for="editContacto" class="form-label">
                        <i class="bi bi-tag"></i>
                        Contacto
                      </label>
                    </div>
                    <div class="form-floating mb-3">
                      <input type="text" name="proveedor" id="editTelefono" class="form-control proveedor" placeholder="Ej. Dijisa" autocomplete="off" required>
                      <label for="editTelefono" class="form-label">
                        <i class="bi bi-tag"></i>
                        Telefono
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
        <div class="card-footer">
          <a href="registrar.php" class="btn btn-primary">Registrar Proveedor</a>
        </div>
      </div>
    </div>
  </div>
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/proveedor/listar-proveedor.js"></script>
<script src="http://localhost/distribumax/js/proveedor/editar-proveedor.js"></script>
<script src="http://localhost/distribumax/js/proveedor/disabled-proveedor.js"></script>
</body>

</html>