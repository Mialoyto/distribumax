<?php require_once '../../header.php'; ?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Empresas</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de karde de producto
      </div>
      <div class="card-body">
        <table class="table table-striped table-sm" id="table-empresas">
          <thead>
            <tr>
              <th>RUC</th>
              <th>Razón Social</th>
              <th>Distrito</th>
              <th>Dirección</th>
              <th>Email</th>
              <th>Teléfono</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <!-- Los datos de las empresas se llenarán dinámicamente -->
          </tbody>
        </table>

        <!-- Modal para actualizar empresa -->
        <div class="modal fade" id="actualizarEmpresaModal" tabindex="-1" aria-labelledby="actualizarEmpresaModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-lg">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="actualizarEmpresaModalLabel">Actualizar Empresa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <!-- Formulario de actualización de empresa dentro del modal -->
                <form method="POST" action="#" id="form-actualizar-empresa">
                  <div class="row">
                    <input type="text" id="idempresaruc-update">
                    <div class="col-md-6 mb-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="razonsocial-update" name="razonsocial" required>
                        <label for="razonsocial-update">
                          <i class="fa fa-building me-2"></i> Razón Social
                        </label>
                      </div>
                    </div>
                    <div class="col-md-6 mb-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="direccion-update" name="direccion" required>
                        <label for="direccion-update">
                          <i class="fa fa-map-marker-alt me-2"></i> Dirección
                        </label>
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <div class="form-floating">
                        <input type="email" class="form-control" id="email-update" name="email">
                        <label for="email-update">
                          <i class="fa fa-envelope me-2"></i> Email
                        </label>
                      </div>
                    </div>
                    <div class="col-md-6 mb-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="telefono-update" name="telefono" required>
                        <label for="telefono-update">
                          <i class="fa fa-phone me-2"></i> Teléfono
                        </label>
                      </div>
                    </div>
                  </div>

                  <div class="row">
                    <div class="col-md-6 mb-3">
                      <div class="form-floating">
                        <input type="search" class="form-control" id="searchDistrito" list="datalistDistrito" required>
                        <div class="error-container" style="display: none;"></div>
                        <label for="" class="form-label">Buscar Distrito</label>
                        <datalist id="datalistDistrito"></datalist>
                      </div>
                    </div>
                  </div>

                  <!-- Botones -->
                  <div class="d-flex justify-content-end mt-4">
                    <button type="submit" class="btn btn-primary me-2" id="btnactualizar">
                      <i class="fa fa-save me-2"></i> Actualizar
                    </button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                      <i class="fa fa-times me-2"></i> Cancelar
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>

        <!-- Botón para registrar nueva empresa -->
        <div class="card-footer">
          <a href="registrar.php" class="btn btn-primary">Registrar nueva movimiento</a>
        </div>
      </div>
    </div>
  </div>
</main>

<script src="../../js/empresas/listar-actualizar.js"></script>

<?php require_once '../../footer.php'; ?>