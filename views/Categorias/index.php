<?php
require_once '../../header.php';
?>
<main>
    <div class="container">
        <div class="card mt-4">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table" id="table-categorias" style="width: 100%;">
                        <thead>
                            <tr>
                                <th>Nombre de Categoría</th>
                                <th>Fecha Creación</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>
                <!-- Botón ubicado dentro del DataTable en la parte inferior derecha -->
                <div class="d-flex justify-content-end mt-3">
                    <a href="registrar.php" class="btn btn-primary">Registrar nueva categoría</a>
                </div>
            </div>
        </div>
    </div><!-- Fin del container -->
</main>
<?php require_once '../../footer.php';?>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- DataTables Core -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<!-- DataTables Bootstrap 5 -->
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<!-- Enlace del JavaScript de DataTable -->
<script src="../../js/categorias/listar.js"></script>
</body>
</html>