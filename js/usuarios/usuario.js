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
    fetch(`../../controller/roles.controller.php`)
      .then(response => response.json())
      .then(data => {
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idrol;
          tagOption.innerText = element.rol;
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
    if ($("#rol").value.trim() == '') {
      alert("Seleccione un rol de usuario")
    } else {
      const formData = new FormData();
      formData.append('operation', 'addUsuario');
      formData.append('idpersona', idpersona);
      formData.append('nombre_usuario', $("#usuario").value.trim());
      formData.append('password_usuario', $("#password").value);
      formData.append('idrol', $("#rol").value);
      const options = {
        method: 'POST',
        body: formData
      }
      const response = await fetch(`../../controller/usuario.controller.php`, options);
      return response.text();
      // console.log(text)
    }
  }

  // validar doc
  function validarDoc(response) {
    if (response.length == 0) {
      alert("Este DNI no esta registrado porfavor registrar sus datos personales");
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
      alert("persona registrada con datos personales pero no posee una cuenta de usuario")
      idpersona = response[0].id;
      validarDoc(response);
    } if (response.length > 0 && response[0].iduser != null) {
      addUsuario(false);
      alert("Este DNI ya esta registrado con un usuario");
    } if (response.length == 0) {
      addUsuario(false);
      alert("Este DNI no esta registrado porfavor registrar sus datos personales");
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

  // registrar usuario boton
  $("#form-user").addEventListener('submit', async (e) => {
    e.preventDefault();
    let response1;
    if (confirm("¿Guardar usuario?")) {
      response1 = await registrarUsuario(idpersona);
      if (response1.idusuario == -1) {
        alert("Error al guardar usuario");
      }
    }
  });


  addUsuario(false);
});  