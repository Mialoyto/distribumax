<?php
require_once '../../header.php';
?>

<div class="container mt-5">
    <!-- Botón que activa el modal -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registroEmpresaModal">
            <i class="fa fa-plus me-2"></i> Registrar Empresa
        </button>
    </div>

    <!-- Tabla de empresas registradas -->
    <h3 class="text-center mb-4">Empresas Registradas</h3>
    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle table-bordered shadow-sm">
            <thead class="table-dark text-center">
                <tr>
                    <th>RUC</th>
                    <th>Razón Social</th>
                    <th>Dirección</th>
                    <th>Email</th>
                    <th>Teléfono</th>
                    <th>Distrito</th>
                </tr>
            </thead>
            <tbody>
                <tr class="text-center">
                    <td>12345678901</td>
                    <td>Empresa XYZ</td>
                    <td>Calle Falsa 123</td>
                    <td>correo@empresa.com</td>
                    <td>987654321</td>
                    <td>Distrito 1</td>
                </tr>
                <tr class="text-center">
                    <td>10987654321</td>
                    <td>Empresa ABC</td>
                    <td>Avenida Siempre Viva 742</td>
                    <td>contacto@empresaabc.com</td>
                    <td>912345678</td>
                    <td>Distrito 2</td>
                </tr>
                <!-- Agrega más filas con datos dinámicos según sea necesario -->
            </tbody>
        </table>
    </div>
</div>

<!-- Modal -->
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
                                <!-- Agrega más opciones según sea necesario -->
                            </select>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2" id="btn-registrar-empresa">
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

<script src="../../js/empresas.js"></script>

<?php
require_once '../../footer.php';
?>
