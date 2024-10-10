document.addEventListener("DOMContentLoaded", function() {
  function $(object = null) { return document.querySelector(object); }
  let dtempresas;

  async function CargarDatosEmpresas() {
      const TablaEmpresas = $("#table-empresas tbody");

      const response = await fetch(`../../controller/empresa.controller.php?operation=getAll`);
      const data = await response.json();
      console.log(data);

      TablaEmpresas.innerHTML = '';
      data.forEach(element => {
          TablaEmpresas.innerHTML += `
          <tr>
              <td>${element.razonsocial}</td>
              <td class="text-start">${element.direccion}</td>
              <td>${element.email}</td>
              <td>${element.telefono}</td>
          </tr>
          `;
      });

      // Destroy the existing DataTable if it exists
      if (dtempresas) {
          dtempresas.destroy();
      }
      RenderDatatableEmpresas();
  }

  CargarDatosEmpresas();

  // Función para inicializar DataTable
  function RenderDatatableEmpresas() {
    dtempresas = new DataTable("#table-empresas", {
        columnDefs: [
            { width: "25%", targets: 0 }, 
            { width: "25%", targets: 1 }, 
            { width: "25%", targets: 2 },
            { width: "25%", targets: 3 }
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
