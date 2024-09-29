<?php
require_once '../../header.php';
?>
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
            </div>
            <div class="card-body">
                
                <div class="table-responsive">
                    <table id="table-vehiculos" class="table" tyle="width: 100%;">
                        <thead>
                            <tr>
                                <th>Vehiculo</th>
                                <th>Conductor</th>
                                <th>Marca</th>
                                <th>Modelo</th>
                                <th>Placa</th>
                                <th>Total Subtotal</th>
                                <th>Acciones</th>
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
<?php
require_once '../../footer.php';
?>