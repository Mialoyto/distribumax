<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>
<main>
    <div class="container-fluid px-4">
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>

        <div class="card mb-4">
            <div class="card-header d-flex align-items-center">
                <i class="fas fa-table me-1 fa-lg"></i> Listado de compras

            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table-compras" class="table table-striped" style="width: 100%;">
                        <thead>
                            <tr>
                                <th>Nro Comprobante</th>
                                <th>Proveedor</th>
                                <th>Fecha</th>
                               
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Las filas se llenarán aquí -->
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <a href="registrar-compra.php" class="btn btn-primary">Registrar Compra</a>
                </div>
            </div>
        </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="../../js/compras/listar-compras.js"></script>
</body>

</html>