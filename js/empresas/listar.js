document.addEventListener("DOMContentLoaded", async () => {
    function $(object = "") {
        return document.querySelector(object);
    }
    let dtEmpresa;

    const formUpdateEmpresa = document.querySelector("#edit-empresa");

    async function CargarEmpresa() {
        if (dtEmpresa) {
            dtEmpresa.destroy();
        }

        dtEmpresa = null;

        try {
            const response = await fetch(`../../controller/empresa.controller.php?operation=getAll`);
            const data = await response.json();
            console.log(data);
            const TablaEmpresa = $("#table-empresas tbody");
            if (!TablaEmpresa) {
                console.error("Error: No se encontró el elemento #table-empresa tbody");
                return;
            }

            let tableContent = "";
            if (data.length === 0) {
                tableContent = `<tr><td colspan="6" class="text-center">No hay datos disponibles</td></tr>`;
            } else {
                data.forEach((element) => {
                    console.log(element);
                    const estadoClass =
                    element.estado === "Activo" ? "text-success" : "text-danger";
                  const icons =
                    element.estado === "Activo"
                      ? "bi bi-toggle2-on fs-5"
                      : "bi bi-toggle2-off fs-5";
                  const bgbtn =
                    element.estado === "Activo" ? "btn-success" : "btn-danger";
        
                  element.estado === "Activo" ? "text-success" : "text-danger";

                    tableContent += `
                        <tr>
                            <td>${element.razonsocial}</td>
                            <td>${element.direccion}</td>
                            <td>${element.email}</td>
                            <td>${element.telefono}</td>
                            <td>
                                <strong class="${estadoClass}">
                                    ${element.estado}
                                </strong>
                            </td>
                            <td>
                                <div class="d-flex justify-content-center">
                                    <a id-data="${element.id}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#edit-empresa">
                                        <i class="bi bi-pencil-square fs-5"></i>
                                    </a>
                                    <a id-data="${element.id}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                                        <i class="${icons}"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    `;
                });
                TablaEmpresa.innerHTML = tableContent;
                asignarEventos();

                if(dtEmpresa) {
                    dtEmpresa.destroy();
                }   
            RenderDataTableEmpresas();
            }
        } catch (error) {
            console.error("Error al cargar las empresas:", error);
            const TablaEmpresa = $("#table-empresas tbody");
            if (TablaEmpresa) {
                TablaEmpresa.innerHTML = `<tr><td colspan="6" class="text-center">Error al cargar los datos</td></tr>`;
            }
        }
    }

    CargarEmpresa();

    function asignarEventos() {
        let id;
        const btnEdit = document.querySelectorAll(".btn-warning");
        const idempresaruc = document.querySelector("#id-empresa-ruc");
        const btnDisabled = document.querySelectorAll(".estado");

        btnEdit.forEach((btn) => {
            btn.addEventListener("click", async (e) => {
                id = e.currentTarget.getAttribute("id-data");
                idempresaruc.setAttribute("id-empresa-ruc", id);
                await cargarDatosModal(id);
            });
        });


        formUpdateEmpresa.addEventListener("submit", async (e) => {
            e.preventDefault();
            try {
                const id = idempresaruc.getAttribute("id-emp");
                const razonSocial = idempresaruc.value.trim();
                idempresaruc.classList.remove("is-invalid");

                const direccion = document.querySelector("#editDireccion").value.trim();
                document.querySelector("#editDireccion").classList.remove("is-invalid");

                const email = document.querySelector("#editEmail").value.trim();
                document.querySelector("#editEmail").classList.remove("is-invalid");

                const telefono = document.querySelector("#editTelefono").value.trim();
                document.querySelector("#editTelefono").classList.remove("is-invalid");

                const spanError = formUpdateEmpresa.querySelector(".text-danger");
                if (spanError) {
                    spanError.remove();
                }

                if (await showConfirm("¿Estás seguro de actualizar la empresa?")) {
                    const data = await updateEmpresa(id, razonSocial, direccion, email, telefono);
                    const estado = data[0].estado;
                    if (estado) {
                        showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                        await CargarEmpresa();
                    } else {
                        idempresaruc.classList.add("is-invalid");
                        const span = document.createElement("span");
                        span.classList.add("text-danger");
                        span.innerHTML = `${data[0].mensaje}`;
                        idempresaruc.insertAdjacentElement("afterend", span);
                    }
                }
            } catch (error) {
                console.error("Error al actualizar la empresa:", error);
            }
        });
        
        btnDisabled.forEach((btn) => {
            btn.addEventListener("click", async (e) => {
                id = e.currentTarget.getAttribute("id-data");
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
});
