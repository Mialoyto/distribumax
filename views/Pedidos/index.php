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
                <div class="row">
                    <div class="col-md-6 mb-2">
                        <label for="idproducto" class="form-label">Producto</label>
                        <select class="form-control" id="idproducto" name="idproducto" required>
                            <option value="">Seleccione un producto</option>
                            <option value="1">Producto 1</option>
                            <option value="2">Producto 2</option>
                            <!-- Opciones dinámicas -->
                        </select>
                    </div>
                    <div class="col-md-6 mb-2">
                        <label for="cantidad_producto" class="form-label">Cantidad</label>
                        <input type="number" class="form-control" id="cantidad_producto" name="cantidad_producto" min="1" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-2">
                        <label for="unidad_medida" class="form-label">Unidad de Medida</label>
                        <input type="text" class="form-control" id="unidad_medida" name="unidad_medida" required>
                    </div>
                    <div class="col-md-6 mb-2">
                        <label for="precio_unitario" class="form-label">Precio Unitario</label>
                        <input type="number" step="0.01" class="form-control" id="precio_unitario" name="precio_unitario" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-2">
                        <label for="precio_descuento" class="form-label">Precio con Descuento</label>
                        <input type="number" step="0.01" class="form-control" id="precio_descuento" name="precio_descuento" required>
                    </div>
                    <div class="col-md-6 mb-2">
                        <label for="subtotal" class="form-label">Subtotal</label>
                        <input type="number" step="0.01" class="form-control" id="subtotal" name="subtotal" required>
                    </div>
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
<?php
require_once '../../footer.php';
?>
