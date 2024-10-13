document.addEventListener("DOMContentLoaded", () => {

  // Helper para simplificar el uso de querySelector
  function $(object = null) {
    return document.querySelector(object);
  }

  // (() => {
    // fetch(`../../controller/documento.controller.php?operation=getAllDocumentos`)
      // .then(response => response.json())
      // .then(data => {
// 
        // data.forEach(element => {
          // optionEmp = document.querySelector("#idtipodocumento");
          // const tagOption = document.createElement('option');
          // tagOption.value = element.idtipodocumento;
          // tagOption.innerText = element.documento;
          // optionEmp.appendChild(tagOption);
        // })
      // })
      // .catch(e => {
        // console.error(e);
      // })
  // })();
// 
  // Botón cancelar: Resetea el formulario y habilita los campos
  $('#cliente').addEventListener('click', function () {
    var activeTab = document.querySelector('.nav-link.active')?.getAttribute('href');
    if (activeTab === '#persona') {
      resetCampos();
      $("#nro-doc-persona").value = '';
    } else if (activeTab === '#empresa') {
      //console.log("empresa")
      $("#nro-doc-empresa").value = '';
      resetCampos();

    }
    habilitarCampos();

  });

  // Función de debounce: Espera para ejecutar una función después de un tiempo sin eventos
  function debounce(func, wait) {
    let timeout;
    return function (...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }

  // Función para desactivar los campos del formulario
  function desactivarCampos() {
    ["#iddistrito", "#email", "#razon-social", "#direccion", "#telefono-empresa", "#registrarEmpresa"].forEach(id => {
      $(id)?.setAttribute("disabled", true);
    });
  }

  // Función para habilitar los campos del formulario
  function habilitarCampos() {
    ["#iddistrito", "#email", "#razon-social", "#direccion", "#telefono-empresa", "#registrarEmpresa"].forEach(id => {
      $(id)?.removeAttribute("disabled");
    });
  }

  // Función para resetear los campos del formulario
  function resetCampos() {
    ["#razon-social", "#direccion", "#email", "#iddistrito", "#telefono-empresa", "#registrarEmpresa"].forEach(id => {
      $(id).value = "";
    });
  }

  // Función para validar el número de documento de la empresa
  async function validarNroDoc(response) {
    if (response.length === 0 || response[0].estado === 'No data') {
      // La empresa no está registrada como cliente ni como empresa
      habilitarCampos();
      resetCampos();
      console.log("La empresa no está registrada, puedes registrarla.");
    } else if (response[0].estado === 'No registrado') {
      // La empresa está registrada, pero no como cliente
      habilitarCampos();
      $("#razon-social").value = response[0].razonsocial;
      $("#email").value = response[0].email;
      $("#iddistrito").value = response[0].distrito;
      $("#direccion").value = response[0].direccion;
      $("#telefono-empresa").value = response[0].telefono;
      console.log("La empresa está registrada, pero no es cliente. Puedes registrarla como cliente.");
    } else if (response[0].estado === 'Registrado') {
      // La empresa ya está registrada como cliente
      desactivarCampos();
      $("#razon-social").value = response[0].razonsocial;
      $("#email").value = response[0].email;
      $("#iddistrito").value = response[0].distrito;
      $("#direccion").value = response[0].direccion;
      $("#telefono-empresa").value = response[0].telefono;
      showToast('La empresa ya está registrada como cliente', 'WARNING', 'WARNING');
      console.log("La empresa ya está registrada como cliente.");
    }
  }

  // Función para buscar los datos del cliente (empresa o persona)
  async function dataCliente() {
    const nroDocEmpresa = $("#nro-doc-empresa");
    if (!nroDocEmpresa || nroDocEmpresa.value.trim() === "") {
      return [];
    }

    const params = new URLSearchParams();
    params.append("operation", "search");
    params.append("ruc", nroDocEmpresa.value.trim());

    try {
      const response = await fetch(`../../controller/empresa.controller.php?${params}`);
      if (!response.ok) {
        throw new Error("Error en la respuesta del servidor");
      }
      return await response.json();  // Parsear la respuesta como JSON
    } catch (e) {
      console.error("Error en dataCliente: ", e);
      return [];
    }
  }

  // Evento para buscar y validar número de documento con debounce
  $("#nro-doc-empresa").addEventListener("input", debounce(async () => {
    if ($("#nro-doc-empresa").value === "") {
      resetCampos();
      habilitarCampos();
    } else {
      const response = await dataCliente();
      await validarNroDoc(response);
    }
  }, 500));

  // Función para registrar la empresa como cliente
  async function registrarEmpresa() {
    const params = new FormData();
    params.append('operation', 'add');
    params.append('idempresaruc', $("#nro-doc-empresa").value);
    params.append('iddistrito', $("#iddistrito").value);
    params.append('razonsocial', $("#razon-social").value);
    params.append('direccion', $("#direccion").value);
    params.append('email', $("#email").value);
    params.append('telefono', $("#telefono-empresa").value);

    const options = {
      method: 'POST',
      body: params
    };


    const response = await fetch(`../../controller/empresa.controller.php`, options);
    const data = await response.json();
    console.log(data);


  }
  async function registrarCliente(idempresa) {
    var cliente = document.querySelector('.nav-link.active')?.getAttribute('href');
    console.log(cliente);
    const params = new FormData();
    params.append('operation', 'addcliente');
    params.append('idpersona', $("#nor-doc-persona").value); // Asegúrate de que este campo tenga el valor correcto
    params.append('idempresa', idempresa); // Usa el ID de la empresa que acabas de registrar
    params.append('tipo_cliente', cliente);

    const options = {
      method: 'POST',
      body: params
    };

    try {
      const response = await fetch(`../../controller/cliente.controller.php`, options);
      const data = await response.json();
      console.log(data);
      if (data.success) {
        // Manejar la respuesta exitosa, por ejemplo, mostrar un mensaje al usuario
        console.log("Cliente registrado exitosamente.");
      } else {
        console.error("Error al registrar el cliente:", data.message);
      }
    } catch (error) {
      console.error("Error al registrar el cliente:", error);
    }
  }

  // Prevenir el envío del formulario al presionar Enter
  $("#nro-doc-empresa").addEventListener('keydown', (event) => {
    if (event.keyCode === 13) {
      event.preventDefault();
      $("#nro-doc-empresa").focus();
    }
  });

  // Evento para registrar la empresa o persona
  $("#registrar-empresa").addEventListener("submit", async (event) => {
    event.preventDefault();
    if (showConfirm("¿Desea registrar la empresa y el cliente?", "Clientes")) {
      // Primero, registra la empresa y espera a que se complete
      const empresaResponse = await registrarEmpresa();
      console.log(empresaResponse)
      const id = empresaResponse;
      if (empresaResponse) {
        await registrarCliente(id);

      }
    } else {
      console.log("Registro cancelado");
    }
  });

});
