<?php
require_once '../../header.php';
?>
<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Despacho</h1>
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>
        <!-- Modal -->
        <div class="card mb-4">
            <div class="card-header">
                <i class="fas fa-table me-1"></i>
                Listado despacho
            </div>
            <div class="card-body">
                
                <div class="table-responsive">
                    <table id="table-despacho" class="table" tyle="width: 100%;">
                        <thead>
                            <tr>
                                <!-- <th>Vehiculo</th> -->
                                <th>Despacho</th>
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
                    <a href="registrar-despacho.php" class="btn btn-primary">Registrar nuevo Despacho</a>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="../../js/vehiculos/listar.js"> </script>
<?php
require_once '../../footer.php';
?>