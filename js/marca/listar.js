document.addEventListener("DOMContentLoaded", () => {
    // Inicializar tooltips en los elementos
    initializeTooltips();

    function $(object = null) {
        return document.querySelector(object);
    }

    let dtmarca;

    // Función para renderizar la tabla Datatable
    function RenderDatatableMarcas() {
        if (dtmarca) {
            dtmarca.destroy(); // Destruir si ya existe
        }

        // Inicializar el Datatable
        dtmarca = new DataTable("#table-marcas", {
            columnDefs: [
                { width: "25%", targets: 0 },
                { width: "25%", targets: 1 }
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

    // Función para cargar las marcas desde el servidor
    async function CargarMarcas() {
        if (dtmarca) {
            dtmarca.destroy(); // Destruir datatable si ya existe
            dtmarca = null;
        }

        const TablaMarcas = $("#table-marcas tbody");
        let tableContent = "";

        try {
            const response = await fetch(`../../controller/marca.controller.php?operation=getAll`);
            const data = await response.json();

            if (data.length > 0) {
                data.forEach((element) => {
                    // Asignar clases dependiendo del estado
                    const estadoClass = element.estado_marca === "Activo" ? "text-success" : "text-danger";
                    const icons = element.estado_marca === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
                    const bgbtn = element.estado_marca === "Activo" ? "btn-success" : "btn-danger";
                    
                    tableContent += `
                        <tr>
                            <td>${element.marca}</td>
                            <td>
                    <strong class="${estadoClass}">
                    ${element.estado_marca}
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

                TablaMarcas.innerHTML = tableContent;
            }

            RenderDatatableMarcas();
        } catch (error) {
            console.error("Error al cargar las marcas:", error);
        }
    }

    CargarMarcas();
});
