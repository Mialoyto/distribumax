<?php require_once '../../header.php'; ?>
<main>
  <div class="container mt-4">
    <!-- Formulario en un solo card -->
    <div class="card shadow-lg border-0 rounded-lg">
      <div class="card-header text-center">
        <h2 class="card-title">Registro de Pedido y Detalles</h2>
      </div>
      <div class="card-body">
        <!-- fomrluario para enviar pedidos -->
        <form method="POST" action="#" id="registrar-pedido" autocomplete="off">
          <!-- Sección de Registro de Pedido -->
          <span class="badge text-bg-light text-uppercase text-end " id="idvendedor" data-id="<?= $_SESSION['login']['idusuario'] ?>">
            <?= $_SESSION['login']['rol']  ?> :
            <?= $_SESSION['login']['nombres']  ?>
            <?= $_SESSION['login']['appaterno']  ?>
            <?= $_SESSION['login']['apmaterno']  ?>
          </span>
          <h5 class="mb-3 mt-3 card-title">Datos del cliente</h5>
          <!-- fila 01 -->
          <div class="row g-3 mb-3">
            <div class="col-md-6 mb-2">

              <div class="form-floating">
                <input type="search" class="form-control numeros" id="nro-doc" name="nro-doc" placeholder="Número de documento" type="number" min="1" pattern="^[0-9]+" required>
                <label for="nro-doc" class="form-label"> <i class="bi bi-search"></i> Número de documento</label>
              </div>
            </div>
            <div class="col-md-6 mb-2">
              <!-- selecc de tipo de documento -->
              <div class="form-floating">
                <select class="form-control" id="cliente" name="cliente" disabled="true" required>
                  <!-- Opciones dinámicas -->
                </select>
                <label for="idcliente" class="form-label"><i class="fa-regular fa-id-card fa-lg"></i> Tipo de cliente </label>
              </div>
              <!-- fin de selec de tipo de documento -->
            </div>
          </div>
          <!-- fila 2 -->
          <div class="row g-3 mb-3">
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input class="form-control" id="nombres" disabled="true" name="nombres" type="text" placeholder="nombres" required />
                <label for="nombres">Nombres</label>
              </div>
            </div>
            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input class="form-control" id="appaterno" disabled="true" name="appaterno" type="text" placeholder="appaterno" required />
                <label for="appaterno">Apellido paterno</label>
              </div>
            </div>

            <div class="col-md-4 mt-3">
              <div class="form-floating">
                <input class="form-control" id="apmaterno" disabled="true" name="apmaterno" type="text" placeholder="Apellido apmaterno" required />
                <label for="apmaterno">Apellido materno</label>
              </div>
            </div>
          </div>
          <div class="row g-3 mb-3">
            <div class="col-md-6 mt-3">
              <div class="form-floating">
                <input class="form-control" id="razon-social" disabled="true" name="razon-social" type="text" placeholder="Razon social" required />
                <label for="razon-social">Razón social</label>
              </div>
            </div>
            <div class="col-md-6 mt-3">
              <div class="form-floating">
                <input class="form-control" id="direccion-cliente" disabled="true" name="direccion-cliente" type="text" placeholder="Dirección cliente" required />
                <label for="direccion-cliente">Dirección cliente</label>
              </div>
            </div>
          </div>
          <hr class="my-3">
          <!-- Sección de Detalle de Pedido -->
          <div>
            <h5 class="mb-3">Detalle del Pedido</h5>
          </div>
          <!-- BUSCADOR PETICIONES -->
          <div class="col-md-8 mb-3">
            <div class="form-floating">
              <input type="search" class="form-control" id="addProducto" list="datalistProducto" placeholder="addProducto" disabled="true">
              <label for="addProducto">Agregar producto</label>
              <ul id="datalistProducto" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
            </div>
          </div>
          <!-- FIN BUSCADOR PETICIONES -->


          <!-- Tabla de productos del pedido -->
          <div class="table-responsive">
            <table class="table table-striped table-hover table-secondar" id="detalle-productos">
              <thead class="bg-primary">
                <tr>
                  <th scope="col">código</th>
                  <th scope="col">Producto</th>
                  <th scope="col">Cantidad</th>
                  <th scope="col">Unidad Medida</th>
                  <th scope="col">Precio Unitario</th>
                  <th scope="col">Subtotal</th>
                  <th scope="col span-2">% Descuento</th>
                  <th scope="col span-2">Monto Descuento</th>
                  <th scope="col">Total</th>
                  <th scope="col">Acciones</th>
                </tr>
              </thead>
              <tbody id="detalle-pedido">
                <!-- primer detalle -->

                <!-- fin del detalle -->
              </tbody>
            </table>
          </div>
          <!-- fin tabla productos -->
          <div class="d-flex justify-content-between">
            <div class="d-flex justify-content-start mt-3">
              <a class="btn btn-primary">Listar pedidos</a>
            </div>
            <!-- Botones -->
            <div class="d-flex justify-content-end mt-3">
              <button type="submit" class="btn btn-success me-2 transition">Registrar Pedido</button>
              <button type="reset" class="btn btn-outline-danger" id="cancelarPedido">Cancelar</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>
<?php require_once '../../footer.php'; ?>
<script type="module" src="http://localhost/distribumax/js/pedidos/pedidos.js"></script>


</body>

</html>