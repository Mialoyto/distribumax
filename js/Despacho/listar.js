document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) { return document.querySelector(object) }




  async function CargarDatos() {
    const Tablaventas = $("#table-despacho tbody");

    const response = await fetch(`../../controller/despacho.controller.php?operation=listar`);
    const data = await response.json();
    // console.log(data);

    Tablaventas.innerHTML = ''; // Limpiar contenido previo

    data.forEach(element => {
      const estadoClass = element.estado === "Activo" ? "text-success" : "text-danger";
      const icons = element.estado === "Activo" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";
      const bgbtn = element.estado === "Activo" ? "btn-success" : "btn-danger";
      Tablaventas.innerHTML += `
        <tr>
    
            <td><a href='#' class='text-primary info' 
             data-bs-toggle="modal" 
            data-bs-target="#generarReporte"
            data-iddespacho='${element.iddespacho}'><p>DES-000` + `${element.iddespacho}</p></a></td>

            <td>${element.perfil}</td>
            <td>${element.datos}</td>
            <td>${element.vehiculo}</td>
            <td>${element.fecha_despacho}</td>
            <td> <strong class="${estadoClass}">
                    ${element.estado}
                    </strong>
            </td>
          <td>
    
    <button class="btn btn-outline-danger reporte" data-iddespacho="${element.iddespacho}">
        <i class="fas fa-file-alt me-2"></i>
    </button>
      <a  id-data="${element.iddespacho}" class="btn ${bgbtn} ms-2 estado" estado-cat="${element.status}">
                        <i class="${icons}"></i>
                      </a>

</td>

        </tr>
`;

    });

    const btnDisabled = document.querySelectorAll(".estado");
    const clase = document.querySelectorAll(".btn-danger")
    let id;

    clase.forEach((btn) => {
      btn.addEventListener("click", async (e) => {
        id = e.currentTarget.getAttribute("id-data");
        if (id) {
          console.log(id)
        } else {
          console.error("El atributo id-data es null o undefined.");
        }
      });
    });
    btnDisabled.forEach((btn) => {
      btn.addEventListener("click", async (e) => {
        try {
          e.preventDefault();
          id = e.currentTarget.getAttribute("id-data");
          const status = e.currentTarget.getAttribute("estado-cat");
          console.log("ID:", id, "Status:", status);
          if (await showConfirm("¿Estás seguro de cambiar el estado de la subcategoría?")) {
            const data = await updateEstado(id, status);
            console.log("Estado actualizado correctamente:", data);

          } else {
            console.error("El atributo id-data o status es null o undefined.");
          }
        } catch (error) {
          console.error("Error al cambiar el estado de la subcategoría:", error);
        }
      });
    });

    // if (dtventa) {
    //     dtventa.destroy(); // Destruir la tabla anterior si existe
    // }
    // RenderDatatable();

    // Añadir listeners a los botones de reporte
    const tagsreporte = document.querySelectorAll('.reporte');
    tagsreporte.forEach(element => {
      element.addEventListener("click", async (event) => {
        event.preventDefault();
        const idventa = element.getAttribute("data-iddespacho");
        await reporte(idventa); // Llamar a la función reporte
      });
    });

    const tagsinfo = document.querySelectorAll('.info');
    tagsinfo.forEach(element => {
      element.addEventListener("click", async (event) => {
        event.preventDefault();
        const idpedido = element.getAttribute("data-iddespacho");
        console.log(idpedido);
        await listarventas(idpedido); // Llamar a la función MostrarDetalle
      });
    });


  }

  CargarDatos();


  async function reporte(iddespacho) {
    const params = new URLSearchParams();
    params.append('operation', 'reporte');
    params.append('iddespacho', iddespacho);

    const response = await fetch(`../../controller/despacho.controller.php?${params}`)
    const data = await response.json();
    console.log(data);
    console.log(iddespacho);
    if (data) {
      window.open(`../../reports/Despacho/despacho.php?iddespacho=${iddespacho}`, '_blank');
    } else {
      showToast("No se puede generar el reporte", "error", "ERROR");
    }

  }

  async function listarventas(iddespacho) {
    const Tablaventas = $("#table-ventas tbody");

    const params = new URLSearchParams();
    params.append('operation', 'listarventas');
    params.append('iddespacho', iddespacho);

    const response = await fetch(`../../controller/despacho.controller.php?${params}`)
    const data = await response.json();
    console.log(data);

    Tablaventas.innerHTML = '';

    data.forEach(element => {

      Tablaventas.innerHTML += `
            <tr>
                <td>${element.idventa}</td>
          
            </tr>
            `;
    });
  }

  async function updateEstado(estado, iddespacho) {
    const params = new FormData();
    params.append('operation', 'updateEstado');
    params.append('estado', estado);
    params.append('iddespacho', iddespacho);

    const option = {
      method: 'POST',
      body: params
    }

    const response = await fetch(`../../controller/despacho.controller.php`, option)
    const data = await response.json();
    console.log(data);

    return data;

  }
})