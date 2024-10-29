document.addEventListener("DOMContentLoaded", () => {

  // Helper para simplificar el uso de querySelector
  function $(object = null) {
    return document.querySelector(object);
  }

  // fucntion para buscar ruc por api
  async function getApiRuc(ruc) {
    try {
      $("#status").classList.remove("d-none");
      const response = await fetch(`../../app/api/api.ruc.php?ruc=${ruc}`, {
        method: 'GET'
      });
      const data = await response.json();  // Parsear la respuesta como JSON

      $("#status").classList.add("d-none");
      if (data.hasOwnProperty('message')) {
        showToast("No se encontraron datos", "info", "INFO");
        $("#iddistrito").value = '';
        $("#razon-social").value = '';
        $("#direccion").value = '';
      } else {
        $("#razon-social").value = data['razonSocial'];
        $("#direccion").value = data['direccion'];
        $("#iddistrito").value = data['distrito'];
      }
      return data;
    } catch (e) {
      console.error("Error en buscarRuc: ", e);
    }
  }

  async function validarDatos() {
    const ruc = $("#nro-doc-empresa").value;
    const response = await searchClienteEmpresa(ruc);
    if (response.length === 0) {
      if (ruc.trim() === "") {
        showToast("Ingrese un número de RUC", "info", "INFO");
        return;
      
      } else if (ruc.length === 11) {
        const data = await getApiRuc(ruc);
        if (data.hasOwnProperty('message')) {
          showToast("No se encontraron datos", "info", "INFO");
          addCliente(false);
        } else {
          addCliente(true);
        }
      }else{
        showToast("El número de RUC debe tener 11 dígitos", "info", "INFO");
        addCliente(false);
      }
    } else {
      showToast("La empresa ya está registrada como cliente", "info", "INFO");
      addCliente(false);
    }
  }
  $("#btn-cliente-empresa").addEventListener('click', async () => {
    await validarDatos();
  });

  // Prevenir el envío del formulario al presionar Enter
  $("#btn-cliente-empresa").addEventListener('keydown', async (e) => {
    if (e.keyCode === "Enter") {
      await validarDatos();
    }
  });

  function addCliente(newdata = false) {
    if (!newdata) {
      $("#email").setAttribute('disabled', true);
      $("#telefono-empresa").setAttribute('disabled', true);
      $("#registrarEmpresa").setAttribute('disabled', true);
    } else {
      $("#email").removeAttribute('disabled');
      $("#telefono-empresa").removeAttribute('disabled');
      $("#registrarEmpresa").removeAttribute('disabled');

    }
  }

  // Función para buscar los datos del cliente (empresa o persona)
  async function searchClienteEmpresa(ruc) {
    const params = new URLSearchParams();
    params.append("operation", "search");
    params.append("ruc", ruc);

    try {
      const response = await fetch(`../../controller/empresa.controller.php?${params}`);
      const data = await response.json();  // Parsear la respuesta como JSON
      if (data.length > 0) {
        $("#iddistrito").value = data[0].distrito;
        $("#razon-social").value = data[0].razonsocial;
        $("#direccion").value = data[0].direccion;
      }
      return data;
    } catch (e) {
      console.error("Error en dataCliente: ", e);
    }
  }

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

  // Función para registrar el cliente
  async function registrarCliente(idempresa) {

    const params = new FormData();
    params.append('operation', 'addcliente');
    params.append('idpersona', $("#nor-doc-persona").value); // Asegúrate de que este campo tenga el valor correcto
    params.append('idempresa', $("#nor-doc-empresa").value); // Usa el ID de la empresa que acabas de registrar
    params.append('tipo_cliente', cliente);

    const options = {
      method: 'POST',
      body: params
    };

    try {
      const response = await fetch(`../../controller/cliente.controller.php`, options);
      const data = await response.json();
      console.log(data);

    } catch (error) {
      console.error("Error al registrar el cliente:", error);
    }
  }

  const searchDist = async (distrito) => {
    let searchData = new FormData();
    searchData.append('operation', 'searchDistrito');
    searchData.append('distrito', distrito);
    const option = {
      method: 'POST',
      body: searchData
    }
    try {
      const response = await fetch(`../../controller/distrito.controller.php`, option);
      const data =await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  const mostraResultados = async () => {
    $("#iddistrito").innerHTML = '';
    const response = await searchDist(nomdistrito);
    response.forEach(element => {
      $("#iddistrito").setAttribute('id-distrito', element.iddistrito);
      $("#iddistrito").value = element.distrito;
    });
  }
  let nomdistrito;
  $("#nro-doc-empresa").addEventListener('click', async () => {
    nomdistrito = $("#iddistrito").value.trim();
    console.log(nomdistrito);
    await mostraResultados();
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

  $("#nro-doc-empresa").addEventListener('input', async () => {
    if ($("#nro-doc-empresa").value.length !== 11) {
      $("#razon-social").value = '';
      $("#direccion").value = '';
      $("#iddistrito").value = '';
    }
  });

});
