<?php
require_once '../../header.php';
?>
<!-- Botón para abrir el modal -->
<div class="container mt-5">
    <div class="d-flex justify-content-end">
        <!-- Botón que activa el modal -->
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registroSubcategoriaModal">
            <i class="fas fa-plus me-2"></i> Registrar Subcategoría
        </button>
    </div>
</div>

<!-- Modal para el registro de subcategoría -->
<div class="modal fade" id="registroSubcategoriaModal" tabindex="-1" aria-labelledby="registroSubcategoriaModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="registroSubcategoriaModalLabel">Registro de Subcategoría</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Formulario de Registro de Subcategoría dentro de una tarjeta -->
                <div class="card border-0 rounded-lg">
                    <div class="card-body">
                        <form method="POST" action="#" id="form-subcategoria">
                            <!-- Selección de Categoría -->
                            <div class="mb-3 position-relative">
                                <label for="idcategoria" class="form-label">Categoría</label>
                                <select class="form-control ps-5" id="idcategoria" name="idcategoria" required>
                                    <option value="">Seleccione una categoría</option>
                                    
                                    <!-- Agrega más opciones dinámicamente desde la base de datos -->
                                </select>
                            </div>

                            <!-- Campo para Subcategoría -->
                            <div class="mb-3 position-relative">
                                <label for="subcategoria" class="form-label">Subcategoría</label>
                                <input type="text" class="form-control ps-5" id="subcategoria" name="subcategoria" required>
                            </div>

                            <!-- Botones del formulario dentro del modal -->
                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fas fa-check me-2"></i> Registrar Subcategoría
                                </button>
                                <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times me-2"></i> Cancelar
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
require_once '../../footer.php';
?>
