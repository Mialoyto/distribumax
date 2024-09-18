<?php
require_once '../../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Proveedores</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Registrar proveedores
      </div>
      <div class="card-body">
        <!-- Formulario de Registro de Proveedor dentro del modal -->
        <form method="POST" action="#" id="form-registrar-proveedor" autocomplete="off">
          <div class="row">
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <select class="form-control" id="idempresaruc" name="" required>
                  <option value="">Seleccione una empresa</option>
                  <!-- Las opciones se cargarán dinámicamente con JavaScript -->
                </select>
                <label for="idempresaruc">Empresa</label>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="proveedor" name="proveedor" minlength="1" maxlength="50" required>
                <label for="proveedor">Nombre del Proveedor</label>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="contacto_principal" name="contacto_principal" minlength="1" maxlength="50" required>
                <label for="contacto_principal">Contacto Principal</label>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="text" 
                class="form-control" 
                id="telefono_contacto" 
                name="telefono_contacto"
                pattern="[0-9]+" 
                title="solo numeros"
                maxlength="9"
                minlength="9" 
                required>
                <label for="telefono_contacto">Teléfono de Contacto</label>
              </div>
            </div>
          </div>

          <div class="row">
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="direccion" name="direccion" minlength="1" maxlength="100" required  >
                <label for="direccion">Dirección</label>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="email" class="form-control" id="email" name="email" minlength="3" maxlength="100">
                <label for="email">Correo Electrónico</label>
              </div>
            </div>
          </div>

          <!-- Botones -->
          <div class="d-flex justify-content-end mt-4">
            <button type="submit" class="btn btn-primary me-2">Registrar</button>
            <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          </div>
        </form>
        <div class="card-footer">
          <a href="index.php" class="btn btn-primary">Listar Proveedores</a>
        </div>
      </div>
    </div>
  </div>
</main>
<!-- Incluye el script de JavaScript -->
<script src="../../js/proveedor/registrar.js"></script>

<?php
require_once '../../footer.php';
?>
