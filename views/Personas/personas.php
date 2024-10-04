<?php require_once '../../header.php'; ?>
<main>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Listado de Personas
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table id="table-personas" class="table" style="width: 100%;">
                    <thead>
                        <tr class="text-center">
                            <th>Tipo documento</th>
                            <th>DNI</th>
                            <th>Nombres</th>
                            <th>Apellido paterno</th>
                            <th>Apellido materno</th>
                            <th>Distrito</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!--Las filas se llenarán aquí-->
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <a href="index.php" class="btn btn-primary">Volver al Registrar Persona</a>
            </div>
        </div>
    </div>
</main>
<script src="../../js/personas/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>
