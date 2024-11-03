document.addEventListener("DOMContentLoaded", () => {
  // Corregir la función $ para que retorne el valor seleccionado
  function $(object = null) {
    return document.querySelector(object); // Debe retornar el valor
  }

  const tipodoc = $("#idtipodocumento");
  (() => {
    fetch(`../../controller/documento.controller.php`)
      .then(response => response.json())
      .then(data => {
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idtipodocumento;
          tagOption.innerText = element.documento;
          tipodoc.appendChild(tagOption);
        });
      })
      .catch(e => {
        console.error(e);
      })
  })();

  async function getApiDni(dni) {
    try {
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
    const dataDB = await searchPersona(dni);
    console.log(dataDB);
    if (dni.length === 8) {
      if (dataDB.length != 0) {
        addClientePersona(false);
        $("#nombres").value = dataDB[0].nombres;
        $("#apellido-paterno").value = dataDB[0].appaterno;
        $("#apellido-materno").value = dataDB[0].apmaterno;
        $("#telefono-persona").value = dataDB[0].telefono;
        $("#direccion-persona").value = dataDB[0].direccion;
        $("#iddistrito-persona").value = dataDB[0].distrito;
        showToast("El cliente ya se encuentra registrado", "info", "INFO");
      } else {
        limpiarCampos();
        const dataAPI = await getApiDni(dni);
        console.log(dataAPI);
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
    } else {
      showToast("El número de DNI debe tener 8 dígitos", "info", "INFO");
      limpiarCampos();
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
      $("#registrar-persona").reset();
      // limpiarCampos();        
      console.log(resultado);
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
      return response.json();

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

    console.log($('#idtipodocumento').value);
    console.log($('#nro-doc-persona').value);
    console.log($('#iddistrito-persona').value);
    console.log($('#nombres').value);
    console.log($('#apellido-paterno').value);
    console.log($('#apellido-materno').value);
    console.log($('#telefono-persona').value);
    console.log($('#direccion-persona').value);


    const options = {
      method: 'POST',
      body: params
    }
    try {
      const response = await fetch(`../../controller/persona.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (error) {
      console.error("Error al registrar el cliente:", error);
    }
  }



  /* function debounce(func, wait) {
    let timeout;
    return function (...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }
  $('#cliente').addEventListener('click', function () {
    var activeTab = document.querySelector('.nav-link.active')?.getAttribute('href');
    if (activeTab === '#persona') {
      desactivarCampos();
      $("#nro-doc-persona").value = '';
    } else if (activeTab === '#empresa') {
      $("#nro-doc-empresa").value = '';
      desactivarCampos();
 
    }
    habilitarCampos();
  });
 
  function desactivarCampos() {
    $("#nombres").setAttribute("disabled", true)
    $("#apellido-paterno").setAttribute("disabled", true)
    $("#apellido-materno").setAttribute("disabled", true)
    $("#telefono-persona").setAttribute("disabled", true)
    $("#direccion-persona").setAttribute("disabled", true)
    $("#iddistrito-persona").setAttribute("disabled", true)
  }
  function habilitarCampos() {
    $("#nombres").removeAttribute("disabled")
    $("#apellido-paterno").removeAttribute("disabled")
    $("#apellido-materno").removeAttribute("disabled")
    $("#telefono-persona").removeAttribute("disabled")
    $("#direccion-persona").removeAttribute("disabled")
    $("#telefono-persona").removeAttribute("disabled")
    $("#iddistrito-persona").removeAttribute("disabled")
 
  }
  function limpiarCampos() {
 
    $("#nombres").value = "";
    $("#apellido-paterno").value = "";
    $("#apellido-materno").value = "";
    $("#telefono-persona").value = "";
    $("#direccion-persona").value = "";
    $("#iddistrito-persona").value = "";
  }
 
  async function buscarDni() {
    const tipodoc = $("#idtipodocumento");
    const nrodoc = $("#nro-doc-persona");
 
    const params = new URLSearchParams();
    params.append('operation', 'search');
    params.append('idtipodocumento', tipodoc.value);
    params.append('idpersonanrodoc', nrodoc.value);
 
    const response = await fetch(`../../controller/persona.controller.php?${params}`);
    return response.json();
  }
 
  function validarDni(response) {
    if (response.length === 0 || response[0].estado === 'No data') {
 
      console.log("Puede registrar a la persona")
    } else if (response[0].estado === 'Registrado') {
      $("#nombres").value = response[0].nombres;
      $("#apellido-paterno").value = response[0].appaterno;
      $("#apellido-materno").value = response[0].appaterno;
      $("#telefono-persona").value = response[0].telefono ? response[0].telefono : '';
      $("#direccion-persona").value = response[0].direccion;
      $("#iddistrito-persona").value = response[0].distrito;
      $("#idtipodocumento").setAttribute("disabled", true)
      $("#registrarPersona").setAttribute("disabled", true)
      desactivarCampos();
      showToast('La persona ya está registrada como cliente', 'warning', 'WARNING');
    }
  }
 
  async function registradoPersona() {
    const params = new FormData();
    params.append('operation', 'addPersona')
    params.append('idtipodocumento', $('#idtipodocumento').value);
    params.append('idpersonanrodoc', $('#nro-doc-persona').value);
    params.append('iddistrito', $('#iddistrito-persona').value);
    params.append('nombres', $('#nombres').value);
    params.append('appaterno', $('#apellido-paterno').value);
    params.append('apmaterno', $('#apellido-materno').value);
    params.append('telefono', $('#telefono-persona').value);
    params.append('direccion', $('#direccion-persona').value);
    const options = {
      method: 'POST',
      body: params
    }
    const id = await fetch(`../../controller/persona.controller.php`, options)
    return id.json();
  } */

  // Evento para buscar DNI cuando el usuario ingrese el número de documento
  /* $("#nro-doc-persona").addEventListener("input", debounce(async () => {
    if ($("#nro-doc-persona").value === '') {
      limpiarCampos();
      habilitarCampos();
      $("#idtipodocumento").removeAttribute("disabled");
      $("#registrarPersona").removeAttribute("disabled");
    } else {
      const response = await buscarDni();
      validarDni(response);
    }
  }, 100));
  $("#registrar-persona").addEventListener("submit", async (event) => {
    event.preventDefault();
    if (showConfirm("¿Desea Registrar?", "Registrar Cliente")) {
      const resultado = await registradoPersona();
      console.log(resultado);
    }
  }) */
});
