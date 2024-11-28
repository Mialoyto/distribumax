document.addEventListener("DOMContentLoaded", function () {
    function $(object = null) { return document.querySelector(object); }
    let dtusuarios;

    async function CargarDatos() {
        const Tablausuarios = $("#table-usuarios tbody");

        try {
            const response = await fetch(`../../controller/usuario.controller.php?operation=getAll`);
            const data = await response.json();

            console.log(data);

            Tablausuarios.innerHTML = '';

            if (data.length > 0) {
                data.forEach(element => {
                    Tablausuarios.innerHTML += `
                  <tr>
                      <td>${element.idpersonanrodoc}</td>
                      <td>${element.perfil}</td>
                      <td>${element.nombre_usuario}</td>
                      <td>${element.Estado}</td>
                      <td>
                      <a href="#" class="btn btn-warning">
                      <i class="bi bi-pencil-fill"></i>
                      </a>
                      <a href="#" class="btn btn-danger">
                      <i class="bi bi-trash-fill"></i>
                      </a>
                      </td>
                  </tr>
                  `;
                });
            } else {
                Tablausuarios.innerHTML = '<tr><td colspan="7" class="text-center">No hay datos disponibles</td></tr>';
            }

            if (dtusuarios) {
                dtusuarios.destroy();
            }
            RenderDatatable();

        } catch (error) {
            console.error("Error al cargar los datos:", error);
        }
    }

    CargarDatos();

    // Función para inicializar DataTable
    function RenderDatatable() {
        dtusuarios = new DataTable("#table-usuarios", {
            columnDefs: [
                { width: "20%", targets: 0 },
                { width: "20%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "20%", targets: 3 },
                { width: "20%", targets: 4 }
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
                "oPaginate": {
                    "sFirst": "Primero",
                    "sLast": "Último",
                    "sNext": "Siguiente",
                    "sPrevious": "Anterior"
                },
                "oAria": {
                    "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                }
            }
        });
    }
});
