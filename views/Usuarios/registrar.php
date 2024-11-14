<?php require_once '../header.php'; ?>
<main>
    <div class="container-fluid mt-5 d-flex justify-content-center">
        <form action="" autocomplete="off" id="form-user">
            <div class="card shadow-lg border-0 rounded-lg d-flex justify-content-around ">
                <div class="card-header text-center">
                    <h2 class="card-title ">Registro de usuarios</h2>
                </div>

                <div class="card-body ">
                    <h4 class="card-title">
                        <i class="fa-solid fa-user-plus"></i>
                        Información del usuario
                    </h4>

                    <!-- fila 1 -->
                    <div class="row g-3 mb-3 mt-3">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <select class="form-select" id="tipo_doc" name="tipo_documento" required>
                                    <option>Seleccione un documento</option>
                                </select>
                                <label>Tipo de documento</label>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="input-group">
                                <div class="form-floating">
                                    <input class="form-control"
                                        id="numero_documento"
                                        name="numero_documento"
                                        type="text" placeholder="Número de documento"
                                        maxlength="8" pattern="[0-9]+"
                                        title="Solo se permite números"
                                        autofocus
                                        required />
                                    <label for="dni" class="form-label">Número documento</label>
                                </div>
                                <button type="button" class="btn btn-lg btn-outline-success" id="buscar-dni"><i class="fa-solid fa-magnifying-glass"></i></button>
                            </div>
                        </div>
                    </div>
                    <!-- fila 2 -->
                    <div class="row g-3 mb-3">

                        <div class="col-md-4">
                            <div class="form-floating mb-3">
                                <input class="form-control " id="usuario" autocomplete="username" name="usuario" type="text" placeholder="Nombre de usuario" required />
                                <label for="usuario valid-feedback">Nombre de usuario</label>
                                <span id="valida-usuario"  style="visibility:visible; position:static;"></span>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-floating mb-3">
                                <input class="form-control" id="password" name="password" autocomplete="current-password" type="password" placeholder="password" required minlength="8" />
                                <label for="password">Contraseña</label>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating mb-3">
                                <select class="form-select" id="rol" name="rol" required>
                                    <option>Seleccione un rol</option>
                                </select>
                                <label>Roles</label>
                            </div>
                        </div>
                    </div>
                    <!-- fila 3 -->
                </div>
                <div class="card-footer text-end">
                    <button type="submit" class="btn btn- btn-success mt-2 mb-2" id="registrar-user">Registrar</button>
                    <button type="reset" class="btn btn-md btn-outline-danger mt-2 mb-2">Cancelar</button>
                    <a href="index.php" class="btn btn-md btn-outline-primary mt-2 mb-2">Mostrar lista de usuarios</a>
                </div>
            </div>
        </form>
    </div> <!-- fin fluid -->
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/usuarios/usuario.js"></script>
</body>

</html>