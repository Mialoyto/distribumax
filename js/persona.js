document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }
/* rama backup */
  const tipodoc = $("#tipo_documento");
  const nrodoc = $("#numero_documento");
  const btnBuscarDni = $("#buscar-dni");

  const distrito = $("#buscar-distrito");
  const dataList = $("#datalistDistrito");

  let idpersona = -1;
  let dataNew = true;
  // AUTOEJECUTABLES
  // funcion de documentos
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



  // FUNCIONES
  async function registradoPersona() {
    const params = new URLSearchParams();
    params.append('operation', 'addPersona')
    params.append('idtipodocumento', $('#tipo_documento').value)
    params.append('idpersonanrodoc', $('#numero_documento').value)
    params.append('iddistrito', selectedId)
    params.append('nombres', $('#nombres').value)
    params.append('appaterno', $('#appaterno').value)
    params.append('apmaterno', $('#apmaterno').value)
    params.append('telefono', $('#telefono').value)
    params.append('direccion', $('#direccion').value)
    const options = {
      method: 'POST',
      body: params
    }
    const id = await fetch(`../../controller/persona.controller.php`, options)
    return id.json();
  }

  // buscar dni
  async function buscarDni() {
    const params = new URLSearchParams();
    params.append('operation', 'searchDni');
    params.append('idtipodocumento', tipodoc.value);
    params.append('idpersonanrodoc', nrodoc.value);

    const response = await fetch(`../../controller/persona.controller.php?${params}`);
    return response.json();
  }

  // peticion ✔️
  const searchDist = async () => {
    let searchData = new FormData();
    searchData.append('operation', 'searchDistrito');
    searchData.append('distrito', distrito.value);
    const option = {
      method: 'POST',
      body: searchData
    }
    try {
      const response = await fetch(`../../controller/distrito.controller.php`, option);
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }
  // mostrar resultados ✔️
  const mostraResultados = () => {
    searchDist()
      .then(response => {
        dataList.innerHTML = '';

        // errorList.style.display = 'none';
        response.forEach(item => {
          const option = document.createElement('option');
          option.setAttribute('data-id', item.iddistrito);
          option.textContent = item.distrito;
          dataList.appendChild(option);
        })
        console.log(response);
      })
  }
  // validar documento ✔️
  function validarDni(response) {
    if (response.length == 0) {
      $("#numero_documento").focus();
      idpersona = -1;
      dataNew = true;
      addPersona(true);
      $("#buscar-distrito").focus();
      limpiarCampos();
    } else {
      dataNew = false;
      idpersona = response[0].idpersonanrodoc;
      $("#buscar-distrito").value = response[0].distrito;
      $("#nombres").value = response[0].nombres;
      $("#appaterno").value = response[0].appaterno;
      $("#apmaterno").value = response[0].appaterno;
      $("#telefono").value = response[0].telefono ? response[0].telefono : '';
      $("#direccion").value = response[0].direccion;
      selectedId = response[0].iddistrito;
      const option = document.createElement('option');
      option.setAttribute('data-id', selectedId);
      option.value = response[0].distrito; // Usa el nombre del distrito
      dataList.appendChild(option);
      console.log('ID del distrito obtenido:', selectedId);
      addPersona(false);
    }
  }

  // habilitar campos ✔️
  function addPersona(add = false) {
    if (!add) {
      $("#buscar-distrito").setAttribute("disabled", true)
      $("#nombres").setAttribute("disabled", true)
      $("#appaterno").setAttribute("disabled", true)
      $("#apmaterno").setAttribute("disabled", true)
      $("#telefono").setAttribute("disabled", true)
      $("#direccion").setAttribute("disabled", true)
      $("#btnRegistrar").setAttribute("disabled", true)
    } else {
      $("#buscar-distrito").removeAttribute("disabled")
      $("#nombres").removeAttribute("disabled")
      $("#appaterno").removeAttribute("disabled")
      $("#apmaterno").removeAttribute("disabled")
      $("#telefono").removeAttribute("disabled")
      $("#direccion").removeAttribute("disabled")
      $("#btnRegistrar").removeAttribute("disabled")
    }
  }

  // funcion limpiar campos
  function limpiarCampos() {
    $("#buscar-distrito").value = "";
    $("#nombres").value = "";
    $("#appaterno").value = "";
    $("#apmaterno").value = "";
    $("#telefono").value = "";
    $("#direccion").value = "";
  }
  // FIN FUNCIONES

  //  EVENTOS DE PRUEBAS

  // Agregar evento change para capturar el id del tipo de documento ✔️ BORRAR
  tipodoc.addEventListener("change", () => {
    console.log("ID tipo documento seleccionado =>", tipodoc.value);
  });

  // capturar el id del distrito ✔️
  let selectedId;
  distrito.addEventListener("change", event => {
    const selectDistrito = event.target.value;
    const options = dataList.children;

    for (let i = 0; i < options.length; i++) {
      if (options[i].value === selectDistrito) {
        selectedId = options[i].getAttribute('data-id');
        console.log("ID distrito selecionado =>", selectedId);
      }
    }
  });

  // evento para buscar dni ✔️
  $("#buscar-dni").addEventListener("click", async () => {
    const response = await buscarDni();
    console.log(response);
    validarDni(response);
  });

  // evento para buscar si se encuentra registrado ✔️
  $("#buscar-dni").addEventListener("keyPress", async () => {
    if (e.keyCode == 13) {
      const response = await buscarDni();
      console.log(response);
      validarDni(response);
      console.log("Buscar dni");
    }
  });

  // buscar distrito ✔️
  distrito.addEventListener('input', event => {
    nomDistrito = event.target.value;
    mostraResultados();
  });

  $("#form-persona").addEventListener("submit", async (e) => {
    e.preventDefault();
    let response1;
    if (dataNew) {
      if (confirm("¿Guardar datos?")) {
        response1 = await registradoPersona();
        idpersona = response1.id;
        console.log("Datos guardados, ID: ", idpersona);
        if (idpersona == -1) {
          alert("No se guarda los datos");
          return;
        }
      }
    }else{
      alert("Esta persona ya esta registrada")
    }
  });

  // FIN DE EVENTOS DE PRUEBAS
  // desabilitar campos
  addPersona(false);

  // FIN DE EVENTO
 

});