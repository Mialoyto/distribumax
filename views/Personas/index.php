<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Listado de Personas
            <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
                <div class="text-end">
                    <a href=<?= $URL . 'reports/Personas/contenidoPDF.php' ?> class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
                        <i class="fas fa-file-pdf me-1"></i> Generar PDF
                    </a>
                    <a href="generar-excel.php" class="btn btn-success">
                        <i class="fas fa-file-excel me-1"></i> Generar Excel
                    </a>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table-personas" class="table" style="width: 100%;">
                        <thead>
                            <tr class="text-center">
                                <th>Tipo Documento</th>
                                <th>DNI</th>
                                <th>Nombres</th>
                                <th>Apellido paterno</th>
                                <th>Apellido materno</th>
                                <th>Distrito</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!--Las filas se llenarán aquí-->
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <a href="registrar.php" class="btn btn-primary">Registrar Persona</a>
                </div>
            </div>
        </div>
</main>
<script src="http://localhost/distribumax/js/personas/listar.js"></script>
<?php require_once '../footer.php'; ?>
</body>

</html>