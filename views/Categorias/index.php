<?php
require_once '../../header.php';
?>

<div class="container mt-5">
    <!-- Botón para abrir el modal -->
    <div class="d-flex justify-content-end mb-3">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#categoriaModal">
            <i class="fas fa-plus me-2"></i>
            Registrar Categoría
        </button>
    </div>
    <h3 class="text-center mb-4">Categorias Registrados</h3>
    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle table-bordered shadow-sm" id="table-categoria">
            <thead class="table-dark text-center">
                <tr>
                    <th>Categorias</th>
  
                    <th>Opciones</th>
                </tr>
            </thead>
            <tbody id="tabla-proveedores">
                <!-- Aquí se agregarán dinámicamente los proveedores registrados -->
            </tbody>
        </table>
        </div>
    </div>
    <!-- Modal para el registro de categoría -->
    <div class="modal fade" id="categoriaModal" tabindex="-1" aria-labelledby="categoriaModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="categoriaModalLabel">Registro de Categoría</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Formulario de Registro de Categoría -->
                    <form method="POST" action="#" id="form-categoria">
                        <div class="mb-3">
                            <label for="categoria" class="form-label">Categoría</label>
                            <input type="text" class="form-control" id="categoria" name="categoria" required>
                        </div>

                        <!-- Botones del formulario dentro del modal -->
                        <div class="d-flex justify-content-end">
                            <button type="submit" class="btn btn-primary me-2">Registrar Categoría</button>
                            <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
require_once '../../footer.php';
?>
