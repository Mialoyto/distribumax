import { cargarTipoDoc } from "../utils/utils.js";

document.addEventListener('DOMContentLoaded', async () => {
  /* variable globa */
  function $(object = null) {
    return document.querySelector(object);
  }
  // carga los tipos de documentos
  await cargarTipoDoc($('#id-tip-doc'));
  // console.log(datos);

  const docTypeMap = {
    8: "DNI",
    11: "RUC",
    12: "CE"
  };

  function validarLongdoc() {
    let digitos = $('#nro-doc').value;
    const docType = docTypeMap[digitos.length] || "";
    const option = Array.from($("#id-tip-doc").options).find(option => option.text === docType);
    if (option) {
      $("#id-tip-doc").value = option.value;
    } else {
      $("#id-tip-doc").value = "";
    }
  }

  async function buscadNroDoc() {
    const params = new URLSearchParams();
    params.append('operation', 'searchDni');
    params.append('idtipodocumento', $("#id-tip-doc").value);
    params.append('idpersonanrodoc', $("#nro-doc").value);

    try {
      const response = await fetch(`../../controller/persona.controller.php?${params}`);
      return response.json();
    } catch (error) {
      console.error(error);
    }
  }

  async function mostrarData() {
    const data = await buscadNroDoc();
    console.log(data)
    if (data.length != 0) {
      $("#nombres").value = data[0].nombres;
      $("#appaterno").value = data[0].appaterno;
      $("#apmaterno").value = data[0].apmaterno;
    } else {
      $("#nombres").value = "";
      $("#appaterno").value = "";
      $("#apmaterno").value = "";
    }
  }
  /* funcion para agregar detalle*/
  async function addDetalle() {
    const tbody = $('#detalle-productos tbody');
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <th class="col-md-3">
          <div class="mt-1">
              <select class="form-control form-control-sm" name="idproducto" id="idproducto" name="idproducto">
                  <option value="">Seleccione un producto</option>
                  <option value="1">Prodcuto 1</option>
                  <!-- Opciones dinámicas -->
              </select>
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm cantidad"name="cantidad" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm und-medida" name="und-medida" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm precio-unitario" name="precio-unitario" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm descuento" name="descuento" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm subtotal" name="subtotal" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1  d-flex justify-content-evenly">
              <button type="button" class="btn btn-warning btn-sm w-100">
                  <i class="bi bi-pencil-square"></i>
              </button>
              <button type="button" class="btn btn-danger btn-sm w-100">
                  <i class="bi bi-x-square"></i>
              </button>
          </div>
      </th>
  `;
    tbody.appendChild(tr);
  }

  $("#agregar-producto").addEventListener("click", async () => {
    await addDetalle();
  });

  $("#nro-doc").addEventListener("input", async () => {
    validarLongdoc();
    await mostrarData();
  })

  /* pruebas para ver si captura lod datos del campos */
  $("#registrar-pedido").addEventListener("submit", async (e) => {
    e.preventDefault();
    const form = new FormData($("#registrar-pedido"));
    console.log(form);
    console.log(form.get('id-tip-doc'));
    console.log(form.get('nro-doc'));
    console.log(form.get('nombres'));
    console.log(form.get('appaterno'));
    console.log(form.get('apmaterno'));
    console.log(form.get('idproducto'));
    console.log(form.get('cantidad'));
    console.log(form.get('und-medida'));
    console.log(form.get('precio-unitario'));
    console.log(form.get('descuento'));
    console.log(form.get('subtotal'));
  })

/* funcion test de id de pedido */
async function testIdPedido() {

  const params = new URLSearchParams();
}

  /* fin */

})
/* fin */