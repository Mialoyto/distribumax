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
    const data = await getApiDni(dni);
    console.log(data);
    if (data.hasOwnProperty('message')) {
      showToast("No se encontraron datos", "info", "INFO");
    } else {
      tipodoc.value = data['tipoDocumento'];
      $("#nombres").value = data['nombres'];
      $("#apellido-paterno").value = data['apellidoPaterno'];
      $("#apellido-materno").value = data['apellidoMaterno'];
      addClientePersona(true);
    }
  }

  $("#btn-cliente-persona").addEventListener("click", async () => {
    await renderData();
  });

  function addClientePersona(newData = false) {
    console.log(newData);
    console.log(!newData);
    if (newData) {
      $("#iddistrito-persona").removeAttribute("disabled");
      $("#telefono-persona").removeAttribute("disabled");
      $("#direccion-persona").removeAttribute("disabled");
    } else {
      $("#iddistrito-persona").setAttribute("disabled", true);
      $("#telefono-persona").setAttribute("disabled", true);
      $("#direccion-persona").setAttribute("disabled", true);
    }
  }

  addClientePersona(false);

  $("#registrar-persona").addEventListener("submit", async (event) => {
    event.preventDefault();
    if (showConfirm("¿Desea Registrar?", "Registrar Cliente")) {
      const resultado = await registradoPersona();
      console.log(resultado);
    }
  });


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
