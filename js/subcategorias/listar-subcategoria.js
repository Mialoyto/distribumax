document.addEventListener("DOMContentLoaded", function () {
  function $(object = null) { return document.querySelector(object); }

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
      const data = await obtenerSubcategoriaId(id);
      console.log("Datos para el modal:", data);
      if (data && data.length > 0) {
        const modal = $(".edit-categoria");
        const inputCategoria = modal.querySelector("input[name='categoria']");
        const inputSubcategoria = modal.querySelector("input[name='subcategoria']");

        inputCategoria.value = data[0].categoria;
        inputSubcategoria.value = data[0].subcategoria;
      } else {
        console.log("No hay datos disponibles para esta subcategoría.");
      }
    } catch (error) {
      console.error("Error al cargar los datos en el modal:", error);
    }
  }

  let dtSubcategorias;
  // Función para cargar las subcategorías
  async function CargarSubcategorias() {
    const TablaSubcategorias = $("#table-subcategorias tbody");

    try {
      // URL para obtener las subcategorías
      const response = await fetch(`../../controller/subcategoria.controller.php?operation=getAll`);
      const data = await response.json();
      console.log("Datos de todas las subcategorías:", data);

      // Limpiar la tabla antes de agregar nuevas filas
      let tableContent = "";
      if (data.length > 0) {
        data.forEach(element => {
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          tableContent += `
                <tr>
                  <td>${element.categoria}</td>  
                  <td class="text-start">${element.subcategoria}</td>
                  <td> <strong class="${estadoClass}">
                    ${element.estado}
                    </strong></td>
                  <td>
                    <div class="d-flex justify-content-center">
                      <a  id-data="${element.id}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target=".edit-categoria" >
                        <i class="bi bi-pencil-square"></i>
                      </a>     
                      <a  id-data="${element.id}" class="btn btn-danger ms-2">
                        <i class="bi bi-trash-fill"></i>
                      </a>
                          <div class="modal fade edit-categoria"
                          data-bs-backdrop="static"
                          data-bs-keyboard="false"
                          tabindex="-1"
                          aria-labelledby="staticBackdropLabel"
                          aria-hidden="true">
                            <div class="modal-dialog">
                              <div class="modal-content">
                                <div class="modal-header">
                                <h1 class="modal-title fs-5" id="staticBackdropLabel">Editar subcategoría</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                              </div>
                              <form class="edit-subcategoria" autocomplete="off">
                                <div class="modal-body">
                                  <div class="form-floating mb-3">
                                  <input type="text" name="categoria" class="form-control categoria"  disabled>
                                  <label for="categoria" class="form-label">
                                      <i class="bi bi-tag"></i>
                                      Categoría
                                  </label>
                                </div>
                                <div class="form-floating mb-3">
                                  <input type="text" name="subcategoria" class="form-control subcategoria" placeholder="Ej. Alimentos" autocomplete="off" required>
                                  <label for="categoria" class="form-label">
                                      <i class="bi bi-tag"></i>
                                      Subcategoría
                                  </label>
                                  </div>
                                </div>
                                <div class="modal-footer">
                                  <button type="submit" class="btn btn-success"><i class="bi bi-floppy"></i></button>
                                  <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal"><i class="bi bi-x-square"></i></button>
                                </div>
                              </form>
                                    </div>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </td>
                </tr>
                `;
        });
        // Agregar contenido a la tabla
        TablaSubcategorias.innerHTML = tableContent;
        const clase = document.querySelectorAll(".btn-warning");
        clase.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            const id = e.currentTarget.getAttribute("id-data");
            if (id) {
              await cargarDatosModal(id);
            } else {
              console.error("El atributo id-data es null o undefined.");
            }
          });
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

  // Función para inicializar DataTable para subcategorías
  function RenderDatatableSubcategorias() {
    dtSubcategorias = new DataTable("#table-subcategorias", {
      columnDefs: [
        { width: "25%", targets: 0 },  // Categoría
        { width: "40%", targets: 1 },  // Subcategoría
        { width: "15%", targets: 2 },  // Estado
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
  CargarSubcategorias(); // Llamar la función para cargar los datos
});