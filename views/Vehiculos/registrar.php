<?php
require_once '../../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Vehículo</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <!-- Card para el Registro de Vehículo -->
    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-car me-1"></i>
        Datos del Vehículo
      </div>
      <div class="card-body">
        <form action="" method="" id="form-registrar-Vehiculo">
          <div class="row">
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="idusuario" name="idusuario" list="datalistConductor" required>
                <datalist id="datalistConductor" class="list-group position-absolute w-100" style="z-index: 1000; display: none;"></datalist>
                <label for="idusuario"><i class="fas fa-user me-2"></i> Conductor</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="marca_vehiculo" name="marca_vehiculo" maxlength="100" minlength="3" required>
                <label for="marca"><i class="fas fa-car me-2"></i> Marca</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="modelo" name="modelo" maxlength="100" minlength="3" required>
                <label for="modelo"><i class="fas fa-car-side me-2"></i> Modelo</label>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="placa" name="placa" pattern="[A-Za-z]{3}-[0-9]{3}" maxlength="7" minlength="7" required>
                <label for="placa"><i class="fas fa-clipboard-check me-2"></i> Placa (Ej: ABC-123)</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="number" class="form-control" id="capacidad" name="capacidad" required>
                <label for="capacidad"><i class="fas fa-users me-2"></i> Capacidad</label>
              </div>
            </div>
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <select class="form-select" id="condicion" name="condicion" required>
                  <option value="operativo">Operativo</option>
                  <option value="taller">Taller</option>
                  <option value="averiado">Averiado</option>
                </select>
                <label for="condicion"><i class="fas fa-cog me-2"></i> Condición</label>
              </div>
            </div>
          </div>
          <button type="submit" class="btn btn-primary">Registrar Vehículo</button>
        </form>
      </div>

      <div class="card-footer">
        <a href="index.php" class="btn btn-secondary">Volver al Listado de Vehículos</a>
      </div>
    </div>
  </div>
</main>
<script src="../../js/vehiculos/registrar.js"></script>
<?php
require_once '../../footer.php';
?>