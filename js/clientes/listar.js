document.addEventListener("DOMContentLoaded", function() {
    function $(object = null) { return document.querySelector(object); }
    let dtcliente;
  
    async function CargarDatos() {
        const Tablaclientes = $("#table-clientes tbody");
  
        const response = await fetch(`../../controller/cliente.controller.php?operation=getAll`);
        const data = await response.json();
        console.log(data);
  
        Tablaclientes.innerHTML = '';
        data.forEach(element => {
            const clienteNombre = element.tipo_cliente === 'Empresa' ? element.razonsocial : `${element.nombre} ${element.apellido}`;
            const documento = element.tipo_cliente === 'Empresa' ? element.idempresaruc : element.idpersonanrodoc;
  
            Tablaclientes.innerHTML += `
            <tr>
                <td>${element.tipo_cliente}</td>
                <td class="text-start">${element.fecha_creacion}</td>
                <td class="text-start">${element.fecha_actualizacion}</td>
                <td>${element.estado === "1" ? "Activo" : "Inactivo"}</td>
            </tr>
            `;
        });
  
        // Destroy the existing DataTable if it exists
        if (dtcliente) {
            dtcliente.destroy();
        }
        RenderDatatable();
    }
  
    CargarDatos();
  
    // Función para inicializar DataTable
    function RenderDatatable() {
      dtcliente = new DataTable("#table-clientes", {
          columnDefs: [
              { width: "25%", targets: 0 }, 
              { width: "25%", targets: 1 }, 
              { width: "25%", targets: 2 },
              { width: "25%", targets: 3 } 
          ],
          // Add this option if you want to enable pagination, searching, etc.
          paging: true,
          searching: true,
          ordering: true
      });
    }
  });
  