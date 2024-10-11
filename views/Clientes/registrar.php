<?php
require_once '../../header.php';
?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Cliente</h1>
    <ol class="breadcrumb mb-4"></ol>

    <!-- Card para el Registro de Cliente -->
    <div class="card mb-4">
      <div class="card-header">
        Clientes
      </div>
      <div class="card-body">
        <form action="" method="" id="form-registrar-Cliente" autocomplete="off">
          <div class="row">
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <select name="tipo_cliente" id="cliente" class="form-select" onchange="toggleForm()" required>
                  <option value="">Seleccione...</option>
                  <option value="Persona">Persona</option>
                  <option value="Empresa">Empresa</option>
                </select>
                <label for="tipo_cliente"><i class="fas fa-user me-2"></i> Tipo de Cliente</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="nro-doc"
                  name="nro-doc" placeholder="Número de documento" required pattern="[0-9]+">
                <label for="nro-doc"><i class="fas fa-id-card me-2"></i>Nro Documento</label>
              </div>
            </div>
          </div>


          <div id="form-persona">
            <h5>Datos de la Persona</h5>
            <div class="row">
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="appaterno" name="appaterno" disabled>
                  <label for="appaterno"><i class="fas fa-user me-2"></i> Apellido Paterno</label>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="apmaterno" name="apmaterno" disabled>
                  <label for="apmaterno"><i class="fas fa-user me-2"></i> Apellido Materno</label>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="nombres" name="nombres" disabled>
                  <label for="nombres"><i class="fas fa-user me-2"></i> Nombres</label>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="direccion-cliente" name="direccion" disabled>
                  <label for="direccion"><i class="fas fa-map me-2"></i> Dirección</label>
                </div>
              </div>

              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="distrito" name="ubigeo" disabled>
                  <label for="distrito"><i class="fas fa-map-marker-alt me-2"></i> Distrito</label>
                </div>
              </div>
            </div>
          </div>

          <div id="form-empresa" class="hidden" style="display: none;">
            <hr>
            <h5>Datos de la Empresa</h5>
            <div class="row">
              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="razon-social" name="razonsocial" disabled>
                  <label for="razonsocial"><i class="fas fa-building me-2"></i>Razón Social</label>
                </div>
              </div>
              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="email" class="form-control" id="email" name="email_empresa" disabled>
                  <label for="email_empresa"><i class="fas fa-envelope me-2"></i>Email</label>
                </div>
              </div>

              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="direccion-cliente" name="direccion" disabled>
                  <label for="direccion"><i class="fas fa-map me-2"></i>Dirección</label>
                </div>
              </div>
              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="distrito" name="ubigeo" disabled>
                  <label for="distrito"><i class="fas fa-map-marker-alt me-2"></i>Distrito</label>
                </div>
              </div>
            </div>
          </div>

          <div class="d-flex justify-content-end mt-4">
            <button type="submit" class="btn btn-primary me-2">Registrar Cliente</button>
            <button type="reset" class="btn btn-secondary">Cancelar</button>
          </div>
        </form>
      </div>

      <!-- Aquí agregamos el card-footer correctamente -->
      <div class="card-footer d-flex ">
        <a href="index.php" class="btn btn-secondary">Listar Clientes</a>
      </div>
    </div>
  </div>
</main>

<script>
  function toggleForm() {
    const tipoCliente = document.getElementById('cliente').value;
    const formPersona = document.getElementById('form-persona');
    const formEmpresa = document.getElementById('form-empresa');

    if (tipoCliente === 'Persona') {
      formPersona.style.display = 'block';
      formEmpresa.style.display = 'none';
    } else {
      formEmpresa.style.display = 'block';
      formPersona.style.display = 'none';
    }
  }
</script>

<script src="../../js/clientes/registrar.js"></script>
<?php
require_once '../../footer.php';
?>