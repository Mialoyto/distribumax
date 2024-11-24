document.addEventListener("DOMContentLoaded", () => {

    // Activar tooltips en todos los elementos que los tengan
    initializeTooltips();
  
    function $(object = null) { return document.querySelector(object); }
    let dtproveedor;
  
    // REFERENCIAS A LOS ELEMENTOS DEL MODAL
    const modal = $("#form-prov"); // MODAL FORMULARIO
    const inputIdEmpresa = modal.querySelector("#editIdEmpresa"); // INPUT ID EMPRESA
    const inputProveedor = modal.querySelector("#editProveedor"); // INPUT PROVEEDOR
    const inputContacto = modal.querySelector("#editContacto"); // INPUT CONTACTO
    const inputTelefono = modal.querySelector("#editTelefono"); // INPUT TELÉFONO
    const inputCorreo = modal.querySelector("#editCorreo"); // INPUT CORREO
    const inputDireccion = modal.querySelector("#editDireccion"); // INPUT DIRECCIÓN
    let idproveedor;
  
    // Función para cargar datos en el modal de edición
    async function cargarDatosModal(id) {
      try {
        inputIdEmpresa.value = "Cargando....";
        inputProveedor.value = "Cargando....";
        inputContacto.value = "Cargando....";
        inputTelefono.value = "Cargando....";
        inputCorreo.value = "Cargando....";
        inputDireccion.value = "Cargando....";
  
        const data = await getProveedor(id); // Llamada para obtener los datos del proveedor
  
        // Si hay datos, llenar los campos del modal
        if (data && data.length > 0) {
          inputIdEmpresa.setAttribute("id-proveedor", data[0].idempresa);
          inputProveedor.value = data[0].proveedor;
          inputContacto.value = data[0].contacto_principal;
          inputTelefono.value = data[0].telefono_contacto;
          inputCorreo.value = data[0].email;
          inputDireccion.value = data[0].direccion;
        }
      } catch (error) {
        console.error("Error al cargar los datos en el modal:", error);
      }
    }
  
    // Función para renderizar la tabla de proveedores
    function RenderDatatableProveedores() {
      if (dtproveedor) {
        dtproveedor.destroy();
      }
  
      dtproveedor = new DataTable("#table-proveedores", {
        columnDefs: [
          { width: "15%", targets: 0 }, // proveedor
          { width: "20%", targets: 1 }, // contacto
          { width: "15%", targets: 2 }, // teléfono
          { width: "15%", targets: 3 }, // correo
          { width: "25%", targets: 4 }, // dirección
          { width: "10%", targets: 5 }, // acciones
        ],
        language: {
          "sEmptyTable": "No hay datos disponibles en la tabla",
          "info": "",
          "sInfoFiltered": "(filtrado de _MAX_ entradas en total)",
          "sLengthMenu": "Filtrar: _MENU_",
          "sLoadingRecords": "Cargando...",
          "sProcessing": "Procesando...",
          "sSearch": "Buscar:",
          "sZeroRecords": "No se encontraron resultados",
          "oAria": {
            "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
            "sSortDescending": ": Activar para ordenar la columna de manera descendente"
          }
        }
      });
    }
  
    // Función para cargar proveedores desde el servidor
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
          data.forEach(element => {
            // CONTENIDO DE LA TABLA
            tableContent += `
              <tr>
                  <td>${element.proveedor}</td>
                  <td>${element.contacto_principal}</td>
                  <td>${element.telefono_contacto}</td>
                  <td>${element.email}</td>
                  <td>${element.direccion}</td>
                  <td>
                      <div class="d-flex justify-content-center">
                          <a id-data="${element.idproveedor}" class="btn btn-warning" data-bs-toggle="modal"  data-bs-target=".edit-proveedor">
                              <i class="bi bi-pencil-square fs-5"></i>
                          </a>
                      </div>
                  </td>
              </tr>
            `;
          });
  
          // INSERTAR EL CONTENIDO A LA TABLA
          TablaProveedores.innerHTML = tableContent;
  
          const editButtons = document.querySelectorAll(".btn-warning");
          editButtons.forEach((btn) => {
            btn.addEventListener("click", async (e) => {
              const id = e.currentTarget.getAttribute("id-data");
              console.log(id);
              await cargarDatosModal(id);
            });
          });
  
          // Event listener para el formulario de actualización del proveedor
          modal.addEventListener("submit", async (e) => {
            e.preventDefault();
            idproveedor = inputProveedor.getAttribute("id-proveedor");
            const proveedor = inputProveedor.value.trim();
            const contacto = inputContacto.value.trim();
            const telefono = inputTelefono.value.trim();
            const correo = inputCorreo.value.trim();
            const direccion = inputDireccion.value.trim();
  
            // Llamada a la función para actualizar el proveedor
            await formUpdateProveedor(idproveedor, proveedor, contacto, telefono, correo, direccion, modal);
            // Recargar la lista de proveedores
            await CargarProveedores();
          });
  
          initializeTooltips();
        } else {
          TablaProveedores.innerHTML = '<tr><td colspan="6" class="text-center">No hay datos disponibles</td></tr>';
        }
  
        RenderDatatableProveedores();
  
      } catch (error) {
        console.error("Error al cargar los proveedores:", error);
      }
    }
  
    // Inicializar la carga de proveedores
    CargarProveedores();
  });
  