<?php
require_once '../../header.php';
?>

<div class="container mt-5">
    <div class="card shadow-lg border-0 rounded-lg">
        <div class="card-header">
            <h3 class="text-center">Registro de Movimiento en Kardex</h3>
        </div>
        <div class="card-body">
            <!-- Formulario de Registro de Movimiento en Kardex -->
            <form method="POST" action="#">
                <div class="row">
                    
                    <div class=" mb-3">
                        <label for="idproducto" class="form-label">Producto</label>
                        <select class="form-control" id="idproducto" name="idproducto" required>
                            <option value="">Seleccione un producto</option>
                            <option value="1">Producto 1</option>
                            <option value="2">Producto 2</option>
                            <option value="3">Producto 3</option>
                            <!-- Agrega más opciones según sea necesario -->
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="stockactual" class="form-label">Stock Actual</label>
                        <input type="number" step="0.01" class="form-control" id="stockactual" name="stockactual" required disabled>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="tipomovimiento" class="form-label">Tipo de Movimiento</label>
                        <select class="form-control" id="tipomovimiento" name="tipomovimiento" required>
                            <option value="Ingreso">Ingreso</option>
                            <option value="Salida">Salida</option>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="cantidad" class="form-label">Cantidad</label>
                        <input type="number" step="0.01" class="form-control" id="cantidad" name="cantidad" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="motivo" class="form-label">Motivo</label>
                        <input type="text" class="form-control" id="motivo" name="motivo" maxlength="255">
                    </div>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary me-2">Registrar</button>
                    <button type="reset" class="btn btn-secondary">Cancelar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<?php
require_once '../../footer.php';
?>
