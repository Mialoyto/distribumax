<?php require_once '../header.php'; ?>

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
        <form action="" id="registrar-empresa" autocomplete="off">
          <div class="card">
            <div class="card-body">
              <!-- Campos específicos para Empresa -->
              <div class="row mb-3">
                <div class="col-md-6 mt-3">
                  <div class="input-group">
                    <div class="form-floating">
                      <input type="number"
                        class="form-control"
                        id="nro-doc-empresa"
                        name="nro-doc-empresa"
                        oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength);"
                        placeholder="Ruc"
                        minlength="11"
                        maxlength="11"
                        title="Por favor, ingresa solo números."
                        required>
                      <label for="nro-doc-empresa"><i class="bi bi-search"></i> Buscar ruc</label>
                    </div>
                    <button class="btn btn-primary" type="button" id="btn-cliente-empresa"><i class="bi bi-search"></i></button>
                  </div>
                  <span id="status" class="d-none">Buscando por favor espere...</span>
                </div>
                <div class="col-md-6 mt-3">
                  <div class="form-floating">
                    <select name="tipodoc" id="tipodoc" class="form-select documento" disabled="true">
                      <option value="">Tipo de documento</option>
                      <!-- genera desde el backend -->
                    </select>
                    <label for="tipodoc" class="form-label">Tipo Documento</label>

                  </div>
                </div>
              </div>
              <div class="row mb-3">
                <div class="col-md-4 mt-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="iddistrito" placeholder="Distrito" disabled="true" required>
                    <label for="">Distrito</label>
                    <ul id="datalistDistrito" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                  </div>
                </div>
                <div class="col-md-8 mt-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="razon-social" placeholder="Razón Social" required disabled="true">
                    <label for="razon-social" class="form-label">Razón Social</label>
                  </div>
                </div>
              </div>
              <div class="row mb-3">
                <div class="col-md-4 mt-3">
                  <div class="form-floating">
                    <input type="email" class="form-control" id="email" placeholder="Email" disabled="true">
                    <label for="email" class="form-label">Email</label>
                  </div>
                </div>
                <div class="col-md-5 mt-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="direccion" placeholder="Dirección" required disabled="true">
                    <label for="">Dirección</label>
                  </div>
                </div>
                <div class="col-md-3 mt-3">
                  <div class="form-floating">
                    <input
                      type="number"
                      minlength="9"
                      maxlength="9"
                      class="form-control"
                      id="telefono-empresa"
                      placeholder="Teléfono"
                      disabled="true">
                    <label for="">Teléfono</label>
                  </div>
                </div>
              </div>
            </div>

          </div>
          <div class="card-footer d-flex justify-content-end">
            <a href="index.php" class="btn btn-outline-primary  mt-2 mb-2 me-2">Listar empresas</a>

            <button
              type="submit"
              class="btn btn-success mt-2 mb-2 me-2"
              id="registrarEmpresa"
              disabled>
              Registrar
            </button>
            <button
              type="reset"
              class="btn btn-outline-danger mt-2 mb-2">
              Cancelar
            </button>

          </div>
        </form>
      </div>

    </div>
  </div>
</main>
<script src="http://localhost/distribumax/js/empresas/registrar.js"></script>
<script src="http://localhost/distribumax/js/utils/utils.js"></script>
<?php require_once '../footer.php'; ?>
</body>

</html>