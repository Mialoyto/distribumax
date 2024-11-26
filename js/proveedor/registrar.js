document.addEventListener("DOMContentLoaded", () => {

  // Helper para simplificar el uso de querySelector
  function $(object = null) {
    return document.querySelector(object);
  }
  renderDocumento('.documento');

  // Función para buscar ruc por api
  async function getApiRuc(ruc) {
    try {
      $("#status").classList.remove("d-none");
      const response = await fetch(`../../app/api/api.ruc.php?ruc=${ruc}`, {
        method: 'GET'
      });
      const data = await response.json();  // Parsear la respuesta como JSON
      console.log(data);
      $("#status").classList.add("d-none");
      if (data.hasOwnProperty('message')) {
        showToast("No se encontraron datos", "info", "INFO");
        $("#iddistrito").value = '';
        $("#razon-social").value = '';
        $("#direccion").value = '';
        document.querySelector('.documento').value = '';
      } else {
        $("#razon-social").value = data['razonSocial'];
        $("#direccion").value = data['direccion'];
        $("#tipodoc").value = 2;
      }
      return data;
    } catch (e) {
      console.error("Error en buscarRuc: ", e);
    }
  }

  async function validarDatos() {
    const ruc = $("#nro-doc-empresa").value;
    const response = await searchClienteEmpresa(ruc);
    console.log(response);
    if (response.length == 0) {
      if (ruc.length === 0) {
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
      } else {
        showToast("El número de RUC debe tener 11 dígitos", "info", "INFO");
        addCliente(false);
      }
    } else {
      showToast("El cliente ya se encuentra registrado", "info", "INFO");
      addCliente(false);
    }
  }

  $("#btn-cliente-empresa").addEventListener('click', async () => {
    await validarDatos();
  });

  function addCliente(newdata = false) {
    if (!newdata) {
      $("#email").setAttribute('disabled', true);
      $("#telefono_contacto").setAttribute('disabled', true);
      $("#registrarEmpresa").setAttribute('disabled', true);
    } else {
      $("#email").removeAttribute('disabled');
      $("#iddistrito").removeAttribute('disabled');
      $("#telefono_contacto").removeAttribute('disabled');
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
      // console.log(data);
      if (data.length > 0) {
        $("#tipodoc").value = data[0].idtipodocumento;
        $("#iddistrito").value = data[0].distrito;
        $("#email").value = data[0].email;
        $("#telefono_contacto").value = data[0].telefono;
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
    params.append('idtipodocumento', $("#tipodoc").value);
    params.append('idempresaruc', $("#nro-doc-empresa").value);
    params.append('iddistrito', iddistrito);
    params.append('razonsocial', $("#razon-social").value);
    params.append('direccion', $("#direccion").value);
    params.append('email', $("#email").value);
    params.append('telefono', $("#telefono_contacto").value);

    const options = {
      method: 'POST',
      body: params
    };
    const response = await fetch(`../../controller/empresa.controller.php`, options);
    const data = await response.json();
    console.log(data);
    return data;
  }

  // Función para registrar el cliente
  async function registrarCliente(idempresa) {
    let idpersona = $("#nor-doc-persona");
    idpersona = null;
    const params = new FormData();
    params.append('operation', 'addcliente');
    params.append('idpersona', idpersona); // Asegúrate de que este campo tenga el valor correcto
    params.append('idempresa', idempresa); // Usa el ID de la empresa que acabas de registrar
    params.append('tipo_cliente', 'Empresa');

    const options = {
      method: 'POST',
      body: params
    };

    try {
      const response = await fetch(`../../controller/cliente.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;

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
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  const dataList = $("#datalistDistrito");
  let iddistrito;
  async function mostraResultados() {
    $("#iddistrito").innerHTML = '';
    const response = await searchDist(nomdistrito);
    console.log(response);
    dataList.innerHTML = '';
    if (response.length != 0) {
      dataList.style.display = 'block';

      response.forEach((distrito) => {
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.setAttribute('data-id', distrito.iddistrito);
        li.innerHTML = ` ${distrito.distrito},${distrito.provincia}, ${distrito.departamento}`;
        li.addEventListener('click', () => {
          $("#iddistrito").value = li.textContent;
          iddistrito = li.getAttribute('data-id');
          dataList.innerHTML = '';
        });
        dataList.appendChild(li);
      });
    }
  }

  let nomdistrito;
  $("#iddistrito").addEventListener('input', async () => {
    nomdistrito = $("#iddistrito").value.trim();
    await mostraResultados();
    console.log(nomdistrito);
    // const data = await mostraResultados
    // console.log(data);
  });

  // Evento para registrar la empresa o persona
  $("#registrar-empresa").addEventListener("submit", async (event) => {
    event.preventDefault();

    if (await showConfirm("¿Desea registrar la empresa y el cliente?", "Clientes")) {
      // Primero, registra la empresa y espera a que se complete
      const empresaResponse = await registrarEmpresa();
      console.log(empresaResponse);
      const id = empresaResponse.idempresa;
      console.log(id);
      if (id != 0) {
        const data = await registrarCliente(id);
        console.log(data);
        $("#registrar-empresa").reset();
        showToast("Cliente registrado con éxito", "success", "SUCCESS");
      } else {
        showToast("No se pudo registrar la empresa", "error", "ERROR");
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
      $("#email").value = '';
      $("#telefono_contacto").value = '';
    }
  });

});
