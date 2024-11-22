document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }
    let dtventa;

    async function CargarDatos() {
        const Tablaventas = $("#table-ventas tbody");

        const response = await fetch(`../../controller/ventas.controller.php?operation=getAll`);
        const data = await response.json();
        // console.log(data);

        Tablaventas.innerHTML = ''; // Limpiar contenido previo

        data.forEach(element => {
            const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.datos;
            const documento = element.tipo_cliente === 'Empresa' ? element.idempresaruc : element.idpersonanrodoc;
            Tablaventas.innerHTML += `
    <tr>
        <td><a href='#' class='text-primary info' 
            data-bs-toggle="modal" 
            data-bs-target="#generarReporte" 
            data-idpedido='${element.idventa}'>${element.idpedido}</a></td>
        <td>${element.tipo_cliente}</td>
        <td>${clienteNombre}</td>
        <td >${documento}</td>
        <td>${element.fecha_venta}</td>
        <td>
            <button class="btn btn-outline-danger info reporte" 
                data-idventa="${element.idventa}">
                <i class="fas fa-file-alt me-2"></i>
            </button>
            <button class="btn btn-warning estado" 
                data-bs-toggle="modal"
                data-bs-target="#cambiarestado"
                data-idventa="${element.idventa}"> 
                Estado
            </button>
        </td>
    </tr>
`;

        });

        if (dtventa) {
            dtventa.destroy(); // Destruir la tabla anterior si existe
        }
        RenderDatatable();

        // Añadir listeners a los botones de reporte
        const tagsreporte = document.querySelectorAll('.reporte');
        tagsreporte.forEach(element => {
            element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idventa = element.getAttribute("data-idventa");
                await Reporte(idventa); // Llamar a la función reporte
            });
        });

        const tagsinfo = document.querySelectorAll('.info');
        tagsinfo.forEach(element => {
            element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idpedido = element.getAttribute("data-idpedido");
                console.log(idpedido);
                await MostrarDetalle(idpedido); // Llamar a la función MostrarDetalle
            });
        });

        const tagestado = document.querySelectorAll('.estado');
        tagestado.forEach(element => {
            element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idventa = element.getAttribute("data-idventa"); // OBTENER idventa
                document.getElementById("cambiarestado").setAttribute("data-idventa", idventa); // ALMACENAR idventa EN EL MODAL
                console.log("idventa para actualizar: ", idventa);
            });
        });
    }

    async function RenderDatatable() {
        dtventa = new DataTable("#table-ventas", {
            columnDefs: [
                { width: "5%", targets: 0 },
                { width: "16%", targets: 1 },
                { width: "16%", targets: 2 },
                { width: "16%", targets: 3 },
                { width: "16%", targets: 4 },
                { width: "16%", targets: 5 }
            ],
            language: {
                lengthMenu: "Mostrar _MENU_ registros por página",
                zeroRecords: "No se encontraron registros",
                info: false,
                infoEmpty: false,
                search: "Buscar:"
            },
            info: false,
            ordering: false
        });
    }

    async function MostrarDetalle(idventa) {
        const Tablaventas = $("#table-pedidos tbody");

        const params = new URLSearchParams();
        params.append('operation', 'getByID');
        params.append('idventa', idventa);

        const response = await fetch(`../../controller/ventas.controller.php?${params}`);
        const data = await response.json();

        Tablaventas.innerHTML = '';

        data.forEach(element => {
            const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.datos;
            Tablaventas.innerHTML += `
            <tr>
                <td>${element.nombreproducto}</td>
                <td>${element.unidad_medida}</td>
                <td>${element.cantidad_producto}</td>
            </tr>
            `;

            $("#datos").value = clienteNombre;
        });
    }

    async function Reporte(idventa) {
        // Crear los parámetros para la solicitud
        const params = new URLSearchParams();
        params.append('operation', 'reporteVenta');
        params.append('idventa', idventa);

        try {
            // Realizar la solicitud al servidor
            const response = await fetch(`../../controller/ventas.controller.php?${params}`, {
                method: 'GET',
            });

            // Verificar si la respuesta es válida
            if (!response.ok) {
                throw new Error(`Error en la solicitud: ${response.status}`);
            }

            // Parsear los datos de la respuesta
            const data = await response.json();

            // Validar que los datos recibidos sean correctos
            if (data.length > 0 && data[0].comprobantepago) {
                // Abrir la página correspondiente según el comprobante de pago
                if (data[0].comprobantepago === 'Boleta') {
                    window.open(`../../reports/Ventas/Boleta/boleta.php?idventa=${idventa}`, '_blank');
                } else {
                    window.open(`../../reports/Ventas/Factura/factura.php?idventa=${idventa}`, '_blank');
                }
            } else {
                console.error("No se encontró información para la venta.");
                alert("No se encontró información para la venta.");
            }
        } catch (error) {
            console.error("Error en la función Reporte:", error);
            alert("Ocurrió un error al generar el reporte.");
        }
    }

    async function UpdateEstado(idventa, estado) {
        const params = new FormData();
        params.append('operation', 'upVenta');
        params.append('estado', estado);  // Usar el estado seleccionado
        params.append('idventa', idventa);  // Usar el idventa pasado

        const options = {
            method: 'POST',
            body: params
        };

        const response = await fetch(`../../controller/ventas.controller.php`, options);
        const data = await response.json();
        console.log(data);  // Verificar la respuesta del servidor
    }

    // Escuchar el evento de clic en el botón "Actualizar"
    $("#actualizar").addEventListener("click", async function (event) {
        event.preventDefault(); // Evitar que se recargue la página al enviar el formulario

        const estadoSeleccionado = document.getElementById("estado").value; // Obtener el valor del select
        const idventa = document.getElementById("cambiarestado").getAttribute("data-idventa"); // OBTENER idventa ALMACENADO EN EL MODAL

        // Verificar si se ha seleccionado una opción
        if (estadoSeleccionado === "") {
            alert("Por favor, seleccione un estado.");
        } else {
            console.log("Estado seleccionado: " + estadoSeleccionado);
            console.log("ID Venta: " + idventa);

            // Llamar a la función para actualizar el estado en el backend
            await UpdateEstado(idventa, estadoSeleccionado);
        }
    });

    CargarDatos();
});
