<?php require_once 'header.php'; ?>

<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Dashboard</h1>
        <ol class="breadcrumb mb-4"></ol>

        <div class="row">
            <!-- Tarjeta de Ranking de Provincias -->
            <div class="col-md-4">
                <div class="card mb-4">

                    <div class="card-body">
                        <span><strong>Pedidos del día</strong></span>
                        <i class="fas fa-clipboard-list me-1"></i>
                        <div class="row">
                            <div class="col-4">
                                <span>Pendientes</span>
                                <h2 id="pendientes" class="text-right"></h2>

                            </div>
                            <div class="col-4 text-center">
                                <span>Enviados</span>
                                <h2 id="enviados" class="text-center"></h2>

                            </div>
                            <div class="col-4 text-end">
                                <span>Cancelados</span>
                                <h2 id="cancelados" class="text-end"></h2>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de Total de Clientes Activos -->
            <div class="col-md-4">
                <div class="card mb-4">

                    <div class="card-body">
                        <span><strong>Clientes Activos</strong></span>
                        <i class="fas fa-user me-2"></i>
                        <div class="row">
                            <h2 id="totalClientesActivos" class="text-center">
                            </h2>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de Ranking de Productos Más Vendidos -->
            <div class="col-md-4">
                <div class="card mb-4">

                    <div class="card-body">
                        <span><strong>Ventas del día</strong></span>
                        <i class="fas fa-user me-2"></i>

                        <div class="row">
                            <div class="col-4">
                                <span>Pendientes</span>
                                <h2 id="ve_pendientes" class="text-right"></h2>

                            </div>
                            <div class="col-4 text-center">
                                <span>Despachados</span>
                                <h2 id="ve_despachados" class="text-center"></h2>

                            </div>
                            <div class="col-4 text-end">
                                <span>Cancelados</span>
                                <h2 id="ve_cancelados" class="text-end"></h2>
                            

                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Tarjeta de Ventas Anuales -->
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-chart-line me-1"></i>
                        Provincias con mayor frecunecia de pedidos
                    </div>
                    <div class="card-body">
                        <form id="filter-form-ventas-anuales">
                            <div class="row mb-3">
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Distrito</th>
                                                <th>Provincia</th>
                                                <th>Pedidos despachados</th>
                                            </tr>
                                        </thead>
                                        <tbody id="pedidos-body">
                                            <tr>
                                            </tr>
                                    </table>
                                </div>
                            </div>
                        </form>

                    </div>
                </div>
            </div>

            <!-- Tarjeta de Compras Anuales -->
            <div class="col-md-6">
                <div class="card mb-8">
                    <div class="card-header">
                        Productos con poco stock y por vencer
                    </div>
                    <div class="card-body">
                        <form id="filter-form-compras-anuales">
                            <div class="row mb-3">
                                <div class="table-responsive">
                                    <table class="table table-sm">
                                        <thead>
                                            <tr>
                                                <th>Producto</th>
                                                <th>Num lote</th>
                                                <th>fecha</th>
                                                <th>Cantidad</th>
                                                <th>Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody id="table-body">
                                            <tr>

                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </form>

                    </div>

                </div>
            </div>
        </div>

        <div class="row">
            <!-- Tarjeta de Ventas Diarias -->
            <div class="col-md-6">
                <div class="card mb-4 mt-4">
                    <div class="card-header">
                        <i class="fas fa-chart-bar me-1"></i>
                        Ventas Diarias
                    </div>
                    <div class="card-body">
                        <form id="filter-form-ventas-diarias">
                            <div class="row mb-3">
                                <div class="input-group col-md-4 mt-2">
                                    <input type="date" id="filter-date-ventas-diarias" class="form-control">

                                </div>
                            </div>
                        </form>
                        <canvas id="dailySalesBarChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de Ventas Mensuales -->
            <!-- <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-chart-line me-1"></i>
                        Ventas Mensuales
                    </div>
                    <div class="card-body">
                        <form id="filter-form-ventas-mensuales">
                            <div class="row mb-3">
                                <div class="input-group col-md-4 mt-2">
                                    <input type="month" id="filter-date-ventas-mensuales" class="form-control">
                                    <button type="button" class="btn btn-primary" id="filtrar-ventas-mensuales">Filtrar</button>
                                </div>
                            </div>
                        </form>
                        <canvas id="monthlySalesLineChart"></canvas>
                    </div>
                </div>
            </div> -->
        </div>
    </div>
</main>

<?php require_once 'footer.php'; ?>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        function $(object = null) {
            return document.querySelector(object);
        }

        // Gráfico de Barras de Ventas Diarias
        const dailySalesBarCtx = document.getElementById('dailySalesBarChart').getContext('2d');
        let dailySalesBarChart = new Chart(dailySalesBarCtx, {
            type: 'bar',
            data: {
                labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'], // Días de la semana
                datasets: [{
                    label: 'Ventas del dia en (s/.)',
                    data: [],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Función para cargar las ventas diarias
        async function cargarVentasDiarias(fecha = null) {
            try {
                const params = new URLSearchParams();
                params.append('operation', 'ventastotales');
                if (fecha) {
                    params.append('fecha', fecha);
                }

                const response = await fetch(`../controller/ventas.controller.php?${params}`);
                const data = await response.json();
                console.log(data);

                // Revisar la respuesta del servidor
                if (data && data.length > 0) {
                    const ventas = data.map(item => item.monto_realizado);
                    const etiquetas = data.map(item => item.fecha);

                    // Actualizar el gráfico de barras con los datos obtenidos
                    dailySalesBarChart.data.labels = etiquetas; // Establecer las etiquetas
                    dailySalesBarChart.data.datasets[0].data = ventas; // Ventas diarias
                    dailySalesBarChart.update(); // Actualizar el gráfico
                } else {
                    // showToast("No se pudo cargar las ventas diarias", "info", "INFO");
                }
            } catch (error) {
                console.error("Error al cargar las ventas diarias:", error);
            }
        }

        // Asignar el evento de clic al botón filtrar ventas diarias
        $("#filter-date-ventas-diarias").addEventListener("input", async () => {
            const fecha = $("#filter-date-ventas-diarias").value;
            cargarVentasDiarias(fecha);
        });

        // Cargar las ventas diarias inicialmente
        cargarVentasDiarias();
    });
</script>
<script src="../js/dashboard/cargar-datos.js"></script>
<script src="../js/utils/sweetalert.js"></script>