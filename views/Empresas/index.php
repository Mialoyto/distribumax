<?php require_once '../../header.php'; ?>

<div class="container">
  <div class="card mt-4">
    <div class="card-body">
      <div class="table-responsive">
        <!-- DataTable requiere de manera obligatoria thead y tbody -->
        <table
          class="table"
          id="tabla-empresas"
          style="width: 100%;">
          <thead>
            <tr>
              <th>Razón Social</th>
              <th>Dirección</th>
              <th>Email</th>
              <th>Teléfono</th>
            </tr>
          </thead>
          <tbody>
            <!-- Aquí DataTables agregará las filas dinámicamente -->
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div><!-- Fin del container -->

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- Bootstrap 5 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<!-- DataTables Core -->
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<!-- DataTables Bootstrap 5 -->
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<!-- Configuración de DataTable -->
<script>
  document.addEventListener("DOMContentLoaded", function() {
    const dtEmpresas = new DataTable("#tabla-empresas", {
      ajax: {
        url: '../Empresas/listarempresa.php', // Archivo PHP que devuelve los datos en formato JSON
        dataSrc: 'data' // Indica que los datos se encuentran en el campo 'data' del JSON
      },
      language: {
        url: "https://cdn.datatables.net/plug-ins/1.13.6/i18n/Spanish.json" // URL corregida del archivo de idioma
      },
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
</script>

<!-- Archivo JS adicional para las funcionalidades de actualizar -->
<script src="../../js/empresas/listar-actualizar.js"></script>

<?php require_once '../../footer.php'; ?>
