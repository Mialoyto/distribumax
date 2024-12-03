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
                                <th>Tipo Documento</th>
                                <th>DNI</th>
                                <th>Nombres</th>
                                <th>Apellido Paterno</th>
                                <th>Apellido Materno</th>
                                <th>Distrito</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Las filas se llenarán aquí dinámicamente -->
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <a href="registrar.php" class="btn btn-primary">Registrar Persona</a>
                </div>
        </div>
    </div>
</main>
<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/personas/listar.js"></script>
<script src="http://localhost/distribumax/js/personas/disabled-persona.js"></script>
</body>
</html>
