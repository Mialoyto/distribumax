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
          <div class="row">
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="conductor" name="marca_vehiculo" maxlength="23" minlength="3" readonly>
                <label for="marca"><i class="fas fa-car me-2"></i> Conductor</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="modelo" name="marca_vehiculo" maxlength="23" minlength="3" readonly>
                <label for="marca"><i class="fas fa-car me-2"></i> Modelo</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="capacidad" name="marca_vehiculo" maxlength="23" minlength="3" readonly>
                <label for="marca"><i class="fas fa-car me-2"></i> Capacidad</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="search" class="form-control" id="placa" name="marca_vehiculo" maxlength="23" minlength="3" readonly>
                <label for="marca"><i class="fas fa-car me-2"></i> Placa</label>
              </div>
            </div>
          </div>

          <div class="row">
            <hr>
            <div>
              <h5 class="mb-3">Detalle del Pedido</h5>
            </div>
            <div class="col-md-6 mb-3">
              <div class="form-floating position-relative">
                <input
                  type="search"
                  class="form-control"
                  id="provincia"
                  name="idproveedor"
                  placeholder="Provincia"
                  required>
                <label for="provincia" class="form-label">Buscar Provincia</label>

                <!-- Botón GetAll posicionado dentro de la estructura de input group -->
                <div class="input-group-append position-absolute" style="right: 10px; top: 50%; transform: translateY(-50%);">
                  <button class="btn btn-primary" id="btnGetAll">Get All</button>
                </div>

                <!-- Lista de ventas para mostrar resultados de búsqueda -->
                <ul
                  id="list-provincias"
                  class="list-group position-absolute w-100 "
                  style="z-index: 1000; display: none; top: 100%;">
                </ul>
              </div>
            </div>

          </div>
          <div class="table-responsive">
            <table class="table table-striped table-hover table-secondar" id="detalle-ventas">
              <thead class="bg-primary">
                <tr>
                  <th scope="col">código</th>
                  <th scope="col">Producto</th>
                  <th scope="col">Cantidad</th>
                  <th scope="col">Unidad Medida</th>
                  <th scope="col">Precio Unitario</th>
                  <th scope="col">Subtotal</th>
                  <th scope="col span-2">% Descuento</th>
                  <th scope="col">Total</th>
                  <th scope="col">Acciones</th>
                </tr>
              </thead>
              <tbody id="detalle-ventas">
                <!-- primer detalle -->

                <!-- fin del detalle -->
              </tbody>
            </table>
          </div>
          <button type="submit" class="btn btn-primary">Registrar</button>
          <button type="reset" class="btn btn-danger">Cancelar</button>
        </form>
      </div>
      <!-- //  ? PIE DE LA TARJETA -->
      <div class="card-footer">
        <a href="index.php" class="btn btn-secondary">Listar</a>
      </div>
    </div>
  </div>
</main>
<script src="../../js/despacho/registrar.js"></script>
<script src="../../js/Despacho/buscar-pedidos.js"></script>
<?php
require_once '../footer.php'; ?>