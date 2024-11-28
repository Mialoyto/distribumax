<?php require_once 'header.php'; ?>

<main>
    <div class="container-fluid px-4">
        <h1 class="mt-4">Dashboard</h1>
        <ol class="breadcrumb mb-4"></ol>

        <!-- Tarjeta de Ventas del Día -->
        <div class="row">
            <div class="col-md-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <i class="fas fa-chart-bar me-1"></i>
                        Ventas del Día
                    </div>
                    <div class="card-body">
                        <form id="filter-form">
                            <div class="row mb-3">
                                <div class="input-group col-md-4 mt-2">
                                    <input type="date" id="filter-date" class="form-control">
                                    <button type="button" class="btn btn-primary" id="filtrar">Filtrar</button>
                                </div>
                            </div>
                        </form>
                        <canvas id="salesChart"></canvas>
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
        // Configuración inicial del gráfico

        function $(object = null){return document.querySelector(object)}

        const ctx = document.getElementById('salesChart').getContext('2d');
        let salesChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [], // Etiquetas (fechas o categorías)
                datasets: [
                    {
                        label: 'Ventas Realizadas',
                        data: [],
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    },
                    {
                        label: 'Ventas Canceladas',
                        data: [],
                        backgroundColor: 'rgba(255, 99, 132, 0.2)',
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Función para cargar las ventas por fecha
        async function cargarVentas() {
            try {
             
                // if (!fecha) {
                //     alert("Selecciona una fecha válida.");
                //     return;
                // }

                const params = new URLSearchParams();
                params.append('operation', 'ventasDay');
                params.append('fecha',$("#filter-date").value);

                const response = await fetch(`../controller/ventas.controller.php?${params}`);
                const data = await response.json();
                console.log(data);
                // Revisar la respuesta del servidor
                if (data && data.length > 0) {
                    const realizadas = data.map(item => item.total_ventas_realizadas);
                    const canceladas = data.map(item => item.total_ventas_canceladas);
                    const etiquetas = data.map(item => item.fecha);

                    // Actualizar el gráfico con los datos obtenidos
                    salesChart.data.labels = etiquetas; // Establecer las etiquetas
                    salesChart.data.datasets[0].data = realizadas; // Ventas realizadas
                    salesChart.data.datasets[1].data = canceladas; // Ventas canceladas
                    salesChart.update(); // Actualizar el gráfico
                } else {
                    showToast("Selecione un fecha","info","INFO");
                }
            } catch (error) {
                console.error("Error al cargar las ventas:", error);
            }
        }

        // Asignar el evento de clic al botón filtrar
        $("#filtrar").addEventListener("click", async()=>{
            cargarVentas();
        });
    });
</script>
<script src="../js/utils/sweetalert.js"></script>
