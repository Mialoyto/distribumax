document.addEventListener("DOMContentLoaded", function () {
  function $(object = null) { return document.querySelector(object); }
  let dtproductos;
  let idmarca;
  const modal = $("#edit-producto");
  const inputproducto = modal.querySelector("#nombreproducto");
  const inputcodigo = modal.querySelector("#codigo");
  const inputmarca = modal.querySelector("#idmarca");
  const inputcategoria = modal.querySelector("#categoria");
  const inputsubcategoria = modal.querySelector("#idsubcategoria");
  const inputprecio_compra = modal.querySelector("#precio_compra");
  const inputprecio_mayorista = modal.querySelector("#precio_mayorista");
  const inputprecio_minorista = modal.querySelector("#precio_minorista");
  const inputunidadmedida = modal.querySelector("#idunidadmedida");
  const idproducto = modal.querySelector("#idproducto");

  async function Getproducto(id) {
    const params = new URLSearchParams();
    params.append('operation', 'ObtenerProducto');
    params.append('idproducto', id);

    try {
      const response = await fetch(`../../controller/producto.controller.php?${params}`);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (error) {
      console.log("Error al buscar un producto", error);
    }
  }

  async function CargarModal(id) {
    try {
      const data = await Getproducto(id);
      if (data) {
        // idproducto.value = data.idproducto;
        inputproducto.value = data[0].nombreproducto;
        inputcodigo.value = data[0].codigo;
        inputmarca.value = data[0].idmarca;
        inputcategoria.value = data[0].categoria;
        inputsubcategoria.value = data[0].idsubcategoria;
        inputprecio_compra.value = data[0].precio_compra;
        inputprecio_mayorista.value = data[0].precio_mayorista;
        inputprecio_minorista.value = data[0].precio_minorista;
        inputunidadmedida.value = data[0].idunidadmedida;
      }
    } catch (error) {
      console.log("No es posible cargar el modal:", error);
    }
  }

  async function CargarDatos() {
    const Tablaproductos = $("#table-productos tbody");

    try {
      const response = await fetch(`../../controller/producto.controller.php?operation=getAll`);
      const data = await response.json();

      Tablaproductos.innerHTML = '';

      if (data.length > 0) {
        data.forEach(element => {
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
          const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
          const editDisabled = element.estado === "Inactivo" ? "disabled" : "";
          Tablaproductos.innerHTML += `
                  <tr>
                      <td>${element.marca}</td>
                      <td>${element.categoria}</td>
                      <td>${element.nombreproducto}</td>
                      <td>${element.codigo}</td>
                      <td><strong class="${estadoClass}">${element.estado}</strong></td>
                      <td>
                           <div class="d-flex justify-content-center">
                      <a  id-data="${element.idproducto}" class="btn btn-warning ${editDisabled}" data-bs-toggle="modal" data-bs-target=".edit-categoria">
                        <i class="bi bi-pencil-square fs-5"></i>
                      </a>     
                      <a  id-data="${element.idproducto}" class="btn ${bgbtn} ms-2 estado" estado-cat="${element.status}">
                        <i class="${icons}"></i>
                      </a>

                      </div>
                      </td>
                  </tr>
                  `;
        });

        const clase = document.querySelectorAll(".btn-warning");
        const btnDisabled = document.querySelectorAll(".estado");
        let id;
        // Añadir eventos de eliminación a cada botón
        btnDisabled.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            try {
              e.preventDefault();
              id = e.currentTarget.getAttribute("id-data");
              const status = e.currentTarget.getAttribute("estado-cat");
              console.log("ID:", id, "Status:", status);
              if (await showConfirm("¿Estás seguro de cambiar el estado del producto?")) {
                
                const data = await EliminarProducto(id,status);
                console.log("Estado actualizado correctamente:", data);
                // Destruir y volver a renderizar la tabla
                dtproductos.destroy();
                CargarDatos();
              } else {
                console.error("El atributo id-data o status es null o undefined.");
              }
            } catch (error) {
              console.error("Error al cambiar el estado de la subcategoría:", error);
            }
          });
        });

        clase.forEach((btn) => {
          btn.addEventListener("click", (e) => {
            const id = e.currentTarget.getAttribute("id-data");
            CargarModal(id);
          });
        });

        RenderDatatable();
      } else {
        Tablaproductos.innerHTML = '<tr><td colspan="5" class="text-center">No hay datos disponibles</td></tr>';
      }
      
    } catch (error) {
      console.error("Error al cargar productos:", error);
    }
  }

  async function EliminarProducto(idproducto,status) {
    try {
      const params = new URLSearchParams();
      params.append("operation", "UpdateEstado");
      params.append("idproducto",idproducto);
      params.append("estado",status);

      const response = await fetch(`../../controller/producto.controller.php`, {
        method: "POST",
        body: params
      });
      const result = await response.json();
       return result;
    } catch (error) {
      console.error("Error en la solicitud de eliminación:", error);
    }
  }

  CargarDatos();

  // Función para inicializar DataTable
  function RenderDatatable() {
    dtproductos = new DataTable("#table-productos", {
     
      language: {
        "sEmptyTable": "No hay datos disponibles en la tabla",
        "info": "",
        "sInfoFiltered": "(filtrado de _MAX_ entradas en total)",
        "sLengthMenu": "Filtrar: _MENU_",
        "sLoadingRecords": "Cargando...",
        "sProcessing": "Procesando...",
        "sSearch": "Buscar:",
        "sZeroRecords": "No se encontraron resultados",
        "oPaginate": {
          "sFirst": "Primero",
          "sLast": "Último",
          "sNext": "Siguiente",
          "sPrevious": "Anterior"
        },
        "oAria": {
          "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
          "sSortDescending": ": Activar para ordenar la columna de manera descendente"
        }
      }
    });
  }
});


//  let selectSubcategoria;
//  let selectUnidad;
//  let subcategoria;
// // Cargar unidades de medida

  async function obtenerUnidadMedida(idmedida) {
    try {
      const response = await fetch(`../../controller/unidades.controller.php?operation=getUnidades`);
      const data = await response.json();
      const selectUnidad = document.getElementById('idunidadmedida');
      data.forEach(element => {
        const tagoption = document.createElement('option');
        tagoption.value = element.idunidadmedida;
        tagoption.textContent = element.unidadmedida;
        selectUnidad.appendChild(tagoption);
      });
      console.log(data);
    } catch (error) {
      console.error("Error al obtener las unidades:", error);
    }
    
  }


// Cargar subcategorías

    async function obtenersubcategoria(idsub) {
      try {
        const response = await fetch(`../../controller/subcategoria.controller.php?operation=getAll`);
        const data = await response.json();
        const selectSubcategoria = document.getElementById('idsubcategoria');
        
        data.forEach(element => {
          const tagoption = document.createElement('option');
          tagoption.value = element.idsubcategoria;
          tagoption.textContent = element.subcategoria;
          selectSubcategoria.appendChild(tagoption);
        });
        console.log(data);
      } catch (error) {
        console.error("Error al obtener las subcategorías:", error);
      }
    
      
    }


    async function obtenerMarca(idmarca) {
      try {
        const response = await fetch(`../../controller/marca.controller.php?operation=getAll`);
        const data = await response.json();
        const selectSubcategoria = document.getElementById('idmarca');
        data.forEach(element => {
          const tagoption = document.createElement('option');
          tagoption.value = element.idmarca;
          tagoption.textContent = element.marca;
          selectSubcategoria.appendChild(tagoption);
        });
        console.log(data);
      } catch (error) {
        console.error("Error al obtener las subcategorías:", error);
      }
    
    }

