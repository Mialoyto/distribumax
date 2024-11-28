document.addEventListener("DOMContentLoaded", function(){
    function $(object = "") {
        return document.querySelector(object);
    }
    let dtmarca;

    const formUpdateMarca = document.querySelector("#edit-marca");

    async function CargarMarcas() {
        
        if (dtmarca) {
            dtmarca.destroy(); // Destruir datatable si ya existe
            dtmarca = null;
        }
    
        try {
            const response = await fetch(`../../controller/marca.controller.php?operation=getAll`);
            const data = await response.json();
            const TablaMarcas = $("#table-marcas tbody");

            //Construir el contenido de la tabla
            let tableContent = "";
            if (data.length === 0) {
                tableContent = `<tr><td colspan="3" class="text-center">No hay datos disponibles</td></tr>`;
            }else{
                data.forEach((element) => {
                    console.log(element);
                        // Asignar clases dependiendo del estado
                        const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
                        const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
                        const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
                        
                        element.estado === "Activo" ? "text-success" : "text-danger";
                        tableContent += `
                            <tr>
                                <td>${element.marca}</td>
                                <td>
                        <strong class="${estadoClass}">
                        ${element.estado}
                        </strong>
                        </td>
                        <td>
                        <div class="d-flex justify-content-center">
                            <a  id-data="${element.id}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#edit-marca" >
                                <i class="bi bi-pencil-square fs-5"></i>
                            </a>     
                            <a  id-data="${element.id}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                                <i class="${icons}"></i>
                            </a>
                        </div>
                        </td>
                            </tr>
                        `;
                    });
                    TablaMarcas.innerHTML = tableContent;
                    asignarEventos();
    
                    if(dtmarca){
                        dtmarca.destroy();
                    }
                    RenderDatatableMarcas();                    
                }

            } catch (error) {
                console.error("Error al cargar las marcas:", error);
                TablaMarcas.innerHTML = `<tr><td colspan="4" class="text-center">Error al cargar los datos</td></tr>`;
            }
        }
    
        CargarMarcas();

    function asignarEventos(){
        let id;
        const btnEdit = document.querySelectorAll(".btn-warning");
        const idmarca = document.querySelector("#id-marca");
        const btnDisabled = document.querySelectorAll(".estado");

        //Evento para cargar los datos en el modal
        btnEdit.forEach((btn) => {
            btn.addEventListener("click", async(e) => {
                id = e.currentTarget.getAttribute("id-data");
                idmarca.setAttribute("id-mar", id);
                await cargarDatosModal(id);
            });
        });

        //Evento para editar el nombre de la marca
        formUpdateMarca.addEventListener("submit", async (e) => {
            e.preventDefault();
            try{
                const id = idmarca.getAttribute("id-mar");
                const marca = idmarca.value;
                const inputMarca = marca.trim();
                idmarca.classList.remove("is-invalid");
                const spanError = document.querySelector(".text-danger");
                if(spanError){
                    spanError.remove();
                }
                if(await showConfirm("¿Estás seguro de actualizar la marca?")){
                    const data = await updateMarca(id, inputMarca);
                    const estado = data[0].estado;
                    if(estado){
                        showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                        await CargarMarcas();
                    } else{
                        idmarca.classList.add("is-invalid");
                        const span = document.createElement("span");
                        span.classList.add("text-danger");
                        span.innerHTML = `${data[0].mensaje}`;
                        idmarca.insertAdjacentElement("afterend", span);
                    }
                }
            }catch(error){
                console.error("Error al actualizar la marca: ", error);
            }
        });

        btnDisabled.forEach((btn) => {
            btn.addEventListener("click", async(e) => {
                id = e.currentTarget.getAttribute("id-data");
                const status = e.currentTarget.getAttribute("status");
                console.log("ID:", id, "Status:", status);
                if(await showConfirm("¿Estás segurp de cambiar el estado de la marca?")){
                    const data = await updateEstado(id, status);
                    const estado = data[0].estado_marca;
                    if(estado){
                        showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                        await CargarMarcas();
                    } else{
                        showToast(`${data[0].mensaje}`, "error", "ERROR");
                    }
                }
            });
        });
    }

    // Función para renderizar la tabla Datatable
    function RenderDatatableMarcas() {
        if (dtmarca) {
            dtmarca.destroy(); // Destruir si ya existe
        }

        // Inicializar el Datatable
        dtmarca = new DataTable("#table-marcas", {
            columnDefs: [
                { width: "25%", targets: 0 },
                { width: "25%", targets: 1 }
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
                    sSortDescending: ": Activar para ordenar la columna de manera descendente"
                },
            },
        });
    }
});
