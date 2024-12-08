<?php require_once 'header.php'; ?>

<main>
    <div class="container-fluid py-4 px-4">
        <h1 class="text-primary fw-bold text-center mb-4">Dashboard</h1>

        <!-- Filas de Tarjetas Principales -->
        <div class="row g-4">
            <!-- Pedidos del Día -->
            <div class="col-lg-4 col-md-6">
                <div class="card text-white bg-primary shadow-sm" style="min-height: 100px;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title fw-bold mb-0">Pedidos del Día</h5>
                            <i class="fas fa-clipboard-list fa-3x"></i>
                        </div>
                        <div class="row mt-3">
                            <div class="col-4 text-start">
                                <span class="fw-bold">Pendientes</span>
                                <h4 id="pendientes" class="mt-2">0</h4>
                            </div>
                            <div class="col-4 text-center">
                                <span class="fw-bold">Enviados</span>
                                <h4 id="enviados" class="mt-2">0</h4>
                            </div>
                            <div class="col-4 text-end">
                                <span class="fw-bold">Cancelados</span>
                                <h4 id="cancelados" class="mt-2">0</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Clientes Activos -->
            <div class="col-lg-4 col-md-6">
                <div class="card text-white bg-success shadow-sm" style="min-height: 170px;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title fw-bold mb-0">Clientes Activos</h5>
                            <i class="fas fa-users fa-3x"></i>
                        </div>
                        <div class="text-center mt-3">
                            <h4 id="totalClientesActivos" class="mt-2">0</h4>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ventas del Día -->
            <div class="col-lg-4 col-md-6">
                <div class="card text-white bg-primary shadow-sm" style="min-height: 100px;">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="card-title fw-bold mb-0">Ventas del Día</h5>
                            <i class="fas fa-chart-line fa-3x"></i>
                        </div>
                        <div class="row mt-3">
                            <div class="col-4 text-start">
                                <span class="fw-bold">Pendientes</span>
                                <h4 id="ve_pendientes" class="mt-2">0</h4>
                            </div>
                            <div class="col-4 text-center">
                                <span class="fw-bold">Despachados</span>
                                <h4 id="ve_despachados" class="mt-2">0</h4>
                            </div>
                            <div class="col-4 text-end">
                                <span class="fw-bold">Cancelados</span>
                                <h4 id="ve_cancelados" class="mt-2">0</h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>



        <!-- Tablas y gráficos -->
        <div class="row mt-5 g-4">
            <!-- Provincias con mayor frecuencia de pedidos -->
            <div class="col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white fw-bold">
                        <i class="fas fa-map-marker-alt me-2"></i>Provincias con Mayor Frecuencia de Pedidos
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Distrito</th>
                                        <th>Provincia</th>
                                        <th>Pedidos Despachados</th>
                                    </tr>
                                </thead>
                                <tbody id="pedidos-body">
                                    <tr>
                                        <td colspan="3" class="text-center">No hay datos disponibles</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Productos con poco stock -->
            <div class="col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-danger text-white fw-bold">
                        <i class="fas fa-boxes me-2"></i>Productos con Poco Stock y por Vencer
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Producto</th>
                                        <th>Número de Lote</th>
                                        <th>Fecha</th>
                                        <th>Cantidad</th>
                                        <th>Estado</th>
                                    </tr>
                                </thead>
                                <tbody id="table-body">
                                    <tr>
                                        <td colspan="5" class="text-center">No hay datos disponibles</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gráfico de Ventas Diarias -->
        <div class="row mt-5">
            <div class="col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white fw-bold">
                        <i class="fas fa-chart-bar me-2"></i>Monto Total de Ventas Diarias
                    </div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <label for="filter-date-ventas-diarias" class="fw-bold">Seleccionar Fecha:</label>
                            <input type="date" id="filter-date-ventas-diarias" class="form-control w-25">
                        </div>
                        <canvas id="dailySalesBarChart"></canvas>
                    </div>
                </div>
            </div>
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