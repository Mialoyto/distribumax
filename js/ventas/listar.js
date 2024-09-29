document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }
    let tagsinfo = null;
    let dtventa;

    async function CargarDatos() {
        const Tablaventas = $("#table-ventas tbody");
        
        const response = await fetch(`../../controller/ventas.controller.php?operation=getAll`);
        const data = await response.json();

        Tablaventas.innerHTML = ''; // Limpiar contenido previo
        data.forEach(element => {
            Tablaventas.innerHTML += `
            <tr>
                <td><a href='#' class='text-primary info' data-idventa='${element.idventa}'>${element.idpedido}</a></td>
                <td>${element.tipo_cliente}</td>
                <td>${element.productos}</td>
                <td>${element.cantidades}</td>
                <td>${element.fecha_venta}</td>
                <td>
                    <a href='#' data-idventa='${element.idventa}' class='btn btn-primary reporte'>Reporte</a>
                </td>
            </tr>
            `;
        });

        if (dtventa) {
            dtventa.destroy(); // Destruir la tabla anterior si existe
        }
        RenderDatatable();

        // Añadir listeners a los enlaces de reporte
        tagsinfo = document.querySelectorAll('.reporte');
        tagsinfo.forEach(element => {
            element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idventa = element.getAttribute("data-idventa");
                await reporte(idventa); // Llamar a la función reporte
            });
        });
    };

    async function RenderDatatable() {
        dtventa = new DataTable("#table-ventas", {
            // language: { url: "../Spanish.json" }
        });
    };

    async function reporte(idventa) {
        const params = new FormData();
        params.append('operation', 'reporteVenta');
        params.append('idventa', idventa);

        const options = {
            method: 'POST',
            body: params
        };

        const response = await fetch(`../../controller/ventas.controller.php`, options);
        const data = await response.json();
           
        if (data.success) { // Verifica si la respuesta es exitosa
            window.open(`../../views/Reportes/reporte.php?idventa=${idventa}`, '_blank');
          //const ventana =  window.location.href=`../../views/Reportes/reporte.php?idventa=${idventa}`;
          console.log(ventana)
        } else {
            //alert('Error al generar el reporte.'); // Mensaje de error si falla
        }      
    }

    CargarDatos();
});
