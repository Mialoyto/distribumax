<?php
require_once '../../header.php';
?>

    <div class="container mt-5">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header">
                <h3 class="text-center">Registro de Empresa</h3>
            </div>
            <div class="card-body">
                <!-- Formulario de Registro de Empresa -->
                <form method="POST" action="#" id="form-registrar-empresa">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="idempresaruc" class="form-label">RUC</label>
                            <input type="number" class="form-control" id="idempresaruc" name="idempresaruc" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="razonsocial" class="form-label">Razón Social</label>
                            <input type="text" class="form-control" id="razonsocial" name="razonsocial" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="direccion" name="direccion" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="telefono" class="form-label">Teléfono</label>
                            <input type="text" class="form-control" id="telefono" name="telefono" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="iddistrito" class="form-label">Distrito</label>
                            <select class="form-control" id="iddistrito" name="iddistrito" required>
                                <option value="">Seleccione un distrito</option>
                                
                                <!-- Agrega más opciones según sea necesario -->
                            </select>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2" id="btn-registrar-empresa">Registrar</button>
                        <button type="reset" class="btn btn-secondary">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

<script src="../../js/empresas.js"></script>

<?php
require_once '../../footer.php';
?>