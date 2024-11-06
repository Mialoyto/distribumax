document.addEventListener("DOMContentLoaded", function () {

  document.getElementById("exportExcel").addEventListener("click", function () {
    const table = $('#table-clientes').DataTable();
    const data = table.rows({ search: 'applied' }).data().toArray();

    // Enviar datos al servidor
    fetch('../../reports-excel/Clientes/exportar_excel.php', {
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
        a.download = 'clientes.xlsx';
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
      })
      .catch(error => console.error('Error al exportar a Excel:', error));
  });



  // funcion para deshabilitar un cliente
  async function deshabilitarCliente(estado, idCliente) {

    if (await showConfirm("¿Estas seguro de deshabilitar el cliente?", "CLIENTE")) {
      try {
        const params = new FormData();
        params.append("operation", "activeCliente");
        params.append("estado", estado);
        params.append("idcliente", idCliente);

        const options = {
          method: "POST",
          body: params
        }
        const response = await fetch(`../../controller/cliente.controller.php`, options);
        const data = await response.json();
        console.log(data);
        if (data.row) {
          showToast("Cliente eliminado", 'success', 'SUCCESS');

          const table = $('#table-clientes').DataTable();
          table.rows(function (idx, data, node) {
            return data.idcliente == idCliente;
          }).remove().draw(false);
        } else {
          showToast("Error al deshabilitar cliente", 'error', 'ERROR');
        }
      } catch (error) {
        console.error("Error al deshabilitar el cliente :", error);
      }
    }
  }


  function RenderDatatable() {
    const dtcliente = new DataTable("#table-clientes", {
      scrollX: true,
      processing: true,
      serverSide: true,
      // lengthMenu: [10, 15, 20, 100, 200, 500],
      ajax: {
        url: `../../controller/cliente.controller.php?operation=getAll`,
        type: "GET",
        data: function (d) {
          // d contiene los datos que DataTables está enviando
          console.log(d);  // Ver qué parámetros están siendo enviados

          // Enviar los parámetros de paginación, búsqueda y orden
          return {
            start: d.start,      // Paginación: inicio de los registros
            length: d.length,    // Paginación: número de registros por página
            search: d.search.value,   // Término de búsqueda
            orderColumn: d.order[0].column,  // Índice de la columna por la que ordenar
            orderDir: d.order[0].dir      // Dirección de la ordenación (ASC o DESC)
          };
        },
        dataSrc: function (json) {
          console.log(json);
          return json;
        }
      },
      columns: [
        {
          data: 'nro_doc', width: "10%", className: "text-start",
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
                <button href="#" class="btn btn-warning" data-idusuario="${row.idcliente}" data-bs-toggle="modal" data-bs-target="#updatecustome">
                  <i class="bi bi-pencil-fill"></i>
                </button>
                <button href="#" class="btn btn-danger" data-idusuario="${row.idcliente}" value="0">
                  <i class="bi bi-trash-fill"></i>
                </button>
              </div>

                <div class="modal fade" id="updatecustome" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Modal title</h1>
                      <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <div class="modal-body">
                      ...
                      </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                      <button type="button" class="btn btn-primary">Understood</button>
                    </div>
                </div>
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
          "sFirst": "<<",
          "sLast": ">>",
          "sNext": ">",
          "sPrevious": "<"
        },
        "oAria": {
          "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
          "sSortDescending": ": Activar para ordenar la columna de manera descendente"
        }
      }
    });
    // Agregar el evento click a los botones de deshabilitar después de que se dibuje la tabla
    dtcliente.on('draw', function () {
      const deshabilitarButtons = document.querySelectorAll('.btn-danger');
      deshabilitarButtons.forEach(button => {
        button.addEventListener('click', async function (e) {
          e.preventDefault();
          const idCliente = this.getAttribute("data-idusuario");
          const estado = this.getAttribute("value");
          await deshabilitarCliente(estado, idCliente);

        });
      });
    });


  }
  RenderDatatable();

});
