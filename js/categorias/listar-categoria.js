document.addEventListener("DOMContentLoaded", function () {
  function $(object = "") {
    return document.querySelector(object);
  }
  let dtcategoria;

  async function CargarDatos() {
    const Tablacategorias = $("#table-categorias tbody");

    try {
      const response = await fetch(
        `../../controller/categoria.controller.php?operation=getAll`
      );

      if (!response.ok) throw new Error("Error en la respuesta del servidor");

      const data = await response.json();
      console.log(data);

      // Construir el contenido de la tabla
      let tableContent = "";
      data.forEach((element) => {
        const estadoClass =
          element.Estado === "Activo" ? "text-success" : "text-danger";
        tableContent += `
                <tr>
                    <td>${element.categoria}</td> 
                    <td>
                    <strong class="${estadoClass}">
                    ${element.Estado}
                    </strong>
                    </td>
                    <td>
                    <div class="d-flex justify-content-center">
                        <a href="#" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#edit-categoria ">
                            <i class="bi bi-pencil-fill"></i>
                        </a>     
                        <a href="#" class="btn btn-danger ms-2">
                            <i class="bi bi-trash-fill"></i>
                        </a>

                          <div class="modal fade" id="edit-categoria"
                            data-bs-backdrop="static"
                            data-bs-keyboard="false"
                            tabindex="-1"
                            aria-labelledby="staticBackdropLabel"
                            aria-hidden="true">
                            <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                <h1 class="modal-title fs-5" id="staticBackdropLabel">EDITAR CATEGORIA</h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form method="" action="#" id="form-editcategoria" autocomplete="off">
                                <div class="modal-body">
                                    <div class="form-floating mb-3">
                                    <input type="text" name="edit-categoria" class="form-control edit-categoria" placeholder="Ej. Alimentos" autocomplete="off" required>
                                    <label for="categoria" class="form-label">
                                        <i class="bi bi-tag"></i>
                                        Categoría
                                    </label>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="submit" id="btn-add-lote" class="btn btn-success">Registrar</button>
                                    <button type="reset" class="btn btn-outline-danger" data-bs-dismiss="modal">Cerrar</button>
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

      Tablacategorias.innerHTML = tableContent;

      if (dtcategoria) {
        dtcategoria.destroy();
      }
      RenderDatatable();
    } catch (error) {
      console.error("Hubo un error al cargar los datos:", error);
      Tablacategorias.innerHTML = `<tr><td colspan="4" class="text-center">Error al cargar los datos</td></tr>`;
    }
  }

  CargarDatos();

  function RenderDatatable() {
    dtcategoria = new DataTable("#table-categorias", {
      columnDefs: [
        { width: "33.33%", targets: 0 }, // Nombre de la categoría
        { width: "33.33%", targets: 1 }, // Fecha de creación
        { width: "33.33%", targets: 2 }, // Estado  // Acciones
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
