document.addEventListener("DOMContentLoaded", () => {
  // Helper para simplificar el uso de querySelector
  function $(object = null) {
    return document.querySelector(object);
  }

  renderDocumento('.documento');

  // Función para buscar RUC por API
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
        $("#proveedor").value = '';
        $("#direccion").value = '';
        document.querySelector('.documento').value = '';
      } else {
        $("#proveedor").value = data['razonSocial'];
        $("#direccion").value = data['direccion'];
        $("#idtipodocumento").value = 2;  // Tipo documento 2 por defecto (RUC)
        addProveedor(true);  // Habilitar los campos
      }
      return data;
    } catch (e) {
      console.error("Error en buscarRuc: ", e);
    }
  }

  // Función para validar los datos y verificar si el proveedor está registrado
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
          addProveedor(false);  // Deshabilitar los campos
        } else {
          addProveedor(true);  // Habilitar los campos
        }
      } else {
        showToast("El número de RUC debe tener 11 dígitos", "info", "INFO");
        addProveedor(false);  // Deshabilitar los campos
      }
    } else {
      // Si el proveedor ya está registrado, muestra los datos
      showToast("El proveedor ya se encuentra registrado", "info", "INFO");
      // Cargar los datos del proveedor en los campos del formulario
      $("#tipodoc").value = response[0].idtipodocumento;
      $("#iddistrito").value = response[0].distrito;
      $("#email").value = response[0].email;
      $("#telefono_contacto").value = response[0].telefono;
      $("#razon-social").value = response[0].razonsocial;
      $("#direccion").value = response[0].direccion;
      
      // Deshabilitar los campos de edición si ya está registrado
      addProveedor(false);
    }
  }

  $("#btn-cliente-empresa").addEventListener('click', async () => {
    await validarDatos();
  });

  // Habilitar/deshabilitar los campos según los datos del proveedor
  function addProveedor(newdata = false) {
    if (!newdata) {
      $("#email").setAttribute('disabled', true);
      $("#iddistrito").setAttribute('disabled', true);
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
      const data = await response.json();
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

  // Función para registrar la empresa como proveedor
  async function registrarProveedor() {
    const params = new FormData();
    params.append('operation', 'add');
    params.append('idtipodocumento', $("#idtipodocumento").value);  // Tipo de documento
    params.append('idempresaruc', $("#nro-doc-empresa").value);  // RUC
    params.append('iddistrito', iddistrito);  // Distrito
    params.append('razonsocial', $("#proveedor").value);  // Nombre del proveedor
    params.append('direccion', $("#direccion").value);  // Dirección
    params.append('email', $("#email").value);  // Email
    params.append('telefono', $("#telefono_contacto").value);  // Teléfono

    const options = {
      method: 'POST',
      body: params
    };
    const response = await fetch(`../../controller/empresa.controller.php`, options);
    const data = await response.json();
    console.log(data);
    return data;
  }

  // Función para registrar el proveedor
  async function registrarProveedorFormulario(event) {
    event.preventDefault();

    if (await showConfirm("¿Desea registrar el proveedor?", "Proveedores")) {
      // Primero, registra el proveedor y espera a que se complete
      const empresaResponse = await registrarProveedor();
      console.log(empresaResponse);
      const id = empresaResponse.idempresa;
      console.log(id);
      if (id != 0) {
        showToast("Proveedor registrado con éxito", "success", "SUCCESS");
        $("#registrar-empresa").reset();  // Resetear el formulario
      } else {
        showToast("No se pudo registrar el proveedor", "error", "ERROR");
      }
    } else {
      console.log("Registro cancelado");
    }
  }

  // Evento para registrar el proveedor
  $("#registrar-empresa").addEventListener("submit", registrarProveedorFormulario);

  // Evento para limpiar el formulario si el RUC es inválido
  $("#nro-doc-empresa").addEventListener('input', async () => {
    if ($("#nro-doc-empresa").value.length !== 11) {
      $("#proveedor").value = '';
      $("#direccion").value = '';
      $("#iddistrito").value = '';
      $("#email").value = '';
      $("#telefono_contacto").value = '';
    }
  });

  // Función para mostrar los distritos
  const searchDist = async (distrito) => {
    let searchData = new FormData();
    searchData.append('operation', 'searchDistrito');
    searchData.append('distrito', distrito);
    const option = {
      method: 'POST',
      body: searchData
    };
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
  });

});
