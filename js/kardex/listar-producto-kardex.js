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
  let dataTable = table.DataTable;

  // Destruir la tabla existente si existe
  try {
    const existingTable = DataTable.isDataTable(table) ? new DataTable(table) : null;
    if (existingTable) {
      existingTable.destroy();
      table.innerHTML = ''; // Limpiar el contenido HTML
    }
  } catch (error) {
    console.error("Error al destruir la tabla:", error);
  }

  // Crear nueva instancia de DataTable
  return new DataTable(table, {
    scrollX: true,
    searching: false,
    ordering: false,
    paging: false,
    data: data,
    columns: [
      // { data: 'lote', width: "30%", className: "text-start", title: "Lote" },
      { data: 'producto', width: "20%", className: "text-start", title: "Producto" },
      { data: 'tipomovimiento', width: "15%", className: "text-start", title: "Tipo Movimiento" },
      { data: 'fechaMovimiento', width: "15%", className: "text-start", title: "Fecha" },
      { data: 'motivo', width: "20%", className: "text-start", title: "Motivo" },
      { data: 'cantidad', width: "10%", className: "text-start", title: "Cantidad" },
      { data: 'stockactual', width: "10%", className: "text-start", title: "Stock actual" },
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

