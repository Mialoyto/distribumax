document.addEventListener("DOMContentLoaded", () => {
  const btnbuscardni = document.querySelector("#btnbuscardni");
  // const optionDoc = document.querySelector("#idtipodocumento");

  // const searchDistritoInput  = document.querySelector("#searchDistrito");
  // const lista = document.querySelector("#lista");

  // variables para renderizar o capturar datos de las personas
  const doc = document.querySelector("#idtipodocumento"); // tipo documento
  const dni = document.querySelector("#idpersonanrodoc"); // nro de documento
  const iddistrito = document.querySelector("#searchDistrito");
  const errorList = document.querySelector("error-container");//
  const dataList = document.querySelector("#datalistDistrito");
  const nombres = document.querySelector("#nombres");
  const appaterno = document.querySelector("#appaterno");
  const apmaterno = document.querySelector("#apmaterno");
  const telefono = document.querySelector("#telefono");
  const direccion = document.querySelector("#direccion");

  // datos de usuarios
  const nombre_usuario = document.querySelector("#nombre_usuario");
  const password_usuario = document.querySelector("#password_usuario");
  const optionRol = document.querySelector("#rol")
  const form = document.querySelector("#form-persona")

  optionRol.addEventListener('change', () => {
    const id = optionRol.value;
    console.log(id)
  })

  /* botones de formulario de usuarios */
  const btnRegistrar = document.querySelector("#btnRegistrarPersona");
  const btnCancelat = document.querySelector("#btnCancelarRegistro");
let idpersona = -1;
  let dataNew = true;
  // funcion que trae los tipos de documentos desde la base de datos
  (() => {
    fetch(`../../controller/documento.controller.php`)
      .then(response => response.json())
      .then(data => {
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idtipodocumento;
          tagOption.innerText = element.documento;
          doc.appendChild(tagOption);
        });
      })
      .catch(e => {
        console.error(e);
      })
  })();

  // funciones para cargar los roles
  (() => {
    fetch(`../../controller/roles.controller.php`)
      .then(response => response.json())
      .then(data => {
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idrol;
          tagOption.innerText = element.rol;
          optionRol.appendChild(tagOption);
        });
      })
      .catch(e => {
        console.error(e);
      })
  })()
  /* buscar distrito */
  let distrito = '';
  if (iddistrito) {
    iddistrito.addEventListener('input', event => {

      distrito = event.target.value;
      mostraResultados();
    })
  }
  // peticion
  const searchDist = async () => {
    let searchData = new FormData();
    searchData.append('operation', 'searchDistrito')
    searchData.append('distrito', distrito)
    const option = {
      method: 'POST',
      body: searchData
    }
    try {
      const response = await fetch(`../../controller/distrito.controller.php`, option)
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }
  const mostraResultados = () => {
    searchDist()
      .then(response => {
        dataList.innerHTML = '';

        // errorList.style.display = 'none';
        response.forEach(item => {
          const option = document.createElement('option');
          option.setAttribute('data-id', item.iddistrito)
          // option.value = item.iddistrito
          option.innerText = item.distrito;
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

    for (let [key, value] of params.entries()) {
      console.log(key, value);
    }

    const options = {
      method: 'POST',
      body: params
    }
    const id = await fetch(`../../controller/persona.controller.php`, options);
    return id.json();
  }

  async function registrarUsuario(idpersona){
    if(optionRol.value.trim() ===''){
      alert("Seleccione un rol de usuario")
      return {idusuario: -1}
    }else{
      const params = new FormData();
      params.append('operation','addUsuario');
      params.append('idpersona', idpersona);
      params.append('idrol',optionRol.value);
      params.append('nombre_usuario',nombre_usuario.value);
      params.append('password_usuario',password_usuario.value);

      const options = {
        method: 'POST',
        body : params
      }

      const idusuario = await fetch(`../../controller/usuario.controller.php`, options)
      return idusuario.json();
    }
  }

  // btnRegistrar.addEventListener('click')

  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    let response1;
    let response2;
    if(confirm("¿Guardar datos?")){
      if(dataNew){
        response1 = await registrarPersona();
        idpersona = response1.id;
        console.log(idpersona)
      }if(idpersona == -1){
        alert("No se guardo datos del colaborador")
      }else{
        response2 = await registrarUsuario(idpersona);
        if(response2.idusuario == -1){
          alert("verificar su nombre de usuario")
        }else{
          resetCampos();
        }
      }
    }
    // console.log(idpersona);
    // registrarPersona()
    resetCampos();
  });




  // -----
  // registrar persona
  function validarDoc(response) {
    if (response.length == 0) {
      resetCampos();

    } else {
      iddistrito.value = response[0].distrito;
      nombres.value = response[0].nombres;
      appaterno.value = response[0].appaterno;
      apmaterno.value = response[0].apmaterno;
      telefono.value = response[0].telefono ? response[0].telefono : 'No registrado';
      direccion.value = response[0].direccion
      selectedId = response[0].iddistrito; // Asegúrate de que el backend devuelve este campo
      
      const option = document.createElement('option');
      // option.value = selectedId;
      option.setAttribute('data-id', selectedId);
      option.innerText = response[0].distrito; // Usa el nombre del distrito
      dataList.appendChild(option);
  
      // Seleccionar la opción en el datalist
     
      console.log('ID del distrito obtenido:', selectedId);
      addPersona();
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
    // console.log(response[0].distrito)
    validarDoc(response);

  })
  function resetCampos() {
      form.reset()
      selectedId='';
  }

  function addPersona(add = false){
    if(!add){
      iddistrito.setAttribute("disabled",true)
      nombres.setAttribute("disabled",true)
      appaterno.setAttribute("disabled",true)
      apmaterno.setAttribute("disabled",true)
      telefono.setAttribute("disabled",true)
      direccion.setAttribute("disabled",true)
    }else{
      iddistrito.setAttribute("disabled")
      nombres.setAttribute("disabled")
      appaterno.setAttribute("disabled")
      apmaterno.setAttribute("disabled")
      telefono.setAttribute("disabled")
      direccion.setAttribute("disabled")
    }
  }

});

