document.addEventListener("DOMContentLoaded", function() {
    function $(object = "") { return document.querySelector(object); }
    let dtcategoria;
  
    async function CargarDatos() {
        const Tablacategorias = $("#table-categorias tbody");
  
        try {
            const response = await fetch(`../../controller/categoria.controller.php?operation=getAll`);
            
            if (!response.ok) throw new Error('Error en la respuesta del servidor');
            
            const data = await response.json();
            console.log(data);
  
            // Construir el contenido de la tabla
            let tableContent = '';
            data.forEach(element => {
                tableContent += `
                <tr>
                    <td>${element.categoria}</td> 
                    <td class="text-start">${element.create_at}</td>
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
  
            Tablacategorias.innerHTML = tableContent;
  
            if (dtcategoria) {
                dtcategoria.destroy();
            }
            RenderDatatable();
            
        } catch (error) {
            console.error('Hubo un error al cargar los datos:', error);
            Tablacategorias.innerHTML = `<tr><td colspan="4" class="text-center">Error al cargar los datos</td></tr>`;
        }
    }
  
    CargarDatos();
  
    function RenderDatatable() {
        dtcategoria = new DataTable("#table-categorias", {
            columnDefs: [
                { width: "30%", targets: 0 },  // Nombre de la categoría
                { width: "30%", targets: 1 },  // Fecha de creación
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
  