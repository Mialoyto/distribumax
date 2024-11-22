<?php
require_once '../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Proveedores</h1>
    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Registrar Proveedores
      </div>
      <div class="card-body">
        <!-- Formulario de Registro de Proveedor -->
        <form id="form-registrar-proveedor" autocomplete="off">
          <div class="row">
            <!-- Campo de búsqueda de proveedor -->
            <div class="col-md-6 mb-3">
            <div class="form-floating">
                  <input
                    type="search"
                    class="form-control"
                    id="idproveedor"
                    name="idproveedor"
                    placeholder="Proveedor"
                    required>
                  <label for="idproveedor" class="form-label">
                    <i class="bi bi-search"></i> Buscar proveedor
                  </label>
                  <ul
                    id="list-proveedor"
                    class="list-group position-absolute w-100 listarDatos"
                    style="z-index: 1000; display: none;">
                  </ul>
                </div>
            </div>

            <!-- Nombre del proveedor -->
            <div class="col-md-6 mb-3">
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

          <!-- Botones -->
          <div class="d-flex justify-content-end mt-4">
            <button type="button" class="btn btn-primary me-2" id="btn-registrar">Registrar</button>
            <button type="reset" class="btn btn-secondary">Cancelar</button>
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
