<?php require_once '../../header.php';?>
<?php require_once '../../app/config/App.php'; ?>
<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Vehiculos</h1>
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>
        <!-- Modal -->
        <div class="card mb-4">
            <div class="card-header">
                <i class="fas fa-table me-1"></i>
                Listado de Vehiculos
                <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
                <div class="text-end">
                    <a href=<?= $URL . 'reports/Vehiculos/contenidoPDF.php' ?> class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
                        <i class="fas fa-file-pdf me-1"></i> Generar PDF
                    </a>
                    <a href="generar-excel.php" class="btn btn-success">
                        <i class="fas fa-file-excel me-1"></i> Generar Excel
                    </a>
                </div>
            </div>
            </div>
            <div class="card-body">
                
                <div class="table-responsive">
                    <table id="table-vehiculos" class="table" style="width: 100%;">
                        <thead>
                            <tr>
                                <!-- <th>Vehiculo</th> -->
                                <th>Conductor</th>
                                <th>Marca</th>
                                <th>Modelo</th>
                                <th>Placa</th>
                                <th>Capacidad</th>
                                <th>Condicion</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Las filas se llenarán aquí -->
                        </tbody>
                    </table>

                </div>
                <div class="card-footer">
                    <a href="registrar.php" class="btn btn-primary">Registrar nuevo Vehiculo</a>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="../../js/vehiculos/listar.js"> </script>
<?php
require_once '../../footer.php';
?>