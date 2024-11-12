document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) {
      return document.querySelector(object);
    }
  
    let proveedores;
    let selectedProvider; // Para almacenar el proveedor seleccionado
  
    function desabilitarCampos() {
      $("#email").setAttribute("disabled", true);
      $("#proveedor").setAttribute("disabled", true);
      $("#contacto_principal").setAttribute("disabled", true);
      $("#telefono_contacto").setAttribute("disabled", true);
      $("#direccion").setAttribute("disabled", true);
    }
    function habilitarCampos(){
        $("#email").removeAttribute("disabled");
        $("#proveedor").removeAttribute("disabled");
        $("#contacto_principal").removeAttribute("disabled");
        $("#telefono_contacto").removeAttribute("disabled");
        $("#direccion").removeAttribute("disabled");
    }
  
    async function renderData() {
      $("#list-proveedor").innerHTML = "";
      const response = await getProveedor(proveedores);
      
      if (response && response.data.length > 0) {
        $("#list-proveedor").style.display = "block";
  
        response.data.forEach(item => {
          const li = document.createElement("li");
          li.classList.add("list-group-item");
          li.innerHTML = `${item.proveedor} <h6 class="btn btn-secondary btn-sm h-25 d-inline-block">${item.idempresa}</h6>`;
          li.addEventListener("click", () => {
            $("#list-proveedor").innerHTML = "";
            $("#idproveedor").setAttribute("data-id", item.idproveedor);
            $("#idproveedor").value = item.proveedor;
  
            // Guarda el proveedor seleccionado
            selectedProvider = item; // Almacena toda la información del proveedor
            mostrarDatosProveedor(); // Llama a la función para mostrar los datos
            desabilitarCampos();
        });
          $("#list-proveedor").appendChild(li);
        
        });
      } else {
        habilitarCampos();
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `<b>Proveedor no encontrado</b>`;
        $("#list-proveedor").appendChild(li);
      }
    }
  
    async function getProveedor(proveedor) {
      const params = new URLSearchParams();
      params.append("operation", "getProveedor");
      params.append("proveedor", proveedor);
      try {
        const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
        return response.json();
      } catch (e) {
        console.error(e);
      }
    }
  
    function mostrarDatosProveedor() {
      if (selectedProvider) {
        $("#proveedor").value = selectedProvider.proveedor;
        $("#contacto_principal").value = selectedProvider.contacto_principal;
        $("#telefono_contacto").value = selectedProvider.telefono_contacto;
        $("#direccion").value = selectedProvider.direccion;
        $("#email").value = selectedProvider.email;
      }
    }
    function cleanCampos(){
        $("#proveedor").value = '';
        $("#contacto_principal").value = '';
        $("#telefono_contacto").value = '';
        $("#direccion").value = '';
        $("#email").value = '';
    }
    $("#idproveedor").addEventListener("input", async () => {
      proveedores = $("#idproveedor").value.trim();
  
      if (!proveedores) {
        $("#list-proveedor").style.display = "none";
        cleanCampos();
        habilitarCampos();
      } else {
        await renderData();
        
      }
    });
  
    async function registrarproveedor() {
      const params = new FormData();
      params.append("operation", "addProveedor");
      params.append("idempresa", optionEmp.value);
      params.append("proveedor", $("#idproveedor").value);
      params.append("contacto_principal", $("#contacto_principal").value);
      params.append("telefono_contacto", $("#telefono_contacto").value);
      params.append("direccion", $("#direccion").value);
      params.append("email", $("#email").value);
  
      try {
        const response = await fetch(`../../controller/proveedor.controller.php`, {
          method: "POST",
          body: params,
        });
        return await response.json();
      } catch (e) {
        console.error(e);
      }
    }
  });
  