document.addEventListener("DOMContentLoaded", function() {
  function $(object = null) { return document.querySelector(object); }
  let dtSubcategorias;

  // Función para cargar las subcategorías
  async function CargarSubcategorias() {
      const TablaSubcategorias = $("#table-categorias tbody");

      try {
          // URL para obtener las subcategorías
          const response = await fetch(`../../controller/subcategoria.controller.php?operation=getAll`);
          const data = await response.json();
          console.log(data);

          // Limpiar la tabla antes de agregar nuevas filas
          TablaSubcategorias.innerHTML = '';
          if (data.length > 0) {
              data.forEach(element => {
                  TablaSubcategorias.innerHTML += `
                  <tr>
                      <td>${element.categoria}</td>  
                      <td class="text-start">${element.subcategoria}</td>
                      <td class="text-start">${element.estado}</td>
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
      dtSubcategorias = new DataTable("#table-categorias", {
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

  // Ejecutar la carga de subcategorías cuando se abre el modal
  const modalCategorias = new bootstrap.Modal(document.getElementById('list-categorias'));
  modalCategorias._element.addEventListener('shown.bs.modal', function () {
      CargarSubcategorias(); // Llamar la función para cargar los datos
  });
});
