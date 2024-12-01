document.addEventListener("DOMContentLoaded", async () => {
  /* variable globa */
  function $(object = null) {
    return document.querySelector(object);
  }
  // Función de debounce
  /*   function debounce(func, wait) {
      let timeout;
      return function (...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
      };
    } */

  // funcion para traer datos del cliente empresa o persona
  async function dataCliente() {
    if (!$("#nro-doc")) {
      return;
    }
    const params = new URLSearchParams();
    params.append("operation", "searchCliente");
    params.append("_nro_documento", $("#nro-doc").value);

    try {
      const response = await fetch(
        `../../controller/cliente.controller.php?${params}`
      );
      const data = await response.json();
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  function desactivarCampos() {
    $("#nombres").setAttribute("disabled", true);
    $("#appaterno").setAttribute("disabled", true);
    $("#apmaterno").setAttribute("disabled", true);
    $("#razon-social").setAttribute("disabled", true);
    $("#direccion-cliente").setAttribute("disabled", true);
    $("#addProducto").removeAttribute("disabled");
    // $("#addProducto").focus();
  }

  let idCliente;
  async function validarNroDoc(response) {
    if (response.length === 0) {
      resetCampos();
      desactivarCampos();
      console.log("No existe el cliente");
    } else {
      if (response[0].tipo_cliente === "Persona") {
        $("#cliente").value = response[0].tipo_cliente;
        $("#nombres").value = response[0].nombres;
        $("#appaterno").value = response[0].appaterno;
        $("#apmaterno").value = response[0].apmaterno;
        desactivarCampos();
        $("#addProducto").focus();
      } else {
        $("#razon-social").value = response[0].razonsocial;
        desactivarCampos();
        $("#addProducto").focus();
      }
      if (response[0].usuario_existe === 1) {
        alert("Cliente:", response[0].mensaje);
      }


      $("#direccion-cliente").value = response[0].direccion_cliente;
      idCliente = response[0].idcliente;
      const option = document.createElement("option");
      option.value = response[0].idcliente;
      option.text = response[0].tipo_cliente;
      option.selected = true;

      $("#cliente").appendChild(option);
      console.log("id Cliente:", idCliente);
    }
  }

  function resetCampos() {
    $("#cliente").value = "";
    $("#cliente").innerHTML = "";
    $("#nombres").value = "";
    $("#appaterno").value = "";
    $("#apmaterno").value = "";
    $("#razon-social").value = "";
    $("#direccion-cliente").value = "";
    $("#addProducto").value = "";
  }

  async function getIdPedido() {
    let idusuario = $("#idvendedor").getAttribute("data-id");
    const params = new FormData();
    params.append("operation", "addPedido");
    params.append("idusuario", idusuario);
    params.append("idcliente", $("#cliente").value);
    const options = {
      method: "POST",
      body: params,
    };
    try {
      const response = await fetch(
        "../../controller/pedido.controller.php",
        options
      );
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }


  // EVENTOS
  $("#nro-doc").addEventListener("input", async () => {

    if ($("#nro-doc").value === "") {
      desactivarCampos();
      $("#addProducto").setAttribute("disabled", true);
      $("#detalle-pedido").innerHTML = "";
      resetCampos();
    } else {
      const response = await dataCliente();
      console.log(response);
      if (response.length != 0) {
        // desactivarCampos();
        await validarNroDoc(response);
        if (response[0].mensaje === "El cliente ya tiene un pedido pendiente.") {
          showToast(`${response[0].mensaje}`, "info", "INFO");
          $("#addProducto").setAttribute("disabled", true);
          setTimeout(async () => {
            if (await showConfirm("Desea registrar un nuevo Pedido?", "Distribumax")) {
              $("#addProducto").removeAttribute("disabled");
            } else {

            }
          }, 3000);
        } else {
          $("#addProducto").removeAttribute("disabled");
        }


      } else {
        // desactivarCampos();
        $("#detalle-pedido").innerHTML = "";
        resetCampos();
        $("#addProducto").value = "";
        $("#addProducto").setAttribute("disabled", true);
      }
      $("#nro-doc").addEventListener('keydown', (event) => {
        if (event.keyCode == 13) {
          event.preventDefault();
          $("#addProducto").focus();
        }
      })

    }
  });

  // buscar producto
  const buscarProducto = async () => {
    const params = new URLSearchParams();
    params.append("operation", "getProducto");
    params.append("_cliente_id", $("#nro-doc").value.trim());
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

  // Función para añadir un producto a la tabla seleccionada
  function addProductToTable(id, codigo, descripcion, unidadmedida, precio_venta, stockactual) {
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
          <input class="form-control form-control-sm cantidad numeros text-center w-100"  type="number" type="number"  name="cantidad" placeholder="0">
      </td>
      <td class="text-nowrap w-auto col-md-1 und-medida">${unidadmedida}</td>
      <td class="text-nowrap w-auto precio" data="${precio_venta}">S/${precio_venta}</td>
      <td class="text-nowrap w-auto subtotal"> S/0.00</td>
      <td class="text-nowrap w-auto">
          <input class="form-control form-control-sm numeros text-center w-100 descuento"  type="number"  name="descuento"  placeholder="0.00" readonly>
      </td>
      <td class="text-nowrap w-auto total">0.00</td>
      <td class="col-1">
        <div class="mt-1  d-flex justify-content-evenly">
          <button type="button" class="btn btn-danger btn-sm w-100 eliminar-fila">
            <i class="bi bi-x-square"></i>
          </button>
        </div>
      </td>
    `;
    // Añadir la fila a la tabla
    document.getElementById("detalle-pedido").appendChild(row);

    // eliminar fila
    row.querySelector(".eliminar-fila").addEventListener("click", () => {
      row.remove();
    });

    const cantidadInput = row.querySelector(".cantidad");
    const subtotalCell = row.querySelector(".subtotal");
    const descuentoCell = row.querySelector(".descuento");
    const totalCell = row.querySelector(".total");

    descuentoCell.addEventListener("click", async () => {
      if (await showConfirm('¿Desea aplicar un descuento al producto?', '', 'Sí', 'No')) {
        descuentoCell.removeAttribute("readonly");
        descuentoCell.focus();
      }
    });


    function calcularTotal() {
      let cantidad = parseInt(cantidadInput.value);
      let stock = parseInt(stockactual);
      let descuento = parseFloat(descuentoCell.value);
      const inputDescuento = descuento ? parseFloat(descuento) : 0.00;
      if (cantidad > stock) {
        showToast(`La cantidad no puede ser mayor que el stock disponible (${stock})`, 'info', 'INFO');
        cantidadInput.value = stock; // Ajustar al stock máximo disponible
        cantidad = stock; // Actualizamos la cantidad
      }
      if (cantidad < 1 || cantidad == "") {
        showToast('La cantidad no puede ser menor a 1', 'info', 'INFO');
      } if (cantidad === '' || inputDescuento === '' || inputDescuento < 0) {
        showToast('La cantidad o el descuento no pueden ser menor a 0', 'info', 'INFO');
        totalCell.textContent = `S/0.00`;
        return;
      } else {
        const subtotal = parseFloat((cantidad * parseFloat(precio_venta))).toFixed(2);
        const descuentos = inputDescuento.toFixed(2);
        const totales = ((cantidad * (precio_venta)) - descuentos).toFixed(2);
        totalCell.textContent = `S/${totales}`;
        descuentoCell.textContent = `S/${descuentos}`;
        subtotalCell.textContent = `S/${subtotal}`;
      }
    }
    cantidadInput.addEventListener('input', calcularTotal);
    descuentoCell.addEventListener('input', calcularTotal);
  }

  async function addDetallePedidos(idpedido) {

    const rows = document.querySelectorAll("#detalle-pedido tr");
    const productos = [];
    let idproducto;
    let cantidad;
    let undMedida;
    let precioUnitario;
    let descuento;
    rows.forEach((row) => {
      idproducto = row.querySelector("td[id-data]").getAttribute("id-data");
      cantidad = row.querySelector(".cantidad").value;
      undMedida = row.querySelector(".und-medida").textContent;
      precioUnitario = row.querySelector(".precio").getAttribute("data");
      descuento = row.querySelector(".descuento").value;
      productos.push({
        idproducto,
        cantidad,
        undMedida,
        precioUnitario,
        descuento
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
      params.append(`productos[${index}][descuento]`, producto.descuento);
    });

    params.forEach((value, key) => {
      console.log(key, value);
    });

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

  async function validarDetalle() {
    const rows = document.querySelectorAll("#detalle-pedido tr");
    if (rows.length === 0) {
      showToast('Debes agregar al menos un producto antes de registrar el pedido', 'warning');
      return false;
    }
    let cantidadInvalida = false;
    rows.forEach((row) => {
      const cantidad = parseInt(row.querySelector(".cantidad").value.trim());
      console.log(cantidad);
      if (cantidad == "" || cantidad < 1 || isNaN(cantidad)) {
        cantidadInvalida = true;
      }
    });
    if (cantidadInvalida) {
      showToast('Todos los productos deben tener una cantidad mayor a 0', 'info', 'INFO');
      return false;
    }

    let descuentoInvalido = false;
    rows.forEach((row) => {
      const descuento = parseFloat(row.querySelector(".descuento").value.trim());
      console.log(descuento);
      if (descuento < 0 || isNaN(descuento)) {
        descuentoInvalido = true;
      }
    });
    if (descuentoInvalido) {
      showToast('Todos los productos deben tener un descuento mayor o igual a 0', 'info', 'INFO');
      return false;
    }

    return true;
  }



  // EVENTO PARA MANDAR LOS DATOS A LA BASE DE DATOS
  let idpedido = -1;
  $("#registrar-pedido").addEventListener("submit", async (e) => {
    e.preventDefault();
    let response01;
    let response02;

    const data  = await validarDetalle();
    console.log(data);
    if (!data) {
      return;
    } else {

      if (await showConfirm('¿Desea registrar el pedido?', 'Pedido')) {
        response01 = await getIdPedido();
        idpedido = response01.idpedido;
        console.log(idpedido);
        if (idpedido == -1) {
          alert("No se guardo los datos")
        } else {
          response02 = await addDetallePedidos(idpedido)
          console.log(response02.id)
          if (response02.id == -1) {
            showToast('Hubo un error al registrar el pedido', 'error', 'ERROR');
          } else {
            showToast(`Pedido registrado con éxito\n ID: ${idpedido}`, 'success', 'SUCCESS');
            $("#registrar-pedido").reset();
            $("#addProducto").setAttribute("disabled", true);
            $("#detalle-pedido").innerHTML = "";
          }
        }
      }
    }
  });

  $("#cancelarPedido").addEventListener("click", () => {
    $("#detalle-pedido").innerHTML = "";
  });

}); /* fin del evento DOMcontenteLoaded */
