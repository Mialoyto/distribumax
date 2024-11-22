<?php
require_once '../header.php';
?>
<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Despacho</h1>
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>
        <!-- Modal -->
        <div class="modal fade" id="generarReporte" tabindex="-1" aria-labelledby="generarReporte" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
    
                        </h5>
                                        </div>
                    <div class="modal-body">
                        <div class="table-responsive">
                            <table id="table-ventas" class="table" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>pedido</th>
                                        
                                    </tr>
                                </thead>
                                <tbody id="table-ventas">
                                    <!-- Las filas se llenarán aquí -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>

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
                                <th>Peril</th>
                                <th>Conductor</th>
                                <th>Vehiculo</th>
                                <th>Despacho</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="table-despacho">
                            <!-- Las filas se llenarán aquí -->
                        </tbody>
                    </table>

                </div>
                <div class="card-footer">
                    <a href="registrar-despacho.php" class="btn btn-primary">Registrar</a>
                </div>
            </div>
        </div>
    </div>
</main>

<script src="../../js/Despacho/listar.js"></script>

<?php
require_once '../footer.php';
?>