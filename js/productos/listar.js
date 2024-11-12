document.addEventListener("DOMContentLoaded", function () {
  function $(object = null) { return document.querySelector(object); }
  let dtproductos;

  async function CargarDatos() {
    const Tablaproductos = $("#table-productos tbody");

    try {
      const response = await fetch(`../../controller/producto.controller.php?operation=getAll`);
      const data = await response.json();

      Tablaproductos.innerHTML = '';

      if (data.length > 0) {
        data.forEach(element => {
          Tablaproductos.innerHTML += `
                  <tr>
                      <td>${element.marca}</td>
                      <td>${element.categoria}</td>
                      <td>${element.nombreproducto}</td>
                      <td>${element.codigo}</td>
                      <td>
                          <a href="#" class="btn btn-warning">
                              <i class="bi bi-pencil-fill"></i>
                          </a>
                          <a href="#" class="btn btn-danger eliminar" data-idproducto="${element.idproducto}">
                              <i class="bi bi-trash-fill"></i>
                          </a>
                      </td>
                  </tr>
                  `;
        });

        // Añadir eventos de eliminación a cada botón
        document.querySelectorAll(".eliminar").forEach(boton => {
          boton.addEventListener("click", async (event) => {
            event.preventDefault();
            const idproducto = boton.getAttribute("data-idproducto");

            if (confirm("¿Estás seguro de que deseas eliminar este producto?")) {
              await EliminarProducto(idproducto);
              CargarDatos(); // Recargar datos después de eliminar
            }
          });
        });
      } else {
        Tablaproductos.innerHTML = '<tr><td colspan="5" class="text-center">No hay datos disponibles</td></tr>';
      }
    } catch (error) {
      console.error("Error al cargar productos:", error);
    }
  }

  async function EliminarProducto(idproducto) {
    try {
      const params = new URLSearchParams();
      params.append("operation", "delete");
      params.append("idproducto", idproducto);

      const response = await fetch(`../../controller/producto.controller.php`, {
        method: "POST",
        body: params
      });

      const result = await response.json();
      if (result.success) {
        alert("Producto eliminado correctamente.");
      } else {
        alert("Error al eliminar el producto.");
      }
    } catch (error) {
      console.error("Error en la solicitud de eliminación:", error);
    }
  }

  CargarDatos();

  // Función para inicializar DataTable
  function RenderDatatable() {
    dtproductos = new DataTable("#table-productos", {
      columnDefs: [
        { width: "10%", targets: 0 },
        { width: "10%", targets: 1 },
        { width: "10%", targets: 2 },
        { width: "5%", targets: 3 },
        { width: "5%", targets: 4 }
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
