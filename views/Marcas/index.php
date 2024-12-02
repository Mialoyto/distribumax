<?php require_once '../header.php'; ?>
<?php require_once '../../app/config/App.php'; ?>

<main>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Listado de Marcas
            <div class="ms-auto"> <!-- Utilizamos ms-auto para alinear a la derecha -->
                <div class="text-end">
                    <a href=<?= $URL . 'reports/Marcas/contenidoPDF.php' ?> class="me-2" style="background-color: var(--bs-danger); color: white; padding: 0.5rem 1rem; border-radius: 0.25rem; text-decoration: none;">
                        <i class="fas fa-file-pdf me-1"></i> Generar PDF
                    </a>
                </div>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table id="table-marcas" class="table" style="width: 100%;">
                    <thead>
                        <tr class="text-center">
                            <th>Nombre Marca</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!--Las filas se llenarán aqui-->
                    </tbody>
                </table>
            </div>

        <!-- MODAL -->
         <div class="modal fade" id="edit-marca"
         data-bs-backdrop="static"
         data-bs-keyboard="false"
         tabindex="-1"
         aria-labelledby="staticBackdropLabel"
         aria-hidden="true">
         <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="staticBackdropLabel">EDITAR MARCA</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form class="edit-marca" autocomplete="off">
                    <div class="modal-body">
                        <div class="form-floating mb-3">
                            <input type="text" id="id-marca" name="edit-marca" class="form-control edit-marca" placeholder="Ej. Marcas." autocomplete="off" required>
                            <label for="marca" class="form-label">
                                <i class="bi bi-tag"></i>
                                Marca
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Registrar</button>
                        <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
                    </div>
                </form>
            </div>
         </div>
         </div>
            <!-- FIN DEL MODAL -->
        </div>
        <div class="card-footer">
            <div class="mt-3 text-end">
                <a href="http://localhost/distribumax/views/marcas/registrar-marca.php" class="btn btn-primary"><i class="bi bi-arrow-left-circle"></i></a>
            </div>
        </div>
    </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/marca/listar-marca.js"></script>
<script src="http://localhost/distribumax/js/marca/editar-marca.js"></script>
<script src="http://localhost/distribumax/js/marca/disabled-marca.js"></script>
</body>
</html>