<?php
require_once '../../header.php';
?>
  <div class="container mt-5">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header">
                <h3 class="text-center">Registro de Marca</h3>
            </div>
            <div class="card-body">
                <!-- Formulario de Registro de Marca -->
                <form method="POST" action="#">
                    <div class="mb-3">
                        <label for="marca" class="form-label">Nombre de la Marca</label>
                        <input type="text" class="form-control" id="marca" name="marca" required>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">Registrar Marca</button>
                        <button type="reset" class="btn btn-secondary">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
<?php
require_once '../../footer.php';
?>