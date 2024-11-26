<?php
require_once '../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Proveedor</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <!-- Card para el registro de Proveedor -->
    <div class="card">
      <div class="card-header">
        <h5><i class="fas fa-table me-1"></i> Datos del Proveedor</h5>
      </div>

      <div class="tab-pane fade" id="empresa" role="tabpanel" aria-labelledby="empresa-tab" tabindex="0">
        <form action="" method="" id="registrar-empresa" autocomplete="off">
          <div class="card">
            <div class="card-body">
              <!-- Fila para buscar el RUC -->
              <div class="row mb-3">
                <div class="input-group">
                  <div class="form-floating">
                    <input
                      type="number"
                      class="form-control"
                      id="nro-doc-empresa"
                      name="nro-doc-empresa"
                      placeholder="RUC Proveedor"
                      oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength);"
                      minlength="11"
                      maxlength="11"
                      title="Por favor ingresa solo números"
                      required
                    >
                    <label for="nro-doc-empresa"><i class="bi bi-search"></i> Buscar RUC</label>
                  </div>
                  <button class="btn btn-primary" type="button" id="btn-cliente-empresa"><i class="bi bi-search"></i></button>
                </div>
                <span id="status" class="d-none">Buscando, por favor espere...</span>
              </div>

              <!-- Nombre del proveedor -->
              <div class="row mb-3">
                <div class="col-md-6">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="proveedor" name="proveedor" minlength="1" maxlength="50" required>
                    <label for="proveedor">Nombre del Proveedor</label>
                  </div>
                </div>
              </div>

              <div class="row">
                <!-- Contacto principal -->
                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="contacto_principal" name="contacto_principal" minlength="1" maxlength="50" required>
                    <label for="contacto_principal">Contacto Principal</label>
                  </div>
                </div>

                <!-- Teléfono de contacto -->
                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="telefono_contacto" name="telefono_contacto" pattern="[0-9]+" title="Solo números" maxlength="9" minlength="9" required>
                    <label for="telefono_contacto">Teléfono de Contacto</label>
                  </div>
                </div>
              </div>

              <div class="row">
                <!-- Dirección -->
                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="direccion" name="direccion" minlength="1" maxlength="100" required>
                    <label for="direccion">Dirección</label>
                  </div>
                </div>

                <!-- Correo electrónico -->
                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="email" class="form-control" id="email" name="email" minlength="3" maxlength="100">
                    <label for="email">Correo Electrónico</label>
                  </div>
                </div>
              </div>
            </div>

            <!-- Botones -->
            <div class="card-footer d-flex justify-content-end mt-3">
              <button type="submit" class="btn btn-success mt-2 mb-2 me-2" id="registrarEmpresa" disabled> Registrar</button>
              <button type="reset" class="btn btn-outline-danger mt-2 mb-2">Cancelar</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>
<script src="http://localhost/distribumax/js/proveedor/registrar.js"></script>
<?php
require_once '../footer.php';
?>
