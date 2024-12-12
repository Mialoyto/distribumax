document.addEventListener("DOMContentLoaded", () => {
  // Simplificar querySelector
  function $(selector = null) {
    return document.querySelector(selector)
  };

  // Variables globales
  let razonsocial = "";
  let iddistrito;

  // Inicializar campos de tipo documento
  renderDocumento(".documento");

  // Buscar distrito
  const searchDist = async (distrito) => {
    const searchData = new FormData();
    searchData.append("operation", "searchDistrito");
    searchData.append("distrito", distrito);

    try {
      const response = await fetch("../../controller/distrito.controller.php", {
        method: "POST",
        body: searchData,
      });
      console.log("Respuesta de searchDist:", response);
      return await response.json();
    } catch (error) {
      console.error("Error buscando distritos:", error);
    }
  };

  // Mostrar resultados de distritos
  const mostrarResultados = async () => {
    const response = await searchDist($("#iddistrito").value.trim());
    console.log("Resultados de distritos:", response);
    const dataList = $("#datalistDistrito");
    dataList.innerHTML = "";

    if (response?.length > 0) {
      dataList.style.display = "block";
      response.forEach((distrito) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.setAttribute("data-id", distrito.iddistrito);
        li.textContent = `${distrito.distrito}, ${distrito.provincia}, ${distrito.departamento}`;
        li.addEventListener("click", () => {
          $("#iddistrito").value = li.textContent;
          iddistrito = li.getAttribute("data-id");
          console.log("Distrito seleccionado:", li.textContent);
          dataList.innerHTML = "";
        });
        dataList.appendChild(li);
      });
    }
  };

  $("#iddistrito").addEventListener("input", mostrarResultados);

  // Registrar empresa
  const registrarEmpresa = async () => {
    const params = new FormData();
    params.append("operation", "add");
    params.append("idtipodocumento", 2);
    params.append("idempresaruc", $("#nro-doc-empresa").value);
    params.append("iddistrito", iddistrito);
    params.append("razonsocial", razonsocial);
    params.append("direccion", $("#direccion").value);
    params.append("email", $("#email").value);
    params.append("telefono", $("#telefono-empresa").value);

    try {
      const response = await fetch("../../controller/empresa.controller.php", {
        method: "POST",
        body: params,
      });
      console.log("Respuesta al registrar empresa:", response);
      return await response.json();
    } catch (error) {
      console.error("Error al registrar empresa:", error);
    }
  };

  // Registrar proveedor
  const registrarProveedor = async (idempresa) => {
    const params = new FormData();
    params.append("operation", "addProveedor");
    params.append("idempresa", idempresa);
    params.append("proveedor", $("#proveedor").value);
    params.append("contacto_principal", $("#contacto_principal").value);
    params.append("telefono_contacto", $("#telefono-empresa").value);
    params.append("direccion", $("#direccion").value);
    params.append("email", $("#email").value);

    try {
      const response = await fetch(`../../controller/proveedor.controller.php`, {
        method: "POST",
        body: params,
      });
      console.log("Respuesta al registrar proveedor:", response);
      return await response.json();
    } catch (error) {
      console.error("Error al registrar el proveedor:", error);
    }
  };

  // Registro completo de empresa y proveedor
  const registrarEmpresaYProveedor = async (event) => {
    event.preventDefault();

    if (await showConfirm("¿Desea registrar la empresa y el proveedor?", "Registro")) {
      const empresaResponse = await registrarEmpresa();
      console.log("Respuesta del registro de empresa:", empresaResponse);
      const idempresa = empresaResponse?.idempresa;

      if (idempresa) {
        const proveedorResponse = await registrarProveedor(idempresa);
        console.log("Respuesta del registro de proveedor:", proveedorResponse);

        if (proveedorResponse) {
          showToast("Proveedor registrado con éxito", "success", "SUCCESS");
          $("#registrar-empresa").reset();
          habilitarCampos(false);
        } else {
          showToast("No se pudo registrar el proveedor", "error", "ERROR");
        }
      } else {
        showToast("No se pudo registrar la empresa", "error", "ERROR");
      }
    } else {
      console.log("Registro cancelado");
    }
  };

  $("#registrar-empresa").addEventListener("submit", registrarEmpresaYProveedor);

  // Buscar cliente empresa
  const searchClienteEmpresa = async (ruc) => {
    try {
      const response = await fetch(`../../controller/empresa.controller.php?operation=search&ruc=${ruc}`);
      console.log("Respuesta de searchClienteEmpresa:", response);
      return await response.json();
    } catch (error) {
      console.error("Error al buscar cliente/empresa:", error);
    }
  };

  // Obtener datos por API
  const getApiRuc = async (ruc) => {
    try {
      $("#status").classList.remove("d-none");
      const response = await fetch(`../../app/api/api.ruc.php?ruc=${ruc}`);
      const data = await response.json();
      console.log("Datos obtenidos de la API RUC:", data);
      $("#status").classList.add("d-none");

      if (data.message) {
        showToast("No se encontraron datos", "info", "INFO");
        limpiarCampos();
      } else {
        $("#proveedor").value = data.razonSocial;
        $("#direccion").value = data.direccion;
        document.getElementById("contacto_principal").disabled = false;
        razonsocial = data.razonSocial;
        habilitarCampos(true);
      }
      return data;
    } catch (error) {
      console.error("Error en buscarRuc:", error);
    }
  };

  // Validar RUC y cargar datos
  const validarDatos = async () => {
    const ruc = $("#nro-doc-empresa").value.trim();

    if (!ruc || ruc.length !== 11) {
      showToast("El número de RUC debe tener 11 dígitos", "info", "INFO");
      habilitarCampos(false);
      return;
    }

    const response = await searchClienteEmpresa(ruc);
    console.log("Respuesta de validarDatos:", response);
    if (!response || response.length === 0) {
      await getApiRuc(ruc);
    } else {
      habilitarCampos(false);
    }
  };

  $("#btn-cliente-empresa").addEventListener("click", async () => {
    const existeProveedor = await verificarProveedor($("#nro-doc-empresa").value.trim());
    console.log("Existe proveedor:", existeProveedor);
    if (existeProveedor[0]) {
      showToast("El proveedor ya está registrado", "info", "INFO");

      const response = await fetch(`../../controller/distrito.controller.php?operation=getbyId&iddistrito=${existeProveedor[0].iddistrito}`);
      const data = await response.json();

      $("#direccion").value = existeProveedor[0].direccion;
      $("#email").value = existeProveedor[0].email;
      $("#telefono-empresa").value = existeProveedor[0].telefono_contacto;
      $("#contacto_principal").value = existeProveedor[0].contacto_principal;
      $("#proveedor").value = existeProveedor[0].proveedor;
      $("#iddistrito").value = data[0].resultado;

    } else {
      await validarDatos();
    }
  });

  // Verificar proveedor
  const verificarProveedor = async (ruc) => {
    try {
      const response = await fetch(`../../controller/proveedor.controller.php?operation=ObtenerProveedorbyRuc&ruc=${ruc}`);
      console.log("Respuesta de verificarProveedor:", response);
      return await response.json();
    } catch (error) {
      console.error("Error al buscar proveedor:", error);
    }
  };

  // Habilitar/deshabilitar campos
  const habilitarCampos = (estado) => {
    ["#email", "#iddistrito", "#telefono-empresa", "#registrarEmpresa"].forEach((selector) => {
      $(selector).toggleAttribute("disabled", !estado);
    });
    document.getElementById("contacto_principal").disabled = !estado;
    console.log(`Campos ${estado ? "habilitados" : "deshabilitados"}`);
    limpiarCampos();
  };

  const limpiarCampos = () => {
    $("#telefono-empresa").value = "";
    $("#contacto_principal").value = "";
    $("#iddistrito").value = "";
  };
W});
