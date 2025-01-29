document.addEventListener("DOMContentLoaded", () => {
  //  VARIABLE GLOBAL
  function $(object = null) {
    return document.querySelector(object);
  }

  // AUTOEJECUTABLES
  (() => {
    fetch(`../../controller/documento.controller.php`)
      .then(response => response.json())
      .then(data => {
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idtipodocumento;
          tagOption.innerText = element.documento;
          $("#tipo_doc").appendChild(tagOption);
        });
      })
      .catch(e => {
        console.error(e);
      })
  })();

  (() => {
    const params = new URLSearchParams();
    params.append('operation', 'listarPerfil');
    fetch(`../../controller/perfil.controller.php?${params}`)
      .then(response => response.json())
      .then(data => {
        console.log(data);
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idperfil;
          tagOption.setAttribute('perfil', element.nombrecorto);
          tagOption.innerText = element.perfil;
          $("#rol").appendChild(tagOption);
        });
      })
      .catch(e => {
        console.error(e);
      })
  })();

  // FIN DE AUTOEJECUTABLES

  // FUNCIONES
  // registrar usuario
  async function registrarUsuario(idpersona) {
    if ($("#rol").value.trim() === '') {
      showToast("Seleccione un rol de usuario", "info", "INFO");
      // alert("Seleccione un rol de usuario")
    } else {
      const selectedOption = $("#rol").selectedOptions[0];
      const perfil = selectedOption.getAttribute('perfil');

      const params = new FormData();
      params.append('operation', 'addUsuario');
      params.append('idpersona', idpersona);
      params.append('idperfil', $("#rol").value);
      params.append('perfil', perfil);
      params.append('nombre_usuario', $("#usuario").value.trim());
      params.append('password_usuario', $("#password").value.trim());

      params.forEach((value, key) => {
        console.log(key, value);
      });

      const options = {
        method: 'POST',
        body: params
      }
      const response = await fetch(`../../controller/usuario.controller.php`, options);
      const data = response.json();
      return data;
      // console.log(text)
    }
  }

  // validar doc
  function validarDoc(response) {

    if (response.length == 0) {
      showToast("No se encontro ningun registro con este DNI", "info", "INFO");
      // alert("Este DNI no esta registrado porfavor registrar sus datos personales");
    } else {
      $("#usuario").value = response[0].iduser;
      if (response[0].iduser == null) {
        addUsuario(true);
      } else {
        addUsuario(false);
      }
    }
  }

  // validar si el usuario ya esta registrado con su dni
  async function buscarDni() {
    const params = new URLSearchParams();
    params.append('operation', 'searchUser');
    params.append('idtipodocumento', $("#tipo_doc").value);
    params.append('idpersonanrodoc', $("#numero_documento").value);

    const response = await fetch(`../../controller/usuario.controller.php?${params}`);
    console.log("Hola soy response \n", response);
    return response.json();

  }
  // desactivar los campos de usuario
  function addUsuario(add = false) {
    if (!add) {
      $("#usuario").setAttribute("disabled", true);
      $("#password").setAttribute("disabled", true);
      $("#rol").setAttribute("disabled", true);
      $("#registrar-user").setAttribute("disabled", true);

    } else {
      $("#usuario").removeAttribute("disabled");
      $("#password").removeAttribute("disabled");;
      $("#rol").removeAttribute("disabled");
      $("#registrar-user").removeAttribute("disabled");
    }
  }

  // EVENTOS
  let idpersona;
  $("#buscar-dni").addEventListener('click', async () => {
    const response = await buscarDni();
    console.log("Soy los datos de buscar dni : \n", response)
    if (response.length != 0 && response[0].iduser == null) {
      showToast("Persona registrada con datos personales pero no posee una cuenta de usuario", "info", "INFO");
      // alert("persona registrada con datos personales pero no posee una cuenta de usuario")
      idpersona = response[0].id;
      validarDoc(response);
    } if (response.length > 0 && response[0].iduser != null) {
      addUsuario(false);
      showToast("Este DNI ya esta registrado con un usuario", "info", "INFO");
      // alert("Este DNI ya esta registrado con un usuario");
    } if (response.length == 0) {
      addUsuario(false);
      showToast("No se encontro ningun registro con este DNI", "info", "INFO");
      // alert("Este DNI no esta registrado porfavor registrar sus datos personales");
    }
  });

  // verificar si el nombre de usuario ya existe
  async function verificarUsuario(username) {
    const params = new URLSearchParams();
    params.append('operation', 'checkUsername');
    params.append('username', username);

    try {
      const response = await fetch(`../../controller/usuario.controller.php?${params}`);
      const data = await response.json();
      console.log("Verificar usuario response:", data);
      if (data.existe) { // Suponiendo que el servidor devuelve { exists: true/false }
        // $("#usuario").value = '';
        $("#usuario").classList.add("is-invalid");
        $("#valida-usuario").innerText = "Usuario no disponible";
        $("#valida-usuario").classList.add("text-danger");
        $("#valida-usuario").classList.add("invalid-feedback");
        $("#valida-usuario").classList.remove("valid-feedback");
        $("#registrar-user").setAttribute("disabled", true);
      } else {
        $("#usuario").classList.remove("is-invalid");
        $("#usuario").classList.add("is-valid");
        $("#valida-usuario").innerText = "Usuario disponible";
        $("#valida-usuario").classList.remove("text-danger");
        $("#valida-usuario").classList.add("text-success");
        $("#valida-usuario").classList.remove("invalid-feedback");
        $("#valida-usuario").classList.add("valid-feedback");
        $("#registrar-user").removeAttribute("disabled");

      }
    } catch (e) {
      console.error("Error al verificar el nombre de usuario:", e);
    }
  }

  // verificar nombre de usuario al perder el foco
  $("#usuario").addEventListener("input", () => {
    const username = $("#usuario").value.trim();
    console.log("Verificando usuario:", username);
    if (username === '') {
      $("#usuario").classList.add("is-invalid");
      $("#valida-usuario").innerText = "Ingrese un usuario";
      $("#valida-usuario").classList.add("text-danger");
      $("#valida-usuario").classList.add("invalid-feedback");
      $("#valida-usuario").classList.remove("valid-feedback");
      $("#registrar-user").setAttribute("disabled", true);
    } else {
      verificarUsuario(username);
    }
  }, false);

  // limpiar campos
  function limpiarCampos() {
    $("#tipo_doc").value = '';
    $("#numero_documento").value = '';
    $("#usuario").value = '';
    $("#password").value = '';
    $("#rol").value = 'Seleccione un documento';
  }
  // funcion para validar el select del rol
  // Validar el select del rol
  function validarRol() {
    const rolSelect = $("#rol").selectedOptions[0].getAttribute('value'); // Asegúrate de que el select tenga el id "rol"
    const rolFeedback = $("#valida-rol"); // Un elemento para mostrar el feedback de validación

    if (rolSelect === null) {
      showToast("Seleccione un rol de usuario", "info", "INFO");
      return false;
    } else {
      return true;
    }
  }

  // registrar usuario boton
  $("#form-user").addEventListener('submit', async (e) => {
    e.preventDefault();
    let response1;

    if (!validarRol()) {
      e.preventDefault(); // Evitar el envío del formulario si la validación falla
    } else {

      if (await showConfirm("¿Desea registrar este usuario?", "", "Guardar", "Cancelar")) {
        response1 = await registrarUsuario(idpersona);
        if (response1.idusuario == -1) {
          showToast("Error al guardar usuario", "error", "ERROR");
          // alert("Error al guardar usuario");
        } else {
          showToast("Usuario registrado correctamente", "success", "SUCCESS");
          // console.log("Usuario registrado correctamente");
          limpiarCampos();
          // alert("Usuario registrado correctamente");
        }
      }
    }

  });
  addUsuario(false);
});  