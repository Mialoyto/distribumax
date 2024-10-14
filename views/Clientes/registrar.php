<?php
require_once '../../header.php';
?>

<main>
  <div class="container-fluid px-4">
    <h1 class="mt-4">Registrar Nuevo Cliente</h1>
    <ol class="breadcrumb mb-4"></ol>

    <!-- Tabs para cambiar entre Persona y Empresa -->
    <div class="card">
      <ul class="nav nav-tabs" id="cliente" role="tablist">
        <li class="nav-item" role="presentation">
          <a class="nav-link" id="persona-tab" data-bs-toggle="tab" href="#persona" role="tab" aria-controls="persona" aria-selected="false">Persona</a>
        </li>
        <li class="nav-item" role="presentation">
          <a class="nav-link" id="empresa-tab" data-bs-toggle="tab" href="#empresa" role="tab" aria-controls="empresa" aria-selected="false">Empresa</a>
        </li>
      </ul>

      <div class="tab-content mt-4">
        <!-- Formulario de Persona -->
        <div class="tab-pane fade" id="persona" role="tabpanel" aria-labelledby="persona-tab">
          <form action="" id="registrar-persona">
            <div class="card">
              <div class="card-body">
                <!-- Campos específicos para Persona -->
                <div class="row">
                  <div class="col-md-6 mb-2">
                    <div class="form-floating">
                      <input type="number" class="form-control" id="nro-doc-persona" placeholder="Número de documento" min="0" required oninput="seleccionarTipoDocumento(this.value)">
                      <label for="nro-doc-persona"><i class="bi bi-search"></i> Número de documento</label>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-3 mb-4">
                    <div class="form-floating">
                      <select name="" id="idtipodocumento" class="form-control">
                        <option value="">Seleccione un tipo de documento</option>
                        <!-- Las opciones se llenarán dinámicamente aquí -->
                      </select>
                      <label for="idtipodocumento" class="form-label">Tipo Documento</label>
                    </div>
                  </div>
                  <div class="col-md-3 mb-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="apellido-paterno" placeholder="Apellido Paterno" required>
                      <label for="apellido-paterno" class="form-label">Apellido Paterno</label>
                    </div>
                  </div>
                  <div class="col-md-3 mb-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="apellido-materno" placeholder="Apellido Materno" required>
                      <label for="apellido-materno" class="form-label">Apellido Materno</label>
                    </div>
                  </div>
                  <div class="col-md-3 mb-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="nombres" placeholder="Nombres" required>
                      <label for="nombres" class="form-label">Nombres</label>
                    </div>
                  </div>
                </div>
                <div class="row">
                <div class="col-md-3 mb-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" placeholder="Distrito" id="iddistrito-persona">
                      <label for="">Distrito</label>
                    </div>
                  </div>
                  <div class="col-md-3 mb-4">
                    <div class="form-floating">
                      <input type="tel" class="form-control" placeholder="Teléfono" id="telefono-persona">
                      <label for="">Teléfono</label>
                    </div>
                  </div>
                  <div class="col-md-3 mb-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" placeholder="Dirección" id="direccion-persona">
                      <label for="">Dirección</label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-footer d-flex justify-content-end">
              <button type="reset" class="btn btn-danger" id="btnCancelarPersona">Cancelar</button>
              <button type="submit" class="btn btn-success" id="registrarPersona">Registrar</button>
            </div>
          </form>
        </div>

        <!-- Formulario de Empresa -->
        <div class="tab-pane fade" id="empresa" role="tabpanel" aria-labelledby="empresa-tab">
          <form action="" id="registrar-empresa">
            <div class="card">
              <div class="card-body">
                <!-- Campos específicos para Empresa -->
                <div class="row">
                  <div class="col-md-6 mb-2">
                    <div class="form-floating">
                      <input type="number" class="form-control" id="nro-doc-empresa" name="nro-doc-empresa" placeholder="Ruc" min="0" max="99999999999" required oninput="this.value = this.value.slice(0, 11)">
                      <label for="nro-doc-empresa"><i class="bi bi-search"></i>Ruc</label>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="iddistrito" placeholder="Distrito" required>
                      <label for="">Distrito</label>
                    </div>
                  </div>
                  <div class="col-md-4 mb-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="razon-social" placeholder="Razón Social" required>
                      <label for="razon-social" class="form-label">Razón Social</label>
                    </div>
                  </div>

                  <div class="col-md-4 mb-4">
                    <div class="form-floating">
                      <input type="email" class="form-control" id="email" placeholder="Email" required>
                      <label for="email" class="form-label">Email</label>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-md-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="direccion" placeholder="Dirección" required>
                      <label for="">Dirección</label>
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="form-floating">
                      <input type="text" class="form-control" id="telefono-empresa" placeholder="Teléfono" required>
                      <label for="">Teléfono</label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="card-footer d-flex justify-content-end">
              <button type="reset" class="btn btn-danger" id="">Cancelar</button>
              <button type="" class="btn btn-success" id="registrarEmpresa">Registrar</button>
            </div>
          </form>
        </div>
      </div>

      <div class="card-footer d-flex justify-content-end">
        <a href="index.php" class="btn btn-primary">Listar</a>
      </div>
    </div>
  </div>
</main>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    // Inicialmente oculta ambas secciones
    document.querySelector("#persona").classList.remove("show", "active");
    document.querySelector("#empresa").classList.remove("show", "active");

    // Escucha los clics en las pestañas y muestra el contenido correspondiente
    const personaTab = document.querySelector("#persona-tab");
    const empresaTab = document.querySelector("#empresa-tab");

    personaTab.addEventListener("click", function () {
      document.querySelector("#persona").classList.add("show", "active");
      document.querySelector("#empresa").classList.remove("show", "active");
    });

    empresaTab.addEventListener("click", function () {
      document.querySelector("#empresa").classList.add("show", "active");
      document.querySelector("#persona").classList.remove("show", "active");
    });
  });

  // Función para cargar los tipos de documentos
   (() => {
   fetch(`../../controller/documento.controller.php?operation=getAllDocumentos`)
   .then(response => response.json())
   .then(data => {
   const optionEmp = document.querySelector("#idtipodocumento");
   data.forEach(element => {
   const tagOption = document.createElement('option');
   tagOption.value = element.idtipodocumento;
   tagOption.innerText = element.documento;
   optionEmp.appendChild(tagOption);
   });
   })
   .catch(e => {
   console.error(e);
   });
   })();
   
  //  Función para seleccionar el tipo de documento
   function seleccionarTipoDocumento(numeroDocumento) {
   const tipoDocSelect = document.getElementById("idtipodocumento");
   
  //  Verifica si el número de documento tiene 8 dígitos
   if (numeroDocumento.length === 8) {
   tipoDocSelect.value = "DNI"; // Selecciona automáticamente DNI
   const opciones = tipoDocSelect.options;
   for (let i = 0; i < opciones.length; i++) {
   if (opciones[i].innerText === "DNI") {
   tipoDocSelect.value = opciones[i].value; // Asigna el ID del tipo de documento
   break;
   }
   }
   } else {
   tipoDocSelect.value = ""; // Restablece la selección si no tiene 8 dígitos
   }
   }
</script>
<script src="../../js/clientes/registrar.js"></script>
<script src="../../js/clientes/registrarPersonas.js"></script>
<?php
require_once '../../footer.php';
?>
