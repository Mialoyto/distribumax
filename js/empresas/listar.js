document.addEventListener("DOMContentLoaded", function() {
    function $(object = null) { return document.querySelector(object); }
    let dtempresas;

    async function CargarDatosEmpresas() {
        const TablaEmpresas = $("#table-empresas tbody");

        try {
            const response = await fetch(`../../controller/empresa.controller.php?operation=getAll`);
            if (!response.ok) {
                throw new Error('Error en la respuesta de la API');
            }
            const data = await response.json();

            // Verificar que el dato contenga una lista
            if (!Array.isArray(data)) {
                throw new Error('Los datos no son un arreglo');
            }

            TablaEmpresas.innerHTML = ''; // Limpiar tabla
            data.forEach(element => {
                const row = document.createElement('tr');

                row.innerHTML = `
                    <td>${element.razonsocial || 'N/A'}</td>
                    <td class="text-start">${element.direccion || 'N/A'}</td>
                    <td>${element.email || 'N/A'}</td>
                    <td>${element.telefono || 'N/A'}</td>
                    <td>
                        <a href="#" class="btn btn-warning" onclick="editEmpresa(${element.id})" aria-label="Editar empresa">
                            <i class="bi bi-pencil-fill"></i>
                        </a>
                        <a href="#" class="btn btn-danger" onclick="deleteEmpresa(${element.id})" aria-label="Eliminar empresa">
                            <i class="bi bi-trash-fill"></i>
                        </a>
                    </td>
                `;
                TablaEmpresas.appendChild(row);
            });

            // Destruir el DataTable existente si existe
            if (dtempresas) {
                dtempresas.destroy();
            }
            RenderDatatableEmpresas();
        } catch (error) {
            console.error('Error al cargar los datos de las empresas:', error);
            // alert('Ocurrió un error al cargar los datos de las empresas.'); // Mensaje de error al usuario
        }
    }

    function RenderDatatableEmpresas() {
        dtempresas = new DataTable("#table-empresas", {
            columnDefs: [
                { width: "15%", targets: 0 }, 
                { width: "15%", targets: 1 }, 
                { width: "25%", targets: 2 },
                { width: "25%", targets: 3 },
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

    CargarDatosEmpresas();
});

// Funciones para editar y eliminar (puedes implementar la lógica según tus necesidades)
function editEmpresa(id) {
    // Lógica para editar la empresa con el id proporcionado
    console.log('Editando empresa con ID:', id);
}

function deleteEmpresa(id) {
    // Lógica para eliminar la empresa con el id proporcionado
    console.log('Eliminando empresa con ID:', id);
}
