// Objetivo: Listar los productos en el kardex usando JavaScript puro
async function getMovimientoProducto(idproducto) {
  const params = new URLSearchParams();
  params.append("operation", "getMovimientoProducto");
  params.append("idproducto", idproducto);

  try {
    const response = await fetch(`../../controller/kardex.controller.php?${params}`);
    const data = await response.json();
    console.log(data);
    return data;
  } catch (error) {
    console.error("Error al obtener los movimientos del producto", error);
  }
}

async function RenderDatatable(data) {
  const table = document.querySelector("#table-productos");
  
  // Verificar si ya existe una instancia de DataTable y destruirla
  if (DataTable.isDataTable(table)) {
    DataTable.getInstance(table).destroy();
  }

  // Crear nueva instancia de DataTable
  new DataTable(table, {
    scrollX: true,
    searching: false,
    ordering: false,
    paging: false,
    data: data,
    columns: [
      { data: 'lote', width: "15%", className: "text-start", title: "Producto" },
      { data: 'producto', width: "15%", className: "text-start", title: "Fecha Vencimiento" },
      { data: 'tipomovimiento', width: "20%", className: "text-start", title: "Lote" },
      { data: 'motivo', width: "30%", className: "text-start", title: "Cantidad" },
      { data: 'cantidad', width: "10%", className: "text-start", title: "Tipo Movimiento" },
      { data: 'stockactual', width: "10%", className: "text-start", title: "Motivo" },
    ],
    language: {
      emptyTable: "No hay datos disponibles en la tabla",
      info: "",
      infoFiltered: "(filtrado de _MAX_ entradas en total)",
      lengthMenu: "Filtrar: _MENU_",
      loadingRecords: "Cargando...",
      processing: "Procesando...",
      search: "Buscar:",
      zeroRecords: "No se encontraron resultados",
      aria: {
        sortAscending: ": Activar para ordenar la columna de manera ascendente",
        sortDescending: ": Activar para ordenar la columna de manera descendente"
      }
    }
  });
}

// Ejemplo de uso:
// const idproducto = 1;
// getMovimientoProducto(idproducto)
//   .then(data => RenderDatatable(data));