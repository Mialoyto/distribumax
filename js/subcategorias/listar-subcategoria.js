document.addEventListener("DOMContentLoaded", function () {
  function $(object = null) { return document.querySelector(object); }
  let dtSubcategorias; // Variable para guardar el DataTable

  // Variables para DataTable
  async function obtenerSubcategoriaId(id) {
    const params = new URLSearchParams();
    params.append("operation", 'getSubcategoria');
    params.append("idsubcategoria", id);
    try {
      const response = await fetch(`../../controller/subcategoria.controller.php?${params}`);
      const data = await response.json();
      console.log("Datos obtenidos:", data);
      return data;
    } catch (error) {
      console.error("Error al obtener la subcategoría por ID:", error);
    }
  }

  async function cargarDatosModal(id) {
    try {
      const modal = $(".edit-categoria");
      const inputCategoria = modal.querySelector("input[name='categoria']");
      const inputSubcategoria = modal.querySelector("input[name='subcategoria']");
      const btn = modal.querySelector(".btn-success");
      btn.setAttribute("disabled", "true");
      inputCategoria.value = "Cargando...";
      inputSubcategoria.value = "Cargando...";
      console.log("ID:", id);
      const data = await obtenerSubcategoriaId(id);
      console.log("Datos para el modal:", data);
      if (data && data.length > 0) {
        // const modal = $(".edit-categoria");
        // const inputCategoria = modal.querySelector("input[name='categoria']");
        // const inputSubcategoria = modal.querySelector("input[name='subcategoria']");
        inputCategoria.value = data[0].categoria;
        inputSubcategoria.value = data[0].subcategoria;
        btn.removeAttribute("disabled");
      } else {
        console.log("No hay datos disponibles para esta subcategoría.");
      }
    } catch (error) {
      console.error("Error al cargar los datos en el modal:", error);
    }
  }

  // Función para inicializar DataTable para subcategorías
  function RenderDatatableSubcategorias() {
    if (dtSubcategorias) {
      dtSubcategorias.destroy();
    }

    dtSubcategorias = new DataTable("#table-subcategorias", {
      columnDefs: [
        { width: "20%", targets: 0 },  // Categoría
        { width: "40%", targets: 1 },  // Subcategoría
        { width: "20%", targets: 2 },  // Estado
        { width: "20%", targets: 3 }   // Acciones
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

  // Función para cargar las subcategorías
  async function CargarSubcategorias() {
    if (dtSubcategorias) {
      dtSubcategorias.destroy();
      dtSubcategorias = null;
    }

    try {
      // URL para obtener las subcategorías
      const response = await fetch(`../../controller/subcategoria.controller.php?operation=getAll`);
      const data = await response.json();
      console.log("Datos de todas las subcategorías:", data);

      const TablaSubcategorias = $("#table-subcategorias tbody");
      // Limpiar la tabla antes de agregar nuevas filas
      let tableContent = "";

      if (data.length > 0) {
        console.log(data)
        data.forEach(element => {
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
          const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";

          tableContent += `
                <tr>
                  <td>${element.categoria}</td>  
                  <td class="text-start">${element.subcategoria}</td>
                  <td> <strong class="${estadoClass}">
                    ${element.estado}
                    </strong>
                  </td>
                  <td>
                    <div class="d-flex justify-content-center">
                      <a  id-data="${element.id}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target=".edit-categoria">
                        <i class="bi bi-pencil-square fs-5"></i>
                      </a>     
                      <a  id-data="${element.id}" class="btn ${bgbtn} ms-2 estado" estado-cat="${element.status}">
                        <i class="${icons}"></i>
                      </a>

                      </div>
                  </td>
                </tr>
                `;
        });
        // Agregar contenido a la tabla
        TablaSubcategorias.innerHTML = tableContent;
        const clase = document.querySelectorAll(".btn-warning");
        const btnDisabled = document.querySelectorAll(".estado");
        const id_sub = document.querySelector("#id-subcategoria");
        let id;
        clase.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            id = e.currentTarget.getAttribute("id-data");
            id_sub.setAttribute("id-sub", id);
            if (id) {
              console.log("ID:", id);
              await cargarDatosModal(id);
            } else {
              console.error("El atributo id-data es null o undefined.");
            }
          });
        });

        btnDisabled.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            try {
              e.preventDefault();
              id = e.currentTarget.getAttribute("id-data");
              const status = e.currentTarget.getAttribute("estado-cat");
              console.log("ID:", id, "Status:", status);
              if (await showConfirm("¿Estás seguro de cambiar el estado de la subcategoría?")) {
                const data = await updateEstado(id, status);
                console.log("Estado actualizado correctamente:", data);
                if (data[0].estado > 0) {
                  showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                  // RenderDatatableSubcategorias();
                  await CargarSubcategorias();
                } else {
                  showToast(`${data[0].mensaje}`, "error", "ERROR");
                }

              } else {
                console.error("El atributo id-data o status es null o undefined.");
              }
            } catch (error) {
              console.error("Error al cambiar el estado de la subcategoría:", error);
            }
          });
        });

        const formUpdate = document.querySelector("#form-edit");
        const subcategoria = document.querySelector("#id-subcategoria");
        formUpdate.addEventListener("submit", async (e) => {
          try {
            e.preventDefault();
            const id = id_sub.getAttribute("id-sub");
            const idsubcategoria = parseInt(id);
            const inputSub = subcategoria.value;

            if (await showConfirm("¿Estás seguro de actualizar la subcategoría?")) {
              const data = await updateSubcategoria(idsubcategoria, inputSub);
              console.log("Subcategoría actualizada correctamente:", data);
              if (data[0].idsubcategoria > 0) {
                showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                // formUpdate.reset();
                // RenderDatatableSubcategorias();
                await CargarSubcategorias();
              } else {
                showToast(`${data[0].mensaje}`, "error", "ERROR");
              }
            }
          } catch (error) {
            console.error("Error al actualizar la subcategoría:", error);
          }
        });
      } else {
        // Si no hay datos, mostrar mensaje en la tabla
        TablaSubcategorias.innerHTML = '<tr><td colspan="4" class="text-center">No hay datos disponibles</td></tr>';
      }

      // Destruir la tabla si ya existe
      if (dtSubcategorias) {
        dtSubcategorias.destroy();
      }
      // Renderizar DataTable para la tabla de subcategorías
      RenderDatatableSubcategorias();

    } catch (error) {
      console.error("Error al cargar las subcategorías:", error);
    }
  }

  
  CargarSubcategorias(); // Llamar la función para cargar los datos
});