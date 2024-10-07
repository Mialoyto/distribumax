document.addEventListener("DOMContentLoaded", function() {
  function $(object = null) { return document.querySelector(object); }
  let dtpromocion;

  async function CargarDatos() {
      const Tablapromociones = $("#table-promociones tbody");

      // URL para obtener las promociones con el nombre del tipo de promoción
      const response = await fetch(`../../controller/promocion.controller.php?operation=getAll`);
      const data = await response.json();
      console.log(data);

      Tablapromociones.innerHTML = '';
      data.forEach(element => {
          Tablapromociones.innerHTML += `
          <tr>
              <td>${element.tipopromocion}</td>  <!-- Mostrar el nombre del tipo de promoción -->
              <td class="text-start">${element.descripcion}</td>
              <td class="text-start">${element.fechainicio}</td>
              <td class="text-start">${element.fechafin}</td>
              <td>${element.valor_descuento}</td>
          </tr>
          `;
      });

      // Destruir la tabla si ya existe
      if (dtpromocion) {
          dtpromocion.destroy();
      }
      RenderDatatable();
  }

  CargarDatos();

  // Función para inicializar DataTable
  function RenderDatatable() {
      dtpromocion = new DataTable("#table-promociones", {
          columnDefs: [
              { width: "20%", targets: 0 },  // Tipo de promoción
              { width: "30%", targets: 1 },  // Descripción
              { width: "15%", targets: 2 },  // Fecha inicio
              { width: "15%", targets: 3 },  // Fecha fin
              { width: "20%", targets: 4 }   // Valor descuento
          ],
          paging: true,
          searching: true,
          ordering: true
      });
  }
});
