<?php
require_once '../header.php';
?>
<main>
    <div class="container">
        <div class="card mt-4">
            <div class="card-body">
                <div class="table-responsive">
                  <h1>Inicio</h1>
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