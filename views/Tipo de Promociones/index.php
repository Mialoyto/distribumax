<?php require_once '../../header.php'; ?>
<main>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Listado de Tipo de Promociones
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table id="table-tipopromociones" class="table" style="width: 100%;">
                    <thead>
                        <tr class="text-center">
                            <th>Tipo de Promoción</th>
                            <th>Descripción</th>
                            <th>Fecha de Inicio</th>
                            <th>Fecha de Fin</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!--Las filas se llenarán aquí-->
                    </tbody>
                </table>
            </div>
            <div class="card-footer d-flex justify-content-end">
                <a href="registrar.php" class="btn btn-primary">Registrar Tipo de Promoción</a>
            </div>
        </div>
    </div>
</main>
<script src="../../js/tipopromociones/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>
