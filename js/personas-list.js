
new DataTable('#list-personas', {

  "language": {
    "lengthMenu": "Mostrar _MENU_ registros por página",
    "zeroRecords": "No se encontraron resultados",
    "info": "Mostrando la página _PAGE_ de _PAGES_",
    "infoEmpty": "No hay registros disponibles",
    "infoFiltered": "(filtrado de _MAX_ registros totales)",
    "search": "Buscar:",
    "paginate": {
      "first": "Primero",
      "last": "Último",
      "next": "Siguiente",
      "previous": "Anterior"
    }
  },
  layout: {
    bottomEnd: {
      paging: {
        firstLast: false
      }
    }
  },
  ajax: 'scripts/server_processing.php',
  processing: true,
  serverSide: true
});
