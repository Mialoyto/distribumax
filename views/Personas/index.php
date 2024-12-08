<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Personas</h1>
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>

        <div class="card mb-4">
            <div class="card-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas fa-table me-1 fa-lg"></i>Listado de Personas
                    </div>
                    <div>
                    <a href="<?= $URL . 'reports/Proveedores/contenidoPDF.php' ?>" 
						   type="button" 
						   class="me-2 btn btn-danger" 
						   data-bs-toggle="tooltip" 
						   data-bs-placement="bottom" 
               data-bs-title="Generar PDF">
               <i class="bi bi-file-earmark-pdf fs-3"></i>
            </a>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table-personas" class="table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th>DNI</th>
                                <th>Nombres</th>
                                <th>Apellido Paterno</th>
                                <th>Apellido Materno</th>
                                <th>Telefono</th>
                                <th>Direccion</th>
                                <th>Distrito</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Las filas se llenarán aquí dinámicamente -->
                        </tbody>
                    </table>

                    <!-- Modal de edición -->
                    <div class="modal fade edit-persona"
                    data-bs-backdrop="static"
                    data-bs-keyboard="false"
                    tabindex="-1"
                    role="dialog"
                    aria-labelledby="staticBackdropLabel">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h1 class="modal-title fs-5" id="staticBackdropLabel">Editar Persona</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                    <!-- FORMULARIO -->
                     <form id="form-per" autocomplete="off" required method="POST">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="editDNI" class="form-label">DNI</label>
                                <input type="text" class="form-control" id="editDNI" name="dni" disabled>
                            </div>

                            <div class="mb-3">
                                <label for="editNombres" class="form-label">Nombres</label>
                                <input type="text" class="form-control" id="editNombres" name="nombres" disabled>
                            </div>

                            <div class="mb-3">
                                <label for="editApellidoPaterno" class="form-label">Apellido Paterno</label>
                                <input type="text" class="form-control" id="editApellidoPaterno" name="apellido_paterno" disabled>
                            </div>

                            <div class="mb-3">
                                <label for="editApellidoMaterno" class="form-label">Apellido Materno</label>
                                <input type="text" class="form-control" id="editApellidoMaterno" name="apellido_materno" disabled>
                            </div>

                            <div class="mb-3">
                                <label for="editTelefono" class="form-label">Telefono</label>
                                <input type="text" class="form-control" id="editTelefono" name="telefono" required>
                            </div>

                            <div class="mb-3">
                                <label for="editDireccion" class="form-label">Direccion</label>
                                <input type="text" class="form-control" id="editDireccion" name="direccion" required>
                            </div>

                            <div class="mb-3">
                                <div class="form-floating">
                                    <input type="search" class="form-control" id="buscar-distrito" list="datalistDistrito" placeholder="Buscar distrito" name="distrito" required >
                                    <label for="datalistDistrito">Buscar distrito</label>
                                    <ul id="datalistDistrito" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                                </div>
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-success" id="btnEditar">Editar</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        </div>
                     </form>
                        </div>
                    </div>
                    </div>
                </div>
                <div class="card-footer">
                    <a href="registrar.php" class="btn btn-primary">Registrar Persona</a>
                </div>
        </div>
    </div>
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/personas/listar.js"></script>
<script src="http://localhost/distribumax/js/personas/editar-persona.js"></script>
<script src="http://localhost/distribumax/js/personas/disabled-persona.js"></script>
<script src="http://localhost/distribumax/js/personas/search-distrito.js"></script>
</body>
</html>
