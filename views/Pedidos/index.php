<?php
require_once '../../header.php';
?>
<div class="container mt-4">
    <!-- Formulario en un solo card -->
    <div class="card shadow-lg border-0 rounded-lg">
        <div class="card-header">
            <h3 class="text-center">Registro de Pedido y Detalles</h3>
        </div>
        <div class="card-body">

            <!-- Sección de Registro de Pedido -->
            <h5 class="mb-3">Registro de Pedido</h5>
            <form method="POST" action="#">
                <div class="row">
                    <div class="col-md-6 mb-2">
                        <label for="idcliente" class="form-label">Cliente</label>
                        <select class="form-control" id="idcliente" name="idcliente" required>
                            <option value="">Seleccione un cliente</option>
                            <option value="1">Cliente 1</option>
                            <option value="2">Cliente 2</option>
                            <!-- Opciones dinámicas -->
                        </select>
                    </div>
                    <div class="col-md-6 mb-2">
                        <label for="fecha_pedido" class="form-label">Fecha del Pedido</label>
                        <input type="datetime-local" class="form-control" id="fecha_pedido" name="fecha_pedido" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-2">
                        <label for="estado" class="form-label">Estado</label>
                        <select class="form-control" id="estado" name="estado" required>
                            <option value="Pendiente">Pendiente</option>
                            <option value="Enviado">Enviado</option>
                            <option value="Cancelado">Cancelado</option>
                            <option value="Entregado">Entregado</option>
                        </select>
                    </div>
                </div>

                <hr class="my-3">

                <!-- Sección de Detalle de Pedido -->
                <h5 class="mb-3">Detalle del Pedido</h5>

                <!-- Tabla de productos del pedido -->
                <table class="table table-bordered" id="tabla-productos">
                    <thead>
                        <tr>
                            <th>Producto</th>
                            <th>Cantidad</th>
                            <th>Unidad de Medida</th>
                            <th>Precio Unitario</th>
                            <th>Precio con Descuento</th>
                            <th>Subtotal</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Aquí se agregarán dinámicamente los productos -->
                    </tbody>
                </table>

                <!-- Formulario para agregar productos a la tabla -->
                <div class="row">
                    <div class="col-md-4 mb-2">
                        <label for="idproducto" class="form-label">Producto</label>
                        <select class="form-control" id="idproducto" name="idproducto" required>
                            <option value="">Seleccione un producto</option>
                            <option value="1">Producto 1</option>
                            <option value="2">Producto 2</option>
                            <!-- Opciones dinámicas -->
                        </select>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label for="cantidad_producto" class="form-label">Cantidad</label>
                        <input type="number" class="form-control" id="cantidad_producto" name="cantidad_producto" min="1" required>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label for="unidad_medida" class="form-label">Unidad de Medida</label>
                        <input type="text" class="form-control" id="unidad_medida" name="unidad_medida" required>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label for="precio_unitario" class="form-label">Precio Unitario</label>
                        <input type="number" step="0.01" class="form-control" id="precio_unitario" name="precio_unitario" required>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label for="precio_descuento" class="form-label">Precio con Descuento</label>
                        <input type="number" step="0.01" class="form-control" id="precio_descuento" name="precio_descuento" required>
                    </div>
                </div>

                <!-- Botón para agregar producto a la tabla -->
                <div class="d-flex justify-content-end mb-3">
                    <button type="button" class="btn btn-success" id="agregar-producto">
                        <i class="fa fa-plus me-2"></i>Agregar Producto
                    </button>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-end mt-3">
                    <button type="submit" class="btn btn-primary me-2">Registrar Pedido</button>
                    <button type="reset" class="btn btn-secondary">Cancelar</button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const tablaProductos = document.getElementById('tabla-productos').getElementsByTagName('tbody')[0];
        const btnAgregarProducto = document.getElementById('agregar-producto');

        btnAgregarProducto.addEventListener('click', function () {
            // Obtener los valores de los campos
            const idProducto = document.getElementById('idproducto').value;
            const nombreProducto = document.getElementById('idproducto').options[document.getElementById('idproducto').selectedIndex].text;
            const cantidadProducto = document.getElementById('cantidad_producto').value;
            const unidadMedida = document.getElementById('unidad_medida').value;
            const precioUnitario = document.getElementById('precio_unitario').value;
            const precioDescuento = document.getElementById('precio_descuento').value;
            const subtotal = (cantidadProducto * precioDescuento).toFixed(2);

            if (idProducto && cantidadProducto && unidadMedida && precioUnitario && precioDescuento) {
                // Crear una nueva fila
                const nuevaFila = tablaProductos.insertRow();

                // Insertar celdas en la fila
                nuevaFila.innerHTML = `
                    <td>${nombreProducto}</td>
                    <td>${cantidadProducto}</td>
                    <td>${unidadMedida}</td>
                    <td>${precioUnitario}</td>
                    <td>${precioDescuento}</td>
                    <td>${subtotal}</td>
                    <td>
                        <button type="button" class="btn btn-warning btn-sm me-2 editar-producto">Editar</button>
                        <button type="button" class="btn btn-danger btn-sm eliminar-producto">Eliminar</button>
                    </td>
                `;

                // Limpiar campos después de agregar
                document.getElementById('idproducto').value = '';
                document.getElementById('cantidad_producto').value = '';
                document.getElementById('unidad_medida').value = '';
                document.getElementById('precio_unitario').value = '';
                document.getElementById('precio_descuento').value = '';
            }

            // Lógica para eliminar un producto de la tabla
            tablaProductos.addEventListener('click', function (e) {
                if (e.target.classList.contains('eliminar-producto')) {
                    const fila = e.target.closest('tr');
                    fila.remove();
                }
            });

            // Lógica para editar un producto de la tabla
            tablaProductos.addEventListener('click', function (e) {
                if (e.target.classList.contains('editar-producto')) {
                    const fila = e.target.closest('tr');
                    const celdas = fila.getElementsByTagName('td');

                    // Asignar los valores de la fila a los campos del formulario
                    document.getElementById('idproducto').value = celdas[0].innerText;
                    document.getElementById('cantidad_producto').value = celdas[1].innerText;
                    document.getElementById('unidad_medida').value = celdas[2].innerText;
                    document.getElementById('precio_unitario').value = celdas[3].innerText;
                    document.getElementById('precio_descuento').value = celdas[4].innerText;

                    // Eliminar la fila al hacer clic en editar
                    fila.remove();
                }
            });
        });
    });
</script>

<?php
require_once '../../footer.php';
?>
