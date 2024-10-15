document.addEventListener("DOMContentLoaded", function () {
  let dtcliente;

  function RenderDatatable() {
    dtcliente = new DataTable("#table-clientes", {
      scrollX: true,
      serverSide: true,
      ajax: {
        url: `../../controller/cliente.controller.php?operation=getAll`,
        dataSrc: function (data) {
          console.log(data);
          return data;
        }
      },
      columns: [
        {
          data: 'idcliente', width: "10%",className: "text-start",
          render: function (data) {
            return `<b>${data}</b>`;
          }
        },
        { data: 'tipo_cliente', width: "10%" },
        { data: 'cliente', width: "20%" },
        { data: 'fecha_creacion', width: "15%" },
        {
          data: 'estado_cliente', width: "5%",
          render: function (data) {
            return data === "1"
              ? '<b class="text-success">Activo</b>'
              : '<b class="text-danger">Inactivo</b>';
          }
        },
        {
          data: null, width: "5%",
          render: function (row) {
            return `
              <div class="mt-1 d-flex justify-content-evenly">
                <a href="#" class="btn btn-warning" data-idusuario="${row.idcliente}">
                  <i class="bi bi-pencil-fill"></i>
                </a>
                <a href="#" class="btn btn-danger" data-idusuario="${row.idcliente}">
                  <i class="bi bi-trash-fill"></i>
                </a>
              </div>
            `;
          }
        }
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

  RenderDatatable();
});
