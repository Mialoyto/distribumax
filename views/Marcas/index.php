<?php
require_once '../../header.php';
?>
<!-- Contenedor principal -->
<div class="container mt-5">
    <!-- Card que contiene el botón para abrir el modal, alineada a la derecha -->
    <div class="d-flex justify-content-end">
        <div class="card border-0 rounded-lg" style="width: 100%;">
            <div class="card-body">
                <!-- Botón que activa el modal -->
                <div class="d-flex justify-content-end mb-3">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registroMarcaModal">
                        <i class="fa fa-plus me-2"></i> Registrar Marca
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="registroMarcaModal" tabindex="-1" aria-labelledby="registroMarcaModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="registroMarcaModalLabel">Registro de Marca</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- Card dentro del modal -->
                <div class="card border-0 rounded-lg">
                    <div class="card-body">
                        <!-- Formulario de Registro de Marca -->
                        <form method="POST" action="#">
                            <div class="mb-3 position-relative">
                                <label for="marca" class="form-label">Nombre de la Marca</label>
                                <input type="text" class="form-control ps-5" id="marca" name="marca" required>
                                <i class="fa fa-tag position-absolute top-50 start-0 translate-middle-y ms-3"></i>
                            </div>

                            <!-- Botones -->
                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="fa fa-check me-2"></i> Registrar Marca
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
    </div>
</div>

<?php
require_once '../../footer.php';
?>
