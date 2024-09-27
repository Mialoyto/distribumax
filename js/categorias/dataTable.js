document.addEventListener("DOMContentLoaded", function() {
  const dtCategorias = new DataTable("#tabla-categorias", {
    ajax: {
      url: '../Categorias/listarcategoria.php', // Archivo PHP que devuelve los datos en formato JSON
      dataSrc: 'data' // Indica que los datos se encuentran en el campo 'data' del JSON
    },
    language: {
      url: "../../js/Spanish.json" // URL corregida del archivo de idioma
    },
    scrollX: false,
    columns: [
      { data: 'categoria' },
      { data: 'create_at' },
      { data: 'estado' }
    ],
    columnDefs: [
      { width: "40%", targets: 0 },
      { width: "30%", targets: 1 },
      { width: "30%", targets: 2 }
    ],
    pageLength: 3 // Mostrará 3 registros por página
  });
});