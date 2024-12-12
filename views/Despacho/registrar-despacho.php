<?php
require_once '../header.php';
?>
<main>
  <div class="container-fluid px-4 mt-4">
  
    <!-- Card para el Registro de Vehículo -->
    <div class="card mb-4">
      <!-- // ? CABECERA DE LA TARJETA -->
      <div class="card-header">
        <i class="fas fa-car me-1"></i>
        Datos del despacho
      </div>
      <!-- // ? CUERPOR DE LA TARJETA -->
      <form action="" method="" id="AddDespacho" autocomplete="off">
        <!-- CUERPO DE LA TARJETA -->
        <div class="col-4 mt-1">
          <input type="hidden" id="idusuario" value="<?= $_SESSION['login']['idusuario'] ?>">
          <span class="badge text-bg-light text-uppercase text-end  " data-id="<?= $_SESSION['login']['idusuario'] ?>">
            <?= $_SESSION['login']['perfil']  ?> :
            <?= $_SESSION['login']['nombres']  ?>
            <?= $_SESSION['login']['appaterno']  ?>
            <?= $_SESSION['login']['apmaterno']  ?>
          </span>
        </div>
        <div class="card-body">

          <!-- FILA 01 -->
          <div class="row">
          
            <div class="col-md-3 mb-3">
              <div class="form-floating position-relative">
                <input type="hidden" id="idconductor_vehiculo">
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
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                
                <input type="text" class="form-control" id="conductor" name="marca_vehiculo" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i> Conductor</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating position-relative">
                <input
                  type="search"
                  class="form-control"
                  id="idjefe_mercaderia"
                  name=""
                  placeholder="Venta"
                  required>
                <label for="idvehiculo" class="form-label"><i class="bi bi-car-front"></i>Buscar Jefe Mercaderia</label>
                <ul id="list-jefe_mercaderia" class="list-group position-absolute w-100 " style="z-index: 1000; display: none; top: 100%;">
                </ul>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="nombres" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i>Nombres</label>
              </div>
            </div>
          </div>
          <!-- FILA 02 -->
          <div class="row">
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="placa" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i>Placa</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="marca_vehiculo" name="marca_vehiculo" maxlength="23" minlength="3" disabled>
                <label for="marca"><i class="fas fa-car me-2"></i>Marca</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="apellidos" maxlength="23" minlength="3" disabled>
                <label for=""><i class="fas fa-car me-2"></i>Apellidos</label>
              </div>
            </div>
            <div class="col-md-3 mb-3">
              <div class="form-floating">
                <input type="text" class="form-control" id="documento" maxlength="23" minlength="3" disabled>
                <label for=""><i class="fas fa-car me-2"></i>Nro Documento</label>
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
                <select class="form-select" id="provincia" aria-label="Default select example" placeholder="">
                  <option value="">Seleccionar una provincia</option>
                </select>
                <label for="provincia" class="form-label">Seleccione provincia</label>
              </div>
            </div>
            <div class="col-md-6 mb-3">
              <div class="col-md-6 mb-3">
                <div class="form-floating">
                  <input type="date" class="form-control" id="fecha-despacho" name="marca_vehiculo" maxlength="23" minlength="3" required>
                  <label for="marca"><i class="fas fa-car me-2"></i> Fecha Despacho</label>
                </div>
              </div>
            </div>
            <!-- </div> -->
          </div>
          <hr>
          <!-- CIONTENERDOR DE LA TABLA -->
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
          <!-- FIN DE LA TABLA -->
        </div>
        <!-- FIN DEL CUERPO DE LA TARJETA -->
        <!-- //  ? PIE DE LA TARJETA -->
        <div class="card-footer">
          <div class="d-flex justify-content-between mt-2 mb-2">
            <div>
              <a href="index.php" class="btn btn-primary ">Listar despacho</a>
            </div>
            <div class="text-end">
              <button type="submit" class="btn btn-success">Registrar </button>
              <button type="reset" class="btn btn-outline-danger">Cancelar</button>
            </div>
          </div>
        </div>
        <!-- //? FIN DE PIE DE PAGINA -->
      </form>
    </div>
  </div>
</main>
<?php require_once '../footer.php'; ?>
<script src="../../js/despacho/registrar.js"></script>
<script src="../../js/Despacho/buscar-pedidos.js"></script>
</body>

</html>