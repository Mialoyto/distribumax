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
  /* fin del buscador */
  let selectedId;
  iddistrito.addEventListener('change', event => {
    const selectedDistrito = event.target.value;
    const options = dataList.children;

    for (let i = 0; i < options.length; i++) {
      if (options[i].value === selectedDistrito) {
        selectedId = options[i].getAttribute('data-id');
        console.log('ID del distrito seleccionado:', selectedId);
        break;
      }
    }
  });
  // --------------------------------------------------------------------------------------------

  async function registrarPersona() {
    const params = new FormData()
    params.append('operation', 'addPersona')
    params.append('idtipodocumento', doc.value)
    params.append('idpersonanrodoc', dni.value)
    params.append('iddistrito', selectedId)
    params.append('nombres', nombres.value)
    params.append('appaterno', appaterno.value)
    params.append('apmaterno', apmaterno.value)
    params.append('telefono', telefono.value)
    params.append('direccion', direccion.value)
    const options = {
      method: 'POST',
      body: params
    }
    const id = await fetch(`../../controller/persona.controller.php`, options);
    return id.json();
  }

  async function registrarUsuario(idpersona) {
    if (optionRol.value.trim() === '') {
      alert("Seleccione un rol de usuario")
      return
    } else {
      const params = new FormData();
      params.append('operation', 'addUsuario');
      params.append('idpersona', idpersona);
      params.append('nombre_usuario', nombre_usuario.value);
      params.append('password_usuario', password_usuario.value);
      params.append('idrol', optionRol.value);

      const options = {
        method: 'POST',
        body: params
      }

      const idusuario = await fetch(`../../controller/usuario.controller.php`, options)
      return idusuario.json();
    }
  }

  // registrar persona
  function validarDoc(response) {
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

      if (response[0].idusuario === null) {
        addUsuario(true)
      } else {
        addPersona(false);
        addUsuario(false);
        alert("esta persona ya tiene un perfil");
      }
    }
  }

  async function searchDni() {
    const params = new URLSearchParams();
    params.append('operation', 'searchDni');
    params.append('idtipodocumento', doc.value)
    params.append('idpersonanrodoc', dni.value)

    const response = await fetch(`../../controller/persona.controller.php?${params}`)
    return response.json();
  }

  btnbuscardni.addEventListener("click", async () => {
    const response = await searchDni();
    console.log(response)
    validarDoc(response);
  })

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

  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    btnRegistrar.disabled = true; 
    let response1;
    let response2;

    if (confirm("¿Guardar datos?")) {
      if (dataNew) {
        response1 = await registrarPersona();
        idpersona = response1.id;
        console.log("Datos guardados, ID: ", idpersona);
        if (idpersona == -1) {
          alert("No se guarda los datos");
          return;
        }
      }
      const iduser = nombre_usuario.value.trim() != '' && password_usuario.value.trim() == '' && optionRol.value.trim() == ''
      if (iduser) {
        response2 = await registrarUsuario(idpersona);
        if (response2.idusuario == -1) {
          alert("verificar su nombre de usuario")
        } else {
          form.reset();
          alert("datos de la persona y usuario guardados"); s
        }
      }
    } else {
      form.reset();
      alert("datos de la persona guardados")
    }
    btnRegistrar.disabled = false; 
  })
  addPersona(false)
  addUsuario(false)
});

