<?php
require_once '../../header.php';
?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Ventas</h1>
    <ol class="breadcrumb mb-4"></ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Registro de venta
      </div>
      <div class="card-body">
        <form method="POST" action="#" autocomplete="off" id="form-venta-registrar">

          <!-- Selección de Pedido -->

          <div class="mb-4">
            <h5>Cliente</h5>
            <div class="row mb-3">
              <div class="col-md-4">
                <input type="text" class="form-control" id="tipocliente" placeholder="Tipo Cliente" readonly>
              </div>
              <div class="col-md-4">
                <input type="text" id="nombres" class="form-control" placeholder="Nombres" readonly>
              </div>
              <div class="col-md-4">
                <input type="text" id="direccion" class="form-control" placeholder="Dirección" readonly>
              </div>
            </div>
          </div>
          <!-- BUSCADOR -->
          <div class="mb-4">
            <h5>Pedido</h5>
            <div class="row mb-3">
              <div class="col">
                <div class="form-floating">
                  <input type="search" class="form-control" id="idpedido" list="datalistIdPedido" placeholder="Buscar ID pedido" required>
                  <label for="idpedido">Buscar ID pedido</label>
                  <ul id="datalistIdPedido" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                  <!-- <label for="idpedido">Pedido</label> -->
                  <!-- <datalist id="datalistProducto" class="list-group position-absolute w-100" style="z-index: 1000; display: none;"></datalist> -->
                  <div id="mensaje-error" style="color: red; display: none;">No existe el pedido</div>
                </div>
              </div>
            </div>
          </div>
          <!-- FIN DEL BUSCADOR -->
          <!-- Tabla de Productos -->
          <div class="table-responsive my-4"> <!-- Añadido margin top y bottom -->
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


          <!-- datos -->
          <div class="mb-4">
            <div class="row mb-3">
              <div class="col-md-4">
                <div class="form-floating">
                  <input type="datetime-local" class="form-control" id="fecha_venta" name="fecha_venta" required>
                  <label for="fecha_venta">Fecha de Venta</label>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-floating">
                  <select name="" id="idmetodopago" class="form-select" required>
                    <option value=""></option>
                  </select>
                  <label for="fecha_venta">Metodo de Pago</label>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-floating">
                  <select name="" id="idtipocomprobante" class="form-select" required>
                    <option value=""></option>
                  </select>
                  <label for="fecha_venta">Tipo de Comprobante</label>
                </div>
              </div>
            </div>
          </div>
          <!-- Totales -->
          <div class="mb-4">
            <h5>Totales</h5>
            <div class="row mb-3">

              <div class="col-md-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="subtotal" name="subtotal" required readonly>
                  <label for="subtotal">Subtotal</label>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="descuento" name="descuento" value="0.00" min="0" required readonly>
                  <label for="descuento">Descuento</label>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="igv" name="igv" value="0.00" required readonly>
                  <label for="igv">IGV</label>
                </div>
              </div>
              <div class="col-md-3">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="total_venta" name="total_venta" required readonly>
                  <label for="total_venta">Total Venta</label>
                </div>
              </div>

            </div>
          </div>



          <!-- Botones -->
          <div class="d-flex justify-content-end mt-4">
            <button type="submit" class="btn btn-primary me-2">Registrar Venta</button>
            <button type="reset" class="btn btn-secondary">Cancelar</button>
          </div>

        </form>

        <div class="card-footer">
          <a href="index.php" class="btn btn-primary">Listar ventas</a>
        </div>
      </div>
    </div>
  </div>
</main>

<?php require_once '../../footer.php'; ?>
<script src="../../js/ventas/registrar.js"></script>
</body>

</html>