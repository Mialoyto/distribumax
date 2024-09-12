<?php
require_once '../../header.php';
?>
<!-- Contenedor principal -->
<div class="container mt-5">
    <div class="card border-0 rounded-lg">
        <div class="card-header">
            <h3 class="text-center">Registro de Empresa</h3>
        </div>
        <div class="card-body">
            <!-- Formulario de Registro de Empresa -->
            <form method="POST" action="#" id="form-registrar-empresa">
                <div class="row">
                    <div class="col-md-6 mb-3 position-relative">
                        <label for="idempresaruc" class="form-label">RUC</label>
                        <input type="number" class="form-control ps-5" id="idempresaruc" name="idempresaruc" required>
                        <i class="fas fa-id-card position-absolute top-50 start-3 translate-middle-y"></i>
                    </div>
                    <div class="col-md-6 mb-3 position-relative">
                        <label for="razonsocial" class="form-label">Razón Social</label>
                        <input type="text" class="form-control ps-5" id="razonsocial" name="razonsocial" required>
                        <i class="fas fa-building position-absolute top-50 start-3 translate-middle-y"></i>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3 position-relative">
                        <label for="direccion" class="form-label">Dirección</label>
                        <input type="text" class="form-control ps-5" id="direccion" name="direccion" required>
                        <i class="fas fa-map-marker-alt position-absolute top-50 start-3 translate-middle-y"></i>
                    </div>
                    <div class="col-md-6 mb-3 position-relative">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control ps-5" id="email" name="email">
                        <i class="fas fa-envelope position-absolute top-50 start-3 translate-middle-y"></i>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3 position-relative">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="text" class="form-control ps-5" id="telefono" name="telefono" required>
                        <i class="fas fa-phone position-absolute top-50 start-3 translate-middle-y"></i>
                    </div>
                    <div class="col-md-6 mb-3 position-relative">
                        <label for="iddistrito" class="form-label">Distrito</label>
                        <select class="form-control ps-5" id="iddistrito" name="iddistrito" required>
                            <option value="">Seleccione un distrito</option>
                            <!-- Agrega más opciones según sea necesario -->
                        </select>
                        <i class="fas fa-map-marker-alt position-absolute top-50 start-3 translate-middle-y"></i>
                    </div>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary me-2" id="btn-registrar-empresa">
                        <i class="fas fa-check me-2"></i> Registrar
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i> Cancelar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="../../js/empresas.js"></script>

<?php
require_once '../../footer.php';
?>
