<?php
require_once '../../header.php';
?>
<div class="container mt-5">
    <!-- Formulario Completo -->
    <div class="card shadow-lg border-0 rounded-lg">
        <div class="card-header">
            <h3 class="text-center">Registro de Promociones</h3>
        </div>
        <div class="card-body">
            <!-- Sección de Registro de Promociones -->
            <h5 class="mb-4">Registro de Promoción</h5>
            <form method="POST" action="#">
                <div class="row">
                    <div class="col-md-6git a mb-3">
                        <label for="idtipopromocion" class="form-label">Tipo de Promoción</label>
                        <select class="form-control" id="idtipopromocion" name="idtipopromocion" required>
                            <option value="">Seleccione un tipo de promoción</option>
                            <!-- Agrega más opciones según sea necesario -->
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="descripcion_promocion" class="form-label">Descripción de la Promoción</label>
                        <input type="text" class="form-control" id="descripcion_promocion" name="descripcion_promocion" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="fechainicio" class="form-label">Fecha de Inicio</label>
                        <input type="datetime-local" class="form-control" id="fechainicio" name="fechainicio" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="fechafin" class="form-label">Fecha de Fin</label>
                        <input type="datetime-local" class="form-control" id="fechafin" name="fechafin" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="valor_descuento" class="form-label">Valor del Descuento</label>
                    <input type="number" step="0.01" class="form-control" id="valor_descuento" name="valor_descuento" min="0.01" required>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary me-2">Registrar Promoción</button>
                    <button type="reset" class="btn btn-secondary me-2">Cancelar</button>
                    <a href="index.php" class="btn btn-outline-primary">Listar promociones</a>
                </div>
            </form>

            <div class="text-end mt-4">
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalTipoPromocion">Registrar Tipo de Promoción</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal para Registrar Tipo de Promoción -->
<div class="modal fade" id="modalTipoPromocion" tabindex="-1" aria-labelledby="modalTipoPromocionLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTipoPromocionLabel">Registro de Tipo de Promoción</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form method="POST" action="#" id="form-promocion">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="tipopromocion" class="form-label">Tipo de Promoción</label>
                            <input type="text" class="form-control" id="tipopromocion" name="tipopromocion" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <input type="text" class="form-control" id="descripcion" name="descripcion_tipo" required>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">Registrar Tipo</button>
                        <button type="reset" class="btn btn-secondary">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="../../js/promociones.js"> </script>
<?php require_once '../../footer.php';?>