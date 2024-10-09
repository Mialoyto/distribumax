document.addEventListener("DOMContentLoaded", function() {
  function $(object = null) { return document.querySelector(object); }
  let dtcategoria;

  async function CargarDatos() {
      const Tablacategorias = $("#table-categorias tbody");

      // Llamada al controlador para obtener todas las categorías
      const response = await fetch(`../../controller/categoria.controller.php?operation=getAll`);
      const data = await response.json();
      console.log(data);

      Tablacategorias.innerHTML = '';
      data.forEach(element => {
          Tablacategorias.innerHTML += `
          <tr>
              <td>${element.categoria}</td> 
              <td class="text-start">${element.create_at}</td>
              <td>${element.estado === "1" ? "Activo" : "Inactivo"}</td>
          </tr>
          `;
      });

      // Destruir la tabla si ya existe
      if (dtcategoria) {
          dtcategoria.destroy();
      }
      RenderDatatable();
  }

  CargarDatos();

  // Función para inicializar DataTable
  function RenderDatatable() {
      dtcategoria = new DataTable("#table-categorias", {
          columnDefs: [
              { width: "35%", targets: 0 },  // Nombre de la categoría
              { width: "35%", targets: 1 },  // Fecha de creación
              { width: "30%", targets: 2 }   // Estado
          ],
          paging: true,
          searching: true,
          ordering: true
      });
  }
});
