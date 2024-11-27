document.addEventListener("DOMContentLoaded", () => {
    function $(selector) {
        return document.querySelector(selector);
    }

    async function ObtenerPedidoId(id) {
        const params = new URLSearchParams();
        params.append('operation', 'GetPedido');
        params.append('idpedido', id);

        try {
            const response = await fetch(`../../controller/pedido.controller.php?${params}`);
            const data = await response.json();
           // console.log(data);
            return data;
        } catch (error) {
            console.log("Error al obtener el idpedido", error);
        }

    }





     let dtpedido;
    // // referencias a los elementos del modal
    // const modal = $("#edits-pedido");
    // const inputdocumento = modal.querySelector("#update-nro-doc");//numero del cliente
    // const inputtipocliente = modal.querySelector("#update-cliente");
    // const inputnombres = modal.querySelector("#update-nombres");
    // const inputapepaterno = modal.querySelector("#update-appaterno");
    // const inputapematerno = modal.querySelector("#update-apmaterno");
    // const inputrazon = modal.querySelector("#update-razon-social");
    // const inputdireccion = modal.querySelector("#update-direccion-cliente");

    let idpedido;

    const modal = $("#edits-pedido");
    const inputdocumento = modal.querySelector("#update-nro-doc");
    const inputtipocliente = modal.querySelector("#update-cliente");
    const inputnombres = modal.querySelector("#update-nombres");
    const inputapepaterno = modal.querySelector("#update-appaterno");
    const inputapematerno = modal.querySelector("#update-apmaterno");
    const inputrazon = modal.querySelector("#update-razon-social");
    const inputdireccion = modal.querySelector("#update-direccion-cliente");

    async function cargarDatosModal(id) {
        try {
            const data = await ObtenerPedidoId(id);
            console.log(data);

            if (data && data.length > 0) {
                console.log("hola " + data);
                modal.setAttribute("id-pedido", data[0].idpedido);
                inputdocumento.value = data[0].documento;
                inputtipocliente.value = data[0].tipo_cliente;
                inputapematerno.value = data[0].apmaterno;
                inputapepaterno.value = data[0].appaterno;
                inputnombres.value = data[0].nombres;
                inputrazon.value = data[0].razonsocial;
                inputdireccion.value = data[0].direccion_cliente;
                $("#addProducto").removeAttribute("disabled");
            }

        } catch (error) {
            console.log("No es posible cargar los datos", error);
        }
    }

    function RenderDatatablePedidos() {
        if (dtpedido) {
            dtpedido.destroy();
        }

        dtpedido = new DataTable("#table-pedidos", {

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



    async function cargarPedidos() {
        if (dtpedido) {
            dtpedido.destroy();
            dtpedido = null;
        }

        const Tablapedidos = $("#table-pedidos tbody");
        let tableContent = ""; // Asegúrate de inicializar la variable para evitar errores

        try {
            const response = await fetch(`../../controller/pedido.controller.php?operation=getAll`);
            const data = await response.json();
            if (data.length > 0) {
                data.forEach(element => {
                    let estadoClass;
                    let editButtonClass = "btn-warning"; // Clase de botón para editar
                    let editButtonDisabled = ""; // Variable para verificar si el botón debe estar deshabilitado
                    let bgbtn;
                    switch (element.estado) {
                        case "Enviado":
                            estadoClass = "text-success";
                            editButtonClass = "btn-warning disabled"; // Botón deshabilitado
                            editButtonDisabled = "disabled"; // Deshabilitar el botón
                            bgbtn = "btn-success";

                            break;
                        case "Cancelado":
                            estadoClass = "text-danger";
                            editButtonClass = "btn-warning disabled"; // Botón deshabilitado
                            editButtonDisabled = "disabled"; // Deshabilitar el botón
                            bgbtn = "btn-danger";
                            break;
                        case "Entregado":
                            estadoClass = "text-primary";
                            editButtonClass = "btn-warning disabled"; // Botón deshabilitado
                            editButtonDisabled = "disabled"; // Deshabilitar el botón
                            bgbtn = "btn-success";
                            break;
                        case "Pendiente":
                            estadoClass = "text-warning";
                            bgbtn = "btn-success";
                            break;
                    }

                    const icons = element.estado === "Enviado" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";


                    tableContent += `
                    <tr>
                        <td>${element.idpedido}</td>
                        <td>${element.tipo_cliente}</td>
                        <td>${element.documento}</td>
                        <td>${element.cliente}</td>
                        <td>${element.create_at}</td>
                        <td><strong class="${estadoClass}">${element.estado}</strong></td>
                        <td>
                            <div 
                            class="d-flex justify-content-center"
                            
                            >
                                <a id-data="${element.idpedido}" class="btn ${editButtonClass}" data-bs-toggle="modal" data-bs-target="#edits-pedido" ${editButtonDisabled}>
                                    <i class="bi bi-pencil-square fs-5"></i>
                                </a>
                                <a id-data="${element.idpedido}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                                    <i class="${icons}"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                `;
                });
                Tablapedidos.innerHTML = tableContent;

                const editButtons = document.querySelectorAll(".btn-warning");
                editButtons.forEach((btn) => {
                    btn.addEventListener("click", async (e) => {
                        const id = e.currentTarget.getAttribute("id-data");
                        console.log(id);
                        await cargarDatosModal(id);
                    });
                });
            }





            RenderDatatablePedidos();
        } catch (error) {
            console.log("Error al cargar los pedidos", error);
        }
    }
    cargarPedidos();
});