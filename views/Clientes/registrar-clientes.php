<?php
require_once '../../header.php';
?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Cliente</h1>
    <ol class="breadcrumb mb-4"></ol>

    <!-- Tabs para cambiar entre Persona y Empresa -->
    <div class="card">
      <div class="card-header">
        <h5><i class="bi bi-person-plus"></i> Registrar Cliente</h5>
      </div>

      <ul class="nav nav-tabs" id="cliente" role="tablist">
        <li class="nav-item" role="presentation">
          <a class="nav-link active" id="persona-tab" data-bs-toggle="tab" data-bs-target="#persona" role="tab" type="button" aria-controls="persona" aria-selected="true">Persona</a>
        </li>
        <li class="nav-item" role="presentation">
          <a class="nav-link" id="empresa-tab" data-bs-toggle="tab" data-bs-target="#empresa" role="tab" type="button" aria-controls="empresa" aria-selected="false">Empresa</a>
        </li>
      </ul>

      <div class="card-body">
        <div class="tab-content mt-4" id="cliente">
          <!-- Formulario de Persona -->

          <div class="tab-pane fade show active" id="persona" role="tabpanel" aria-labelledby="persona-tab" tabindex="0">
            <form id="registrar-persona">
              <div class="card">
                <div class="card-body">
                  <!-- Campos específicos para Persona -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="form-floating">
                        <input type="number" class="form-control" id="nro-doc-persona" placeholder="Número de documento" min="0" required >
                        <label for="nro-doc-persona"><i class="bi bi-search"></i> Buscar número de documento</label>
                      </div>
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-3">
                      <div class="form-floating">
                        <select name="" id="idtipodocumento" class="form-control">
                          <option value="">Seleccione un tipo de documento</option>
                          <!-- Las opciones se llenarán dinámicamente aquí -->
                        </select>
                        <label for="idtipodocumento" class="form-label">Tipo Documento</label>
                      </div>
                    </div>
                    <div class="col-md-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="apellido-paterno" placeholder="Apellido Paterno" required>
                        <label for="apellido-paterno" class="form-label">Apellido Paterno</label>
                      </div>
                    </div>
                    <div class="col-md-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="apellido-materno" placeholder="Apellido Materno" required>
                        <label for="apellido-materno" class="form-label">Apellido Materno</label>
                      </div>
                    </div>
                    <div class="col-md-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="nombres" placeholder="Nombres" required>
                        <label for="nombres" class="form-label">Nombres</label>
                      </div>
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" placeholder="Distrito" id="iddistrito-persona">
                        <label for="">Distrito</label>
                      </div>
                    </div>
                    <div class="col-md-3">
                      <div class="form-floating">
                        <input type="tel" class="form-control" placeholder="Teléfono" id="telefono-persona">
                        <label for="">Teléfono</label>
                      </div>
                    </div>
                    <div class="col-md-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" placeholder="Dirección" id="direccion-persona">
                        <label for="">Dirección</label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-footer d-flex justify-content-end">
                  <button type="submit" class="btn btn-success mt-2 mb-2 me-2" id="registrarPersona">Registrar</button>
                  <button type="reset" class="btn btn-outline-danger mt-2 mb-2" id="btnCancelarPersona">Cancelar</button>
                </div>
              </div>
            </form>
          </div>

          <!-- Formulario de Empresa -->
          <div class="tab-pane fade" id="empresa" role="tabpanel" aria-labelledby="empresa-tab" tabindex="0">
            <form action="" id="registrar-empresa" autocomplete="off">
              <div class="card">
                <div class="card-body">
                  <!-- Campos específicos para Empresa -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="input-group">
                        <div class="form-floating">
                          <input type="number"

                            class="form-control"
                            id="nro-doc-empresa"
                            name="nro-doc-empresa"
                            placeholder="Ruc"
                            minlength="11"
                            maxlength="11"
                            title="Por favor, ingresa solo números."
                            required>
                          <label for="nro-doc-empresa"><i class="bi bi-search"></i> Buscar ruc</label>
                        </div>
                        <button class="btn btn-primary" type="button" id="btn-cliente-empresa"><i class="bi bi-search"></i></button>
                      </div>
                      <span id="status" class="d-none">Buscando por favor espere...</span>
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-4 mt-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="iddistrito" placeholder="Distrito" disabled="true" required>
                        <label for="">Distrito</label>
                        <ul id="datalistDistrito" class="list-group position-absolute w-100 ListarDatos" style="z-index: 1000; display: none;"></ul>
                      </div>
                    </div>
                    <div class="col-md-8 mt-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="razon-social" placeholder="Razón Social" required disabled="true">
                        <label for="razon-social" class="form-label">Razón Social</label>
                      </div>
                    </div>
                  </div>
                  <div class="row mb-3">
                    <div class="col-md-4 mt-3">
                      <div class="form-floating">
                        <input type="email" class="form-control" id="email" placeholder="Email" disabled="true">
                        <label for="email" class="form-label">Email</label>
                      </div>
                    </div>
                    <div class="col-md-5 mt-3">
                      <div class="form-floating">
                        <input type="text" class="form-control" id="direccion" placeholder="Dirección" required disabled="true">
                        <label for="">Dirección</label>
                      </div>
                    </div>
                    <div class="col-md-3 mt-3">
                      <div class="form-floating">
                        <input
                          type="number"
                          minlength="9"
                          maxlength="9"
                          class="form-control"
                          id="telefono-empresa"
                          placeholder="Teléfono"
                          disabled="true">
                        <label for="">Teléfono</label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="card-footer d-flex justify-content-end mt-3">
                  <button type="submit" class="btn btn-success mt-2 mb-2 me-2" id="registrarEmpresa" disabled="true"> Registrar</button>
                  <button type="reset" class="btn btn-outline-danger mt-2 mb-2">Cancelar</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="card-footer mt-3">
        <a href="index.php" class="btn btn-primary mt-2 mb-2">Listar clientes</a>
      </div>
    </div>
  </div>
</main>
<?php require_once '../../footer.php'; ?>
<script src="../../js/clientes/registrar-clientes.js"></script>
<script src="../../js/clientes/registrarPersonas.js"></script>