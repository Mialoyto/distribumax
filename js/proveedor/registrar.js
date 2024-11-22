document.addEventListener("DOMContentLoaded", () => {
  function $(selector) {
    return document.querySelector(selector);
  }

  let selectedProvider;

  // Deshabilitar campos
  function deshabilitarCampos() {
    ["#proveedor", "#contacto_principal", "#telefono_contacto", "#direccion", "#email"].forEach(id => {
      $(id).setAttribute("disabled", true);
    });
  }

  // Habilitar campos
  function habilitarCampos() {
    ["#proveedor", "#contacto_principal", "#telefono_contacto", "#direccion", "#email"].forEach(id => {
      $(id).removeAttribute("disabled");
    });
  }

  // Limpiar campos
  function limpiarCampos() {
    ["#proveedor", "#contacto_principal", "#telefono_contacto", "#direccion", "#email"].forEach(id => {
      $(id).value = "";
    });
  }

  // Mostrar datos del proveedor seleccionado
  function mostrarDatosProveedor() {
    if (selectedProvider) {
      $("#proveedor").value = selectedProvider.proveedor;
      $("#contacto_principal").value = selectedProvider.contacto_principal;
      $("#telefono_contacto").value = selectedProvider.telefono_contacto;
      $("#direccion").value = selectedProvider.direccion;
      $("#email").value = selectedProvider.email;
    }
  }

  // Renderizar lista de proveedores
  async function renderData(proveedores) {
    $("#list-proveedor").innerHTML = "";
    const response = await getProveedor(proveedores);

    if (response?.data?.length) {
      $("#list-proveedor").style.display = "block";
      response.data.forEach(item => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.textContent = item.proveedor;
        li.addEventListener("click", () => {
          $("#idproveedor").value = item.proveedor;
          selectedProvider = item;
          mostrarDatosProveedor();
          deshabilitarCampos();
          $("#list-proveedor").style.display = "none";
        });
        $("#list-proveedor").appendChild(li);
      });
    } else {
      habilitarCampos();
    }
  }

  // Obtener proveedores desde la API
  async function getProveedor(proveedor) {
    const params = new URLSearchParams();
    params.append("operation", "getProveedor");
    params.append("idproveedor", proveedor);

    try {
      const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
      return await response.json();
    } catch (error) {
      console.error(error);
    }
  }

  // Registrar proveedor
  async function registrarProveedor() {
    const params = new FormData();
    params.append("operation", "addProveedor");
    params.append("proveedor", $("#proveedor").value);
    params.append("contacto_principal", $("#contacto_principal").value);
    params.append("telefono_contacto", $("#telefono_contacto").value);
    params.append("direccion", $("#direccion").value);
    params.append("email", $("#email").value);

    try {
      const response = await fetch("../../controller/proveedor.controller.php", {
        method: "POST",
        body: params,
      });

      const result = await response.json();
      if (result.success) {
        alert("Proveedor registrado correctamente.");
        limpiarCampos();
        habilitarCampos();
      } else {
        alert("Error al registrar proveedor.");
      }
    } catch (error) {
      console.error(error);
    }
  }

  // Eventos
  $("#idproveedor").addEventListener("input", async () => {
    const proveedores = $("#idproveedor").value.trim();
    if (proveedores) {
      await renderData(proveedores);
    } else {
      limpiarCampos();
      habilitarCampos();
    }
  });

  $("#btn-registrar").addEventListener("click", registrarProveedor);
});
