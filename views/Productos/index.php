<?php
require_once '../../header.php';
?>

<div class="container mt-5">
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header">
                <h3 class="text-center">Registro de Producto</h3>
            </div>
            <div class="card-body">
                <!-- Formulario de Registro de Producto -->
                <form method="POST" action="#">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="idmarca" class="form-label">Marca</label>
                            <select class="form-control" id="idmarca" name="idmarca" required>
                                <option value="">Seleccione una marca</option>
                                <option value="1">Marca 1</option>
                                <option value="2">Marca 2</option>
                                <option value="3">Marca 3</option>
                                <!-- Agrega más opciones según sea necesario -->
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="idsubcategoria" class="form-label">Subcategoría</label>
                            <select class="form-control" id="idsubcategoria" name="idsubcategoria" required>
                              
                                <!-- Agrega más opciones según sea necesario -->
                            </select>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="nombreproducto" class="form-label">Nombre del Producto</label>
                            <input type="text" class="form-control" id="nombreproducto" name="nombreproducto" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="codigo" class="form-label">Código del Producto</label>
                            <input type="text" class="form-control" id="codigo" name="codigo" maxlength="11" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label for="preciounitario" class="form-label">Precio Unitario</label>
                        <input type="number" step="0.01" class="form-control" id="preciounitario" name="preciounitario" min="0.01" required>
                    </div>

                    <div class="mb-3">
                        <label for="descripcion" class="form-label">Descripción</label>
                        <textarea class="form-control" id="descripcion" name="descripcion" rows="3" required></textarea>
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