document.addEventListener("DOMContentLoaded", () => {
  // Inicializar tooltips en los elementos
  initializeTooltips();

  function $(object = null) { return document.querySelector(object); }
  let dtproveedor;

  // REFERENCIAS A LOS ELEMENTOS DEL MODAL
  const modal = $("#form-prov"); // Modal del formulario de proveedores
  const inputEmpresa = modal.querySelector("#editIdEmpresa"); // Input Nombre
  const inputProveedor = modal.querySelector("#editProveedor"); // Input Contacto
  const inputTelefono = modal.querySelector("#editTelefono"); // Input Teléfono
  const inputCorreo = modal.querySelector("#editCorreo"); // Input Correo
  const inputDireccion = modal.querySelector("#editDireccion"); 
  const inputContacto = modal.querySelector("#editContacto");
  let idproveedor;

  async function cargarDatosModal(id) {
    try {
      inputEmpresa.value = "Cargando...";
      inputProveedor.value = "Cargando...";
      inputContacto.value = "Cargando...";
      inputTelefono.value = "Cargando...";
      inputCorreo.value = "Cargando...";
      inputDireccion.value = "Cargando...";

      const data = await getProveedor(id); // Función que obtiene datos del proveedor
      if (data && data.length > 0) {
        const proveedor = data[0];
        inputProveedor.setAttribute("id-proveedor", proveedor.idproveedor);
        inputEmpresa.value = proveedor.idempresa;
        inputProveedor.value = proveedor.proveedor;
        inputContacto.value = proveedor.contacto_principal;
        inputTelefono.value = proveedor.telefono_contacto;
        inputCorreo.value = proveedor.email;
        inputDireccion.value = proveedor.direccion;
      }
    } catch (error) {
      console.error("Error al cargar los datos en el modal:", error);
    }
  }

  function RenderDatatableProveedores() {
    if (dtproveedor) {
      dtproveedor.destroy();
    }

    dtproveedor = new DataTable("#table-proveedores", {
      columnDefs: [
        { width: "20%", targets: 0 }, // Nombre
        { width: "20%", targets: 1 }, // Contacto
        { width: "15%", targets: 2 }, // Teléfono
        { width: "20%", targets: 3 }, // Correo
        { width: "20%", targets: 4 }, // Dirección
        { width: "5%", targets: 5 }, // Estado
        { width: "10%", targets: 6 }, // Acciones
        { width: "10%", targets: 7 }
      ],
      language: {
        sEmptyTable: "No hay datos disponibles en la tabla",
        info: "",
        sInfoFiltered: "(filtrado de _MAX_ entradas en total)",
        sLengthMenu: "Filtrar: _MENU_",
        sLoadingRecords: "Cargando...",
        sProcessing: "Procesando...",
        sSearch: "Buscar:",
        sZeroRecords: "No se encontraron resultados",
        oAria: {
          sSortAscending: ": Activar para ordenar la columna de manera ascendente",
          sSortDescending: ": Activar para ordenar la columna de manera descendente"
        }
      }
    });
  }

  async function CargarProveedores() {
    if (dtproveedor) {
      dtproveedor.destroy();
      dtproveedor = null;
    }

    const TablaProveedores = $("#table-proveedores tbody");
    let tableContent = "";

    try {
      const response = await fetch(`../../controller/proveedor.controller.php?operation=getAll`);
      const data = await response.json();

      if (data.length > 0) {
        data.forEach((element) => {
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-6" : "bi bi-toggle2-off fs-6";
          const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
          const isDisabled = element.estado === "Inactivo" || element.status === 0 ? "disabled" : "";

          tableContent += `
            <tr>
              <td>${element.idempresaruc}</td>
              <td>${element.proveedor}</td>
              <td>${element.contacto_principal}</td>
              <td>${element.telefono_contacto}</td>
              <td>${element.direccion}</td>
              <td>${element.email}</td>
              <td class="${estadoClass} fw-bold">${element.estado}</td>
              <td>
                <div class="d-flex ">
                    <div class="btn-group btn-group-sm" role="group">
                    <a id-data="${element.idproveedor}" 
                  class="btn btn-warning ${isDisabled}" 
                  data-bs-toggle="modal" 
                  data-bs-target=".edit-proveedor"
                  type="button" class="me-2" 
                  data-bs-placement="bottom" 
                  data-bs-title="Editar">
                  <i class="bi bi-pencil-square fs-6"></i>
                  </a>
                  <a id-data="${element.idproveedor}" 
                  class="btn ${bgbtn} ms-2 estado" 
                  status="${element.status}"
                  data-bs-target=".edit-proveedor"
                  type="button" 
                  data-bs-placement="bottom"
                  data-bs-toggle="tooltip"  
                  data-bs-title="Cambiar estado">
                    <i class="${icons}"></i>
                  </a>
                    </div>
                </div>
              </td>
            </tr>
          `;
        });
           initializeTooltips();
        TablaProveedores.innerHTML = tableContent;

        const editButtons = document.querySelectorAll(".btn-warning");
        editButtons.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            const id = e.currentTarget.getAttribute("id-data");
            await cargarDatosModal(id);
          });
        });

        //NOTE - EVENTO PARA ACTUALIZAR EL PROVEEDOR
        // ? EVENTO PARA ACTUALIZAR EL PROVEEDOR
        modal.addEventListener("submit", async (e) =>{
          e.preventDefault();
          idproveedor = inputProveedor.getAttribute("id-proveedor");
          const empresa = inputEmpresa.value.trim();
          const proveedor = inputProveedor.value.trim();
          const contacto = inputContacto.value.trim();
          const telefono = inputTelefono.value.trim();
          const correo = inputCorreo.value.trim();
          const direccion = inputDireccion.value.trim();

          console.log("idproveedor : ", idproveedor);
          console.log("idempresa : ", empresa);
          console.log("proveedor : ", proveedor);
          console.log("contacto : ", contacto);
          console.log("telefono : ", telefono);
          console.log("correo : ", correo);
          console.log("direccion : ", direccion);
          //NOTE - ESTA FUNCION SE ENCUENTRA EN EL ARCHIVO editar-proveedor.js
          await formUpdateProveedor(idproveedor, empresa, proveedor, contacto, telefono, correo, direccion);
          //RENDERIZAR LA TABLA DE PROVEEDORES
          await CargarProveedores();
        })


        const statusButtons = document.querySelectorAll(".estado");
        statusButtons.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            try {
              const id = e.currentTarget.getAttribute("id-data");
              const status = e.currentTarget.getAttribute("status");
              if (await showConfirm("¿Estás seguro de cambiar el estado del proveedor?")) {
                const data = await updateEstado(id, status);
                if (data[0].estado > 0) {
                  showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                  await CargarProveedores();
                } else {
                  showToast(`${data[0].mensaje}`, "error", "ERROR");
                }
              }
            } catch (error) {
              console.error("Error al cambiar el estado del proveedor:", error);
            }
          });
        });

        initializeTooltips();

      } else {
        TablaProveedores.innerHTML = '<tr><td colspan="7" class="text-center">No hay datos disponibles</td></tr>';
      }

      RenderDatatableProveedores();

    } catch (error) {
      console.error("Error al cargar los proveedores:", error);
    }
  }

  CargarProveedores();
});
