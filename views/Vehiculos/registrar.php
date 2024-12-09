<?php require_once '../header.php'; ?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Vehículo</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <!-- Card principal para el Registro de Vehículo -->
    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-car me-1"></i>
        Datos del Vehículo
      </div>
      <div class="card-body">
        <form action="" method="" id="form-registrar-Vehiculo" autocomplete="off">
          <div class="row">
            <!-- Buscar conductor -->
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input
                  type="search"
                  class="form-control"
                  id="idusuario"
                  name="idusuario"
                  placeholder="Proveedor"
                  required>
                <label for="idusuario">
                  <i class="bi bi-search"></i> Buscar conductor
                </label>
                <ul id="list-usuario" class="list-group position-absolute w-100 listarDatos" style="z-index: 1000; display: none;"></ul>
              </div>
            </div>

            <!-- Marca -->
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <select class="form-control" id="marca_vehiculo" name="marca_vehiculo" required>
                  <option value="" disabled selected>Seleccione una marca</option>
                  <option value="Toyota">Toyota</option>
                  <option value="Hyundai">Hyundai</option>
                  <option value="Kia">Kia</option>
                  <option value="Nissan">Nissan</option>
                  <option value="Chevrolet">Chevrolet</option>
                  <option value="Volkswagen">Volkswagen</option>
                  <option value="Mazda">Mazda</option>
                  <option value="Suzuki">Suzuki</option>
                  <option value="Mitsubishi">Mitsubishi</option>
                  <option value="Honda">Honda</option>
                  <option value="Ford">Ford</option>
                  <option value="Renault">Renault</option>
                  <option value="Chery">Chery</option>
                  <option value="Great Wall">Great Wall</option>
                  <option value="Geely">Geely</option>
                  <option value="JAC">JAC</option>
                  <option value="Dongfeng">Dongfeng</option>
                  <option value="Subaru">Subaru</option>
                  <option value="BMW">BMW</option>
                  <option value="Mercedes-Benz">Mercedes-Benz</option>
                  <option value="Audi">Audi</option>
                  <option value="Peugeot">Peugeot</option>
                  <option value="Fiat">Fiat</option>
                  <option value="Isuzu">Isuzu</option>
                  <option value="SsangYong">SsangYong</option>
                  <option value="Volvo">Volvo</option>
                  <option value="Land Rover">Land Rover</option>
                </select>
                <label for="marca_vehiculo">
                  <i class="fas fa-car me-2"></i> Marca
                </label>
              </div>
            </div>

            <!-- Modelo -->
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="modelo" name="modelo" maxlength="73" minlength="1" required>
                <label for="modelo">
                  <i class="fas fa-car-side me-2"></i> Modelo
                </label>
              </div>
            </div>
          </div>

          <div class="row">
            <!-- Placa -->
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="placa" name="placa"
                  pattern="[A-Za-z]{1}[A-Za-z0-9]{1}[A-Za-z]{1}-[0-9]{3}"
                  maxlength="7" minlength="7" required>
                <label for="placa">
                  <i class="fas fa-clipboard-check me-2"></i> Placa (Ej: A1B-123 o ABC-123)
                </label>
              </div>
            </div>

            <!-- Capacidad -->
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="capacidad" name="capacidad" pattern="[0-9]+" title="Solo números" maxlength="5" required>
                <label for="capacidad">
                  <i class="fas fa-users me-2"></i> Capacidad kg
                </label>
              </div>
            </div>

            <!-- Condición -->
            <div class="col-md-4 mb-3">
              <div class="form-floating">
                <select class="form-select" id="condicion" name="condicion" required disabled>
                  <option value="operativo" selected>Operativo</option>
                  <option value="taller">Taller</option>
                  <option value="averiado">Averiado</option>
                </select>
                <label for="condicion">
                  <i class="fas fa-cog me-2"></i> Condición
                </label>
              </div>
            </div>
          </div>
        </form>
      </div>

      <!-- Footer con los botones -->

      <div class="card-footer">
        <div class="d-flex justify-content-between mt-2 mb-2">
          <div>
            <a href="index.php" class="btn btn-primary ">Listar vehiculos</a>
          </div>
          <div class="text-end">
            <button type="submit" class="btn btn-success" form="form-registrar-Vehiculo">Registrar </button>
            <button type="reset" class="btn btn-outline-danger">Cancelar</button>
          </div>
        </div>
      </div>
</main>
<script src="http://localhost/distribumax/js/vehiculos/registrar.js"></script>
<?php require_once '../footer.php'; ?>