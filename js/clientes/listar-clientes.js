document.addEventListener("DOMContentLoaded", function () {
  function $(object = null) { return document.querySelector(object); }
  let dtcaclientes;
  document.getElementById("exportExcel").addEventListener("click", function () {
    const table = $('#table-clientes').DataTable();
    const data = table.rows({ search: 'applied' }).data().toArray();

    // Enviar datos al servidor
    fetch('../../reports-excel/Clientes/exportar_excel.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ data: data })
    })
      .then(response => response.blob())
      .then(blob => {
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.style.display = 'none';
        a.href = url;
        a.download = 'clientes.xlsx';
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
      })
      .catch(error => console.error('Error al exportar a Excel:', error));
  });


  function RenderDatatableClientes() {
    if (dtcaclientes) {
      dtcaclientes.destroy();
    }

    dtcaclientes = new DataTable("#table-clientes", {
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

  async function CargarDatos() {
    const response = await fetch(`../../controller/cliente.controller.php?operation=getAll`);
    const data = await response.json();
    console.log(data);
    const tableClientes = $("#table-clientes tbody");
    tableClientes.innerHTML = '';
    data.forEach(element => {
      const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
      const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-7" : "bi bi-toggle2-off fs-7";
      const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
      tableClientes.innerHTML += `
        <tr>
          <td>${element.nro_doc}</td>
          <td>${element.tipo_cliente}</td>
          <td>${element.cliente}</td>
  
          <td>${element.fecha_creacion}</td>
          <td><strong class="${estadoClass}">${element.estado}</strong></td>
          <td>
             <div class="d-flex justify-content-center">
  <div class="btn-group btn-group-sm" role="group">
    <a id-data="${element.idcliente}" class="btn btn-warning" data-bs-toggle="modal" data-bs-target=".edit-categoria">
      <i class="bi bi-pencil-square fs-7"></i>
    </a>
    <a id-data="${element.idcliente}" class="btn ${bgbtn} estado" estado-cat="${element.status}">
      <i class="${icons}"></i>
    </a>
  </div>
</div>
          </td>
        </tr>
      `;
    });

    // Agregar eventos a los botones de editar y eliminar
    document.querySelectorAll('.btn-warning').forEach(button => {
      button.addEventListener('click', (e) => {
        const idCliente = e.currentTarget.getAttribute('data-idcliente');
        CargarModal(idCliente);
      });
    });
    
    const btnDisabled = document.querySelectorAll(".estado");
    btnDisabled.forEach((btn) => {
      btn.addEventListener("click", async (e) => {
        try {
          e.preventDefault();
          id = e.currentTarget.getAttribute("id-data");
          const status = e.currentTarget.getAttribute("estado-cat");
          console.log("ID:", id, "Status:", status);
          if (await showConfirm("¿Estás seguro de cambiar el estado de la subcategoría?")) {
            const data = await deshabilitarCliente(status,id);
            console.log("Estado actualizado correctamente:", data);
            //  RenderDatatableClientes();

          } else {
            console.error("El atributo id-data o status es null o undefined.");
          }
        } catch (error) {
          console.error("Error al cambiar el estado de la subcategoría:", error);
        }
      });
    });

    RenderDatatableClientes();
  }

  async function deshabilitarCliente(estado, idCliente) {
  
      try {
        const params = new FormData();
        params.append("operation", "activeCliente");
        params.append("estado", estado);
        params.append("idcliente", idCliente);

        const options = {
          method: "POST",
          body: params
        }
        const response = await fetch(`../../controller/cliente.controller.php`, options);
        const data = await response.json();
        console.log(data);
        

      } catch (error) {
        console.error("Error al deshabilitar el cliente :", error);
      }
    }
  

  // async function CargarModal(idCliente) {
  //   try {
  //     const response = await fetch(`../../controller/cliente.controller.php?operation=getById&id=${idCliente}`);
  //     const data = await response.json();
  //     if (data) {
  //       document.getElementById('idcliente').value = data.idcliente;
  //       document.getElementById('nro_doc').value = data.nro_doc;
  //       document.getElementById('tipo_cliente').value = data.tipo_cliente;
  //       document.getElementById('cliente').value = data.cliente;
  //       document.getElementById('fecha_creacion').value = data.fecha_creacion;
  //       document.getElementById('estado').value = data.estado;
  //     }
  //   } catch (error) {
  //     console.log("No es posible cargar el modal:", error);
  //   }
  // }

  CargarDatos();
});