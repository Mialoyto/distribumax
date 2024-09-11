<?php
require_once '../../header.php';
?>
  <div class="container mt-5">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header">
                <h3 class="text-center">Registro de Proveedor</h3>
            </div>
            <div class="card-body">
                <!-- Formulario de Registro de Proveedor -->
                <form method="POST" action="#">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="idempresa" class="form-label">Empresa</label>
                            <select class="form-control" id="idempresa" name="idempresa" required>
                                <option value="">Seleccione una empresa</option>
                                <option value="1">Empresa 1</option>
                                <option value="2">Empresa 2</option>
                                <option value="3">Empresa 3</option>
                                <!-- Agrega más opciones según sea necesario -->
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="nombre_proveedor" class="form-label">Nombre del Proveedor</label>
                            <input type="text" class="form-control" id="nombre_proveedor" name="nombre_proveedor" required>
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
                        <button type="reset" class="btn btn-secondary">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<?php
require_once '../../footer.php';
?>