document.addEventListener("DOMContentLoaded", function () {
  function $(object = "") {
    return document.querySelector(object);
  }
  let dtcliente;

  const formUpdateCliente = document.querySelector("#edit-cliente");

  async function CargarClientes() {
    if (dtcliente) {
      dtcliente.destroy();
      dtcliente = null;
    }

    try {
      const response = await fetch(`../../controller/cliente.controller.php?operation=getAll`);
      const data = await response.json();
      const TablaClientes = $("#table-clientes tbody");

      let tableContent = "";
      if (data.length === 0) {
        tableContent = `<tr><td colspan="6" class="text-center">No hay datos disponibles</td></tr>`;
      } else {
        data.forEach((element) => {
          console.log(element);
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
          const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";

          tableContent += `
            <tr>
              <td>${element.nro_doc}</td>
              <td>${element.tipo_cliente}</td>
              <td>${element.cliente}</td>
              <td>
                <strong class="${estadoClass}">
                  ${element.estado}
                </strong>
              </td>
              <td>
                <div class="d-flex justify-content-center">
                  <a id-data="${element.idcliente}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#edit-cliente">
                    <i class="bi bi-pencil-square fs-5"></i>
                  </a>
                  <a id-data="${element.idcliente}" class="btn ${bgbtn} ms-2 estado" status="${element.estado}">
                    <i class="${icons}"></i>
                  </a>
                </div>
              </td>
            </tr>
          `;
        });
      }
      TablaClientes.innerHTML = tableContent;
      asignarEventos();

      if (dtcliente) {
        dtcliente.destroy();
      }
      RenderDatatableClientes();
    } catch (error) {
      console.error("Error al cargar los clientes: ", error);
      const TablaClientes = $("#table-clientes tbody");
      TablaClientes.innerHTML = `<tr><td colspan="6" class="text-center">Error al cargar los datos</td></tr>`;
    }
  }

  CargarClientes();

  function asignarEventos() {
    let id;
    const btnEdit = document.querySelectorAll(".btn-warning");
    const btnDisabled = document.querySelectorAll(".estado");

    btnDisabled.forEach((btn) => {
      btn.addEventListener("click", async (e) => {
        id = e.currentTarget.getAttribute("id-data");
        const status = e.currentTarget.getAttribute("status");
        console.log("ID: ", id, " Status: ", status);
        if (await showConfirm("¿Estás seguro de cambiar el estado del cliente?")) {
          const data = await updateEstado(id, status);
          const estado = data[0].estado;
          if (estado) {
            showToast(`${data[0].mensaje}`, "success", "SUCCESS");
            CargarClientes();
          } else {
            showToast(`${data[0].mensaje}`, "error", "ERROR");
          }
        }
      });
    });
  }

  function RenderDatatableClientes() {
    if (dtcliente) {
      dtcliente.destroy();
      dtcliente = null;
    }

    // Inicializar DataTable
    dtcliente = new DataTable("#table-clientes", {
      columnDefs: [
        { width: "10%", targets: 0 },
        { width: "10%", targets: 1 },
        { width: "10%", targets: 2 },
        { width: "10%", targets: 3 },
        { width: "10%", targets: 4 },
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
          sSortDescending: ": Activar para ordenar la columna de manera descendente",
        },
      },
    });
  }
});
