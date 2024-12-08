document.addEventListener("DOMContentLoaded", function() {
    //INICIAR TOOLTIPS EN LOS ELEMENTOS
    initializeTooltips();
    function $(object = null) { return document.querySelector(object); }
    let dtpersonas;

    // REFERENCIAS A LOS ELEMENTOS DEL MODAL
    const modal = $("#form-per");
    const idtipodocumento = modal.querySelector("#editDNI");
    const inputDNI = modal.querySelector("#editDNI");
    const inputNombres = modal.querySelector("#editNombres");
    const inputAppaterno = modal.querySelector("#editApellidoPaterno");
    const inputApmaterno = modal.querySelector("#editApellidoMaterno");
    const inputTelefono = modal.querySelector("#editTelefono");
    const inputDireccion = modal.querySelector("#editDireccion");
    const inputDistrito = modal.querySelector("#buscar-distrito");
    let idpersona;

    async function cargarDatosModal(id) {
        try{
            inputDNI.value = "Cargando....";
            inputNombres.value = "Cargando....";
            inputAppaterno.value = "Cargando....";
            inputApmaterno.value = "Cargando....";
            inputTelefono.value = "Cargando....";
            inputDireccion.value = "Cargando....";
            inputDistrito.value = "Cargando....";

            const data = await getPersona(id);
            console.log(data);
            if(data && data.length > 0){
                idtipodocumento.setAttribute("idtipodoc", data[0].idtipodocumento);
                inputDNI.value = data[0].idpersonanrodoc;
                inputNombres.value = data[0].nombres;
                inputAppaterno.value = data[0].appaterno;
                inputApmaterno.value = data[0].apmaterno;
                inputTelefono.value = data[0].telefono;
                inputDireccion.value = data[0].direccion;
                inputDistrito.value = data[0].distrito;
            }
        }catch(error){
            console.error("Error al cargar los datos en el modal:", error);
        }
    }
        

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
                { width: "10%", targets: 7 },
                {with: "10%", targets: 8}
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
        if (dtpersonas) {
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
                    // Verificar si el teléfono es null o vacío
                    const telefono = element.telefono ? element.telefono : "No tiene número de celular";
    
                    const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
                    const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
                    const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
                    const isDisabled = element.estado === "Inactivo" || element.status === 0 ? "disabled" : "";
    
                    tableContent += `
                        <tr>
                            <td>${element.id}</td>
                            <td>${element.nombres}</td>
                            <td>${element.appaterno}</td>
                            <td>${element.apmaterno}</td>
                            <td>${telefono}</td> <!-- Aquí se muestra el mensaje si el teléfono es null -->
                            <td>${element.direccion}</td>
                            <td>${element.distrito}</td>
                            <td class="${estadoClass}" fw-bold>${element.estado}</td>
                            <td>
                                <div class="d-flex justify-content-center">
                                <a id-data="${element.id}" class="btn btn-warning ${isDisabled}" data-bs-toggle="modal"  data-bs-target=".edit-persona">
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
    
                Tablapersonas.innerHTML = tableContent;
    
                const editButtons = document.querySelectorAll(".btn-warning");
                editButtons.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        const id = e.currentTarget.getAttribute("id-data");
                        await cargarDatosModal(id);
                    });
                });
    
                //? EVENTO DEL FORMULARIO PARA ACTUALIZAR LA PERSONA
                modal.addEventListener("submit", async (e) => {
                    e.preventDefault();
    
                    const id = idtipodocumento.getAttribute("idtipodoc");
                    const dni = inputDNI.value.trim();
                    const nombres = inputNombres.value.trim();
                    const appaterno = inputAppaterno.value.trim();
                    const apmaterno = inputApmaterno.value.trim();
                    const telefono = inputTelefono.value.trim();
                    const direccion = inputDireccion.value.trim();
                    const distrito = inputDistrito.value.trim();

                    console.log(id, dni, nombres, appaterno, apmaterno, telefono, direccion, distrito);
    
                    // TODO: ESTA FUNCION SE ENCUENTRA EN EL ARCHIVO editar-persona.js
                    await formUpdatePersona(dni,id, nombres, appaterno, apmaterno, telefono, direccion, distrito);
                    //RENDERIZAMOS LA TABLA DE PERSONAS
                    await CargarPersonas();
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
