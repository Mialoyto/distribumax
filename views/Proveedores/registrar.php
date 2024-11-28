<?php require_once '../header.php'; ?>
<main>
  <!-- //todo: contenedor -->
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Proveedor</h1>

    <!-- // todo: Card para el registro de Proveedor -->
    <div class="card">
      <div class="card-header">
        <h5><i class="fas fa-table me-1"></i> Datos del Proveedor</h5>
      </div>
      <div class="card-body">
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
                      required>
                    <label for="nro-doc-empresa"><i class="bi bi-search"></i> Buscar RUC</label>
                  </div>
                  <button class="btn btn-primary" type="button" id="btn-cliente-empresa"><i class="bi bi-search"></i></button>
                </div>
                <span id="status" class="d-none">Buscando, por favor espere...</span>
              </div>

              <!-- //todo: select de tipo de documento -->
              <div class="col-md-6 mb-3">
                <div class="form-floating">
                  <select name="" id="idtipodocumento" class="form-control documento" disabled="true">
                    <option value="">Tipo de documento</option>
                    <!-- Las opciones se llenarán dinámicamente aquí -->
                  </select>
                  <label for="idtipodocumento" class="form-label">Tipo Documento</label>
                </div>
              </div>

              <!-- Nombre del proveedor y Distrito en la misma fila -->
              <div class="row mb-3">
                <div class="col-md-6">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="proveedor" name="proveedor" minlength="1" maxlength="50" disabled required>
                    <label for="proveedor">Nombre del Proveedor</label>
                  </div>
                </div>

                <div class="col-md-6">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="iddistrito" placeholder="Distrito" disabled required>
                    <label for="iddistrito">Distrito</label>
                    <ul id="datalistDistrito" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                  </div>
                </div>
              </div>

              <!-- Contacto principal y teléfono -->
              <div class="row">
                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="contacto_principal" name="contacto_principal" minlength="1" maxlength="50" disabled required>
                    <label for="contacto_principal">Contacto Principal</label>
                  </div>
                </div>

                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="telefono_contacto" name="telefono_contacto" pattern="[0-9]+" title="Solo números" maxlength="9" minlength="9" disabled required>
                    <label for="telefono_contacto">Teléfono de Contacto</label>
                  </div>
                </div>
              </div>

              <!-- Dirección y correo electrónico -->
              <div class="row">
                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="text" class="form-control" id="direccion" name="direccion" minlength="1" maxlength="100" disabled required>
                    <label for="direccion">Dirección</label>
                  </div>
                </div>

                <div class="col-md-6 mb-3">
                  <div class="form-floating">
                    <input type="email" class="form-control" id="email" name="email" minlength="3" maxlength="100" disabled required>
                    <label for="email">Correo Electrónico</label>
                  </div>
                </div>
              </div>
            </div>

            <!-- Botones -->
            <div class="card-footer d-flex justify-content-end mt-3">
              <button type="submit" class="btn btn-success mt-2 mb-2 me-2" id="registrarEmpresa" disabled>Registrar</button>
              <button type="reset" class="btn btn-outline-danger mt-2 mb-2">Cancelar</button>
            </div>
          </div>
        </form>
      </div>
      <div class="card-footer text-end">
        <a href=""><i class="bi bi-arrow-left-square fs-3"></i></a>
      </div>
    </div>
    <!-- //todo: fin de la tarjeta -->
  </div>
  <!-- //todo: fin del contenedor -->
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/proveedor/registrar.js"></script>
<script src="http://localhost/distribumax/js/utils/utils.js"></script>
