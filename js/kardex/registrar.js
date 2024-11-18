document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  const inputProducto = $("#searchProducto");
  const stock = $("#stockactual");
  const datalist = $("#listProductKardex");
  const medida = $("#medida");
  const cantidad = $("#cantidad");
  const loteProducto = $("#loteP");
  const fechaVencimiento = $("#fechaVP");
  const movimiento = $("#tipomovimiento");
  const motivoIngresoDiv = $("#motivoIngresoDiv");
  const motivoSalidaDiv = $("#motivoSalidaDiv");
  // const motivo = $("#motivo");

  let idproducto;
  let producto = "";

  // Maneja la búsqueda de productos
  inputProducto.addEventListener("input", async (event) => {
    producto = event.target.value;
    if (producto.length > 0) {
      await mostraResultados();
    } else {
      datalist.innerHTML = "";
      stock.value = "";
      medida.textContent = "Unidad Medida";
      inputProducto.removeAttribute("producto");
    }
  });

  // Muestra los divs correspondientes al tipo de movimiento seleccionado
 /*  movimiento.addEventListener("change", function () {
    const tipoMovimiento = this.value;
    if (tipoMovimiento === 'Ingreso') {
      motivoIngresoDiv.style.display = 'block';
      motivoSalidaDiv.style.display = 'none';
    } else if (tipoMovimiento === 'Salida') {
      motivoSalidaDiv.style.display = 'block';
      motivoIngresoDiv.style.display = 'none';
    } else {
      motivoIngresoDiv.style.display = 'none';
      motivoSalidaDiv.style.display = 'none';
    }
  }); */

  // Función para buscar productos
  const searchProducto = async (producto) => {
    const searchData = new URLSearchParams();
    searchData.append("operation", "searchProducto");
    searchData.append("_item", producto);
    try {
      const response = await fetch(`../../controller/producto.controller.php?${searchData}`);
      const data = await response.json();
      return data;
    } catch (e) {
      console.error(e);
    }
  };

  let dataLote;
  // Muestra los resultados de los productos
  const mostraResultados = async () => {
    const response = await searchProducto(producto);
    datalist.innerHTML = "";
    if (response.data.length > 0) {
      datalist.style.display = "block";
      response.data.forEach((item) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.nombreproducto} 
                        <span class="badge rounded-pill text-bg-primary">${item.unidadmedida}</span>`;
        li.setAttribute("data-id", item.idproducto);
        li.addEventListener("click", async () => {
          inputProducto.value = item.nombreproducto;
          inputProducto.setAttribute("producto", item.idproducto);
          idproducto = item.idproducto;
          dataLote = await renderLote(idproducto);
          datalist.innerHTML = "";
        });
        datalist.appendChild(li);
      });
    }
  };

  // Función para renderizar los lotes del producto
  async function renderLote(idproducto) {
    try {
      const params = new URLSearchParams();
      params.append('operation', 'searchLote');
      params.append('_idproducto', idproducto);
      const response = await fetch(`../../controller/lotes.controller.php?${params}`);
      const lotes = await response.json();
      if (!lotes) {
        showToast('No se encontraron lotes para este producto', 'info', 'INFO');
        return;
      } else {
        loteProducto.innerHTML = '';
        loteProducto.innerHTML = '<option value="">Seleccione un lote</option>';
        lotes.forEach(lote => {
          const option = document.createElement('option');
          option.value = lote.idlote;
          option.innerText = lote.numlote;
          loteProducto.appendChild(option);
        });
      }
      return lotes;
    } catch (e) {
      console.error(e);
    }
  }

  // Cuando se selecciona un lote
  loteProducto.addEventListener('change', async () => {
    const lote = dataLote.find(lote => lote.idlote == loteProducto.value);
    if (!lote) {
      stock.value = '';
      medida.textContent = 'Unidad Medida';
      fechaVencimiento.value = '';
    } else {
      if (lote.fecha_vencimiento) {
        fechaVencimiento.value = lote.fecha_vencimiento;
      }
      stock.value = lote.stockactual;
      medida.textContent = lote.unidadmedida;
    }
  });

  // Limpiar campos al borrar el valor en el campo de producto
  inputProducto.addEventListener('input', async () => {
    if (inputProducto.value == '') {
      loteProducto.innerHTML = '<option value="">Seleccione un lote</option>';
      $("#form-registrar-kardex").reset();
    }
  });

  // Función para registrar en el kardex
  async function registrarkardex() {
    const params = new FormData();
    params.append("operation", "add");
    params.append("idusuario", $("#iduser").getAttribute("data-id"));
    params.append("idproducto", idproducto);
    params.append("idlote", $("#loteP").value);
    params.append("tipomovimiento", $("#motivoSalida").value);
    params.append("cantidad", cantidad.value);
    // params.append("motivo", $("#motivo").value);
    for (let [key, value] of params.entries()) {
      console.log(`${key}: ${value}`);
    }

    const options = {
      method: "POST",
      body: params,
    };
    try {
      const response = await fetch(`../../controller/kardex.controller.php`, options);
      const data = await response.text();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  // Validar formulario antes de registrar
  async function validarForm() {
    const stockProducto = parseInt(stock.value);
    const movimientoProducto = movimiento.value;
    const cantidadProducto = parseInt(cantidad.value);

    if (stockProducto == 0 && movimientoProducto == 'Salida') {
      showToast(`Este producto no cuenta con stock, registre un movimiento tipo 'Ingreso'.`, 'info', 'INFO');
      return false;
    } else if (cantidadProducto > stockProducto && movimientoProducto == 'Salida') {
      showToast(`La cantidad no debe ser mayor al stock actual de ${stockProducto}`, "warning", "WARNING");
      return false;
    } else if (cantidadProducto <= 0) {
      showToast(`La cantidad debe ser mayor a 0`, "warning", "WARNING");
      return false;
    } else if ($("#loteP").value == "") {
      showToast("El campo lote es obligatorio", "warning", "WARNING", 2500);
      return false;
    }
    return true;
  }

  // Evento de registro de Kardex
  $("#form-registrar-kardex").addEventListener("submit", async (event) => {
    event.preventDefault();

    const isvalid = await validarForm();
    if (!isvalid) {
      return;
    } else {
      if (await showConfirm("¿Desea registrar el producto en el kardex?", "Kardex")) {
        const resultado = await registrarkardex();
        if (resultado.estado) {
          showToast("Registro exitoso del producto en el kardex", "success", "SUCCESS", 2500);
          $("#form-registrar-kardex").reset();
        } else {
          showToast("Error al registrar el producto en el kardex", "error", "ERROR", 2500);
        }
      }
    }
  });

  // Cancelar formulario
  $("#btnCancelar").addEventListener("click", () => {
    $("#form-registrar-kardex").reset();
    $("#medida").textContent = "Unidad Medida";
  });
});
