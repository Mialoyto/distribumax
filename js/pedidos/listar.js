document.addEventListener("DOMContentLoaded", () => {
  function $(selector) {
    return document.querySelector(selector);
  }

  async function ObtenerPedidoId(id) {
    const params = new URLSearchParams();
    params.append('operation', 'GetPedido');
    params.append('idpedido', id);

    try {
      const response = await fetch(`../../controller/pedido.controller.php?${params}`);
      const data = await response.json();
      // console.log(data);
      return data;
    } catch (error) {
      console.log("Error al obtener el idpedido", error);
    }

  }





  let dtpedido;
  // // referencias a los elementos del modal
  // const modal = $("#edits-pedido");
  // const inputdocumento = modal.querySelector("#update-nro-doc");//numero del cliente
  // const inputtipocliente = modal.querySelector("#update-cliente");
  // const inputnombres = modal.querySelector("#update-nombres");
  // const inputapepaterno = modal.querySelector("#update-appaterno");
  // const inputapematerno = modal.querySelector("#update-apmaterno");
  // const inputrazon = modal.querySelector("#update-razon-social");
  // const inputdireccion = modal.querySelector("#update-direccion-cliente");



  const modal = $("#edits-pedido");
  const inputdocumento = modal.querySelector("#update-nro-doc");
  const inputtipocliente = modal.querySelector("#update-cliente");
  const inputnombres = modal.querySelector("#update-nombres");
  const inputapepaterno = modal.querySelector("#update-appaterno");
  const inputapematerno = modal.querySelector("#update-apmaterno");
  const inputrazon = modal.querySelector("#update-razon-social");
  const inputdireccion = modal.querySelector("#update-direccion-cliente");

  async function cargarDatosModal(id) {
    try {
      const data = await ObtenerPedidoId(id);
      console.log(data);

      if (data && data.length > 0) {
        console.log("Pedido encontrado", data);
        modal.setAttribute("id-pedido", data[0].idpedido);
        inputdocumento.value = data[0].documento;
        inputtipocliente.value = data[0].tipo_cliente;
        inputapematerno.value = data[0].apmaterno;
        inputapepaterno.value = data[0].appaterno;
        inputnombres.value = data[0].nombres;
        inputrazon.value = data[0].razonsocial;
        inputdireccion.value = data[0].direccion_cliente;
        $("#addProducto").removeAttribute("disabled");

        // Aquí se agrega la lógica para llenar la tabla con los productos

        // Limpiar la tabla antes de llenarla con nuevos datos
        const detallePedidoTable = $("#update-detalle-pedido");
        detallePedidoTable.innerHTML = ""; // Limpiar contenido previo

        data.forEach(element => {
          addProductToTable(
            element.codigo,
            element.nombreproducto,
            element.descripcion,
            element.unidadmedida,
            element.precio_venta,
            element.descuento,
            element.subtotal
          );

        });

      }

    } catch (error) {
      console.log("No es posible cargar los datos", error);
    }
  }


  function RenderDatatablePedidos() {
    if (dtpedido) {
      dtpedido.destroy();
    }

    dtpedido = new DataTable("#table-pedidos", {

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



  async function cargarPedidos() {
    if (dtpedido) {
      dtpedido.destroy();
      dtpedido = null;
    }

    const Tablapedidos = $("#table-pedidos tbody");
    let tableContent = ""; // Asegúrate de inicializar la variable para evitar errores

    try {
      const response = await fetch(`../../controller/pedido.controller.php?operation=getAll`);
      const data = await response.json();
      if (data.length > 0) {
        data.forEach(element => {
          let estadoClass;
          let editButtonClass = "btn-warning";
          let editButtonDisabled = "";
          let bgbtn;
          let etadodisabled = "";
          let estadoButtonDisabled = "";

          switch (element.estado) {
            case "Enviado":
              estadoClass = "text-success";
              editButtonClass = "btn-warning disabled";
              editButtonDisabled = "disabled";
              bgbtn = "btn-success disabled";
              etadodisabled = "btn-success disabled";
              estadoButtonDisabled = "disabled";
              break;
            case "Cancelado":
              estadoClass = "text-danger";
              editButtonClass = "btn-warning disabled";
              editButtonDisabled = "disabled";
              bgbtn = "btn-danger disabled";
              estadoButtonDisabled = "disabled";
              break;
            case "Entregado":
              estadoClass = "text-primary";
              bgbtn = "btn-success";
              break;
            case "Pendiente":
              estadoClass = "text-warning";
              bgbtn = "btn-success";
              break;
          }

          const icons = element.estado === "Enviado" ? "bi bi-toggle2-on fs-5" : "bi bi-toggle2-off fs-5";

          tableContent += `
            <tr>
              <td>${element.idpedido}</td>
              <td>${element.tipo_cliente}</td>
              <td>${element.documento}</td>
              <td>${element.cliente}</td>
              <td>${element.create_at}</td>
              <td><strong class="${estadoClass}">${element.estado}</strong></td>
              <td>
                <div class="d-flex justify-content-center">
                  <a id-data="${element.idpedido}" class="btn ${editButtonClass}" data-bs-toggle="modal" data-bs-target="#edits-pedido" ${editButtonDisabled}>
                    <i class="bi bi-pencil-square fs-5"></i>
                  </a>
                  <a id-data="${element.idpedido}" class="btn ${bgbtn} ms-2 estado" status="${element.estado}" ${etadodisabled} ${estadoButtonDisabled}>
                    <i class="${icons}"></i>
                  </a>
                </div>
              </td>
            </tr>`;
        });

        Tablapedidos.innerHTML = tableContent;

        const editButtons = document.querySelectorAll(".btn-warning");
        editButtons.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            const id = e.currentTarget.getAttribute("id-data");
            console.log(id);
            await cargarDatosModal(id);
          });
        });

        const statusButtons = document.querySelectorAll(".estado");
        statusButtons.forEach((btn) => {
          btn.addEventListener("click", async (e) => {
            try {
              const id = e.currentTarget.getAttribute("id-data");
              const currentStatus = e.currentTarget.getAttribute("status");

              // Verificar si se permite cambiar el estado
              if (currentStatus === "Cancelado" || currentStatus === "Enviado") {
                showToast("No se puede cambiar el estado desde Cancelado o Enviado", "warning", "AVISO");
                return;
              }

              let newStatus = "Cancelado"; // El único estado al que puede cambiar

              console.log(`Estado actual: ${currentStatus}`);
              console.log(`Nuevo estado: ${newStatus}`);

              if (await showConfirm("¿Estás seguro de cambiar el estado del Pedido?")) {
                const data = await updateEstado(id, newStatus);
                if (data[0].estado > 0) {
                  showToast(`${data[0].mensaje}`, "success", "SUCCESS");
                  await CargarProveedores();
                } else {
                  showToast(`${data[0].mensaje}`, "error", "ERROR");
                }
              }
            } catch (error) {
              console.error("Error al cambiar el estado del pedido:", error);
            }
          });
        });
      }

      RenderDatatablePedidos();
    } catch (error) {
      console.log("Error al cargar los pedidos", error);
    }


  }
  cargarPedidos();


  async function updateEstado(id, status) {
    const params = new FormData();
    params.append('operation', 'UpdateEstadoPedido');
    params.append('idpedido', id);
    params.append('estado', status);

    try {
      const response = await fetch(`../../controller/pedido.controller.php`, {
        method: 'POST',
        body: params
      });

      const data = await response.json();
      console.log(data);
      return data;
    } catch (error) {
      console.log("error al actualizar el pedido", error);
    }
  }

  const buscarProducto = async () => {
    const params = new URLSearchParams();
    params.append("operation", "getProducto");
    params.append("_cliente_id", $("#update-nro-doc").value.trim());
    params.append("_item", $("#addProducto").value);

    try {
      const response = await fetch(
        `../../controller/producto.controller.php?${params}`
      );
      return response.json();
      // console.log("linea 125 :", data);
    } catch (e) {
      console.error(e);
    }
  };

  // mostrar resultados ✔️
  const mostraResultados = async () => {
    const response = await buscarProducto();
    $("#datalistProducto").innerHTML = "";
    if (response.length > 0) {
      $("#datalistProducto").style.display = "block";
      // Iterar sobre los resultados y mostrarlos
      response.forEach((item) => {
        if (item.descuento === null) {
          const descuento = 0.00;
          item.descuento = parseFloat(descuento);
        }
        const li = document.createElement("li");
        li.classList.add("list-group-item"); // Clase de Bootstrap para los ítems
        li.innerHTML = `${item.nombreproducto} <span class="badge text-bg-success rounded-pill">${item.unidadmedida}: ${item.stockactual}</span>`;
        li.addEventListener("click", () => {
          addProductToTable(
            item.idproducto,
            item.codigo,
            item.descripcion,
            item.unidadmedida,
            item.precio_venta,
            item.descuento,
            item.stockactual
          );
          $("#datalistProducto").style.display = "none"; // Ocultar la lista cuando se selecciona un producto
          document.getElementById("addProducto").value = ""; // Limpiar el campo de búsqueda
        });
        $("#datalistProducto").appendChild(li);
      });
      console.log("datos de los productos", response);
    } else {
      $("#datalistProducto").style.display = "none";
    }
  };
  $("#addProducto").addEventListener("input", async () => {
    await mostraResultados();
    // await buscarProducto();
    if ($("#addProducto").value === "") {
      $("#datalistProducto").style.display = "none";
    }
  });

  function addProductToTable(id, codigo, descripcion, unidadmedida, precio_venta, descuento, stockactual) {
    const existId = document.querySelector(`#detalle-pedido tr td[id-data="${id}"]`);
    console.log("existe el ID en la tabla ?", existId);
    if (existId) {
      showToast('El producto ya se encuentra en la tabla', 'info', 'INFO');
      return;
    }
    const row = document.createElement("tr");
    row.innerHTML = `
          <th scope="row" class"text-nowrap w-auto">${codigo}</th>
          <td class="text-nowrap w-auto" id-data="${id}">${descripcion}</td>
          <td class="col-md-1 w-10">
              <input class="form-control form-control-sm cantidad numeros text-center w-100"  type="number" type="number" step="1" min="1" pattern="^[0-9]+" name="cantidad"  aria-label=".form-control-sm example" placeholder="0">
          </td>
          <td class="text-nowrap w-auto col-md-1 und-medida">${unidadmedida}</td>
          <td class="text-nowrap w-auto precio" data="${precio_venta}">
          
    
          S/${precio_venta}
          </td>
          <td class="text-nowrap w-auto subtotal"> S/0.00</td>
          <td class="text-nowrap w-auto">% ${descuento}</td>
          <td class="text-nowrap w-auto descuento">S/0.00</td>
          <td class="text-nowrap w-auto total">S/0.00</td>
          <td class="col-1">
            <div class="mt-1  d-flex justify-content-evenly">
              <button type="button" class="btn btn-danger btn-sm w-100 eliminar-fila">
                <i class="bi bi-x-square"></i>
              </button>
            </div>
          </td>
        `;
    // Añadir la fila a la tabla
    document.getElementById("update-detalle-pedido").appendChild(row);

    // eliminar fila
    row.querySelector(".eliminar-fila").addEventListener("click", () => {
      row.remove();
    });

    const cantidadInput = row.querySelector(".cantidad");
    const subtotalCell = row.querySelector(".subtotal");
    const descuentoCell = row.querySelector(".descuento");
    const totalCell = row.querySelector(".total");

    cantidadInput.addEventListener("input", () => {
      let cantidad = parseInt(cantidadInput.value);
      let stock = parseInt(stockactual);
      console.log("cantidad", cantidad);
      console.log("stockactual", stock);
      console.log(cantidad > stock);

      if (cantidad > stock) {
        showToast(`La cantidad no puede ser mayor que el stock disponible (${stock})`, 'info', 'INFO');
        cantidadInput.value = stock; // Ajustar al stock máximo disponible
        cantidad = stock; // Actualizamos la cantidad
        console.log("cantidad", parseInt(cantidad));
      }
      if (cantidad <= 0 || cantidad == "") {
        showToast('La cantidad no puede ser menor a 1', 'info', 'INFO');
      } else {
        const subtotal = (cantidad * parseFloat(precio_venta)).toFixed(2);
        const descuentos = (subtotal * (parseFloat(descuento) / 100)).toFixed(2);
        const totales = ((cantidad * (parseFloat(precio_venta))) - descuentos).toFixed(2);
        totalCell.textContent = `S/${totales}`;
        descuentoCell.textContent = `S/${descuentos}`;
        subtotalCell.textContent = `S/${subtotal}`;
      }
    });
  }

  async function addDetallePedidos(idpedido) {

    const rows = document.querySelectorAll("#update-detalle-pedido tr");
    const productos = [];
    let idproducto;
    let cantidad;
    let undMedida;
    let precioUnitario;
    rows.forEach((row) => {
      idproducto = row.querySelector("td[id-data]").getAttribute("id-data");
      cantidad = row.querySelector(".cantidad").value;
      undMedida = row.querySelector(".und-medida").textContent;
      precioUnitario = row.querySelector(".precio").getAttribute("data");
      productos.push({
        idproducto,
        cantidad,
        undMedida,
        precioUnitario,
      });
    });

    const params = new FormData();
    params.append("operation", "addDetallePedido");
    params.append("idpedido", idpedido);
    productos.forEach((producto, index) => {
      params.append(`productos[${index}][idproducto]`, producto.idproducto);
      params.append(`productos[${index}][cantidad_producto]`, parseInt(producto.cantidad));
      params.append(`productos[${index}][unidad_medida]`, producto.undMedida);
      params.append(`productos[${index}][precio_unitario]`, producto.precioUnitario);
    });
    console.log("productos", productos);
    console.log(idpedido);

    const options = {
      method: "POST",
      body: params,
    };

    try {
      const response = await fetch(
        `../../controller/detallepedido.controller.php`,
        options
      );
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }
  let idpedido = -1;

});