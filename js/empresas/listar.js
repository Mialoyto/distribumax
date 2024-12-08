document.addEventListener("DOMContentLoaded", async () => {
    // INICIALIZAR TOOLTIPS EN LOS ELEMENTOS
    initializeTooltips();
    function $(object = null) { return document.querySelector(object); }
    let dtEmpresa;

    // REFERENCIAS A LOS ELEMENTOS DEL MODAL
    const modal = $("#form-emp");
    const inputRazonSocial = document.querySelector("#editRazonSocial");
    const inputDireccion = document.querySelector("#editDireccion");
    const inputEmail = document.querySelector("#editEmail");
    const inputTelefono = document.querySelector("#editTelefono");
    let idempresa;

    async function cargarDatosModal(id) {
        try {
            inputRazonSocial.value = "Cargando...";
            inputDireccion.value = "Cargando...";
            inputEmail.value = "Cargando...";
            inputTelefono.value = "Cargando...";

            const data = await getEmpresaById(id);
            if (data && data.length > 0) {
                const empresa = data[0];
                inputRazonSocial.setAttribute("id-empresa", empresa.idempresaruc);
                inputRazonSocial.value = empresa.razonsocial;
                inputDireccion.value = empresa.direccion;
                inputEmail.value = empresa.email;
                inputTelefono.value = empresa.telefono;
            }
        } catch (error) {
            console.error("Error al cargar los datos en el modal:", error);
        }
    }

    function RenderDataTableEmpresas() {
        if (dtEmpresa) {
            dtEmpresa.destroy();
            dtEmpresa = null;
        }

        dtEmpresa = new DataTable("#table-empresas", {
            columnDefs: [
                { width: "20%", targets: 0 },
                { width: "20%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "20%", targets: 3 },
                { width: "20%", targets: 4 },
                { width: "20%", targets: 5 },
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

    async function CargarEmpresa() {
        if (dtEmpresa) {
            dtEmpresa.destroy();
            dtEmpresa = null;
        }

        const TablaEmpresa = $("#table-empresas tbody");
        let tableContent = "";

        try {
            const response = await fetch(`../../controller/empresa.controller.php?operation=getAll`);
            const data = await response.json();

            if (data.length > 0) {
                data.forEach((element) => {
                    const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
                    const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-6" : "bi bi-toggle2-off fs-6";
                    const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
                    const isDisabled = element.estado === "Inactivo" || element.status === 0 ? "disabled" : "";

                    tableContent += `
                        <tr>
                            <td>${element.razonsocial}</td>
                            <td>${element.direccion}</td>
                            <td>${element.email}</td>
                            <td>${element.telefono}</td>
                            <td class="${estadoClass}" fw-bold>${element.estado}</td>
                            <td>
                                <div class="d-flex justify-content-center">
                        
                                     <div class="btn-group btn-group-sm" role="group">
                                        <a id-data="${element.id}" 
                                        class="btn btn-warning ${isDisabled}" 
                                        data-bs-toggle="modal" 
                                        data-bs-target=".edit-empresa"
                                        type="button" 
                                        data-bs-toggle="tooltip" 
                                        data-bs-placement="bottom" 
                                        data-bs-title="Editar">
                                        <i class="bi bi-pencil-square fs-6"></i>
                                        </a>
                                        <a id-data="${element.id}" class="btn ${bgbtn} ms-2 estado" status="${element.status}"
                                        type="button" class="me-2" 
                                        data-bs-toggle="tooltip" 
                                        data-bs-placement="bottom" 
                                        data-bs-title="Cambiar estado">
                                            <i class="${icons}"></i>
                                        </a>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    `;
                });
                

                TablaEmpresa.innerHTML = tableContent;

                const editButtons = document.querySelectorAll(".btn-warning");
                editButtons.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        const id = e.currentTarget.getAttribute("id-data");
                        await cargarDatosModal(id);
                    });
                });

                // NOTE - EVENTO PARA ACTUALIZAR LAS EMPRESAS
                modal.addEventListener("submit", async (e) => {
                    e.preventDefault();
                    idempresaruc = inputRazonSocial.getAttribute("id-empresa");
                    const razonSocial = inputRazonSocial.value.trim();
                    const direccion = inputDireccion.value.trim();
                    const email = inputEmail.value.trim();
                    const telefono = inputTelefono.value.trim();

                    console.log("idempresaruc: ", idempresaruc);
                    console.log("razon social: ", razonSocial);
                    console.log("direccion: ", direccion);
                    console.log("email", email);
                    console.log("telefono:", telefono);
                    await updateEmpresa(idempresaruc, razonSocial, direccion, email, telefono);
                    await CargarEmpresa();
                });

                const btnDisabled = document.querySelectorAll(".estado");
                btnDisabled.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        const id = e.currentTarget.getAttribute("id-data");
                        const status = e.currentTarget.getAttribute("status");
                        console.log("ID:", id, "Status:", status);
                        if (await showConfirm("¿Estás seguro de cambiar el estado de la empresa?")) {
                            const data = await updateEstado(id, status);
                            const estado = data[0].estado;
                            if (estado) {
                                showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                                CargarEmpresa();
                            } else {
                                console.error("Error al cambiar el estado de la empresa");
                            }
                        }
                    });
                });

                initializeTooltips();
            } else {
                TablaEmpresa.innerHTML = '<tr><td colspan="7" class="text-center">No hay datos disponibles</td></tr>';
            }

            RenderDataTableEmpresas();
        } catch (error) {
            console.error("Error al cargar las empresas:", error);
        }
    }

    CargarEmpresa();
});
