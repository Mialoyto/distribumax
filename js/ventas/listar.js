document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) { return document.querySelector(object); }
  let dtventa;

  async function CargarDatos(fechaSeleccionada = null) {
    const Tablaventas = $("#contenido-venta");
    //console.log(Tablaventas);

    const url = fechaSeleccionada
      ? `../../controller/ventas.controller.php?operation=getAll&fecha_venta=${fechaSeleccionada}`
      : `../../controller/ventas.controller.php?operation=getAll`;

    const response = await fetch(url);
    const data = await response.json();
    dtventa.destroy();
    Tablaventas.innerHTML = ''; // Limpiar contenido previo



    data.forEach(element => {
      let estadoClass;
      let icons;
      let bgbtn;

      let ocultar;
      let reporte = "btn-outline-danger";
      let btnDisabled;
      switch (element.venta_estado) {
        case "Pendiente":
          estadoClass = "text-warning";
          icons = "bi bi-ban fs-6"
          bgbtn = "btn-danger";
          reporte = "disabled";

          break;

        case "Despachado":
          estadoClass = "text-primary";
          icons = "bi bi-toggle2-on fs-6";
          bgbtn = "btn-success disabled";
          break;
      }


      const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : element.datos;
      const documento = element.tipo_cliente === 'Empresa' ? element.idempresaruc : element.idpersonanrodoc;

      Tablaventas.innerHTML += `
                <tr>
                    <td>${element.numero_comprobante}</td>
                    <td><a href='#' class='text-primary info' 
                        data-bs-toggle="modal" 
                        data-bs-target="#generarReporte"
                        data-idpedido='${element.idventa}'>${element.idpedido}</a>
                    </td>
                    <td>${clienteNombre}</td>
                    <td>${documento}</td>
                    <td>${element.fecha_venta}</td>
                    <td><strong class="${estadoClass}">${element.venta_estado}</strong></td>
                    <td>
                      <div class="d-flex justify-content-start">
                        <div>
                            <a class="btn btn-outline-danger reporte ${reporte} " data-idventa="${element.idventa}"
                              type="button"  class="me-2" 
                              data-bs-toggle="tooltip" 
                              data-bs-placement="bottom" 
                              data-bs-title="Comprobante">
                                <i class="fas fa-file-alt me-6"></i>
                            </a>
                          </div>
                          <div>
                            <a id-data="${element.idventa}" class="btn ${bgbtn} estado ms-2"  estado-cat="${element.status_venta}"
                              id-ped="${element.idpedido}"
                              type="button"  class="me-2" 
                              data-bs-toggle="tooltip" 
                              data-bs-placement="bottom" 
                              data-bs-title="Cancelar venta">
                                <i class="${icons}"></i>
                            </a>
                          </div>
                        </div>
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
        console.log(idventa);
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

    const btnDisabled = document.querySelectorAll(".estado");
    const clase = document.querySelectorAll(".btn-danger")
    let id;
    btnDisabled.forEach((btn) => {
      btn.addEventListener("click", async (e) => {
        try {
          e.preventDefault();
          const condicion = e.currentTarget.getAttribute("estado-cat");
          const idventa = e.currentTarget.getAttribute("id-data");
          const idpedido = e.currentTarget.getAttribute("id-ped");
          console.log("Condicion:", condicion);
          console.log("IDVENTA:", idventa, "IDPEDIDO:", idpedido);
          if (await showConfirm("¿Estás seguro de cancelar la venta?")) {

            if (await cancelarVenta(condicion, idventa, idpedido)) {
              dtventa.destroy();
              CargarDatos();
              RenderDatatable();
            }
          }
        } catch (error) {
          console.error("Error al cambiar el estado de la subcategoría:", error);
        }
      });
    });

    initializeTooltips();
  }

  (() => {
    RenderDatatable();
  })();

  initializeTooltips();
  async function RenderDatatable() {
    dtventa = new DataTable("#table-ventas", {
      columnDefs: [
        { width: "5%", targets: 0 },
        { width: "5%", targets: 1 },
        { width: "10%", targets: 2 },
        { width: "20%", targets: 3 },
        { width: "16%", targets: 4 },
        { width: "10%", targets: 5 },
        { width: "10%", targets: 6 }

      ],
      language: {
        lengthMenu: "Mostrar _MENU_",
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

  /* async function UpdateEstado(idventa, condicion) {
    const params = new FormData();
    params.append('operation', 'upVenta');
    params.append('condicion', condicion);
    params.append('idventa', idventa);

    const options = {
      method: 'POST',
      body: params
    };

    const response = await fetch(`../../controller/ventas.controller.php`, options);
    const data = await response.json();
    console.log(data);
  } */

  // Filtrar ventas por fecha cuando se seleccione una nueva fecha
  $("#fecha-venta").addEventListener("input", () => {
    const fechaSeleccionada = $("#fecha-venta").value;
    CargarDatos(fechaSeleccionada);
  });


  // NOTE ESTA FUNCIÓN DEBE DE CANCELAR LA VENTA
  async function cancelarVenta(condicion, idventa, idpedido) {
    const params = new FormData();
    params.append('operation', 'cancelarVenta');
    params.append('condicion', condicion);
    params.append('idventa', idventa);
    params.append('idpedido', idpedido);

    const options = {
      method: 'POST',
      body: params
    };

    try {
      const response = await fetch(`../../controller/ventas.controller.php`, options);
      const data = await response.json();
      console.log(data);
      if (data.success) {
        showToast(`${data.message}`, 'success', 'SUCCESS');
        return true;
      } else {
        showToast(`${data.message}`, 'error', 'ERROR');
        return false;
      }


    } catch (error) {
      console.error("Error al cancelar la venta", error);
    }


  }

  // Llamar a CargarDatos sin filtro inicialmente
  CargarDatos();
});
