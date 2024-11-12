<?php require_once '../../header.php'; ?>

<main>
  <div class="card mb-4">
    <div class="card-header">
      <i class="fas fa-table me-1"></i>
      Listado de Kardex
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table id="table-kardex" class="table" style="width: 100%;">
          <thead>
            <tr class="text-center">
              <th>Nombre Producto</th>
              <th>Fecha Vencimiento</th>
              <th>Num. Lote</th>
              <th>Stock Actual</th>
              <th>Tipo Movimiento</th>
              <th>Cantidad</th>
              <th>Motivo</th>
              <th>Estado</th>
            </tr>
          </thead>
          <tbody>
            <!--Las filas se llenaràn aquì-->
          </tbody>
        </table>
      </div>
    </div>
    <div class="card-footer">
      <a href="registrar.php" class="btn btn-primary">Registrar nueva movimiento</a>
    </div>
  </div>
</main>
<script src="../../js/kardex/listar.js"></script>
<?php require_once '../../footer.php'; ?>
</body>
</html>
