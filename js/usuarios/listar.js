document.addEventListener("DOMContentLoaded", async () => {
    // INICIAR TOOLTIPS EN LOS ELEMENTOS
    initializeTooltips();
    function $(object = null) { return document.querySelector(object); }
    let dtusuarios;

    // Función para inicializar DataTable
    function RenderDatatable() {
        dtusuarios = new DataTable("#table-usuarios", {
            columnDefs: [
                { width: "20%", targets: 0 },
                { width: "20%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "20%", targets: 3 },
                { width: "20%", targets: 4 },
                { width: "20%", targets: 5 },
                { width: "20%", targets: 6 }
            ],
            language: {
                "sEmptyTable": "No hay datos disponibles en la tabla",
                "info": "",
                "sInfoFiltered": "(filtrado de _MAX_ entradas en total)",
                "sLengthMenu": "Filtrar: _MENU_",
                "sLoadingRecords": "Cargando...",
                "sProcessing": "Procesando...",
                "sSearch": "Buscar:",
                "sZeroRecords": "No se encontraron resultados",
                "oAria": {
                    "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                }
            }
        });
    }

    // Función para cargar los usuarios
    async function CargarUsuarios() {
        if (dtusuarios) {
            dtusuarios.destroy();
            dtusuarios = null;
        }

        const Tablausuarios = $("#table-usuarios tbody");
        let tableContent = "";

        try {
            const response = await fetch(`../../controller/usuario.controller.php?operation=getAll`);
            const data = await response.json();

            if (data.length > 0) {
                data.forEach(element => {
                    const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
                    const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
                    const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";

                    tableContent += `
                    <tr>
                        <td data-idusuario="${element.id}">${element.nombres}</td>
                        <td>${element.appaterno}</td>
                        <td>${element.apmaterno}</td>
                        <td>${element.perfil}</td>
                        <td>${element.nombre_usuario}</td>
                        <td class="${estadoClass}" fw-bold>${element.estado}</td>
                            <td>
                                <div class="d-flex justify-content-center">
                                    <a id-data="${element.id}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                                        <i class="${icons}"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>`;
                });

                Tablausuarios.innerHTML = tableContent;

                const btnDisabled = document.querySelectorAll(".estado");
                btnDisabled.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        const id = e.currentTarget.getAttribute("id-data");
                        const status = e.currentTarget.getAttribute("status");
                        console.log("ID: ", id, "Status: ", status);

                        if (await showConfirm("¿Estás seguro de cambiar el estado?")) {
                            const data = await updateEstado(id, status);
                            console.log(data);
                            const estado = data.estado;
                            if (estado) {
                                showToast(`${data.mensaje}`, "success", "SUCCESS");
                                CargarUsuarios();
                            } else {
                                console.error("Error al cambiar el estado del usuario");
                            }
                        }
                    });
                });

                initializeTooltips();
            } else {
                Tablausuarios.innerHTML = '<tr><td colspan="7" class="text-center">No hay datos disponibles</td></tr>';
            }

            RenderDatatable();
        } catch (error) {
            console.error("Error al cargar los datos:", error);
        }
    }

    CargarUsuarios();
});
