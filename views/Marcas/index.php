<?php require_once '../../header.php'; ?>

<main>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1">Listado de Marcas</i>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table id="table-marcas" class="table" style="width: 100%;">
                    <thead>
                        <tr class="text-center">
                            <th>Nombre Proveedor</th>
                            <th>Contacto Principal</th>
                            <th>Marca</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!--Las filas se llenarán aqui-->
                    </tbody>
                </table>
            </div>
        </div>
        <div class="card-footer">
            <a href="registrar.php" class="btn btn-primary">Registrar Marca</a>
        </div>
    </div>
</main>
<script src="../../js/marca/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>
