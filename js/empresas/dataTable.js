document.addEventListener("DOMContentLoaded", function() {
  const dtEmpresas = new DataTable("#tabla-empresas", {
    ajax: {
      url: '../Empresas/listarempresa.php', // Archivo PHP que devuelve los datos en formato JSON
      dataSrc: 'data' // Indica que los datos se encuentran en el campo 'data' del JSON
    },
    language: {
      url: "../../js/Spanish.json" // URL corregida del archivo de idioma
    },
    scrollX: false,
    columns: [
      { data: 'razonsocial' },
      { data: 'direccion' },
      { data: 'email' },
      { data: 'telefono' }
    ],
    columnDefs: [
      { width: "30%", targets: 0 },
      { width: "30%", targets: 1 },
      { width: "20%", targets: 2 },
      { width: "20%", targets: 3 }
    ],
    pageLength: 3 // Mostrará 3 registros por página
  });
});