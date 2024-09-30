document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }
    let dtventa;
    
    async function CargarDatos() {
        const Tablaventas = $("#table-ventas tbody");
        
        const response = await fetch(`../../controller/ventas.controller.php?operation=getAll`);
        const data = await response.json();

        Tablaventas.innerHTML = ''; // Limpiar contenido previo
        data.forEach(element => {
            Tablaventas.innerHTML += `
            <tr>
                <td><a href='#' class='text-primary info' 
                    data-bs-toggle="modal" 
                    data-bs-target="#generarReporte" 
                    data-idpedido='${element.idpedido}'>${element.idpedido}</a></td>
                <td>${element.tipo_cliente}</td>
                <td>${element.productos}</td>
                <td>${element.cantidades}</td>
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
        const tagsinfo=document.querySelectorAll('.info');
        tagsinfo.forEach(element => {
            element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idpedido = element.getAttribute("data-idpedido");
                console.log(idpedido)
                await MostrarDetalle(idpedido); // Llamar a la función reporte

            });
        });
    };

    async function RenderDatatable() {
        dtventa = new DataTable("#table-ventas", {
            // language: { url: "../Spanish.json" }
        });
    };
    
    async function MostrarDetalle(idpedido) {
        
        const Tablaventas = $("#table-pedidos tbody");
        
        const response = await fetch(`../../controller/ventas.controller.php?operation=getAll`);
        const data = await response.json();

        Tablaventas.innerHTML = ''; // Limpiar contenido previo
        data.forEach(element => {
            Tablaventas.innerHTML += `
            <tr>
               
      
                <td>${element.productos}</td>
                <td>${element.cantidades}</td>
             
            </tr>
            `;
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
        if(data[0].tipo_cliente == 'Persona'){
        window.location.href=`../../views/Reportes/Boleta.php?idventa=${idventa}`;  
        }else{
            
                window.location.href=`../../views/Reportes/Factura.php?idventa=${idventa}`;
        
        }
      
    }
    
    //Reporte();
    CargarDatos();
});
