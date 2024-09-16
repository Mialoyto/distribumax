<?php
require_once '../../header.php';
?>

<div class="container mt-5">
    <!-- Botón que activa el modal de registro -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registroEmpresaModal">
            <i class="fa fa-plus me-2"></i> Registrar Empresa
        </button>
    </div>

    <!-- Tabla de empresas registradas -->
    <h3 class="text-center mb-4">Empresas Registradas</h3>
    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle table-bordered shadow-sm" id="table-empresas">
            <thead class="table-dark text-center">
                <tr>
                    <th>RUC</th>
                    <th>Razón Social</th>
                    <th>Dirección</th>
                    <th>Email</th>
                    <th>Teléfono</th>
                    <th>Distrito</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Se llenarán dinámicamente -->
            </tbody>
        </table>
    </div>
</div>

<!-- Modal para registro de empresa -->
<div class="modal fade" id="registroEmpresaModal" tabindex="-1" aria-labelledby="registroEmpresaModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="registroEmpresaModalLabel">Registro de Empresa</h5>
               
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Formulario de Registro de Empresa dentro del modal -->
                <form method="POST" action="#" id="form-registrar-empresa">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="idempresaruc" class="form-label">
                                <i class="fa fa-id-card me-2"></i> RUC
                            </label>
                            <input type="number" class="form-control" id="idempresaruc" name="idempresaruc" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="razonsocial" class="form-label">
                                <i class="fa fa-building me-2"></i> Razón Social
                            </label>
                            <input type="text" class="form-control" id="razonsocial" name="razonsocial" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="direccion" class="form-label">
                                <i class="fa fa-map-marker-alt me-2"></i> Dirección
                            </label>
                            <input type="text" class="form-control" id="direccion" name="direccion" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">
                                <i class="fa fa-envelope me-2"></i> Email
                            </label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="telefono" class="form-label">
                                <i class="fa fa-phone me-2"></i> Teléfono
                            </label>
                            <input type="text" class="form-control" id="telefono" name="telefono" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="iddistrito" class="form-label">
                                <i class="fa fa-map-marker-alt me-2"></i> Distrito
                            </label>
                            <select class="form-control" id="iddistrito" name="iddistrito" required>
                                <option value="">Seleccione un distrito</option>
                                <!-- Opciones de distritos se llenarán dinámicamente -->
                            </select>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="fa fa-check me-2"></i> Registrar
                        </button>
                        <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-2"></i> Cancelar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal para actualizar empresa -->
<div class="modal fade" id="actualizarEmpresaModal" data-id="idempresaruc" tabindex="-1" aria-labelledby="actualizarEmpresaModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="actualizarEmpresaModalLabel" data-id="idempresaruc">Actualizar Empresa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Formulario de actualización de empresa dentro del modal -->
                <form method="POST" action="#" id="form-actualizar-empresa">

                    
           
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="update-razonsocial" class="form-label">
                                <i class="fa fa-building me-2"></i> Razón Social
                            </label>
                            <input type="text" class="form-control" id="razonsocial-update" name="razonsocial" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="update-direccion" class="form-label">
                                <i class="fa fa-map-marker-alt me-2"></i> Dirección
                            </label>
                            <input type="text" class="form-control" id="direccion-update" name="direccion" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="update-email" class="form-label">
                                <i class="fa fa-envelope me-2"></i> Email
                            </label>
                            <input type="email" class="form-control" id="email-update" name="email">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="update-telefono" class="form-label">
                                <i class="fa fa-phone me-2"></i> Teléfono
                            </label>
                            <input type="text" class="form-control" id="telefono-update" name="telefono" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="update-iddistrito" class="form-label">
                                <i class="fa fa-map-marker-alt me-2"></i> Distrito
                            </label>
                            <select class="form-control" id="iddistrito-update" name="iddistrito" required>
                                <!-- Opciones de distritos se llenarán dinámicamente -->
                            </select>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="fa fa-save me-2"></i> Actualizar
                        </button>
                        <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-2"></i> Cancelar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>





<script src="../../js/empresas.js"></script>

<?php
require_once '../../footer.php';
?>
