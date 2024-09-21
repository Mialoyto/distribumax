<?php require_once '../../header.php'; ?>
<main>
    <div class="container mt-4">
        <!-- Formulario en un solo card -->
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header text-center">
                <h2 class="card-title">Registro de Pedido y Detalles</h2>
                <!-- tailwindcss -->
                <h1 class="text-3xl font-bold underline">
                    Hello world!
                </h1>
            </div>
            <div class="card-body">
                <span class="badge text-bg-info text-uppercase fs-6 d-block d-lg-inline" id="<?= $_SESSION['login']['idusuario']  ?>">
                    <?= $_SESSION['login']['rol']  ?> :
                    <?= $_SESSION['login']['nombres']  ?>
                    <?= $_SESSION['login']['appaterno']  ?>
                    <?= $_SESSION['login']['apmaterno']  ?>
                </span>

                <!-- Sección de Registro de Pedido -->
                <h5 class="mb-3 mt-3 card-title">Datos del cliente</h5>
                <!-- fomrluario para enviar pedidos -->
                <form method="POST" action="#" id="registrar-pedido" autocomplete="off">
                    <!-- fila 01 -->
                    <div class="row g-3 mb-3">

                        <div class="col-md-6 mb-2">
                            <!-- selecc de tipo de documento -->
                            <div class="form-floating">
                                <select class="form-control" id="id-tip-doc" name="id-tip-doc" disabled="true" required>
                                    <option value="">Tipo de documento</option>
                                    <!-- Opciones dinámicas -->
                                </select>
                                <label for="idcliente" class="form-label"><i class="fa-regular fa-id-card fa-lg"></i> Tipo de documento </label>
                            </div>
                            <!-- fin de selec de tipo de documento -->
                        </div>
                        <div class="col-md-6 mb-2">
                            <div class="form-floating">
                                <input type="number" class="form-control" id="nro-doc" name="nro-doc" placeholder="Número de documento" required>
                                <label for="nro-doc" class="form-label"> Número de documento</label>
                            </div>
                        </div>
                    </div>
                    <!-- fila 2 -->
                    <div class="row g-3 mb-3">

                        <div class="col-md-4 mt-3">
                            <div class="form-floating">
                                <input class="form-control" id="nombres" name="nombres" type="text" placeholder="nombres" required />
                                <label for="nombres">Nombres</label>
                            </div>
                        </div>
                        <div class="col-md-4 mt-3">
                            <div class="form-floating">
                                <input class="form-control" id="appaterno" name="appaterno" type="text" placeholder="appaterno" required />
                                <label for="appaterno">Apellido paterno</label>
                            </div>
                        </div>

                        <div class="col-md-4 mt-3">
                            <div class="form-floating">
                                <input class="form-control" id="apmaterno" name="apmaterno" type="text" placeholder="Apellido apmaterno" required />
                                <label for="apmaterno">Apellido materno</label>
                            </div>
                        </div>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6 mt-3">
                            <div class="form-floating">
                                <input class="form-control" id="razon-social" name="razon-social" type="text" placeholder="Razon social" required />
                                <label for="razon-social">Razón social</label>
                            </div>
                        </div>
                        <div class="col-md-6 mt-3">
                            <div class="form-floating">
                                <input class="form-control" id="direccion-cliente" name="direccion-cliente" type="text" placeholder="Dirección cliente" required />
                                <label for="direccion-cliente">Dirección cliente</label>
                            </div>
                        </div>

                    </div>

                    <hr class="my-3">

                    <!-- Sección de Detalle de Pedido -->
                    <div>
                        <h5 class="mb-3">Detalle del Pedido</h5>
                    </div>

                    <!-- Tabla de productos del pedido -->
                    <div class="table-responsive bs-warning">
                        <table class="table table-striped table-hover table-secondar" id="detalle-productos">
                            <thead class="bg-primary">
                                <tr>
                                    <th>Producto</th>
                                    <th>Cantidad</th>
                                    <th>Unidad Medida</th>
                                    <th>Precio Unitario</th>
                                    <th>Descuento</th>
                                    <th>Subtotal</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- primer detalle -->
                                <tr>
                                    <th class="col-md-3">
                                        <div class="mt-1">
                                            <select class="form-control form-control-sm" name="idproducto" id="idproducto" name="idproducto">
                                                <option value="">Seleccione un producto</option>
                                                <option value="1">Prodcuto 1</option>
                                                <!-- Opciones dinámicas -->
                                            </select>
                                        </div>
                                    </th>
                                    <th class="col-md-1">
                                        <div class="mt-1">
                                            <input class="form-control form-control-sm cantidad" name="cantidad" type="text" aria-label=".form-control-sm example">
                                        </div>
                                    </th>
                                    <th class="col-md-1">
                                        <div class="mt-1">
                                            <input class="form-control form-control-sm und-medida" name="und-medida" type="text" aria-label=".form-control-sm example">
                                        </div>
                                    </th>
                                    <th class="col-md-1">
                                        <div class="mt-1">
                                            <input class="form-control form-control-sm precio-unitario" name="precio-unitario" type="text" aria-label=".form-control-sm example">
                                        </div>
                                    </th>
                                    <th class="col-md-1">
                                        <div class="mt-1">
                                            <input class="form-control form-control-sm descuento" name="descuento" type="text" aria-label=".form-control-sm example">
                                        </div>
                                    </th>
                                    <th class="col-md-1">
                                        <div class="mt-1">
                                            <input class="form-control form-control-sm subtotal" name="subtotal" type="text" aria-label=".form-control-sm example">
                                        </div>
                                    </th>
                                    <th class="col-md-1">
                                        <div class="mt-1  d-flex justify-content-evenly">
                                            <button type="button" class="btn btn-warning btn-sm w-100">
                                                <i class="bi bi-pencil-square"></i>
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm w-100">
                                                <i class="bi bi-x-square"></i>
                                            </button>
                                        </div>
                                    </th>
                                </tr>
                                <!-- fin del detalle -->
                            </tbody>
                        </table>
                    </div>
                    <!-- fin tabla productos -->
                    <!-- Botones -->

                    <div class="text-end">
                        <!-- Botón para agregar producto a la tabla -->
                        <div class="d-flex justify-content-end mb-3">
                            <button type="button" class="btn btn-outline-success" id="agregar-producto">
                                <i class="bi bi-plus-circle"></i>
                            </button>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end mt-3">
                        <button type="submit" class="btn btn-primary me-2 transition">Registrar Pedido</button>
                        <button type="reset" class="btn btn-outline-danger">Cancelar</button>
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