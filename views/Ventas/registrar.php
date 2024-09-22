<?php
require_once '../../header.php';
?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Empresas</h1>
    <ol class="breadcrumb mb-4"></ol>

    <div class="card mb-4">
      <div class="card-header">
        <i class="fas fa-table me-1"></i>
        Listado de Empresas
      </div>
      <div class="card-body">
        <form method="POST" action="#">
          
          <!-- Selección de Pedido -->
          <div class="mb-4">
            <h5>Pedido</h5>
            <div class="row mb-3">
              <div class="col-md-6">
                <div class="form-floating">
                  <select class="form-control" id="idpedido" name="idpedido" required onchange="cargarProductos()">
                    <option value="">Seleccione un pedido</option>
                    <!-- Opciones dinámicas -->
                  </select>
                  <label for="idpedido">Pedido</label>
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-floating">
                  <input type="datetime-local" class="form-control" id="fecha_venta" name="fecha_venta" required>
                  <label for="fecha_venta">Fecha de Venta</label>
                </div>
              </div>
            </div>
          </div>

          <!-- Tabla de Productos -->
          <h5>Productos</h5>
          <table class="table">
            <thead>
              <tr>
                <th>Producto</th>
                <th>Cantidad</th>
                <th>Precio Unitario</th>
                <th>Total</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody id="productosTabla">
              <!-- Productos se llenarán aquí -->
            </tbody>
          </table>

          <!-- Totales -->
          <div class="mb-4">
            <h5>Totales</h5>
            <div class="row mb-3">
              <div class="col-md-4">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="subtotal" name="subtotal" required readonly>
                  <label for="subtotal">Subtotal</label>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-floating">
                  <input type="number" step="0.01" class="form-control" id="igv" name="igv" value="0.00" required readonly>
                  <label for="igv">IGV</label>
                </div>
              </div>
              <div class="col-md-4">
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

<?php
require_once '../../footer.php';
?>

<script>
async function cargarProductos() {
  const idPedido = document.getElementById('idpedido').value;
  
  if (!idPedido) return;

  try {
    const response = await fetch(`../../controller/pedido.controller.php?operation=getProductos&idpedido=${idPedido}`);
    const productos = await response.json();

    const productosTabla = document.getElementById('productosTabla');
    productosTabla.innerHTML = ''; // Limpiar tabla antes de llenar

    let subtotal = 0;

    productos.forEach(producto => {
      const total = producto.precio_unitario * producto.cantidad;
      subtotal += total;

      const row = `
        <tr>
          <td>${producto.nombre}</td>
          <td>${producto.cantidad}</td>
          <td>${producto.precio_unitario.toFixed(2)}</td>
          <td>${total.toFixed(2)}</td>
          <td><button type="button" class="btn btn-danger" onclick="eliminarProducto(this)">Eliminar</button></td>
        </tr>
      `;
      productosTabla.innerHTML += row;
    });

    const igv = subtotal * 0.18; // 18% de IGV
    const totalVenta = subtotal + igv;

    document.getElementById('subtotal').value = subtotal.toFixed(2);
    document.getElementById('igv').value = igv.toFixed(2);
    document.getElementById('total_venta').value = totalVenta.toFixed(2);
  } catch (error) {
    console.error(error);
  }
}

function eliminarProducto(button) {
  const row = button.closest('tr');
  row.remove();
  calcularTotales();
}

function calcularTotales() {
  const rows = document.querySelectorAll('#productosTabla tr');
  let subtotal = 0;

  rows.forEach(row => {
    const total = parseFloat(row.cells[3].innerText);
    subtotal += total;
  });

  const igv = subtotal * 0.18;
  const totalVenta = subtotal + igv;

  document.getElementById('subtotal').value = subtotal.toFixed(2);
  document.getElementById('igv').value = igv.toFixed(2);
  document.getElementById('total_venta').value = totalVenta.toFixed(2);
}
</script>
