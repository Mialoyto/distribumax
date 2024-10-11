document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }
    let dtventa;

    async function CargarDatos() {
        const Tablaventas = $("#table-ventas tbody");

        const response = await fetch(`../../controller/ventas.controller.php?operation=historial`);
        const data = await response.json();
        console.log(data);
      
        Tablaventas.innerHTML = ''; // Limpiar contenido previo
            data.forEach(element => {
                const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.datos;
                const documento = element.tipo_cliente === 'Empresa' ? element.idempresaruc : element.idpersonanrodoc;
                Tablaventas.innerHTML += `
                <tr>
                    <td>
                        <a href='#' class='text-primary info' 
                            data-bs-toggle="modal" 
                            data-bs-target="#generarReporte" 
                            data-idpedido='${element.idventa}'>${element.idpedido}
                        </a>
                    </td>
                    <td>${element.tipo_cliente}</td>
                    <td>${clienteNombre}</td>
                    <td >${documento}</td>
                    <td>${element.fecha_venta}</td>
                    <td>
                      
                    </td>
                </tr>
                `;
            }); 
        
      

        if (dtventa) {
            dtventa.destroy(); // Destruir la tabla anterior si existe
        }
        RenderDatatable();

        // Añadir listeners a los botones de reporte
        const tagsestado = document.querySelectorAll('.estado');
        tagsestado.forEach(element => {
            element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idventa = element.getAttribute("data-idventa");
                // await Reporte(idventa); // Llamar a la función reporte
                 if(confirm("desea eliminar")){
                    UpdateEstado(idventa);
                 }
            });
        });

        const tagsinfo = document.querySelectorAll('.info');
        tagsinfo.forEach(element => {
            element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idventa = element.getAttribute("data-idpedido");
                await MostrarDetalle(idventa);
            });
        });

        
    }


    async function RenderDatatable() {
        dtventa = new DataTable("#table-ventas", {
            columnDefs: [
                { width: "5%", targets: 0 },  // Columna del contador de filas
                { width: "16%", targets: 1 }, // Ancho para la columna de Pedido
                { width: "16%", targets: 2 }, // Ancho para la columna de Tipo Cliente
                { width: "16%", targets: 3 }, // Ancho para la columna de Cliente
                { width: "16%", targets: 4 },
                { width: "16%", targets: 5 } // Ancho para la columna de Documento
            
            ],
            language: {
                lengthMenu: "Mostrar _MENU_ registros por página",
                zeroRecords: "No se encontraron registros",
                info: false,
                infoEmpty: false,
                //infoFiltered: "(filtrado de _MAX_ registros totales)",
                search: "Buscar:",
                
            },
            info:false,
            ordering:  false

        });
    }
    
    
    async function MostrarDetalle(idventa) {

        const Tablaventas = $("#table-pedidos tbody");

       const params = new URLSearchParams();
       params.append('operation','getByID');
       params.append('idventa',idventa);
       const response = await fetch(`../../controller/ventas.controller.php?${params}`)
        const data = await response.json();
      
        Tablaventas.innerHTML = '';

        data.forEach(element => {
            const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.datos;
            Tablaventas.innerHTML += `
            <tr>
                <td>${element.nombreproducto}</td>
                <td>${element.cantidad_producto}</td>
            </tr>
            `;

            $("#datos").value = clienteNombre;
        });
    }
 

    async  function UpdateEstado(idventa,estado){
        const params = new FormData();
        params.append('operation','upVenta');
        params.append('estado',1);
        params.append('idventa',idventa);

        const options ={
            method : 'POST',
            body   : params
        }
        const response = await fetch(`../../controller/ventas.controller.php`,options)
        const data = response.json()
        console.log(data)    
    }
    // async function Reporte(idventa) {
    //    const params = new FormData();
    //    params.append('operation', 'reporteVenta');
    //    params.append('idventa', idventa);
    //
    //    const option = {
    //        method: 'POST',
    //        body: params // Cambiar params a body
    //    };

    //    const response = await fetch(`../../controller/ventas.controller.php`, option);
    //    const data = await response.json();
    //    if (data[0].comprobantepago == 'Boleta') {
    //        window.open(`../../views/Reportes/Boleta.php?idventa=${idventa}`, '_blank');
    //    } else {
    //       window.open(`../../views/Reportes/Factura.php?idventa=${idventa}`, '_blank');
    //   }

    //}

    //Reporte();
    CargarDatos();
});
