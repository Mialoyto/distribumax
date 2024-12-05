document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }

    let dtcompras;

    async function CargarCompras() {
        try {
            const response = await fetch(`../../controller/compras.controller.php?operation=getAll`);
            const data = await response.json();
            console.log(data)
            const tableContent = $("#table-compras tbody");
            tableContent.innerHTML = "";
            // let bgbtn = "";
            data.forEach(element => {
                const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
                const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-6" : "bi bi-toggle2-off fs-6";
                const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
                tableContent.innerHTML += `
                    <tr>
                    <td>${element.numcomprobante}</td>  c.idcompra,
                    <td>${element.proveedor}</td>
                    <td>${element.fechaemision}</td>
           
                    <td><strong class="${estadoClass}">${element.estado}</strong></td>
                    <td>
                    <div class="d-flex justify-content-center">
                      <div class="btn-group btn-group-sm" role="group">
                               
                    <button class="btn 
                    btn-outline-danger reporte" 
                    data-idcompra="${element.idcompra}"
                    type="button" class="me-2" 
                    data-bs-toggle="tooltip" 
                    data-bs-placement="bottom" 
                    data-bs-title="Reporte">
                    <i class="fas fa-file-alt me-6"></i>
                    </button>    
                        <a 
                        id-data="${element.idcompra}" 
                        class="btn ${bgbtn} estado" 
                        estado-cat="${element.status}"
                        type="button"  
                        data-bs-toggle="tooltip" 
                        data-bs-placement="bottom" 
                        data-bs-title="Cambiar estado">
                        <i class="${icons}"></i>
                        </a>
                
                      </div>
                    </div>
                    </td>
                    </tr>`
            });

            const btnDisabled = document.querySelectorAll(".estado");
            btnDisabled.forEach((btn) => {
              btn.addEventListener("click", async (e) => {
                try {
                  e.preventDefault();
                  id = e.currentTarget.getAttribute("id-data");
                  const status = e.currentTarget.getAttribute("estado-cat");
                  console.log("ID:", id, "Status:", status);
                  if (await showConfirm("¿Estás seguro de cambiar el estado de la subcategoría?")) {
                     const data = await updateEstado(status,id);
                    console.log("Estado actualizado correctamente:", data);
           
                     dtcompras.destroy();
                
                     CargarCompras();
                  } else {
                    console.error("El atributo id-data o status es null o undefined.");
                  }
                } catch (error) {
                  console.error("Error al cambiar el estado de la subcategoría:", error);
                }
              });
            });

            const tagsinfo = document.querySelectorAll('.reporte');
            tagsinfo.forEach(element => {
              element.addEventListener("click", async (event) => {
                event.preventDefault();
                const idpedido = element.getAttribute("data-idcompra");
                console.log(idpedido);
                await GenerarReporte(idpedido); // Llamar a la función MostrarDetalle
              });
            });
              initializeTooltips();
  
            RenderDatatable();
        } catch (e) {
            console.error(e);
        }
    }

  
    async function updateEstado( estado,id) {
        const params = new FormData();
        params.append('operation', 'updateEstado');
        params.append('estado', estado);
        params.append('idcompra', id);
        try {
            const response = await fetch(`../../controller/compras.controller.php`,{
                method : 'POST',
                body : params
            });
            const data = await response.json();
            console.log(data);
            return data;
        } catch (error) {
            console.error("Error al actualizar el estado de la compra:", error);
        }
        
    }


    async function GenerarReporte(id) {
     
      const params = new URLSearchParams();
      params.append('operation', 'reporte');
      params.append('idcompra', id);
      try {
          const response = await fetch(`../../controller/compras.controller.php?${params}`);
          const data = await response.json();
          if(!data){
              console.error("No se pudo generar el reporte de la compra.");
          }else
          {
            window.open(`../../reports/Compras/compra.php?idcompra=${id}`, '_blank');
          }
          return data;
      } catch (error) {
          console.error("Error al generar el reporte de la compra:", error);
      }
    }

    function RenderDatatable() {
        dtcompras = new DataTable("#table-compras", {

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

    CargarCompras();

});