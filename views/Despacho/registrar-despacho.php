<?php
require_once '../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Despacho</h1>
    <!-- Card para el Registro de Vehículo -->
    <div class="card mb-4">
      <!-- // ? CABECERA DE LA TARJETA -->
      <div class="card-header">
        <i class="fas fa-car me-1"></i>
        Datos del despacho
      </div>
      <!-- // ? CUERPOR DE LA TARJETA -->
      <div class="card-body">
        <form action="" method="" id="form-registrar-despacho" autocomplete="off">
          <!-- FILA 01 -->
          <div class="row">
            <div class="col-md-6 mb-3">
              <div class="form-floating position-relative">
                <input
                  type="search"
                  class="form-control"
                  id="idvehiculo"
                  name=""
                  placeholder="Venta"
                  required>
                <label for="idvehiculo" class="form-label"><i class="bi bi-car-front"></i> Buscar placa</label>
                <ul id="list-vehiculo" class="list-group position-absolute w-100 " style="z-index: 1000; display: none; top: 100%;">
                </ul>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <input type="date" class="form-control" id="fecha_despacho" name="marca_vehiculo" maxlength="23" minlength="3" required>
                <label for="marca"><i class="fas fa-car me-2"></i> Fecha Despacho</label>
              </div>
            </div>
          </div>
          <!-- FILA 02 -->
          <div class="row">
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="conductor" name="marca_vehiculo" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i> Conductor</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="modelo" name="marca_vehiculo" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i> Modelo</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="capacidad" name="marca_vehiculo" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i> Capacidad</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="placa" name="marca_vehiculo" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i> Placa</label>
              </div>
            </div>
          </div>

          <hr>
          <div>
            <h5 class="mb-3">Detalle del despacho</h5>
          </div>
          <div class="row">
            <!-- <div class="row"> -->
            <div class="col-md-6 mb-3">
              <div class="form-floating">
                <select class="form-select" id="provincia" aria-label="Default select example" placeholder="" required>
                  <option value="">Seleccionar una provincia</option>
                </select>
                <label for="provincia" class="form-label">Seleccione provincia</label>
              </div>
            </div>
            <!-- </div> -->
          </div>
          <hr>
          <div class="table-responsive">
            <table class="table table-striped table-hover table-secondar" id="detalle-despacho">
              <thead class="bg-primary">
                <tr>
                  <th scope="col">código</th>
                  <th scope="col">Producto</th>
                  <th scope="col">Unidad Medida</th>
                  <th scope="col">Cantidad</th>
                  <th scope="col">Monto</th>
                </tr>
              </thead>
              <tbody id="detalle-ventas">
                <!-- primer detalle -->

                <!-- fin del detalle -->
              </tbody>
            </table>
          </div>

        </form>
      </div>
      <!-- //  ? PIE DE LA TARJETA -->
      <div class="card-footer">
        <div class="d-flex justify-content-between mt-2 mb-2">
          <div>
            <a href="index.php" class="btn btn-secondary">Listar</a>
          </div>
          <div class="text-end">
            <button type="submit" class="btn btn-success">Registrar</button>
            <button type="reset" class="btn btn-outline-danger">Cancelar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>
<script src="../../js/despacho/registrar.js"></script>
<script src="../../js/Despacho/buscar-pedidos.js"></script>
<?php
require_once '../footer.php'; ?>