<?php
require_once '../../header.php';
?>

<div class="container mt-5">
    <!-- Botón que activa el modal para registrar un nuevo proveedor -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registroProveedorModal">
            <i class="fa fa-plus me-2"></i> Registrar Proveedor
        </button>
    </div>

    <!-- Tabla de proveedores registrados -->
    <h3 class="text-center mb-4">Proveedores Registrados</h3>
    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle table-bordered shadow-sm" id="table-proveedores">
            <thead class="table-dark text-center">
                <tr>
                    <th>Empresa</th>
                    <th>Proveedor</th>
                    <th>Contacto Principal</th>
                    <th>Teléfono</th>
                    <th>Email</th>
                    <th>Dirección</th>
                    <th>Opciones</th>
                </tr>
            </thead>
            <tbody id="tabla-proveedores">
                <!-- Aquí se agregarán dinámicamente los proveedores registrados -->
            </tbody>
        </table>
    </div>
</div>

<!-- Modal para el formulario de registro de proveedores -->
<div class="modal fade" id="registroProveedorModal" tabindex="-1" aria-labelledby="registroProveedorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="registroProveedorModalLabel">Registro de Proveedor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Formulario de Registro de Proveedor dentro del modal -->
                <form method="POST" action="#" id="form-registrar-proveedor">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="idempresa" class="form-label">Empresa</label>
                            <select class="form-control" id="idempresa" name="idempresa" required>
                                <option value="">Seleccione una empresa</option>
                                <!-- Las opciones se cargarán dinámicamente con JavaScript -->
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="proveedor" class="form-label">Nombre del Proveedor</label>
                            <input type="text" class="form-control" id="proveedor" name="proveedor" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="contacto_principal" class="form-label">Contacto Principal</label>
                            <input type="text" class="form-control" id="contacto_principal" name="contacto_principal" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="telefono_contacto" class="form-label">Teléfono de Contacto</label>
                            <input type="text" class="form-control" id="telefono_contacto" name="telefono_contacto" maxlength="9" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="direccion" name="direccion" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Correo Electrónico</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">Registrar</button>
                        <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal para el formulario de actualización de proveedores -->
<div class="modal fade" id="actualizarProveedorModal" tabindex="-1" aria-labelledby="actualizarProveedorModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="actualizarProveedorModalLabel">Actualizar Proveedor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Formulario de Actualización de Proveedor dentro del modal -->
                <form method="POST" action="#" id="form-actualizar-proveedor">
                    <input type="hidden" id="idproveedor_update" name="idproveedor">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="idempresa_update" class="form-label">Empresa</label>
                            <select class="form-control" id="idempresaruc" name="idempresa" required>
                                <option value="">Seleccione una empresa</option>
                                <!-- Las opciones se cargarán dinámicamente con JavaScript -->
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="proveedor_update" class="form-label">Nombre del Proveedor</label>
                            <input type="text" class="form-control" id="proveedor" name="proveedor" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="contacto_principal_update" class="form-label">Contacto Principal</label>
                            <input type="text" class="form-control" id="contacto_principal" name="contacto_principal" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="telefono_contacto_update" class="form-label">Teléfono de Contacto</label>
                            <input type="text" class="form-control" id="telefono_contacto" name="telefono_contacto" maxlength="9" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="direccion_update" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="direccion" name="direccion" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="email_update" class="form-label">Correo Electrónico</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                                <input type="text" value="" class="form-control" id="idproveedor">
                        <div>
                            
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="" class="btn btn-primary me-2"  id="btnactualizarproveedor">Actualizar</button>
                        <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Incluye el script de JavaScript -->
<script src="../../js/proveedor.js"></script>

<?php
require_once '../../footer.php';
?>
