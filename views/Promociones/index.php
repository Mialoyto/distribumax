<?php
require_once '../header.php';
?>
<main>


    <div class="container mt-5">
        <!-- Formulario Completo -->
        <div class="card shadow-lg border-0 rounded-lg">
            <div class="card-header d-flex justify-content-between aligns-item-center">
                <div>
                    <h3 class="text">Registro de Promociones</h3>
                </div>
                <div>
                    <button type="button" class="btn btn-primary float-end" data-bs-toggle="modal" data-bs-target="#modalTipoPromocion">
                        <i class="bi bi-bookmark-plus"></i> Registrar tipo
                    </button>
                </div>
            </div>

            <!-- MODAL -->
            <div class="modal fade " id="modalTipoPromocion" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalTipoPromocionLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalTipoPromocionLabel">Registro de Tipo de Promoción</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="add-tipo-promocion">
                            <div class="modal-body">

                                <span class="badge text-bg-light text-uppercase text-end" id="user" data-id="<?= $_SESSION['login']['idusuario'] ?>"></span>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="tipopromocion" name="tipopromocion" placeholder="Tipo de Promoción" required>
                                            <label for="tipopromocion"><i class="bi bi-tag"></i> Tipo de Promoción</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <div class="form-floating">
                                            <textarea type="text" class="form-control col-5" id="descripcion" name="descripcion" placeholder="Descripción" required></textarea>
                                            <label for="descripcion"><i class="bi bi-pencil-square"></i> Descripción</label>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Registrar Tipo</button>
                                <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <!-- FIN DEL MODAL -->
            <div class="card-body">

                <form method="POST" action="#" id="form-promocion">
                    <div class="row">
                        <div class="col-md-6 mb-3 ">
                            <div class="form-floating">


                                <select class="form-control" id="idtipopromocion" name="idtipopromocion" required placeholder>
                                    <option value="">Seleccione un tipo de promoción</option>
                                    <!-- Opciones adicionales se agregarán dinámicamente -->
                                </select>
                                <label for="idtipopromocion">Tipo de Promoción</label>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="form-floating">

                                <input type="text" class="form-control" placeholder id="descripcion_promocion" name="descripcion_promocion" required placeholder>
                                <label for="descripcion_promocion">Descripción de la Promoción</label>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <div class="form-floating">
                                <input type="date" class="form-control" id="fechainicio" name="fechainicio" required placeholder>
                                <label for="fechainicio">Fecha de Inicio</label>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <div class="form-floating">
                                <input type="date" class="form-control" id="fechafin" name="fechafin" required placeholder>
                                <label for="fechafin">Fecha de Fin</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="form-floating">
                            <input type="number" step="0.01" class="form-control" id="valor_descuento" name="valor_descuento" min="0.01" required placeholder>
                            <label for="valor_descuento" class="form-label">Valor del Descuento</label>
                        </div>
                    </div>

                    <!-- Botones -->
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">Registrar Promoción</button>
                        <button type="reset" class="btn btn-secondary me-2">Cancelar</button>
                        <a href="http://localhost/distribumax/views/promociones/listar-promociones.php" class="btn btn-outline-primary">Listar promociones</a>
                    </div>
                </form>
            </div>
        </div>


</main>
<!-- Modal para Registrar Tipo de Promoción -->

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/promociones/registrar.js"></script>
<script src="http://localhost/distribumax/js/tipopromociones/registrar.js"></script>


</body>

</html>