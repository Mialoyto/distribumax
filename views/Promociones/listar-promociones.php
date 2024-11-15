<?php require_once '../header.php'; ?>
<main>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Listado de Promociones
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table id="table-promociones" class="display" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Tipo de Promoción</th>
                            <th>Descripción de la Promoción</th>
                            <th>Fecha de Inicio</th>
                            <th>Fecha de Fin</th>
                            <th>Valor de Descuento</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!--Las filas se llenarán aquí-->
                    </tbody>
                </table>
            </div>
            <div class="card-footer d-flex justify-content-end">
                <a href="http://localhost/distribumax/views/promociones/" class="btn btn-primary"><i class="bi bi-arrow-left-circle"></i></a>
            </div>
        </div>
    </div>
</main>

<?php require_once '../footer.php'; ?>
<!-- <script src="http://localhost/distribumax/js/tipopromociones/registrar.js"></script> -->
<script src="http://localhost/distribumax/js/tipopromociones/listar.js"></script>
</body>

</html>