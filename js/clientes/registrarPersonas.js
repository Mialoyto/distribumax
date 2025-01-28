document.addEventListener("DOMContentLoaded", () => {
  // Corregir la función $ para que retorne el valor seleccionado
  function $(object = null) {
    return document.querySelector(object); // Debe retornar el valor
  }

  renderDocumento('.documento');


  const tipodoc = $("#idtipodocumento");



  async function getApiDni(dni) {
    try {
      $("#statusdni").classList.remove("d-none");
      const response = await fetch(`../../app/api/api.dni.php?dni=${dni}`, {
        method: 'GET'
      });
      return response.json();  // Parsear la respuesta como JSON

    } catch (e) {
      console.error("Error en buscarDni: ", e);
    }
  }
  $("#btn-cliente-persona").addEventListener('keydown', (event) => {
    if (event.key === "Enter") {
      event.preventDefault();
      renderData();
    }
  });

  async function renderData() {
    const dni = $("#nro-doc-persona").value;
    const dataDB = await searchCliente(dni);
    console.log(dataDB);
    if (dni.length === 8) {
      if (dataDB.length != 0) {
        addClientePersona(false);
        console.log('dentro de db', dataDB);
        $("#nombres").value = dataDB[0].nombres;
        $("#apellido-paterno").value = dataDB[0].appaterno;
        $("#apellido-materno").value = dataDB[0].apmaterno;
        $("#telefono-persona").value = dataDB[0].telefono;
        $("#direccion-persona").value = dataDB[0].direccion_cliente;
        $("#iddistrito-persona").value = dataDB[0].distrito;
      } else {
        limpiarCampos();
        const dataAPI = await getApiDni(dni);
        $("#statusdni").classList.add("d-none");
        if (dataAPI.hasOwnProperty('message')) {
          showToast("No se encontraron datos", "info", "INFO");
          addClientePersona(false)
        } else {
          tipodoc.value = dataAPI['tipoDocumento'];
          $("#nombres").value = dataAPI['nombres'];
          $("#apellido-paterno").value = dataAPI['apellidoPaterno'];
          $("#apellido-materno").value = dataAPI['apellidoMaterno'];
          addClientePersona(true);
        }
      }

    }
  }


  $("#btn-cliente-persona").addEventListener("click", async () => {
    await renderData();
  });

  function addClientePersona(newData = false) {
    if (newData) {
      $("#iddistrito-persona").removeAttribute("disabled");
      $("#telefono-persona").removeAttribute("disabled");
      $("#direccion-persona").removeAttribute("disabled");
      $("#registrarPersona").removeAttribute("disabled");
    } else {
      $("#iddistrito-persona").setAttribute("disabled", true);
      $("#telefono-persona").setAttribute("disabled", true);
      $("#direccion-persona").setAttribute("disabled", true);
      $("#registrarPersona").setAttribute("disabled", true);
    }
  }

  addClientePersona(false);

  $("#registrar-persona").addEventListener("submit", async (event) => {
    event.preventDefault();

    if (await showConfirm("¿Desea Registrar?", "Registrar Cliente")) {
      const resultado = await registradoPersona();
      const id = resultado.id;
      if (id > 0) {
        const data = await addCliente(id);
        limpiarCampos();
        if (data.id > 0) {
          showToast("Cliente registrado", "success", "SUCCESS");
        } else {
          showToast("Error al registrar el cliente", "error", "ERROR");
        }
      } else if (id < 0) {
        const data = await searchPersona($("#nro-doc-persona").value);
        const nrodoc = data[0].idpersonanrodoc;
        console.log(nrodoc);
        const response = await addCliente(nrodoc);
        if (response.id < 0) {
          showToast("El cliente ya se encuentra registrado", "info", "INFO");
          addClientePersona(false);
        } else {
          showToast("Cliente registrado", "success", "SUCCESS");

        }
      }

    }
  });

  $("#nro-doc-persona").addEventListener("input", () => {
    const nrodoc = $("#nro-doc-persona").value.length;
    if (nrodoc === 8) {
      $("#idtipodocumento").value = 1;
    } else {
      limpiarCampos();
    }
  });

  function limpiarCampos() {
    $("#nombres").value = "";
    $("#apellido-paterno").value = "";
    $("#apellido-materno").value = "";
    $("#telefono-persona").value = "";
    $("#direccion-persona").value = "";
    $("#iddistrito-persona").value = "";
    $("#idtipodocumento").value = '';
  }

  async function searchPersona(dni) {
    const params = new URLSearchParams();
    params.append('operation', 'searchDni');
    params.append('idtipodocumento', tipodoc.value);
    params.append('idpersonanrodoc', dni);
    try {
      const response = await fetch(`../../controller/persona.controller.php?${params}`);
      const data = await response.json();
      return data;
    } catch (e) {
      console.error(e);
    }

  }

  async function searchCliente(dni) {
    const params = new URLSearchParams();
    params.append('operation', 'searchCliente');
    params.append('_nro_documento', dni);
    try {
      const response = await fetch(`../../controller/cliente.controller.php?${params}`);
      const data = await response.json();
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  async function searchDistrito(distrito) {
    const searchData = new FormData();
    searchData.append('operation', 'searchDistrito');
    searchData.append('distrito', distrito);
    const option = {
      method: 'POST',
      body: searchData
    }
    try {
      const response = await fetch(`../../controller/distrito.controller.php`, option);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  const dataList = $("#datalistDistritoPersona");
  let iddistrito;
  async function renderListaDistrito() {
    let nomDistrito = $("#iddistrito-persona").value;
    nomDistrito.innerHTML = '';
    const response = await searchDistrito(nomDistrito);
    dataList.innerHTML = '';
    console.log(response);
    if (response.length != 0) {
      dataList.style.display = 'block';

      response.forEach((distrito) => {
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.setAttribute('data-id', distrito.iddistrito);
        li.innerHTML = `${distrito.distrito}, ${distrito.provincia}, ${distrito.departamento}`;
        li.addEventListener('click', () => {
          $("#iddistrito-persona").value = li.textContent;
          iddistrito = li.getAttribute('data-id');
          console.log(iddistrito);
          dataList.innerHTML = '';
        });
        dataList.appendChild(li);
      });

    }
  }

  $("#iddistrito-persona").addEventListener("input", async () => {
    await renderListaDistrito();
  });

  async function registradoPersona() {
    const params = new FormData();
    params.append('operation', 'addPersona')
    params.append('idtipodocumento', $('#idtipodocumento').value);
    params.append('idpersonanrodoc', $('#nro-doc-persona').value);
    params.append('iddistrito', iddistrito);
    params.append('nombres', $('#nombres').value);
    params.append('appaterno', $('#apellido-paterno').value);
    params.append('apmaterno', $('#apellido-materno').value);
    params.append('telefono', $('#telefono-persona').value);
    params.append('direccion', $('#direccion-persona').value);
    const options = {
      method: 'POST',
      body: params
    }
    try {
      const response = await fetch(`../../controller/persona.controller.php`, options);
      const data = await response.json();
      return data;
    } catch (error) {
      console.error("Error al registrar el cliente:", error);
    }
  }

  async function addCliente(idpersona) {
    let idempresa = $("#nro-doc-empresa");
    idempresa = null;
    const params = new FormData();
    params.append('operation', 'addcliente');
    params.append('idpersona', idpersona);
    params.append('idempresa', idempresa);
    params.append('tipo_cliente', 'Persona');

    const options = {
      method: 'POST',
      body: params
    };

    try {
      const response = await fetch(`../../controller/cliente.controller.php`, options);
      const data = await response.json();
      return data;
    } catch (error) {
      console.error("Error al analizar el JSON:", error);
      return data;
    }


  }


});
