<?php
require_once '../../header.php';
?>

<div class="container mt-5">
    <!-- Botón que activa el modal -->
    <div class="d-flex justify-content-end mb-4">
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registroClienteModal">
            <i class="fa fa-plus me-2"></i> Registrar Cliente
        </button>
    </div>

    <!-- Tabla de clientes registrados -->
    <h3 class="text-center mb-4">Clientes Registrados</h3>
    <div class="table-responsive">
        <table class="table table-striped table-hover align-middle table-bordered shadow-sm">
            <thead class="table-dark text-center">
                <tr>
                    <th>Nombre Empresa</th>
                    <th>Tipo Cliente</th>
                    <th>Fecha de Creación</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <td>Dijisa</td>
                <td>Empresa</td>
                <td>2024-05-23</td>
                <td>Activo</td>
                <?php
                        // echo "<tr class='text-center'>";
                        // echo "<td>" . $row["nombre_empresa"] . "</td>";
                        // echo "<td>" . $row["tipo_cliente"] . "</td>";
                        // echo "<td>" . $row["fecha_creacion"] . "</td>";
                        // echo "<td>" . $row["estado"] . "</td>";
                        // echo "</tr>";
                ?>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<div class="modal fade" id="registroClienteModal" tabindex="-1" aria-labelledby="registroClienteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="registroClienteModalLabel">Registro de Cliente</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form method="POST" action="registrar_cliente.php" id="form-registrar-cliente">
                    <h5 class="mb-4"><i class="fas fa-user"></i> Tipo de Cliente</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="tipo_cliente" class="form-label">Tipo de Cliente</label>
                            <select class="form-control" id="tipo_cliente" name="tipo_cliente" required>
                                <option value="Persona">Persona</option>
                                <option value="Empresa">Empresa</option>
                            </select>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end">
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="fa fa-check me-2"></i> Registrar
                        </button>
                        <button type="reset" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-2"></i> Cancelar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="<?=$host?>/js/documento.js"></script>
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