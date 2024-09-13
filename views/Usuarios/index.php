<?php

require_once '../../header.php';
?>

<div class="container mt-5">
    <div class="card shadow-lg border-0 rounded-lg">
        <div class="card-header">
            <h3 class="text-center">Registro de Personas</h3>
        </div>
        <div class="card-body">
            <!-- Formulario de Registro -->
            <form method="POST" action="registrar_persona.php">
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
                    <div class="col-md-4 mb-3">
                        <label for="iddistrito" class="form-label">Distrito</label>
                            <input type="text" class="form-control" id="iddistrito" name="iddistrito" required>
                    </div>
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
                            <label for="appmaterno" class="form-label">Apellido Materno</label>
                            <input type="text" class="form-control" id="appmaterno" name="appmaterno" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="telefono" class="form-label">Teléfono</label>
                            <input type="text" class="form-control" id="telefono" name="telefono" pattern="[0-9]+"  inputmode="numeric">
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

                    <div class="col-md-4 mb-3">
                        <label for="nombre_usuario" class="form-label">Nombre de Usuario</label>
                        <input type="text" class="form-control" id="nombre_usuario" name="nombre_usuario" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="password_usuario" class="form-label">Contraseña</label>
                        <input type="password" class="form-control" id="password_usuario" name="password_usuario" required>
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
<script src="<?=$host?>/js/persona.js"></script>