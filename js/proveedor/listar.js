document.addEventListener("DOMContentLoaded", function() {
  function $(object = null) { return document.querySelector(object); }
  let dtproovedor;

  async function CargarDatos() {
    const Tablaproovedores = $("#table-proveedores tbody");

    try {
        const response = await fetch(`../../controller/proveedor.controller.php?operation=getAll`);
        const data = await response.json();

        console.log(data);

        Tablaproovedores.innerHTML = '';
        if (data.length > 0) {
          data.forEach(element => {
              Tablaproovedores.innerHTML += `
              <tr>
                  <td>${element.idempresaruc}</td>
                  <td>${element.proveedor}</td>
                  <td>${element.contacto_principal}</td>
                  <td>${element.telefono_contacto}</td>
                  <td>${element.email}</td>
                  <td>${element.direccion}</td>
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
          Tablaproovedores.innerHTML = '<tr><td colspan="8" class="text-center">No hay datos disponibles</td></tr>';
      }

      if (dtproovedor) {
          dtproovedor.destroy(); // Destruye la tabla si ya está inicializada
      }
      RenderDatatable(); // Inicializa DataTable de nuevo

  } catch (error) {
      console.error("Error al cargar los datos:", error);
  }
}

CargarDatos();

// Función para inicializar DataTable
function RenderDatatable() {
  dtproovedor = new DataTable("#table-proveedores", {
      columnDefs: [
          { width: "10%", targets: 0 }, 
          { width: "10%", targets: 1 },
          { width: "10%", targets: 2 },
          { width: "20%", targets: 3 }, 
          { width: "10%", targets: 4 },
          { width: "20%", targets: 5 },
          { width: "20%", targets: 6 }
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
