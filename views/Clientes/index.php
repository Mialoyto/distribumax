<?php require_once '../../header.php';?>
<main>
    <div class="container-fluid px-4">
        <div class="mt-4">Clientes</div>
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>
        <!--Modal -->
        <div class="modal fade" id="generarReporte" tabindex="-1" aria-labelledby="generarReporte" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <input type="text" id="datos" value="Nombre del Cliente" class="form-control"
                            style="border: none; outline: none; background: transparent; font-weight: bold;" readonly>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <div class="table-responsive">
              <table id="table-pedidos" class="table" style="width: 100%;">
                <thead>
                  <tr>
                    <th>Productos</th>
                    <th>Cantidades</th>
                  </tr>
                </thead>
                <tbody>
                  <!-- Las filas se llenarán aquí -->
                </tbody>
              </table>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
          </div>
        </div>
      </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i>
            Listado de Clientes
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table id="table-clientes" class="table" style="width: 100%;">
                    <thead>
                        <tr class="text-center">
                            <th>Tipo de Cliente</th>
                            <th>Fecha de Creación</th>
                            <th>Fecha de Actualización</th>
                            <th>Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Las filas se llenarán aquí -->
                    </tbody>
                </table>
            </div>
            <div class="card-footer">
                <a href="registrar.php" class="btn btn-primary">Registrar Nuevo Cliente</a>
            </div>
        </div>
    </div>
</main>

<script src="../../js/clientes/listar.js"></script>
<script>
    // Manejar el cambio entre los campos de Persona y Empresa
    document.getElementById('tipo_cliente').addEventListener('change', function () {
        var tipoCliente = this.value;
        if (tipoCliente === 'Persona') {
            document.getElementById('personaFields').style.display = 'block';
            document.getElementById('empresaFields').style.display = 'none';
        } else if (tipoCliente === 'Empresa') {
            document.getElementById('personaFields').style.display = 'none';
            document.getElementById('empresaFields').style.display = 'block';
        }
    });

    
   
</script>

<?php
require_once '../../footer.php';
?>
</body>
</html>