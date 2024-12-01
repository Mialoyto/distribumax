// REVIEW
// ? ESTA FUNCION ACTUALIZA EL ESTADO DEL PEDIDO
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

// REVIEW
// ? PRIMERO OBTENEMOS EL DETALLE DEL PEDIDO POR ID DEL PEDIDO
async function ObtenerPedidoId(idpedido) {
  const params = new URLSearchParams();
  params.append('operation', 'GetPedido');
  params.append('idpedido', idpedido);

  try {
    const response = await fetch(`../../controller/pedido.controller.php?${params}`);
    const data = await response.json();
    return data;
  } catch (error) {
    console.log("Error al obtener el idpedido", error);
  }
}

// REVIEW
// ? LUEGO DE OBTENER EL DETALE DEL PEDIDO, LLENAMOS EL MODAL 
async function cargarDatosModal(idpedido, modal, nrodocumento, tipocliente, appaterno, apmaterno, nombres, razonsocial, direccion, tableDetallePedido) {
  const data = await ObtenerPedidoId(idpedido);
  try {
    if (!data) {
      showToast("No se encontraron datos", "error");
      return;
    } else {
      // REVIEW 
      // ? DATOS DEL CLIENTE
      modal.setAttribute("id-pedido", data[0].idpedido);
      nrodocumento.value = data[0].documento;
      tipocliente.value = data[0].tipo_cliente;
      appaterno.value = data[0].appaterno;
      apmaterno.value = data[0].appaterno;
      nombres.value = data[0].nombres;
      razonsocial.value = data[0].razonsocial;
      direccion.value = data[0].direccion_cliente;
      $("#addProducto").removeAttribute("disabled");

      tableDetallePedido.innerHTML = "";
      data.forEach(producto => {
        const id = producto.idproducto;
        const codigo = producto.codigo;
        const descripcion = element.nombreproducto;
        const cantidad = element.cantidad_producto;
        const unidadmedida = element.unidadmedida;
        const precio_unit = element.precio_unitario;
        const descuento = element.descuento;
        const subtotal = (cantidad * precio_unit).toFixed(2);
        const descuentos = (subtotal * (descuento / 100)).toFixed(2);
        const total = ((cantidad * precio_unit) - descuentos).toFixed(2);

        // REVIEW
        // ? AGREGAMOS LOS PRODUCTOS A LA TABLA
        addProductToTable(
          id,
          codigo,
          descripcion,
          cantidad,
          unidadmedida,
          precio_unit,
          descuento,);
      });
    }
  } catch (error) {
    console.log("Error al cargar los datos del modal", error);
  }
}


// REVIEW
// ? ESTA FUNCION PARA AGREGAR PRODUCTOS A LA TABLA DE DETALLE PEDIDO
function addProductToTable(id, codigo, descripcion, cantidad, unidadmedida, precio_venta, descuento, stockactual) {
  const existId = document.querySelector(`#update-detalle-pedido tr td[id-data="${id}"]`);
  if (existId) {
    showToast('El producto ya se encuentra en la tabla', 'info', 'INFO');
    return;
  }
  const row = document.createElement("tr");
  row.innerHTML = `
        <th scope="row" class"text-nowrap w-auto">${codigo}</th>
        <td class="text-nowrap w-auto" id-data="${id}">${descripcion}</td>
        <td class="col-md-1 w-10">
            <input class="form-control form-control-sm cantidad numeros text-center w-100" value="${cantidad}"  type="number" type="number" step="1" min="1" pattern="^[0-9]+" name="cantidad"  aria-label=".form-control-sm example" placeholder="0">
        </td>
        <td class="text-nowrap w-auto col-md-1 und-medida">${unidadmedida}</td>
        <td class="text-nowrap w-auto precio" data="${precio_venta}">S/${precio_venta}</td>
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
  row.querySelector(".eliminar-fila").addEventListener("click", async () => {
    if (await showConfirm("¿Estás seguro de eliminar el producto del pedido?")) {
      row.remove();
    }
  });

  const cantidadInput = row.querySelector(".cantidad");
  const subtotalCell = row.querySelector(".subtotal");
  const descuentoCell = row.querySelector(".descuento");
  const totalCell = row.querySelector(".total");

  cantidadInput.addEventListener("input", () => {
    let cantidad = parseInt(cantidadInput.value);
    const stock = parseInt(stockactual);

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