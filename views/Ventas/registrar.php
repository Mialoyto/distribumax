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
            <span class="badge text-bg-light text-uppercase text-end " id="iduser" >
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
                  <label for="idpedido">Buscar pedido (PED-)</label>
                  <ul id="datalistIdPedido" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                  <div id="mensaje-error" style="color: red; display: none;">No existe el pedido</div>
                </div>
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

          <!-- Datos de Venta -->
          <div class="mb-4">
            <div class="row mb-3">
              <div class="col-md-4">
                <div class="form-floating">
                  <input type="datetime-local" class="form-control" id="fecha_venta" name="fecha_venta" required readonly>
                  <label for="fecha_venta">Fecha de Venta</label>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-floating">
                  <select id="tipo_pago" class="form-select"  onchange="togglePaymentMethod()">
                    <option value=""></option>
                    <option value="unico">Pago Único</option>
                    <option value="mixto">Pago Mixto</option>
                  </select>
                  <label for="tipo_pago">Tipo de Pago</label>
                </div>
              </div>
              <div class="col-md-4" id="tipo_comprobante_container">
                <div class="form-floating">
                  <select id="idtipocomprobante" class="form-select" required>
                    <option value=""></option>
                  </select>
                  <label for="idtipocomprobante">Tipo de Comprobante</label>
                </div>
              </div>
            </div>
          </div>

          <!-- Métodos de Pago -->
          <div id="paymentMethodsContainer" style="display: none;"> <!-- Ocultar por defecto -->
            <div class="mb-4">
              <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Métodos de Pago</h5>
                <button type="button" id="agregar" class="btn btn-primary btn-sm" onclick="addPaymentMethod()">+</button>
              </div>

              <div class="row mb-3">
                <div class="col-md-6 metodos" id="">
                  <div class="form-floating">
                    <select id="idmetodopago" class="form-select  metodo" >
                      <option value=""></option>
                      <!-- Agrega más opciones según sea necesario -->
                    </select>
                    <label for="idmetodopago">Método de Pago 1</label>
                  </div>
                  <div class="form-floating montos">
                    <input type="number" step="0.01" class="form-control monto" id="monto_pago_1" placeholder="Monto">
                    <label for="monto_pago_2">Monto 1</label>
                  </div>
                </div>
                <div class="col-md-6 metodos" id="metodo_pago_2" style="display: none;">
                  <div class="form-floating">
                    <select id="idmetodopago_2" class="form-select metodo">
                      <option value=""></option>

                      <!-- Agrega más opciones según sea necesario -->
                    </select>
                    <label for="idmetodopago_2">Método de Pago 2</label>
                  </div>
                  <div class="form-floating montos">
                    <input type="number" step="0.01" class="form-control monto" id="monto_pago_2" placeholder="Monto" >
                    <label for="monto_pago_2">Monto 2</label>
                  </div>
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
<script>
  function togglePaymentMethod() {
    const tipoPago = document.getElementById("tipo_pago").value;
    const paymentMethodsContainer = document.getElementById("paymentMethodsContainer");
    const metodoPago2 = document.getElementById("metodo_pago_2");

    // Muestra el contenedor de métodos de pago solo si el tipo de pago no está vacío
    if (tipoPago) {
      paymentMethodsContainer.style.display = "block";

      // Muestra el segundo método de pago si se selecciona "Mixto"
      if (tipoPago === "mixto") {
        metodoPago2.style.display = "block"; // Mostrar segundo método
      } else {
        metodoPago2.style.display = "none"; // Ocultar segundo método si no es mixto
      }
    } else {
      paymentMethodsContainer.style.display = "none"; // Ocultar si no se ha seleccionado nada
      metodoPago2.style.display = "none"; // Asegúrate de ocultar también el segundo método
    }
  }
</script>
<script>

async  function  ValidarSelect(){

  const tipoPagoSelect = $("#tipo_pago");
  const metodoPago1Select = $("#idmetodopago");
  const metodoPago2Select = $("#idmetodopago_2");
  const metodoPago2Container = $("#metodo_pago_2");

  // Función para manejar la selección de tipo de pago
  tipoPagoSelect.addEventListener("change", () => {
    if (tipoPagoSelect.value === "mixto") {
      metodoPago2Container.style.display = "block"; // Mostrar método de pago 2
    } else {
      metodoPago2Container.style.display = "none"; // Ocultar método de pago 2
      metodoPago2Select.value = ""; // Reiniciar selección del método de pago 2
    }
  });

  // Función para manejar la selección del primer método de pago
  metodoPago1Select.addEventListener("change", () => {
    const selectedOption = metodoPago1Select.value;

    // Habilitar todas las opciones del segundo select antes de proceder
    Array.from(metodoPago2Select.options).forEach(option => {
      option.disabled = false;
    });

    // Deshabilitar la opción seleccionada en el primer select en el segundo select
    if (selectedOption) {
      Array.from(metodoPago2Select.options).forEach(option => {
        if (option.value === selectedOption) {
          option.disabled = true;
        }
      });
    }
  });
}
//ValidarSelect();

  
</script>
</body>

</html>