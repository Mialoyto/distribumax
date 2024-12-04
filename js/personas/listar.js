document.addEventListener("DOMContentLoaded", function() {
    //INICIAR TOOLTIPS EN LOS ELEMENTOS
    initializeTooltips();
    function $(object = null) { return document.querySelector(object); }
    let dtpersonas;

    function RenderDatatable() {
        if(dtpersonas){
            dtpersonas.destroy();
            dtpersonas = null;
        }

        dtpersonas = new DataTable("#table-personas", {
            columnDefs: [
                { width: "5%", targets: 0 },
                { width: "5%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "15%", targets: 3 },
                { width: "15%", targets: 4 },
                { width: "20%", targets: 5 },
                { width: "10%", targets: 6 },
                { width: "10%", targets: 7 }
            ],
            language: {
                sEmptyTable: "No hay datos disponibles en la tabla",
                info: "",
                sInfoFiltered: "(filtrado de _MAX_ entradas en total)",
                sLengthMenu: "Filtrar: _MENU_",
                sLoadingRecords: "Cargando...",
                sProcessing: "Procesando...",
                sSearch: "Buscar:",
                sZeroRecords: "No se encontraron resultados",
                oAria: {
                    sSortAscending: ": Activar para ordenar la columna de manera ascendente",
                    sSortDescending: ": Activar para ordenar la columna de manera descendente",
                },
            },
        });
    }

    async function CargarPersonas() {
        if(dtpersonas){
            dtpersonas.destroy();
            dtpersonas = null;
        }

        const Tablapersonas = $("#table-personas tbody");
        let tableContent = "";

        try {
            const response = await fetch(`../../controller/persona.controller.php?operation=getAll`);
            const data = await response.json();

            if (data.length > 0) {
                data.forEach(element => {
                    const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
                    const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
                    const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";

                    tableContent += `
                    <tr>
                        <td>${element.tipo_documento}</td>
                        <td>${element.id}</td>
                        <td>${element.nombres}</td>
                        <td>${element.appaterno}</td>
                        <td>${element.apmaterno}</td>
                        <td>${element.distrito}</td>
                        <td class="${estadoClass}" fw-bold>${element.estado}</td>
                        <td>
                            <a id-data="${element.id}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                                <i class="${icons}"></i>
                            </a>
                        </td>
                    </tr>
                    `;
                });

                Tablapersonas.innerHTML = tableContent;

                const editButtons = document.querySelectorAll(".btn-warning");
                editButtons.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        const id = e.currentTarget.getAttribute("id-data");
                        await cargarDatosModal(id);
                    });
                });

                const btnDisabled = document.querySelectorAll(".estado");
                btnDisabled.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        const id = e.currentTarget.getAttribute("id-data");
                        const status = e.currentTarget.getAttribute("status");

                        // Mostrar confirmación antes de cambiar el estado
                        console.log("ID:", id, "Status:", status);
                        if (await showConfirm("¿Estás seguro de cambiar el estado de la persona?")) {
                            const data = await updateEstado(id, status);

                            // Verificar si el estado se actualizó correctamente
                            const estado = data[0].estado;
                            if (estado) {
                                showToast(`${data[0].mensaje}`, "success", "SUCCESS");

                                CargarPersonas();
                            } else {
                                console.error("Error al cambiar el estado de la persona");
                            }
                        }
                    });
                });

                initializeTooltips();
            } else {
                Tablapersonas.innerHTML = '<tr><td colspan="8" class="text-center">No hay datos disponibles</td></tr>';
            }

            RenderDatatable();
        } catch (error) {
            console.error("Error al cargar los datos:", error);
        }
    }

    CargarPersonas();
});
