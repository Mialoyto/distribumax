<?php
require_once '../../header.php';
?>


<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Empresas</h1>
        <ol class="breadcrumb mb-4">
            <!-- Breadcrumbs pueden ser agregados aquí si es necesario -->
        </ol>

        <div class="card mb-4">
            <div class="card-header">
                <i class="fas fa-table me-1"></i>
                Listado de Empresas
            </div>
            <div class="card-body">

                <div class="table-responsive">

                    <table class="table table-striped " id="table-marcas">
                        <thead class="">
                            <tr>

                                <th scope="col"> Marca</th>
                                <th scope="col">Fecha de Registro</th>
                                <th scope="col">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>

                            <!-- Agrega más filas según sea necesario -->
                        </tbody>
                    </table>
                </div>
                <div class="card-footer">
                    <a href="registrar.php" class="btn btn-primary">Registrar nuevo producto</a>
                </div>
            </div>
        </div>
    </div>
</main>

<?php
require_once '../../footer.php';
?>