document.addEventListener("DOMContentLoaded", function() {
    function $(object = null) { return document.querySelector(object); }
    let dtpersonas;
  
    async function CargarDatos() {
        const Tablapersonas = $("#table-personas tbody");
  
        try {
            const response = await fetch(`../../controller/persona.controller.php?operation=getAll`);
            const data = await response.json();
  
            console.log(data);
  
            Tablapersonas.innerHTML = '';
  
            if (data.length > 0) {
                data.forEach(element => {
                    Tablapersonas.innerHTML += `
                    <tr>
                        <td>${element.tipo_documento}</td>
                        <td>${element.nro_documento}</td>
                        <td>${element.nombres}</td>
                        <td>${element.appaterno}</td>
                        <td>${element.apmaterno}</td>
                        <td>${element.distrito}</td>
                        <td>${element.estado === "1" ? "Activo" : "Inactivo"}</td>
                    </tr>
                    `;
                });
            } else {
                Tablapersonas.innerHTML = '<tr><td colspan="7" class="text-center">No hay datos disponibles</td></tr>';
            }
  
            if (dtpersonas) {
                dtpersonas.destroy();
            }
            RenderDatatable();
  
        } catch (error) {
            console.error("Error al cargar los datos:", error);
        }
    }
  
    CargarDatos();
  
    // Función para inicializar DataTable
    function RenderDatatable() {
      dtpersonas = new DataTable("#table-personas", {
          columnDefs: [
              { width: "15%", targets: 0 },  // Tipo de documento
              { width: "15%", targets: 1 },  // Número de documento
              { width: "15%", targets: 2 },  // Nombres
              { width: "15%", targets: 3 },  // Apellido paterno
              { width: "15%", targets: 4 },  // Apellido materno
              { width: "15%", targets: 5 },  // Distrito
              { width: "10%", targets: 6 }   // Estado
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
  