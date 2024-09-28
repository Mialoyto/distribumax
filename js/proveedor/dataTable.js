document.addEventListener("DOMContentLoaded", function() {
  const dtProveedores = new DataTable("#tabla-proveedores", {
    ajax: {
      url: '../Proveedores/listarproveedor.php', // Archivo PHP que devuelve los datos en formato JSON
      dataSrc: 'data' // Indica que los datos se encuentran en el campo 'data' del JSON
    },
    language: {
      url: "../../js/Spanish.json" // URL corregida del archivo de idioma
    },
    scrollX: false,
    columns: [
      { data: 'idempresa' },
      { data: 'proveedor' },
      { data: 'contacto_principal' },
      { data: 'telefono_contacto' },
      { data: 'email' },
      { data: 'direccion' }
    ],
    columnDefs: [
      { width: "15%", targets: 0 },
      { width: "15%", targets: 1 },
      { width: "15%", targets: 2 },
      { width: "15%", targets: 3 },
      { width: "15%", targets: 4 },
      { width: "15%", targets: 5 }
    ],
    pageLength: 3 // Mostrará 3 registros por página
  });
});