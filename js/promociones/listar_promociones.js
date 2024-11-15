document.addEventListener("DOMContentLoaded", function() {
    function $(object = null) { return document.querySelector(object); }
    let dtpromocion;

    async function CargarDatos() {
        const Tablapromociones = $("#table-promociones tbody");

        try {
            // URL para obtener las promociones con el nombre del tipo de promoción
            const response = await fetch(`../../controller/promocion.controller.php?operation=getAll`);
            const data = await response.json();
            console.log(data);

            Tablapromociones.innerHTML = '';
            if (data.length > 0) {
                data.forEach(element => {
                    Tablapromociones.innerHTML += `
                    <tr>
                        <td>${element.tipopromocion}</td>  
                        <td class="text-start">${element.descripcion}</td>
                        <td class="text-start">${element.fechainicio}</td>
                        <td class="text-start">${element.fechafin}</td>
                        <td>${element.valor_descuento}</td>
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
                // Cambia el colspan a 6 porque hay 6 columnas en total
                Tablapromociones.innerHTML = '<tr><td colspan="6" class="text-center">No hay datos disponibles</td></tr>';
            }

            // Destruir la tabla si ya existe
            if (dtpromocion) {
                dtpromocion.destroy();
            }
            RenderDatatable();

        } catch (error) {
            console.error("Error al cargar los datos:", error);
        }
    }

    CargarDatos();

    // Función para inicializar DataTable
    function RenderDatatable() {
        dtpromocion = new DataTable("#table-promociones", {
            columnDefs: [
                { width: "10%", targets: 0 },  // Tipo de promoción
                { width: "30%", targets: 1 },  // Descripción
                { width: "15%", targets: 2 },  // Fecha inicio
                { width: "15%", targets: 3 },  // Fecha fin
                { width: "15%", targets: 4 },  // Valor descuento
                { width: "15%", targets: 5 }   // Acciones
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
