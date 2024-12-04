document.addEventListener("DOMContentLoaded", function () {
  function $(object = null) { return document.querySelector(object); }
  let dtcaclientes;
  // document.getElementById("exportExcel").addEventListener("click", function () {
  //   const table = $('#table-clientes').DataTable();
  //   const data = table.rows({ search: 'applied' }).data().toArray();

  //   // Enviar datos al servidor
  //   fetch('../../reports-excel/Clientes/exportar_excel.php', {
  //     method: 'POST',
  //     headers: {
  //       'Content-Type': 'application/json'
  //     },
  //     body: JSON.stringify({ data: data })
  //   })
  //     .then(response => response.blob())
  //     .then(blob => {
  //       const url = window.URL.createObjectURL(blob);
  //       const a = document.createElement('a');
  //       a.style.display = 'none';
  //       a.href = url;
  //       a.download = 'clientes.xlsx';
  //       document.body.appendChild(a);
  //       a.click();
  //       window.URL.revokeObjectURL(url);
  //     })
  //     .catch(error => console.error('Error al exportar a Excel:', error));
  // });

  
  // const modal= document.querySelector("#edit-cliente");
  // // const tipo_cliente = modal.querySelector("#tipo_cliente");
  // const nro_doc = modal.querySelector("#nro_doc");
  // const email = modal.querySelector("#email");
  // const telefono = modal.querySelector("#telefono");
  // const direccion = modal.querySelector("#direccion");

  async function GetCliente(id) {
    const params = new URLSearchParams();
    params.append('operation', 'obtenerCliente');
    params.append('idcliente', id);

    try {
      const response = await fetch(`../../controller/cliente.controller.php?${params}`);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (error) {
      console.log("Error al buscar un cliente", error);
    }
  }
  async function CargarModal(id) {
    try {
      const data = await GetCliente(id);
      console.log(data)
      if(data && data.lenght <0){
        console.log(data);
        tipo_cliente.value = data[0].tipo_cliente;
        nro_doc.value = data[0].nro_doc;
        email.value = data[0].email;
        telefono.value = data[0].telefono;
        direccion.value = data[0].direccion;
      }
    } catch (error) {
      console.log("No es posible cargar el modal:", error);
    }
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
      const editDisabled = element.estado === "Inactivo" ? "disabled" : "";
      tableClientes.innerHTML += `
        <tr>
          <td>${element.nro_doc}</td>
          <td>${element.tipo_cliente}</td>
          <td>${element.cliente}</td>
          <td>${element.provincia}</td>
          <td>${element.fecha_creacion}</td>
          <td><strong class="${estadoClass}">${element.estado}</strong></td>
          <td>
             <div class="d-flex justify-content-center">
  <div class="btn-group btn-group-sm" role="group">
   
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
        const idCliente = e.currentTarget.getAttribute('id-data');
        // console.log("ID Cliente:", idCliente);
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
          if (await showConfirm("¿Estás seguro de deshabilitar el cliente?")) {
            const data = await updateEstado(id,status);
            console.log("Estado actualizado correctamente:", data);
           
            dtcaclientes.destroy();
        
            CargarDatos();
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

  // async function deshabilitarCliente(estado, idCliente) {
  
 
  //       const params = new FormData();
  //       params.append("operation", "activeCliente");
  //       params.append("estado", estado);
  //       params.append("idcliente", idCliente);

  //       const options = {
  //         method: "POST",
  //         body: params
  //       }

  //       try{

  //         const response = await fetch(`../../controller/cliente.controller.php`, options);
  //         const data = await response.json();
  //         console.log(data);
  //         return data;

  //     } catch (error) {
  //       console.error("Error al deshabilitar el cliente :", error);
  //     }
  // }
  
  CargarDatos();

  function RenderDatatableClientes() {
    
    dtcaclientes = new DataTable("#table-clientes", {
      language: {
        "sEmptyTable": "No hay datos disponibles en la tabla",
        "info": "",
        "sInfoFiltered": "(filtrado de MAX entradas en total)",
        "sLengthMenu": "Filtrar: MENU",
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

  
 
});