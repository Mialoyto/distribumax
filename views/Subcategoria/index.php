<?php
require_once '../../header.php';
?>
<div class="container mt-5">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header">
                <h3 class="text-center">Registro de Subcategoría</h3>
            </div>
            <div class="card-body">
                <!-- Formulario de Registro de Subcategoría -->
                <form method="POST" action="#">
                    <div class="mb-3">
                        <label for="idcategoria" class="form-label">Categoría</label>
                        <select class="form-control" id="idcategoria" name="idcategoria" required>
                            <option value="">Seleccione una categoría</option>
                            <option value="1">Categoría 1</option>
                            <option value="2">Categoría 2</option>
                            <option value="3">Categoría 3</option>
                            <!-- Agrega más opciones dinámicamente desde la base de datos -->
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="subcategoria" class="form-label">Subcategoría</label>
                        <input type="text" class="form-control" id="subcategoria" name="subcategoria" required>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">Registrar Subcategoría</button>
                        <button type="reset" class="btn btn-secondary">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
<?php
require_once '../../footer.php';
?>