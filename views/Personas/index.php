<?php require_once '../../header.php'; ?>
<main>
    <div class="container-fluid mt-5 d-flex justify-content-around">
        <form action="" autocomplete="off" id="form-persona">
            <div class="card shadow-lg border-0 rounded-lg">
                <div class="card-header text-center">
                    <h2 class="card-title ">Registro de personas</h2>
                </div>

                <div class="card-body">
                    <h4 class="card-title">
                        <i class="fa-solid fa-address-card fa-1x"></i>
                        Información personal
                    </h4>

                    <!-- fila 1 -->
                    <div class="row g-3 mb-3 mt-3">
                        <div class="col-md-4">
                            <div class="form-floating mb-3">
                                <select class="form-select" id="tipo_documento" name="tipo_documento" required>
                                    <option>Seleccione un documento</option>
                                </select>
                                <label>Tipo de documento</label>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
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
                        <!-- BUSCADOR PETICIONES -->
                        <div class="col-md-4 mb-3">
                            <div class="form-floating">
                                <input type="search" class="form-control" id="buscar-distrito" list="datalistDistrito" placeholder="Buscar distrito" required>
                                <datalist id="datalistDistrito">
                                </datalist>
                                <label for="datalistDistrito">Buscar distrito</label>
                            </div>
                        </div>
                        <!-- FIN BUSCADOR PETICIONES -->
                    </div>
                    <!-- fila 2 -->
                    <div class="row g-3 mb-3">

                        <div class="col-md-4">
                            <div class="form-floating mb-3">
                                <input class="form-control" id="nombres" name="nombres" type="text" placeholder="nombres" required />
                                <label for="nombres">Nombres</label>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-floating mb-3">
                                <input class="form-control" id="appaterno" name="apellidos" type="text" placeholder="appaterno" required />
                                <label for="appaterno">Apellido paterno</label>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-floating mb-3">
                                <input class="form-control" id="apmaterno" name="apmaterno" type="text" placeholder="Apellido apmaterno" required />
                                <label for="apmaterno">Apellido materno</label>
                            </div>
                        </div>
                    </div>
                    <!-- fila 3 -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input class="form-control"
                                    id="telefono"
                                    name="telefono"
                                    type="text"
                                    placeholder="Número de télefono"
                                    maxlength="9" minlength="9"
                                    pattern="[0-9]+"
                                    title="Solo se permite números"
                                    required />
                                <label for="telefono">Telefono</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating">
                                <input class="form-control" id="direccion" name="direccion" type="text" placeholder="Dirección" required />
                                <label for="direccion">Dirección</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer text-end">
                    <button type="submit" class="btn btn- btn-success mt-2 mb-2" id="btnRegistrar">Registrar</button>
                    <button type="reset" class="btn btn-md btn-outline-danger mt-2 mb-2">Cancelar</button>
                    <a href="personas.php" class="btn btn-md btn-outline-primary mt-2 mb-2">Mostrar lista de personas</a>
                </div>
            </div>
        </form>
    </div> <!-- fin fluid -->
</main>
<?php require_once '../../footer.php'; ?>
<script src="<?= $host ?>/js/persona.js"></script>
</body>

</html>