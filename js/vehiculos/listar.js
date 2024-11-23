document.addEventListener("DOMContentLoaded", () => {
    function $(object = null) { return document.querySelector(object); }
    let dtvehiculo;
  
    // async function obtenerVehiculos(id) {
    //     const params = new URLSearchParams();
    //     params.append("operation", 'getVehiculo');
    //     params.append("idusuario", id);
    //     try {
    //         const response = await fetch(`../../controller/vehiculo.controller.php?${params}`);
    //         const data = await response.json();
    //         console.log("Datos obtenidos:", data);
    //         return data;
    //     } catch (error) {
    //         console.error("Error al obtener los vehiculos por ID:", error);
    //     }
    // }
  
    async function cargarDatosModal(id) {
      try {
        const modal = $("#form-veh");
        const inputConductor = modal.querySelector("#editConductor");
        const inputMarca = modal.querySelector("#editMarca");
        const inputModelo = modal.querySelector("#editModelo");
        const inputPlaca = modal.querySelector("#editPlaca");
        const inputCapacidad = modal.querySelector("#editCapacidad");
        const inputCondicion = modal.querySelector("#editCondicion");
  
        inputConductor.value = "Cargando....";
        inputMarca.value = "Cargando....";
        inputModelo.value = "Cargando....";
        inputPlaca.value = "Cargando....";
        inputCapacidad.value = "Cargando....";
        inputCondicion.value = "Cargando....";
  
        const data = await getVehiculo(id);
        console.log("Datos para el modal:", data);
  
        // Si hay datos, llenar los campos del modal
        if (data && data.length > 0) {
          inputConductor.setAttribute("id-vehiculo", data[0].idvehiculo);
          inputConductor.value = data[0].usuario;
          inputMarca.value = data[0].marca;
          inputMarca.setAttribute("id-vehiculo", data[0].idvehiculo);
          inputModelo.value = data[0].modelo;
          inputPlaca.value = data[0].placa;
          inputCapacidad.value = data[0].capacidad;
          inputCondicion.value = data[0].condicion;
        }
      } catch (error) {
        console.error("Error al cargar los datos en el modal:", error);
      }
    }
  
    function RenderDatatableVehiculos() {
      if (dtvehiculo) {
        dtvehiculo.destroy();
      }
  
      dtvehiculo = new DataTable("#table-vehiculos", {
        columnDefs: [
          { width: "20%", targets: 0 },
          { width: "20%", targets: 1 },
          { width: "20%", targets: 2 },
          { width: "10%", targets: 3 },
          { width: "10%", targets: 4 },
          { width: "10%", targets: 5 },
          { width: "10%", targets: 6 }
        ],
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
  
    async function CargarVehiculos() {
      if (dtvehiculo) {
        dtvehiculo.destroy();
        dtvehiculo = null;
      }
  
      try {
        const response = await fetch(`../../controller/vehiculo.controller.php?operation=getAll`);
        const data = await response.json();
        console.log("Datos de todos los vehiculos:", data);
  
        const TablaVehiculos = $("#table-vehiculos tbody");
        let tableContent = "";
  
        if (data.length > 0) {
          data.forEach(element => {
            const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
            const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
            const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
  
            element.estado === "Activo" ? "text-success" : "text-danger";
            tableContent += `
              <tr>
                  <td>${element.datos}</td>
                  <td>${element.marca_vehiculo}</td>
                  <td>${element.modelo}</td>
                  <td>${element.placa}</td>
                  <td>${element.capacidad}</td>
                  <td>${element.condicion}</td>
                  <strong class="${estadoClass}">
                  ${element.estado}
                  </strong>
                  <td>
                      <div class="d-flex justify-content-center">
                          <a id-data="${element.idvehiculo}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target=".edit-vehiculo">
                              <i class="bi bi-pencil-square fs-5"></i>
                          </a>
                          <a id-data="${element.idvehiculo}" class="btn ${bgbtn} ms-2 estado" status="${element.status}">
                              <i class="${icons}"></i>
                          </a>
                      </div>
                  </td>
              </tr>
            `;
          });
  
          TablaVehiculos.innerHTML = tableContent;
  
          const editButtons = document.querySelectorAll(".btn-warning");
          editButtons.forEach((btn) => {
            btn.addEventListener("click", async (e) => {
              const id = e.currentTarget.getAttribute("id-data");
              console.log(id);
              await cargarDatosModal(id);
            });
          });
  
          const statusButtons = document.querySelectorAll(".estado");
          statusButtons.forEach((btn) => {
            btn.addEventListener("click", async (e) => {
              try {
                const id = e.currentTarget.getAttribute("id-data");
                const status = e.currentTarget.getAttribute("status");
                console.log("ID:", id, "Status:", status);
                if (await showConfirm("¿Estás seguro de cambiar el estado del vehículo?")) {
                  const data = await updateEstadoVehiculo(id, status);
                  if (data[0].estado > 0) {
                    showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                    await CargarVehiculos();
                  } else {
                    showToast(`${data[0].mensaje}`, "error", "ERROR");
                  }
                }
              } catch (error) {
                console.error("Error al cambiar el estado del vehiculo:", error);
              }
            });
          });
  
        } else {
          TablaVehiculos.innerHTML = '<tr><td colspan="7" class="text-center">No hay datos disponibles</td></tr>';
        }
  
        RenderDatatableVehiculos();
  
      } catch (error) {
        console.error("Error al cargar los vehiculos:", error);
      }
    }
  
    CargarVehiculos();
  });
  