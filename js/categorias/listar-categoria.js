document.addEventListener("DOMContentLoaded", function () {
  function $(object = "") {
    return document.querySelector(object);
  }
  let dtcategoria;

  const formUpdateCategoria = document.querySelector("#edit-categoria");

  async function CargarDatos() {

    if (dtcategoria) {
      dtcategoria.destroy();
      dtcategoria = null;
    }

    try {
      const response = await fetch(`../../controller/categoria.controller.php?operation=getAll`);
      const data = await response.json();
      const Tablacategorias = $("#table-categorias tbody");

      // Construir el contenido de la tabla
      let tableContent = "";
      if (data.length === 0) {
        tableContent = `<tr><td colspan="3" class="text-center">No hay datos disponibles</td></tr>`;
      } else {
        data.forEach((element) => {
          // console.log(element);
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
          const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";

          element.estado === "Activo" ? "text-success" : "text-danger";
          tableContent += `
                <tr>
                    <td>${element.categoria}</td> 
                    <td>
                    <strong class="${estadoClass}">
                    ${element.estado}
                    </strong>
                    </td>
                    <td>
                    <div class="d-flex justify-content-center">
                        <a  id-data="${element.id}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#edit-categoria" >
                            <i class="bi bi-pencil-square fs-5"></i>
                        </a>     
                        <a  id-data="${element.id}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                            <i class="${icons}"></i>
                        </a>
                    </div>
                    </td>
                </tr>
                `;
        });
        Tablacategorias.innerHTML = tableContent;
        asignarEventos();

        if (dtcategoria) {
          dtcategoria.destroy();
        }
        RenderDatatable();
      }

    } catch (error) {
      console.error("Hubo un error al cargar los datos:", error);
      Tablacategorias.innerHTML = `<tr><td colspan="4" class="text-center">Error al cargar los datos</td></tr>`;
    }
  }

  CargarDatos();

  function asignarEventos() {
    // para almacenar el id de la categoria
    let id;
    const btnEdit = document.querySelectorAll(".btn-warning");
    const idcategoria = document.querySelector("#id-categoria");
    const btnDisabled = document.querySelectorAll(".estado");

    // evento para cargar los datos en el modal
    btnEdit.forEach((btn) => {
      btn.addEventListener("click", async (e) => {
        id = e.currentTarget.getAttribute("id-data");
        idcategoria.setAttribute("id-cat", id);
        await cargarDatosModal(id);
      });
    });

    // evento para editar el nombre de la categoria
    formUpdateCategoria.addEventListener("submit", async (e) => {
      e.preventDefault();
      try {
        const id = idcategoria.getAttribute("id-cat");
        const categoria = idcategoria.value;
        const inputCategoria = categoria.trim();
        idcategoria.classList.remove("is-invalid");
        const spanError = document.querySelector(".text-danger");
        if (spanError) {
          spanError.remove();
        }
        if (await showConfirm("¿Estás seguro de actualizar la categoria?")) {
          const data = await updateCategoria(id, inputCategoria);
          const estado = data[0].estado;
          if (estado) {
            // console.log(" retorna true")
            showToast(`${data[0].mensaje}`, "success", "SUCCESS");
            await CargarDatos();
          } else {
            idcategoria.classList.add("is-invalid");
            const span = document.createElement("span");
            span.classList.add("text-danger");
            span.innerHTML = `${data[0].mensaje}`;
            idcategoria.insertAdjacentElement("afterend", span);
          }
        }
      } catch (error) {
        console.error("Error al actualizar la categoria:", error);
      }
    });

    // evento para cambiar el estado de la categoria
    btnDisabled.forEach((btn) => {
      btn.addEventListener("click", async (e) => {
        id = e.currentTarget.getAttribute("id-data");
        const status = e.currentTarget.getAttribute("status");
        console.log("ID:", id, "Status:", status);
        if (await showConfirm("¿Estás seguro de cambiar el estado de la categoria?")) {
          const data = await updateEstado(id, status);
          const estado = data[0].estado;
          if (estado) {
            showToast(`${data[0].mensaje}`, "success", "SUCCESS");
            await CargarDatos();
          } else {
            showToast(`${data[0].mensaje}`, "error", "ERROR");
          }
        }
      });
    });
  }

  function RenderDatatable() {

    if (dtcategoria) {
      dtcategoria.destroy();
      dtcategoria = null;
    }

    dtcategoria = new DataTable("#table-categorias", {
      columnDefs: [
        { width: "33.33%", targets: 0 },
        { width: "33.33%", targets: 1 },
        { width: "33.33%", targets: 2 },
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
          sSortAscending:
            ": Activar para ordenar la columna de manera ascendente",
          sSortDescending:
            ": Activar para ordenar la columna de manera descendente",
        },
      },
    });
  }
});
