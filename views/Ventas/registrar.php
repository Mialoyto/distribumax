<?php
require_once '../header.php';
?>

<main>
  <div class="container-fluid px-4">

    <ol class="breadcrumb mb-4"></ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Registro de venta
      </div>
      <div class="card-body">
        <form method="POST" action="#" autocomplete="off" id="form-venta-registrar">
          <!-- Obtener el id de la sesion -->
          <input type="hidden" id="idusuario" value="<?= $_SESSION['login']['idusuario'] ?>">
          <div class="col-4 mt-1">
            <span class="badge text-bg-light text-uppercase text-end  " id="iduser" data-id="<?= $_SESSION['login']['idusuario'] ?>">
              <?= $_SESSION['login']['perfil']  ?> :
              <?= $_SESSION['login']['nombres']  ?>
              <?= $_SESSION['login']['appaterno']  ?>
              <?= $_SESSION['login']['apmaterno']  ?>
            </span>
          </div>
          <!-- Selección de Pedido -->
          <div class="mt-2">
            <h5 >Cliente</h5>
            <div class="row mb-3">
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" class="form-control" id="tipocliente" placeholder="Tipo Cliente" disabled>
                  <label for="tipocliente">Tipo Cliente</label>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" id="nombres" class="form-control" placeholder="Nombres" disabled>
                  <label for="nombres">Nombres</label>
                </div>
              </div>
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="text" id="direccion" class="form-control" placeholder="Dirección" disabled>
                  <label for="direccion">Dirección</label>
                </div>
              </div>
            </div>
          </div>

          <!-- BUSCADOR -->

          <h5>Pedido</h5>
          <div class="row mb-3">
            <div class="col">
              <div class="form-floating">
                <input type="search" class="form-control" id="idpedido" list="datalistIdPedido" placeholder="Buscar ID pedido" required>
                <label for="idpedido">Buscar pedido (PED-)</label>
                <ul id="datalistIdPedido" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                <!-- <div id="mensaje-error" style="color: red; display: none;">No existe el pedido</div> -->
              </div>
            </div>
          </div>


          <!-- Tabla de Productos -->
          <div class="table-responsive my-4">
            <table class="table table-striped table-sm" id="productosTabla">
              <thead>
                <tr>
                  <th>Producto</th>
                  <th>Unidad de Medida</th>
                  <th>Cantidad</th>
                  <th>Precio Unitario</th>
                  <th>Descuento</th>
                  <th>Total</th>
                </tr>
              </thead>
              <tbody>
                <!-- Productos se llenarán aquí -->
              </tbody>
            </table>
          </div>

          <hr>
          <!-- Datos de Venta -->
          <div class="mb-4">
            <div class="row">
              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <input type="datetime-local" class="form-control" id="fecha_venta" name="fecha_venta" required disabled>
                  <label for="fecha_venta">Fecha de Venta</label>
                </div>
              </div>

              <div class="col-md-4 mb-3" id="tipo_comprobante_container">
                <div class="form-floating">
                  <select id="idtipocomprobante" class="form-select" disabled>
                    <option value="">Selecione comprobante</option>
                  </select>
                  <label for="idtipocomprobante">Tipo de Comprobante</label>
                </div>
              </div>

              <div class="col-md-4 mb-3">
                <div class="form-floating">
                  <select id="tipo_pago" class="form-select" disabled>
                    <option value="">Seleccione tipo de pago</option>
                    <option value="unico">Pago Único</option>
                    <option value="mixto">Pago Mixto</option>
                  </select>
                  <label for="tipo_pago">Tipo de Pago</label>
                </div>
              </div>

            </div>
          </div>

          <!-- Métodos de Pago -->
          <div id="loadMetodos" style="display: none;"> <!-- Ocultar por defecto -->
            <div class="mb-4">
              <div class="d-inline-flex justify-content-center align-items-center gap-1">
                <h5 class="mb-3">Métodos de Pago</h5>
                <button type="button" class="btn btn-primary mb-3" id="add-metodo"><i class="fa-solid fa-plus fa-lg"></i></button>
              </div>

              <div class="row mt-3" id="container-metodos">
                <!-- SELECT 01 -->
                <div class="col-md-6 mb-3 metodos">
                  <div class="input-group">
                    <div class="form-floating">
                      <select id="idmetodopago" class="form-select metodo" name="idmetodopago">
                        <option value="">Selecione método</option>
                        <!-- Agrega más opciones según sea necesario -->
                      </select>
                      <label for="idmetodopago">Método de Pago</label>
                    </div>
                    <div class="form-floating mb-3 montos">
                      <input type="number" step="0.01" min="1" class="form-control monto monto_pago_1" id="monto_pago_1" name="monto_pago_1" placeholder="Monto">
                      <label for="monto_pago_2">Monto</label>
                    </div>
                  </div>
                </div>
                <!-- FIN SELECT 01 -->

              </div>
            </div>
          </div>

          <!-- Totales -->
          <div class="mb-4">
            <h5>Totales</h5>
            <div class="row">
              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="subtotal" name="subtotal" required disabled>
                  <label for="subtotal">Subtotal</label>
                </div>
              </div>
              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="descuento" name="descuento" value="0.00" min="0" required disabled>
                  <label for="descuento">Descuento</label>
                </div>
              </div>
              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="igv" name="igv" value="0.00" required disabled>
                  <label for="igv">IGV</label>
                </div>
              </div>
              <div class="col-md-3 mb-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="total_venta" name="total_venta" required disabled>
                  <label for="total_venta">Total Venta</label>
                </div>
              </div>
            </div>
          </div>

          <!-- Botones -->
          

        </form>
      </div>
      
      <div class="card-footer">
        <div class="d-flex justify-content-between mt-2 mb-2">
          <div>
            <a href="index.php" class="btn btn-primary ">Listar ventas</a>
          </div>
          <div class="text-end">
            <button type="submit" class="btn btn-success" form="form-venta-registrar">Registrar</button>
            <button type="reset" class="btn btn-outline-danger">Cancelar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/ventas/registrar.js"></script>


</body>

</html>