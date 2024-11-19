document.addEventListener("DOMContentLoaded", function () {
    // Función para simplificar la selección de elementos
    function $(selector = null) {
        return document.querySelector(selector);
    }

    let dtProveedores; // Variable para el DataTable

    // Función para obtener un proveedor por ID
    async function obtenerProveedorId(id) {
        const params = new URLSearchParams();
        params.append("operation", "getProveedores");
        params.append("idproveedor", id);
        try {
            const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
            const data = await response.json();
            console.log("Datos obtenidos:", data);
            return data;
        } catch (error) {
            console.error("Error al obtener el proveedor por ID:", error);
        }
    }

    // Función para cargar datos en el modal de edición
    async function cargarDatosModal(id) {
        try {
            const modal = $("#edit-proveedor");
            const inputRuc = modal.querySelector("#ruc");
            const inputProveedor = modal.querySelector("#proveedor");
            const inputDireccion = modal.querySelector("#direccion");
            const inputEmail = modal.querySelector("#email");
            const inputTelefono = modal.querySelector("#telefono");
            const inputContacto = modal.querySelector("#contacto");

            const btnGuardar = modal.querySelector(".btn-success");

            modal.reset();
            // Bloqueamos los inputs mientras se cargan los datos
            btnGuardar.setAttribute("disabled", "true");

            const data = await obtenerProveedorId(id);
            console.log("Datos para el modal: ", data);

            if (data && data.length > 0) {
                inputRuc.value = data[0].idempresa;
                inputProveedor.value = data[0].proveedor;
                inputDireccion.value = data[0].direccion;
                inputEmail.value = data[0].email;
                inputTelefono.value = data[0].telefono_contacto;
                inputContacto.value = data[0].contacto_principal;
                btnGuardar.removeAttribute("disabled");
            } else {
                console.log("No hay datos disponibles para este proveedor.");
            }
        } catch (error) {
            console.error("Error al cargar los datos en el modal:", error);
        }
    }

    // Función para actualizar el estado de un proveedor
    async function updateEstado(id, status) {
        const params = new URLSearchParams();
        params.append("operation", "updateEstado");
        params.append("idproveedor", id);
        params.append("estado", status === "Activo" ? "Inactivo" : "Activo");

        try {
            const response = await fetch(`../../controller/proveedor.controller.php`, {
                method: "POST",
                body: params,
            });
            const data = await response.json();
            console.log("Respuesta de actualización de estado:", data);
            return data;
        } catch (error) {
            console.error("Error al actualizar el estado del proveedor:", error);
            throw error; // Para capturar errores en otros contextos
        }
    }

    // Función para inicializar DataTable
    function RenderDatatableProveedores() {
        if (dtProveedores) {
            dtProveedores.destroy();
        }

        dtProveedores = new DataTable("#table-proveedores", {
            columnDefs: [
                { width: "10%", targets: 0 },
                { width: "20%", targets: 1 },
                { width: "20%", targets: 2 },
                { width: "10%", targets: 3 },
                { width: "10%", targets: 4 },
                { width: "20%", targets: 5 },
                { width: "10%", targets: 6 },
                { width: "10%", targets: 7 },
            ],
            language: {
                sEmptyTable: "No hay datos disponibles en la tabla",
                sInfoFiltered: "(filtrado de _MAX_ entradas en total)",
                sLengthMenu: "Filtrar: _MENU_",
                sLoadingRecords: "Cargando...",
                sProcessing: "Procesando...",
                sSearch: "Buscar:",
                sZeroRecords: "No se encontraron resultados",
                oPaginate: {
                    sFirst: "Primero",
                    sLast: "Último",
                    sNext: "Siguiente",
                    sPrevious: "Anterior",
                },
            },
        });
    }

    // Función para cargar los datos de los proveedores
    async function cargarProveedores() {
        try {
            const response = await fetch(`../../controller/proveedor.controller.php?operation=getAll`);
            const data = await response.json();
            console.log("Datos de todos los proveedores:", data);

            const Tablaproveedores = $("#table-proveedores tbody");
            let tableContent = "";

            if (data.length > 0) {
                data.forEach((element) => {
                    console.log("Elemento:", element);
                    const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
                    const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
                    const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";

                    tableContent += `
                    <tr>
                        <td>${element.idempresaruc}</td>
                        <td>${element.proveedor}</td>
                        <td>${element.contacto_principal}</td>
                        <td>${element.telefono_contacto}</td>
                        <td>${element.email}</td>
                        <td>${element.direccion}</td>
                        <td><strong class="${estadoClass}">${element.estado}</strong></td>
                        <td>
                        <div class="d-flex justify-content-center">
                            <a id-data="${element.idproveedor}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target=".edit-proveedor">
                                <i class="bi bi-pencil-square fs-5"></i>
                            </a>
                            <a id-data="${element.idproveedor}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                                <i class="${icons}"></i>
                            </a>
                        </div>
                        </td>
                    </tr>`;
                });

                Tablaproveedores.innerHTML = tableContent;

                const editButtons = document.querySelectorAll(".btn-warning");
                const btnDisabled = document.querySelectorAll(".estado");
                const idInput = $("#proveedor");
                let id;

                editButtons.forEach((btnGuardar) => {
                    btnGuardar.addEventListener("click", async (e) => {
                        id = e.currentTarget.getAttribute("id-data");
                        idInput.setAttribute("id-prov", id);
                        if (id) {
                            await cargarDatosModal(id);
                        } else {
                            console.error("El atributo id-data es null o undefined.");
                        }
                    });
                });

                btnDisabled.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        console.log("status: ", btnDisabled);
                        try {
                            e.preventDefault();
                            id = parseInt(e.currentTarget.getAttribute("id-data"));
                            const status = e.currentTarget.getAttribute("status");
                            console.log("ID:", id, "Status:", status);

                            if (await showConfirm("¿Estas seguro de cambiar el estado del proveedor?")) {
                                const data = await updateEstado(id, status);
                                console.log("Estado actualizado correctamente:", data);

                                if (data[0].estado > 0) {
                                    showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                                    await cargarProveedores();
                                } else {
                                    showToast(`${data[0].mensaje}`, "error", "ERROR");
                                }
                            }
                        } catch (error) {
                            console.error("Error al cambiar el estado del proveedor:", error);
                        }
                    });
                });

                const formUpdate = $("#form-edit");
                formUpdate.addEventListener("submit", async (e) => {
                    try {
                        e.preventDefault();
                        const id = idInput.getAttribute("id-prov");
                        const idproveedor = parseInt(id);
                        const inputProv = idInput.value;

                        if (await showConfirm("¿Estas seguro de actualizar el proveedor?")) {
                            const data = await updateProveedor(idproveedor, inputProv);
                            console.log("Proveedor actualizado correctamente:", data);

                            if (data[0].idproveedor > 0) {
                                showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                                await cargarProveedores();
                            } else {
                                showToast(`${data[0].mensaje}`, "error", "ERROR");
                            }
                        }
                    } catch (error) {
                        console.error("Error al actualizar el proveedor", error);
                    }
                });
            } else {
                Tablaproveedores.innerHTML = '<tr><td colspan="8" class="text-center">No hay datos disponibles</td></tr>';
            }

            if (dtProveedores) {
                dtProveedores.destroy();
            }

            RenderDatatableProveedores();
        } catch (error) {
            console.error("Error al cargar los proveedores:", error);
        }
    }

    cargarProveedores();
});
