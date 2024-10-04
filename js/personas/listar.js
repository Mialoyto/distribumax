document.addEventListener("DOMContentLoaded", function() {
  function $(object = null) { return document.querySelector(object); }
  let dtpersonas;

  async function CargarDatos() {
      const Tablapersonas = $("#table-personas tbody");

      // Solicitar los datos al controlador
      const response = await fetch(`../../controller/persona.controller.php?operation=getAll`);
      const data = await response.json();
      console.log(data);

      Tablapersonas.innerHTML = ''; // Limpiar contenido previo

      data.forEach(element => {
          Tablapersonas.innerHTML += `
          <tr>
              <td>${element.tipo_documento}</td>
              <td>${element.idpersonanrodoc}</td>
              <td>${element.nombres}</td>
              <td>${element.appaterno}</td>
              <td>${element.apmaterno}</td>
              <td class="text-start">${element.distrito}</td>
              <td>${element.estado === "1" ? "Activo" : "Inactivo"}</td>
          </tr>
          `;
      });

      if (dtpersonas) {
          dtpersonas.destroy(); // Destruir la tabla anterior si ya existe
      }
      RenderDatatable(); // Inicializar DataTable nuevamente
  }

  CargarDatos();

  // Función para inicializar DataTable
  async function RenderDatatable() {
    dtpersonas = new DataTable("#table-personas", {
        columnDefs: [
            { width: "15%", targets: 0 }, 
            { width: "15%", targets: 1 }, 
            { width: "15%", targets: 2 },
            { width: "15%", targets: 3 },
            { width: "15%", targets: 4 },
            { width: "15%", targets: 5 },
            { width: "10%", targets: 6 }
        ],
    });
  }
});
