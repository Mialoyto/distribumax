document.addEventListener("DOMContentLoaded", function() {
    function $(object = null) { return document.querySelector(object); }
    let dtcliente;
  
    async function CargarDatos() {
        const Tablaclientes = $("#table-clientes tbody");
  
        const response = await fetch(`../../controller/cliente.controller.php?operation=getAll`);
        const data = await response.json();
        console.log(data);
  
        Tablaclientes.innerHTML = '';
        data.forEach(element => {
            const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : `${element.nombre} ${element.apellido}`;
            const documento = element.tipo_cliente === 'Empresa' ? element.idempresaruc : element.idpersonanrodoc;
  
            Tablaclientes.innerHTML += `
            <tr>
                <td>${element.tipo_cliente}</td>
                <td class="text-start">${element.fecha_creacion}</td>
                <td class="text-start">${element.fecha_actualizacion}</td>
                <td>${element.estado === "1" ? "Activo" : "Inactivo"}</td>
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
  
        if (dtcliente) {
            dtcliente.destroy();
        }
        RenderDatatable();
    }
  
    CargarDatos();
  
    function RenderDatatable() {
        dtcliente = new DataTable("#table-clientes", {
            columnDefs: [
                { width: "25%", targets: 0 }, 
                { width: "15%", targets: 1 }, 
                { width: "15%", targets: 2 },
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
});
