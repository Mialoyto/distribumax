document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }
    let dtventa;
    
    async function CargarDatos() {
        const Tablaventas = $("#table-ventas tbody");
        
        const response = await fetch(`../../controller/ventas.controller.php?operation=getAll`);
        const data = await response.json();
    
        Tablaventas.innerHTML = ''; // Limpiar contenido previo
        data.forEach(element => {
            const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.nombres;
            const documetno =clienteNombre === 'Empresa'?element.idempresaruc :element.idpersonanrodoc;
            Tablaventas.innerHTML += `
            <tr>
                <td><a href='#' class='text-primary info' 
                    data-bs-toggle="modal" 
                    data-bs-target="#generarReporte" 
                    data-idpedido='${element.idpedido}'>${element.idpedido}</a></td>
                <td>${element.tipo_cliente}</td>
                <td>${clienteNombre}</td>
                <td>${documetno}</td>
                <td>${element.fecha_venta}</td>
                <td>
                    <button class="btn btn-primary info reporte" 
                        data-idventa="${element.idventa}">
                        Reporte
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
                console.log(idpedido)
                await MostrarDetalle(idpedido); // Llamar a la función reporte
            });
        });
    }
    

    async function RenderDatatable() {
        dtventa = new DataTable("#table-ventas", {
            columnDefs: [
                { width: "16%", targets: 0 }, // Ancho para la columna de Pedido
                { width: "16%", targets: 1 }, // Ancho para la columna de Tipo Cliente
                { width: "16%", targets: 2 }, // Ancho para la columna de Cliente
                { width: "16%", targets: 3 }, // Ancho para la columna de Documento
                { width: "16%", targets: 4 },
                { width: "16%", targets: 5 }  // Ancho para la columna de Fecha Venta
            ],
            // Puedes agregar más opciones aquí si es necesario
        });
    }
    
    
    async function MostrarDetalle(idpedido) {
        
        const Tablaventas = $("#table-pedidos tbody");
        
        const response = await fetch(`../../controller/ventas.controller.php?operation=getAll`);
        const data = await response.json();

        Tablaventas.innerHTML = '';
        
        data.forEach(element => {
        const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.nombres;
            Tablaventas.innerHTML += `
            <tr>
                <td>${element.nombreproducto}</td>
                <td>${element.cantidad_producto}</td>
            </tr>
            `;

            $("#datos").value=clienteNombre;
        });
    }
    
    async function Reporte(idventa) {
        const params = new FormData();
        params.append('operation', 'reporteVenta');
        params.append('idventa', idventa);
       
        const option = {
            method: 'POST',
            body: params // Cambiar params a body
        };
    
        const response = await fetch(`../../controller/ventas.controller.php`, option);
        const data = await response.json();
        if(data[0].comprobantepago == 'Boleta'){
            window.location.href=`../../views/Reportes/Boleta.php?idventa=${idventa}`;  
        }else{
            
            window.location.href=`../../views/Reportes/Factura.php?idventa=${idventa}`;
        
        }
      
    }
    
    //Reporte();
    CargarDatos();
});
