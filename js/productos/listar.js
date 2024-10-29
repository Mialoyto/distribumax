document.addEventListener("DOMContentLoaded", function() {

    document.getElementById("exportExcel").addEventListener("click", function () {
        const table = $('#table-productos').DataTable();
        const data = table.rows({ search: 'applied' }).data().toArray();
    
        // Enviar datos al servidor
        fetch('../../reports-excel/Productos/exportar_excel.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ data: data })
        })
        .then(response => response.blob())
        .then(blob => {
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.style.display = 'none';
            a.href = url;
            a.download = 'productos.xlsx';
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
        })
        .catch(error => console.error('Error al exportar a Excel:', error));
      });
  

  function $(object = null) { return document.querySelector(object); }
  let dtproductos;

  async function CargarDatos() {
      const Tablaproductos = $("#table-productos tbody");

      try {
          const response = await fetch(`../../controller/producto.controller.php?operation=getAll`);
          const data = await response.json();

          console.log(data);

          Tablaproductos.innerHTML = '';

          if (data.length > 0) {
              data.forEach(element => {
                  Tablaproductos.innerHTML += `
                  <tr>
                      <td>${element.marca}</td>
                      <td>${element.categoria}</td>
                      <td>${element.nombreproducto}</td>
                      <td>${element.codigo}</td>
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
              // Cambia el colspan a 8 porque hay 8 columnas en total
              Tablaproductos.innerHTML = '<tr><td colspan="8" class="text-center">No hay datos disponibles</td></tr>';
          }

          if (dtproductos) {
              dtproductos.destroy(); // Destruye la tabla si ya está inicializada
          }
          RenderDatatable(); // Inicializa DataTable de nuevo

      } catch (error) {
          console.error("Error al cargar los datos:", error);
      }
  }

  CargarDatos();

  // Función para inicializar DataTable
  function RenderDatatable() {
      dtproductos = new DataTable("#table-productos", {
          columnDefs: [
              { width: "10%", targets: 0 }, 
              { width: "10%", targets: 1 },
              { width: "10%", targets: 2 },
              { width: "5%", targets: 3 },
              { width: "5%", targets: 4 }
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
