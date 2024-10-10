<?php require_once '../../header.php'; ?>

<main>
  <div class="card mb-4">
    <div class="card-header">
      <i class="fas fa-table me-1"></i>
      Listado de Usuarios
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table id="table-usuarios" class="table" style="width: 100%;">
          <thead>
            <tr class="text-center">
              <th>Nro. Documento</th>
              <th>Nombre Rol</th>
              <th>Nombre Usuario</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <!--Las filas se llenaràn aquì-->
          </tbody>
        </table>
      </div>
    </div>
    <div class="card-footer">
      <a href="registrar.php" class="btn btn-primary">Registrar Usuario</a>
    </div>
  </div>
</main>
<script src="../../js/usuarios/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>
