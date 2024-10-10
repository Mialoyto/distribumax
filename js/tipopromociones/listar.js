document.addEventListener("DOMContentLoaded", function() {
  function $(object = null) { return document.querySelector(object); }
  let dttipopromocion;

  async function CargarDatos() {
      const Tablapromociones = $("#table-tipopromociones tbody");

      // URL para obtener los tipos de promociones
      const response = await fetch(`../../controller/tipopromociones.controller.php?operation=getAll`);
      const data = await response.json();
      console.log(data);

      Tablapromociones.innerHTML = '';
      data.forEach(element => {
          Tablapromociones.innerHTML += `
          <tr>
              <td>${element.tipopromocion}</td>  <!-- Nombre del tipo de promoción -->
              <td class="text-start">${element.descripcion}</td>  <!-- Descripción del tipo de promoción -->
              <td class="text-start">${element.create_at}</td>  <!-- Fecha de creación -->
              <td class="text-start">${element.update_at || 'Sin actualizar'}</td>  <!-- Fecha de actualización, si la hay -->
              <td>${element.estado === "1" ? "Activo" : "Inactivo"}</td>  <!-- Estado -->
          </tr>
          `;
      });

      // Destruir la tabla si ya existe
      if (dttipopromocion) {
          dttipopromocion.destroy();
      }
      RenderDatatable();
  }

  CargarDatos();

  // Función para inicializar DataTable
  function RenderDatatable() {
      dttipopromocion = new DataTable("#table-tipopromociones", {
          columnDefs: [
              { width: "20%", targets: 0 },  // Tipo de promoción
              { width: "30%", targets: 1 },  // Descripción
              { width: "15%", targets: 2 },  // Fecha de creación
              { width: "15%", targets: 3 },  // Fecha de actualización
              { width: "20%", targets: 4 }   // Estado
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
