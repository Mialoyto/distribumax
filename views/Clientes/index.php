<?php
require_once '../../header.php';
?>
<div class="container mt-5">
    <div class="card shadow-lg border-0 rounded-lg">
        <div class="card-header">
            <h3 class="text-center">Registro de Clientes</h3>
        </div>
        <div class="card-body">
            <!-- Formulario de Registro -->
            <form method="POST" action="registrar_cliente.php" id="clienteForm">
                <!-- Sección de Selección de Tipo de Cliente -->
                <h5 class="mb-4">
                    <i class="fas fa-user"></i> Tipo de Cliente
                </h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="tipo_cliente" class="form-label">Tipo de Cliente</label>
                        <select class="form-control" id="tipo_cliente" name="tipo_cliente" required>
                            <option value="Persona">Persona</option>
                            <option value="Empresa">Empresa</option>
                        </select>
                    </div>
                </div>

                <!-- Sección de Información de Persona -->
                <div id="personaFields">
                    <h5 class="mb-4">
                        <i class="fas fa-id-card"></i> Información Personal
                    </h5>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="idtipodocumento" class="form-label">Tipo de Documento</label>
                            <select class="form-control" id="idtipodocumento" name="idtipodocumento">
                                <option value="DNI">DNI</option>
                                <option value="PAS">Pasaporte</option>
                            </select>
                        </div>
                        <div class="col-md-8 mb-3">
                            <label for="idpersonanrodoc" class="form-label">Número de Documento</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="idpersonanrodoc" name="idpersonanrodoc">
                                <button class="btn btn-outline-secondary" type="button" id="buscarPersona">Buscar</button>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="nombres" class="form-label">Nombres</label>
                            <input type="text" class="form-control" id="nombres" name="nombres" readonly>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="appaterno" class="form-label">Apellido Paterno</label>
                            <input type="text" class="form-control" id="appaterno" name="appaterno" readonly>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="appmaterno" class="form-label">Apellido Materno</label>
                            <input type="text" class="form-control" id="appmaterno" name="appmaterno" readonly>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="direccion" name="direccion" readonly>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="iddistrito" class="form-label">Distrito</label>
                            <select class="form-control" id="iddistrito" name="iddistrito">
                                <option value="DNI">DistritoA</option>
                                <option value="PAS">DistritoB</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Sección de Información de Empresa -->
                <div id="empresaFields" style="display: none;">
                    <h5 class="mb-4">
                        <i class="fas fa-building"></i> Información de Empresa
                    </h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="ruc" class="form-label">RUC</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="ruc" name="ruc">
                                <button class="btn btn-outline-secondary" type="button" id="buscarEmpresa">Buscar</button>
                            </div>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="nombre_empresa" class="form-label">Nombre de Empresa</label>
                            <input type="text" class="form-control" id="nombre_empresa" name="nombre_empresa" readonly>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="direccion_empresa" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="direccion_empresa" name="direccion_empresa" readonly>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="iddistrito" class="form-label">Distrito</label>
                            <select class="form-control" id="iddistrito" name="iddistrito">
                                <option value="DNI">DistritoA</option>
                                <option value="PAS">DistritoB</option>
                            </select>
                        </div>
                        
                    </div>
                </div>

                <!-- Botones -->
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary me-2">Registrar</button>
                    <button type="reset" class="btn btn-secondary">Cancelar</button>
                </div>
            </form>
        </div>
    </div>
</div>

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


