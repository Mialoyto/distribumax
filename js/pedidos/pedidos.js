document.addEventListener("DOMContentLoaded", async () => {
  /* variable globa */
  function $(object = null) {
    return document.querySelector(object);
  }
  // Función de debounce
  function debounce(func, wait) {
    let timeout;
    return function (...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }

  // funcion para traer datos del cliente empresa o persona
  async function dataCliente() {
    if (!$("#nro-doc")) {
      return;
    }
    const params = new URLSearchParams();
    params.append("operation", "searchCliente");
    params.append("nro_documento", $("#nro-doc").value);

    try {
      const response = await fetch(
        `../../controller/cliente.controller.php?${params}`
      );
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  let idCliente;
  async function validarNroDoc(response) {
    if (response.length === 0) {
      resetCampos();
      $("#nombres").setAttribute("disabled", true);
      $("#appaterno").setAttribute("disabled", true);
      $("#apmaterno").setAttribute("disabled", true);
      $("#razon-social").setAttribute("disabled", true);
      $("#direccion-cliente").setAttribute("disabled", true);

      console.log("No existe el cliente");
    } else {
      if (response[0].tipo_cliente === "Persona") {
        $("#cliente").value = response[0].tipo_cliente;
        $("#nombres").value = response[0].nombres;
        $("#appaterno").value = response[0].appaterno;
        $("#apmaterno").value = response[0].apmaterno;
        $("#razon-social").setAttribute("disabled", true);
      } else {
        $("#razon-social").value = response[0].razonsocial;
        $("#razon-social").removeAttribute("disabled");
        $("#nombres").setAttribute("disabled", true);
        $("#appaterno").setAttribute("disabled", true);
        $("#apmaterno").setAttribute("disabled", true);
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
  $("#nro-doc").addEventListener("input",debounce(async () => {
      if ($("#nro-doc").value === "") {
        $("#detalle-pedido").innerHTML = "";
        resetCampos();
      } else {
        const response = await dataCliente();
        await validarNroDoc(response);
      }
    }, 500)
  );

  // buscar producto
  const buscarProducto = async () => {
    const params = new URLSearchParams();
    params.append("operation", "getProducto");
    params.append("_cliente_id", $("#nro-doc").value);
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
          const descuento = 0;
          item.descuento = parseFloat(descuento);
        }
        const li = document.createElement("li");
        li.classList.add("list-group-item"); // Clase de Bootstrap para los ítems
        li.innerHTML = `${item.codigo}-${item.nombreproducto} <h6 class="btn btn-secondary btn-sm h-25 d-inline-block"secondary>${item.unidadmedida}</h6>`;
        li.addEventListener("click", () => {
          addProductToTable(
            item.idproducto,
            item.codigo,
            item.nombreproducto,
            item.unidadmedida,
            item.precio_venta,
            item.descuento
            // item.stockactual
          );
          $("#datalistProducto").style.display = "none"; // Ocultar la lista cuando se selecciona un producto
          document.getElementById("addProducto").value = ""; // Limpiar el campo de búsqueda
        });
        $("#datalistProducto").appendChild(li);
      });
    } else {
      $("#datalistProducto").style.display = "none";
    }
    console.log(response);
  };

  $("#addProducto").addEventListener("input", async () => {
    await mostraResultados();
    // await buscarProducto();
    if ($("#addProducto").value === "") {
      $("#datalistProducto").style.display = "none";
    }
  });

  // Función para añadir un producto a la tabla seleccionada
  function addProductToTable(id, codigo, nombre, unidadmedida, precio_venta, descuento) {
    const row = document.createElement("tr");
    row.innerHTML = `
      <th scope="row" colspan="1">${codigo}</th>
      <td colspan="1" id-data="${id}">${nombre}</td>
      <td class="col-md-1">
          <input class="form-control form-control-sm cantidad"  type="number" type="number" step="1" min="1" pattern="^[0-9]+" name="cantidad"  aria-label=".form-control-sm example" placeholder="0">
      </td>
      <td class="col-md-1 und-medida">${unidadmedida}</td>
      <td class="precio">${precio_venta}</td>
      <td class="subtotal"> 0.00</td>
      <td class="descuento">${descuento}</td>
      <td class="total">0.00</td>
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

    cantidadInput.addEventListener("input", () => {
      const cantidad = cantidadInput.value;
      if (cantidad >= 1 || cantidad === "") {
        const subtotal = (cantidad * parseFloat(precio_venta)).toFixed(2);
        const descuentos = (subtotal * (parseFloat(descuento) / 100)).toFixed(2);
        const totales = ((cantidad * (parseFloat(precio_venta))) - descuentos).toFixed(2);
        totalCell.textContent = totales;
        descuentoCell.textContent = descuentos;
        subtotalCell.textContent = subtotal;
      } else {
        alert("La cantidad no puede ser menor a 1");
      }
    });
  }

  async function addDetallePedidos(idpedido) {
    const rows = document.querySelectorAll("#detalle-pedido tr");
    const productos = [];
    let idproducto;
    let cantidad;
    let undMedida;
    let precioUnitario;
    rows.forEach((row) => {
      idproducto = row.querySelector("td[id-data]").getAttribute("id-data");
      cantidad = row.querySelector(".cantidad").value;
      undMedida = row.querySelector(".und-medida").textContent;
      precioUnitario = row.querySelector(".precio").textContent;

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
      params.append(`productos[${index}][cantidad_producto]`,producto.cantidad);
      params.append(`productos[${index}][unidad_medida]`, producto.undMedida);
      params.append(`productos[${index}][precio_unitario]`,producto.precioUnitario);
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
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }

  // EVENTO PARA MANDAR LOS DATOS A LA BASE DE DATOS
  let idpedido = -1;
  $("#registrar-pedido").addEventListener("submit", async (e) => {
    e.preventDefault();
    let response01;
    let response02;

    if (confirm("Esta seguro de guardar los datos")) {
      response01 = await getIdPedido();
      idpedido = response01.idpedido;
      console.log(idpedido);
      if (idpedido == -1) {
        alert("No se guardo los datos")
      } else {
        response02 = await addDetallePedidos(idpedido)
        console.log(response02.id)
        if(response02.id == -1){
          console.log("No se guardo los datos")
        }else{
          console.log("Datos guardados correctamente")
        }
      }
    }
  });
}); /* fin del evento DOMcontenteLoaded */
