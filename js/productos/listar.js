
// ! : NO TOQUES ESTE CODIGO, PORQUE TODO YA ESTA CORRECTO DESDE EL EDITAR
// ! : Y CAMBIAR SU ESTADO

document.addEventListener("DOMContentLoaded", function () {
  function $(object = null) { return document.querySelector(object); }
  let dtproductos;

  const modal = $("#edit-producto");
  const inputproducto = modal.querySelector("#nombreproducto");
  const inputcodigo = modal.querySelector("#codigo");
  const inputmarca = modal.querySelector("#idmarca");
  const inputcategoria = modal.querySelector("#idcategoria");
  const inputsubcategoria = modal.querySelector("#idsubcategoria");
  const inputpresentacion = modal.querySelector("#cantidad_presentacion");
  const inputprecio_compra = modal.querySelector("#precio_compra");
  const inputprecio_mayorista = modal.querySelector("#precio_mayorista");
  const inputprecio_minorista = modal.querySelector("#precio_minorista");
  const inputunidadmedida = modal.querySelector("#idunidadmedida");
  const idproducto = modal.querySelector("#idproducto");
  const proveedor = document.querySelector("#idproveedor");

  let idmarca, idsubcategoria, idunidadmedida;

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
        idproducto.value = data[0].idproducto;
        proveedor.value = data[0].idproveedor;
        proveedor.setAttribute('id-proveedor', data[0].idproveedor);
        inputproducto.value = data[0].nombreproducto;
        inputcodigo.value = data[0].codigo;
        inputpresentacion.value = data[0].cantidad_presentacion;
        inputmarca.value = data[0].idmarca;
        inputcategoria.value = data[0].idcategoria;
        inputsubcategoria.value = data[0].idsubcategoria;
        inputprecio_compra.value = data[0].precio_compra;
        inputprecio_mayorista.value = data[0].precio_mayorista;
        inputprecio_minorista.value = data[0].precio_minorista;
        inputunidadmedida.value = data[0].idunidadmedida;

        // Llamar a obtenerMarca y obtenerUnidades después de establecer el atributo id-proveedor
        obtenerMarca(data[0].idmarca);
        obtenerUnidades(data[0].idunidadmedida);
      }
    } catch (error) {
      console.log("No es posible cargar el modal:", error);
    }
  }

  async function obtenerMarca(selectedMarcaId) {
    const id = proveedor.getAttribute('id-proveedor');
    console.log(id);
    const params = new URLSearchParams();
    params.append('operation', 'getMarcas');
    params.append('id', id);

    try {
      const response = await fetch(`../../controller/marca.controller.php?${params}`);
      const data = await response.json();
      console.log(data);

      const selectMarca = document.querySelector('#idmarca');
      selectMarca.innerHTML = ''; // Limpiar opciones anteriores
      data.marcas.forEach(element => {
        const tagoption = document.createElement('option');
        tagoption.value = element.idmarca;
        tagoption.textContent = element.marca;
        if (element.idmarca == selectedMarcaId) {
          tagoption.selected = true;
        }
        selectMarca.appendChild(tagoption);
      });

      // Agregar evento change para cargar categorías cuando se seleccione una marca
      selectMarca.addEventListener('change', function () {
        idmarca = this.value;
        console.log("Marca seleccionada:", idmarca);
        ObtenerCategorias(idmarca);
      });

      // Cargar categorías para la marca seleccionada inicialmente
      ObtenerCategorias(selectedMarcaId);

    } catch (error) {
      console.error("Error al obtener las marcas:", error);
    }
  }

  async function ObtenerCategorias(marcaId) {
    const params = new URLSearchParams();
    params.append('operation', 'getmarcas_categorias');
    params.append('idmarca', marcaId);
    try {
      const response = await fetch(`../../controller/marca.controller.php?${params}`);
      const data = await response.json();
      console.log(data);
      const selectCategoria = document.querySelector('#idcategoria');
      selectCategoria.innerHTML = ''; // Limpiar opciones anteriores
      data.forEach(element => {
        const tagoption = document.createElement('option');
        tagoption.value = element.idcategoria;
        tagoption.textContent = element.categoria;
        if (element.idcategoria == inputcategoria.value) {
          tagoption.selected = true;
        }
        selectCategoria.appendChild(tagoption);
      });

      // Agregar evento change para cargar subcategorías cuando se seleccione una categoría
      selectCategoria.addEventListener('change', function () {
        idsubcategoria = this.value;
        console.log("Categoría seleccionada:", idsubcategoria);
        obtenerSubcategorias(idsubcategoria);
      });

      // Cargar subcategorías para la categoría seleccionada inicialmente
      obtenerSubcategorias(inputcategoria.value);

    } catch (error) {
      console.error("Error al obtener las categorías:", error);
    }
  }

  async function obtenerSubcategorias(categoriaId) {
    const params = new URLSearchParams();
    params.append('operation', 'getSubcategorias');
    params.append('idcategoria', categoriaId);
    try {
      const response = await fetch(`../../controller/subcategoria.controller.php?${params}`);
      const data = await response.json();
      console.log(data);
      const selectSubcategoria = document.querySelector('#idsubcategoria');
      selectSubcategoria.innerHTML = ''; // Limpiar opciones anteriores
      data.forEach(element => {
        const tagoption = document.createElement('option');
        tagoption.value = element.idsubcategoria;
        tagoption.textContent = element.subcategoria;
        if (element.idsubcategoria == inputsubcategoria.value) {
          tagoption.selected = true;
        }
        selectSubcategoria.appendChild(tagoption);
      });

    } catch (error) {
      console.error("Error al obtener las subcategorías:", error);
    }
  }

  async function obtenerUnidades(selectedUnidadId) {
    try {
      const response = await fetch(`../../controller/unidades.controller.php?operation=getUnidades`);
      const data = await response.json();
      console.log(data);
      const selectUnidad = document.querySelector('#idunidadmedida');
      selectUnidad.innerHTML = ''; // Limpiar opciones anteriores
      data.forEach(element => {
        console.log(element);
        const tagoption = document.createElement('option');
        tagoption.value = element.idunidadmedida;
        tagoption.textContent = element.unidadmedida;
        if (element.idunidadmedida == selectedUnidadId) {
          tagoption.selected = true;
        }
        selectUnidad.appendChild(tagoption);
      });

      // Agregar evento change para manejar la selección de unidad de medida
      selectUnidad.addEventListener('change', function () {
        idunidadmedida = this.value;
        console.log("Unidad de medida seleccionada:", idunidadmedida);
      });

    } catch (error) {
      console.error("Error al obtener las unidades de medida:", error);
    }
  }
  obtenerUnidades();

  async function CargarDatos() {
    const Tablaproductos = $("#table-productos tbody");

    try {
      const response = await fetch(`../../controller/producto.controller.php?operation=getAll`);
      const data = await response.json();

      Tablaproductos.innerHTML = '';

      if (data.length > 0) {
        data.forEach(element => {
          const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
          const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-8" : "bi bi-toggle2-off fs-8";
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

    <a id-data="${element.idproducto}" class="btn btn-warning ${editDisabled}" data-bs-toggle="modal" data-bs-target=".edit-categoria"
      type="button" class="me-2" 
                           data-bs-toggle="tooltip" 
                           data-bs-placement="bottom" 
                           data-bs-title="Editar">
      <i class="bi bi-pencil-square fs-8"></i>
    </a>
    <a id-data="${element.idproducto}" class="btn ${bgbtn} estado" estado-cat="${element.status}"
      type="button" class="me-2" 
                           data-bs-toggle="tooltip" 
                           data-bs-placement="bottom" 
                           data-bs-title="Cambiar estado">
      <i class="${icons}"></i>
    </a>

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

                const data = await EliminarProducto(id, status);
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
        initializeTooltips();
        RenderDatatable();
      } else {
        Tablaproductos.innerHTML = '<tr><td colspan="5" class="text-center">No hay datos disponibles</td></tr>';
      }

    } catch (error) {
      console.error("Error al cargar productos:", error);
    }
  }

  async function EliminarProducto(idproducto, status) {
    try {
      const params = new URLSearchParams();
      params.append("operation", "UpdateEstado");
      params.append("idproducto", idproducto);
      params.append("estado", status);

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

  $("#formActualizarProducto").addEventListener("submit", async (e) => {
    e.preventDefault();

    const data = await UpdateProduct();
    console.log(data);

    if (data && data.length > 0 && data[0].status === 1) {
      showToast(data[0].mensaje, 'success', 'SUCCESS');
      // $("#edit-producto").close();
      dtproductos.destroy();
      CargarDatos();
    } else {
      showToast(data[0].mensaje, 'warning', 'WARNING');
    }

  });

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

        "oAria": {
          "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
          "sSortDescending": ": Activar para ordenar la columna de manera descendente"
        }
      }
    });
  }

  async function UpdateProduct() {
    idmarca = inputmarca.value;
    idsubcategoria = inputsubcategoria.value;
    idunidadmedida = inputunidadmedida.value;
    const params = new FormData();
    params.append("operation", "updateProducto");
    params.append("idmarca", idmarca);
    params.append("idsubcategoria", idsubcategoria);
    params.append("nombreproducto", inputproducto.value);
    params.append("idunidadmedida", idunidadmedida);
    params.append("cantidad_presentacion", inputpresentacion.value);
    params.append("codigo", inputcodigo.value);
    params.append("precio_compra", inputprecio_compra.value);
    params.append("precio_mayorista", inputprecio_mayorista.value);
    params.append("precio_minorista", inputprecio_minorista.value);
    params.append("idproducto", idproducto.value);

    params.forEach((value, key) => {
      console.log(key, value)

    });
    try {
      const response = await fetch(`../../controller/producto.controller.php`, {
        method: "POST",
        body: params
      });
      const data = await response.json();
      // console.log(data);
      return data;
    } catch (error) {
      console.error("Error al actualizar el producto:", error);
    }
  }

  

  CargarDatos();
});
