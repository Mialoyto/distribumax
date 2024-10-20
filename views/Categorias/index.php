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
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!--Las filas se llenarán aqui-->
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
<script src="../../js/categorias/listar.js"></script>
<?php require_once '../../footer.php';?>
</body>
</html>