<?php require_once '../../header.php';?>
<main>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Listado de Productos
            <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
          <div class="text-end">
            <a href="../reports/Productos/contenidoPDF.php" class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
              <i class="fas fa-file-pdf me-1"></i> Generar PDF
            </a>
            <a href="generar-excel.php" class="btn btn-success">
              <i class="fas fa-file-excel me-1"></i> Generar Excel
            </a>
          </div>
        </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table id="table-productos" class="table" style="width: 100%;">
                    <thead>
                        <tr class="text-center">
                            <th>Marca</th>
                            <th>Categoría</th>
                            <th>Nombre del Producto</th>
                            <th>Código</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Las filas se llenarán aquí -->
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <a href="registrar.php" class="btn btn-primary">Registrar</a>
            </div>
        </div>
    </div>
</main>
<script src="../../js/productos/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>