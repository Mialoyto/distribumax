document.addEventListener("DOMContentLoaded", () => {
  // Corregir la función $ para que retorne el valor seleccionado
  function $(object = null) {
    return document.querySelector(object); // Debe retornar el valor
  }
  function debounce(func, wait) {
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
      //console.log("empresa")
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
      //hablilitar camposr
      //resetcampos 
      console.log("Puede registrar a la persona")
    } else if (response[0].estado === 'Registrado') {
      //$("#buscar-distrito").value = response[0].distrito;
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
  }

  // Evento para buscar DNI cuando el usuario ingrese el número de documento
  $("#nro-doc-persona").addEventListener("input", debounce(async () => {
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
  })
});
