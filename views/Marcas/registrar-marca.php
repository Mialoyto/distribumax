<?php
require_once '../header.php';
?>
<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Marcas</h1>
    <ol class="breadcrumb mb-4">
      <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
    </ol>

    <div class="card mb-4">
      <div class="card-header">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <i class="fas fa-table me-1"></i>
            Registro de Marcas
          </div>

          <div class="btn-group align-items-center" role="group" aria-label="Basic example">
            <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#categoriaAdd">
              <i class="bi bi-plus-circle"></i>
              Categoría
            </button>
            <a type="button" class="btn btn-outline-primary btn-sm" href="http://localhost/distribumax/views/Categorias/listar-categoria.php">
              <i class="bi bi-list-check"></i>
              Listar Categorías
            </a>
            <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#subcategoriaAdd">
              <i class="bi bi-plus-circle"></i>
              Subcategoría
            </button>
            <a type="button" class="btn btn-outline-primary btn-sm" href="http://localhost/distribumax/views/subcategoria/listar-subcategoria.php">
              <i class="bi bi-list-check"></i>
              Listar Subcategorías
            </a>
          </div>
          <!-- MODAL PARA REGISTRAR CATEGORIA  -->
          <div class="modal fade" id="categoriaAdd"
            data-bs-backdrop="static"
            data-bs-keyboard="false"
            tabindex="-1"
            aria-labelledby="staticBackdropLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="staticBackdropLabel">REGISTRAR CATEGORIA</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="" action="#" id="form-categoria" autocomplete="off">
                  <div class="modal-body">
                    <div class="form-floating mb-3">
                      <input type="text" id="categoria" name="categoria" class="form-control" placeholder="Ej. Alimentos" autocomplete="off" required>
                      <label for="categoria" class="form-label">
                        <i class="bi bi-tag"></i>
                        Categoría
                      </label>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="submit" id="btn-add-lote" class="btn btn-success">Registrar</button>
                    <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
          <!-- FIN MODAL REGISTRAR CATEGORIA -->
          <!--MODAL PARA REGISTRAR SUBCATEGORIA -->
          <div class="modal fade" id="subcategoriaAdd"
            data-bs-backdrop="static"
            data-bs-keyboard="false"
            tabindex="-1"
            aria-labelledby="staticBackdropLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="staticBackdropLabel">REGISTRAR SUBCATEGORIA</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form method="" action="#" id="form-categoria" autocomplete="off">
                  <div class="modal-body">
                    <div class="form-floating mb-3">
                      <select name="searchcategoria" class="form-control select-categorias" placeholder="Ej. Alimentos" required>
                        <option value="">Seleccione categoría</option>
                      </select>
                      <label for="searchcategoria" class="form-label">
                        <i class="bi bi-tag"></i>
                        Categoría
                      </label>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                      <div class="mb-3 me-3">
                        <span>Agregar subcategorias </span>
                        <button type="button" id="btn-subcategoria" class="btn btn-primary btn-sm"><i class="bi bi-plus-circle"></i></button>
                      </div>
                      <div class="mb-3">
                        <span>Subcategorías agregadas: </span>
                        <span id="contador-subcategorias">0</span>
                      </div>
                    </div>
                    <div id="addsubcategoria" class="overflow-auto" style="max-height: 35vh;">
                      <!-- renderizaran mas inputs -->
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="submit" id="btn-add-lote" class="btn btn-success">Registrar</button>
                    <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
          <!-- FIN MODAL DE SUBCATEGORIA -->

          <!-- MODAL PARA LISTAR SUBCATEGORIA -->
          <div class="modal fade" id="list-categorias" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
              <div class="modal-content">
                <div class="modal-header">
                  <i class="fas fa-table me-1"></i>
                  <h1 class="modal-title fs-5" id="staticBackdropLabel">Listado de subcategorias</h1>
                  <div class="text-end align-items-center">
                  </div>
                  <button type="button" class="btn-close text-end" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <div class="card mt-4">
                    <div class="card-body">
                      <div class="table-responsive">
                        <table class="table" id="table-categorias" style="width: 100%;">
                          <thead>
                            <tr>
                              <th>Categoría</th>
                              <th>Subcategoría</th>
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
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- FIN MODAL DE SUBCATEGORIA -->
        </div>

        <div class="card-body">
          <!-- pruebas -->

          <!-- Formulario de Registro de Marca -->
          <form method="POST" action="#" id="form-registrar-marca" autocomplete="off">
            <!-- FILA N°01 -->
            <div class="row mt-3">
              <div class="col-12">
                <div class="form-floating">
                  <input
                    type="search"
                    class="form-control"
                    id="idproveedor"
                    name="idproveedor"
                    placeholder="Proveedor"
                    required>
                  <label for="idproveedor" class="form-label">
                    <i class="bi bi-search"></i> Buscar proveedor
                  </label>
                  <ul
                    id="list-proveedor"
                    class="list-group position-absolute w-100 listarDatos"
                    style="z-index: 1000; display: none;">
                  </ul>
                </div>
              </div>
            </div>
            <!-- FILA N°02 -->
            <div class="row mt-3">
              <div class="col-6 mb-3">
                <div class="form-floating">
                  <input
                    type="text"
                    class="form-control"
                    id="marca"
                    minlength="1"
                    maxlength="100"
                    required
                    placeholder="Marca">
                  <label for="marca">Marca</label>
                </div>
              </div>
              <div class="col-6 mb-3">
                <div class="form-floating">
                  <select name="" class="form-select select-categorias" required>
                    <option value="">Seleccione categoría</option>
                    <!-- Aquí puedes agregar más opciones de categorías -->
                  </select>
                  <label for="idcategoria">Buscar categoría</label>
                </div>
              </div>
              <!-- select de subcategoria -->
              <!--  <div class="col-4 mb-3">
              <div class="form-floating">
                <select name="" id="idsubcategoria" class="form-select">
                  <option value=""></option>
                  
                </select>
                <label for="idsubcategoria">Buscar categoría</label>
              </div>
            </div> -->

            </div>

        </div>
        <div class="card-footer">


          <!-- Botones de acción -->
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <a href="index.php" class="btn btn-primary btn-sm">Listar Marcas</a>
            </div>
            <div>
              <button type="submit" class="btn btn-success btn-sm me-2" id="btn-registrar">
                <i class="fa fa-check me-2"></i> Registrar Marca
              </button>
              <button type="reset" class="btn btn-outline-danger btn-sm">
                <i class="fa fa-times me-2"></i> Cancelar
              </button>
            </div>
          </div>
        </div>
        </form>
      </div>
    </div>
</main>

<?php require_once '../footer.php'; ?>
<script src="http://localhost/distribumax/js/categorias/registrar-categoria.js"></script>
<script src="http://localhost/distribumax/js/marca/registrar.js"></script>
<script src="http://localhost/distribumax/js/utils/utils.js"></script>
<script src="http://localhost/distribumax/js/marca/listar.js"></script>
<script src="http://localhost/distribumax/js/subcategorias/listar-subcategoria.js"></script>