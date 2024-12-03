document.addEventListener("DOMContentLoaded", () => {

  // Activar tooltips en todos los elementos que los tengan
  initializeTooltips();

  function $(object = null) { return document.querySelector(object); }
  let dtvehiculo;

  // REFERENCIAS A LOS ELEMENTOS DEL MODAL
  const modal = $("#form-veh"); // MODAL FORMULARIO
  const inputConductor = modal.querySelector("#editConductor"); // INPUT CONDUCTOR
  const inputMarca = modal.querySelector("#editMarca"); // INPUT MARCA
  const inputModelo = modal.querySelector("#editModelo"); // INPUT MODELO
  const inputPlaca = modal.querySelector("#editPlaca"); // INPUT PLACA
  const inputCapacidad = modal.querySelector("#editCapacidad"); // INPUT CAPACIDAD
  const inputCondicion = modal.querySelector("#editCondicion");
  let idvehiculo;

  async function cargarDatosModal(id) {
    try {
      inputConductor.value = "Cargando....";
      inputMarca.value = "Cargando....";
      inputModelo.value = "Cargando....";
      inputPlaca.value = "Cargando....";
      inputCapacidad.value = "Cargando....";
      inputCondicion.value = "Cargando....";
      inputCapacidad.value = "Cargando....";

      const data = await getVehiculo(id);
      // console.log("Datos para el modal:", data);

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
    // SI YA EXISTE UNA INSTANCIA DE DATATABLE, DESTRUIRLA
    if (dtvehiculo) {
      dtvehiculo.destroy();
      dtvehiculo = null;
    }
    const TablaVehiculos = $("#table-vehiculos tbody");
    let tableContent = "";

    try {
      const response = await fetch(`../../controller/vehiculo.controller.php?operation=getAll`);
      const data = await response.json();
      let disponible;
      let classDisponible;
      if (data.length > 0) {
        data.forEach(element => {
           switch (element.disponible) {
            case 'Disponible':
             
              classDisponible = "text-success";
              break;
            case 'Ocupado':
              classDisponible = "text-warning";
              break;
        
           }
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
          const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
          const isDisabled = element.estado === "Inactivo" || element.status === 0 ? "disabled" : "";
          // CONTENIDO DE LA TABLA
          tableContent += `
              <tr>
                  <td>${element.datos}</td>
                  <td>${element.marca_vehiculo}</td>
                  <td>${element.modelo}</td>
                  <td>${element.placa}</td>
                  <td>${element.capacidad}</td>
                  <td>${element.condicion}</td>
                  <td class="${estadoClass} fw-bold">
                  ${element.estado}
                  </td>
                  <td><strong class="${classDisponible}">${element.disponible}</strong></td>
                  <td>
                      <div class="d-flex ">
                          <a id-data="${element.idvehiculo}" class="btn btn-warning ${isDisabled}" data-bs-toggle="modal"  data-bs-target=".edit-vehiculo">
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

        // INSERTAR EL CONTENIDO A LA TABLA
        TablaVehiculos.innerHTML = tableContent;

        const editButtons = document.querySelectorAll(".btn-warning");
        editButtons.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            const id = e.currentTarget.getAttribute("id-data");
            console.log(id);
            await cargarDatosModal(id);
          });
        });

        // ? EVENTO DEL FORMULARIO PARA ACTUALIZAR EL VEHICULO
        modal.addEventListener("submit", async (e) => {
          e.preventDefault();
          idvehiculo = inputMarca.getAttribute("id-vehiculo");
          const marca = inputMarca.value.trim();
          const modelo = inputModelo.value.trim();
          const placa = inputPlaca.value.trim();
          const capacidad = inputCapacidad.value.trim();
          const condicion = inputCondicion.value.trim();

          // TODO:  ESTA FUNCION SE ENCUENTRA EN EL ARCHIVO editar-vehiculo.js
          await formUpdateVehiculo(idvehiculo, marca, modelo, placa, capacidad, condicion, inputPlaca, modal);
          // RENDERIZAMOS LA TABLA DE VEHICULOS
          await CargarVehiculos();
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

        initializeTooltips();

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
