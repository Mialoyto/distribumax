document.addEventListener("DOMContentLoaded", function () {
  let id = document.querySelector("#searchProducto");
  

  async function getMovimientoProducto(idproducto) {
    const params = new URLSearchParams();
    params.append("operation", "getMovimientoProducto");
    params.append("idproducto", idproducto);

    try {
      const response = await fetch(`../../controller/kardex.controller.php?${params}`);
      const data = await response.json();
      console.log(data.data);
      return data.data; // Retorna solo el array de datos
    } catch (error) {
      console.error("Error al obtener los movimientos del producto", error);
    }
  }

  id.addEventListener("click", async function () {
    const idproducto = this.getAttribute('producto');
    const data = await getMovimientoProducto(idproducto);
    console.log(data)
    if (data) {
      RenderDatatable(data);
    }
  });

  function RenderDatatable(data) {
    // Verificar si ya existe una instancia de DataTable y destruirla si es necesario
    if ($.fn.DataTable.isDataTable("#table-productos")) {
      $('#table-productos').DataTable().clear().destroy();
    }

    $('#table-productos').DataTable({
      scrollX: true,
      processing: true,
      serverSide: false,
      data: data, // Pasar los datos obtenidos directamente
      columns: [
        { data: 'nombreproducto', width: "30%", className: "text-start" , title: "Producto"},
        { data: 'fecha_vencimiento', width: "10%",className: "text-start", title: "Fecha Vencimiento" },
        { data: 'numlote', width: "10%", title: "Lote" ,className: "text-start",className: "text-start"},
        { data: 'cantidad', width: "5%", title: "Cantidad",className: "text-start" },
        { data: 'tipomovimiento', width: "10%", title: "Tipo Movimiento",className: "text-start" },
        { data: 'motivo', width: "25%", title: "Motivo" ,className: "text-start"},
        { data: 'stockactual', width: "10%", title: "Stock Actual",className: "text-start" }
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
