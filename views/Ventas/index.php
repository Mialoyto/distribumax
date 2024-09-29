<?php
require_once '../../header.php';
?>


<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Empresas</h1>
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>
        <!-- Modal -->
        <div class="modal fade" id="detalleModal" tabindex="-1" aria-labelledby="detalleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="detalleModalLabel">Detalles de la Venta</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="modal-body">
                        <!-- Los detalles se cargarán aquí -->
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
                Listado de Empresas
            </div>
            <div class="card-body">
                
                <div class="table-responsive">
                    <table id="table-ventas" class="table" tyle="width: 100%;">
                        <thead>
                            <tr>
                                <th>ID Pedido</th>
                                <th>Tipo Cliente</th>
                                <th>Productos</th>
                                <th>Cantidades</th>
                                <th>Total Subtotal</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Las filas se llenarán aquí -->
                        </tbody>
                    </table>

                </div>
                <div class="card-footer">
                    <a href="registrar.php" class="btn btn-primary">Registrar nueva Venta</a>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="../../js/ventas/listar.js"></script>
<?php
require_once '../../footer.php';
?>