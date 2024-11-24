document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }
    let dtventa;

    async function CargarDatos(fechaSeleccionada = null) {
        const Tablaventas = $("#contenido-venta");
         console.log(Tablaventas);
      
        const url = fechaSeleccionada 
            ? `../../controller/ventas.controller.php?operation=getAll&fecha_venta=${fechaSeleccionada}` 
            : `../../controller/ventas.controller.php?operation=getAll`;
    
        const response = await fetch(url);
        const data = await response.json();
         console.log('Datos recibidos:', data);  // Verificar los datos recibidos
         dtventa.destroy();
        Tablaventas.innerHTML = ''; // Limpiar contenido previo
        
    
        
        data.forEach(element => {
            // console.log(data);
            // console.log(element)
            const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
            const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
            const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
            const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.datos;
            const documento = element.tipo_cliente === 'Empresa' ? element.idempresaruc : element.idpersonanrodoc;
          
            Tablaventas.innerHTML += `
                <tr>
                    <td><a href='#' class='text-primary info' 
                        data-bs-toggle="modal" 
                        data-bs-target="#generarReporte"
                        data-idpedido='${element.idventa}'>${element.idpedido}</a>
                    </td>
                    <td>${element.tipo_cliente}</td>
                    <td>${clienteNombre}</td>
                    <td>${documento}</td>
                    <td>${element.fecha_venta}</td>
                    <td><strong class="${estadoClass}">
                    ${element.estado}
                    </strong></td>
                    <td>
                        <button class="btn btn-outline-danger info reporte" 
                            data-idventa="${element.idventa}"
                             >
                            <i class="fas fa-file-alt me-2"></i>

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
        RenderDatatable();
    
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
      
    (()=>{
        RenderDatatable();
    })();

    async function RenderDatatable() {
        dtventa = new DataTable("#table-ventas", {
            columnDefs: [
                { width: "10%", targets: 0 },
                { width: "15%", targets: 1 },
                { width: "16%", targets: 2 },
                { width: "16%", targets: 3 },
                { width: "16%", targets: 4 },
                { width: "10%", targets: 5 },
                { width: "10%", targets: 6 }
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
        const params = new URLSearchParams();
        params.append('operation', 'reporteVenta');
        params.append('idventa', idventa);

        try {
            const response = await fetch(`../../controller/ventas.controller.php?${params}`, {
                method: 'GET',
            });

            if (!response.ok) {
                throw new Error(`Error en la solicitud: ${response.status}`);
            }

            const data = await response.json();

            if (data.length > 0 && data[0].comprobantepago) {
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
        params.append('estado', estado);
        params.append('idventa', idventa);

        const options = {
            method: 'POST',
            body: params
        };

        const response = await fetch(`../../controller/ventas.controller.php`, options);
        const data = await response.json();
        console.log(data);
    }

    // Filtrar ventas por fecha cuando se seleccione una nueva fecha
    $("#filtrar").addEventListener("click", () => {
        const fechaSeleccionada = $("#fecha-venta").value;
       CargarDatos(fechaSeleccionada);
        
   
    });

    // Llamar a CargarDatos sin filtro inicialmente
    CargarDatos();
});
