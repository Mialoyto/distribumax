<?php

require_once '../../header.php';
?>

<div class="container mt-5">
    <div class="card shadow-lg border-0 rounded-lg">
        <div class="card-header">
            <h3 class="text-center">Registro de Personas</h3>
        </div>
        <div class="card-body">
            <!-- FORMULARIO DE REGISTRO -->
            <form method="POST"   id="form-persona"autocomplete="off">
                <!-- Sección de Información Personal -->
                <h5 class="mb-4">
                    <i class="fas fa-id-card"></i> Información Personal
                </h5>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="idtipodocumento" class="form-label">Tipo de Documento</label>
                        <select class="form-control" id="idtipodocumento" name="idtipodocumento" required>
                            <option>Seleccione un documento de identidad</option>

                            <!-- Agrega más opciones si es necesario -->
                        </select>
                    </div>
                    <div class="col-md-8 mb-3">
                        <label for="idpersonanrodoc" class="form-label">Número de Documento</label>
                        <div class="input-group">
                            <input type="number" class="form-control" id="idpersonanrodoc" name="idpersonanrodoc" required>
                            <button class="btn btn-outline-secondary" type="button" id="btnbuscardni">Verificar</button>
                        </div>
                    </div>
                </div>

                <div class="row">

                    <!-- BUSCADOR PETICIONES -->
                    <div class="col-md-4 mb-3">
                        <label for="datalistDistrito" class="form-label">Buscar Distrito</label>
                        <input type="search" class="form-control" id="searchDistrito" list="datalistDistrito" required>
                        <div class="error-container" style="display: none;"></div>
                        <datalist id="datalistDistrito"></datalist>
                    </div>
                    <!-- FIN BUSCADOR PETICIONES -->
                    <div class="col-md-4 mb-3">
                        <label for="nombres" class="form-label">Nombres</label>
                        <input type="text" class="form-control" id="nombres" name="nombres" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="appaterno" class="form-label">Apellido Paterno</label>
                        <input type="text" class="form-control" id="appaterno" name="appaterno" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="apmaterno" class="form-label">Apellido Materno</label>
                        <input type="text" class="form-control" id="apmaterno" name="apmaterno" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="telefono" class="form-label">Teléfono</label>
                        <input type="text" class="form-control" id="telefono" name="telefono" pattern="[0-9]+" inputmode="numeric">
                    </div>
                </div>

                <div class="mb-3">
                    <label for="direccion" class="form-label">Dirección</label>
                    <input type="text" class="form-control" id="direccion" name="direccion" required>
                </div>

                <!-- Separación visual entre secciones -->
                <hr class="my-4">

                <!-- Sección de Información de Cuenta de Usuario -->
                <h5 class="mb-4">
                    <i class="fas fa-user"></i> Información de Cuenta de Usuario
                </h5>
                <div class="row">

                    <div class="col-md-4 px-5 pt-3">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control" id="nombre_usuario">
                            <label for="nombre_usuario">Nombre de Usuario</label>
                        </div>
                    </div>
                    <div class="col-md-4 px-5 pt-3">
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="password_usuario">
                            <label for="password_usuario">Contraseña</label>
                        </div>
                    </div>

                    <!-- otion de roles -->
                    <div class="col-md px-5 pt-3">
                        <div class="form-floating mb-3">
                            <select name="rol" id="rol" class="form-select">
                                <option>Seleccione un rol</option>
                                <!-- asincronismo -->
                            </select>
                            <label form="rol">Rol</label>
                        </div>
                    </div>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary me-2" id="btnRegistrarPersona">Registrar</button>
                    <button type="reset" class="btn btn-secondary" id="btnCancelarRegistro">Cancelar</button>
                </div>
            </form>
            <!-- FORMULARIO DE REGISTRO -->
        </div>
    </div>
</div>

<?php

require_once '../../footer.php';
?>
<script src="<?= $host ?>/js/persona.js"></script>