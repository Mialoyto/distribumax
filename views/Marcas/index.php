<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>

<main>
    <div class="container-fluid px-4">
        <ol class="breadcrumb mb-4">
       
        </ol>
        <div class="card mb-4">
            <div class="card-header">
                <i class="fas fa-table me-1"></i>
                Listado de Marcas
                <!-- <div class="ms-auto"> 
                    <div class="text-end">
                        <a href="<?= $URL . 'reports/Marcas/contenidoPDF.php' ?>" class="me-2 btn btn-danger text-white">
                            <i class="fas fa-file-pdf me-1"></i> Generar PDF
                        </a>
                        <a href="generar-excel.php" class="btn btn-success">
                            <i class="fas fa-file-excel me-1"></i> Generar Excel
                        </a>
                    </div>
                </div> -->
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="table-marcas" class="table table-striped " style="width: 100%;">
                        <thead>
                            <tr>
                                <th>Nombre Marca</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Las filas se llenarán aquí -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="card-footer">
                <a href="registrar-marca.php" class="btn btn-primary">Registrar Marca</a>
            </div>
        </div>
    </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/marca/listar.js"></script>
</body>
</html>