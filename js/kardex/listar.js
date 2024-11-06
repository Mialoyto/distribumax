document.addEventListener("DOMContentLoaded", function () {
    function $(object = null) { return document.querySelector(object); }
    let dtkardex;

    async function CargarDatos() {
        const Tablakardex = $("#table-kardex tbody");

        try {
            const response = await fetch(`../../controller/kardex.controller.php?operation=getAll`);
            const data = await response.json();

            console.log(data);

            // Filtrar para obtener solo el último movimiento por producto
            const ultimoMovimiento = obtenerUltimosMovimientos(data);

            Tablakardex.innerHTML = '';

            if (ultimoMovimiento.length > 0) {
                ultimoMovimiento.forEach(element => {
                    Tablakardex.innerHTML += `
                    <tr>
                        <td>${element.nombreproducto}</td>
                        <td>${element.fecha_vencimiento}</td>
                        <td>${element.numlote}</td>
                        <td>${element.stockactual}</td>
                        <td>${element.tipomovimiento}</td>
                        <td>${element.cantidad}</td>
                        <td>${element.motivo}</td>
                        <td class="badge text-bg-success align-self-center">${element.estado}</td>
                    </tr>
                    `;
                });
            } else {
                Tablakardex.innerHTML = '<tr><td colspan="7" class="text-center">No hay datos disponibles</td></tr>';
            }

            if (dtkardex) {
                dtkardex.destroy();
            }
            RenderDatatable();

        } catch (error) {
            console.error("Error al cargar los datos:", error);
        }
    }

    // Función para obtener el último movimiento de cada producto
    function obtenerUltimosMovimientos(data) {
        // Objeto para almacenar el último movimiento de cada producto
        const productos = {};

        // Iterar sobre los datos y mantener solo el último movimiento por producto
        data.forEach(element => {
            const productoId = element.nombreproducto; // O usa un identificador único si lo tienes
            if (!productos[productoId] || new Date(element.fecha_vencimiento) > new Date(productos[productoId].fecha_vencimiento)) {
                productos[productoId] = element;
            }
        });

        // Convertir el objeto a un array de los últimos movimientos
        return Object.values(productos);
    }

    CargarDatos();

    // Función para inicializar DataTable
    function RenderDatatable() {
        dtkardex = new DataTable("#table-kardex", {
            columnDefs: [
                { width: "15%", targets: 0 },
                { width: "5%", targets: 1 },
                { width: "5%", targets: 2 },
                { width: "5%", targets: 3 },
                { width: "5%", targets: 4 },
                { width: "5%", targets: 5 },
                { width: "15%", targets: 6 },
                { width: "5%", targets: 7 }
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
