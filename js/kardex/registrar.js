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
  let idproducto;

  let producto = "";
  // OK ✔️
  inputProducto.addEventListener("input", async (event) => {
    producto = event.target.value;
    if (!producto.length == 0) {
      await mostraResultados();
    } else {
      datalist.innerHTML = "";
      stock.value = "";
      medida.textContent = "Unidad Medida";
      inputProducto.removeAttribute("producto");
    }
  });
  // OK ✔️
  const searchProducto = async (producto) => {
    const searchData = new URLSearchParams();
    searchData.append("operation", "searchProducto");
    searchData.append("_item", producto);
    try {
      const response = await fetch(
        `../../controller/producto.controller.php?${searchData}`
      );
      const data = await response.json();
      // console.log("Function SearchProducto",data);
      return data;
    } catch (e) {
      console.error(e);
    }
  };
  // OK ✔️
  let dataLote;
  const mostraResultados = async () => {
    const response = await searchProducto(producto);
    console.log(response);
    datalist.innerHTML = "";
    if (response.data.length > 0) {
      datalist.style.display = "block";
      response.data.forEach((item) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.nombreproducto}
				<span class="badge rounded-pill text-bg-primary">${item.unidadmedida}</span> `;
        li.setAttribute("data-id", item.idproducto);
        li.addEventListener("click", async () => {
          inputProducto.value = item.nombreproducto;
          inputProducto.setAttribute("producto", item.idproducto);
          idproducto = item.idproducto;
          dataLote = await renderLote(idproducto);
          // await viewStock(item.stockactual, item.unidadmedida);
          datalist.innerHTML = "";
          // await render();

        });
        datalist.appendChild(li);
      });
    }
  };


  async function renderLote(idproducto) {
    try {
      const params = new URLSearchParams();
      params.append('operation', 'searchLote');
      params.append('_idproducto', idproducto);
      const response = await fetch(`../../controller/lotes.controller.php?${params}`);
      const lotes = await response.json();
      console.log(lotes);
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


  loteProducto.addEventListener('change', async () => {
    console.log(dataLote);
    const lote = dataLote.find(lote => lote.idlote == loteProducto.value);
    if (!lote) {
      stock.value = '';
      medida.textContent = 'Unidad Medida';
      fechaVencimiento.value = '';
    } else {
      if (lote.fecha_vencimiento) {
        // La fecha ya viene en formato YYYY-MM-DD desde la BD
        fechaVencimiento.value = lote.fecha_vencimiento;
      }
      // fechaVencimiento.value = lote.fechavencimiento;
      stock.value = lote.stockactual;
      medida.textContent = lote.unidadmedida;
    }
  });

  inputProducto.addEventListener('input', async () => {
    if (inputProducto.value == '') {
      loteProducto.innerHTML = '<option value="">Seleccione un lote</option>';
      $("#form-registrar-kardex").reset();
    }
  });







  /*  let id;
   async function render() {
     id = idproducto.getAttribute('producto');
     console.log(id);
     const data = await getMovimientoProducto(id);
     console.log(data)
     if (data) {
       await RenderDatatable(data);
     }
 
   } */
  // OK ✔️
  /*   async function viewStock(stockactual, unidaMedida) {
      stock.value = stockactual;
      medida.textContent = unidaMedida;
    } */

  // PROBANDO EL REGISTRO DE KARDEX
  /*   let fecha;
    let anio;
    $("#fechaVP").addEventListener("input", () => {
      fecha = $("#fechaVP").value;
      anio = new Date(fecha).getFullYear();
      console.log(fecha);
      console.log(anio);
      if (fecha <= new Date().getDate()) {
        if (anio <= new Date(fecha).getFullYear()) {
          console.log(new Date().getFullYear());
          showToast(
            "La fecha de vencimiento debe ser mayor a la fecha actual",
            "warning",
            "WARNING",
            2500
          );
          fecha.value = new Date().toISOString().split("T")[0];
          return;
        }
        fecha.value = new Date().toISOString().split("T")[0];
        return;
      }
    }); */

  /*   async function validarFormulario() {
      // const dato = await mostraResultados();
      // const data = await searchProducto(producto)
      const stock = $("#stockactual").value;
      console.log("stock", stock);
  
      const movimiento = $("#tipomovimiento");
  
      if (stock == 0 && movimiento.value == 'Salida') {
        showToast(`Este producto no cuenta con stock, registre un movimiento tipo 'Ingreso'.`, 'info', 'INFO');
        return;
      } else if (cantidad.value > stock && movimiento.value == 'Salida') {
        showToast(`La cantidad no debe ser mayor al stock actual de ${stock}`, "warning", "WARNING");
        return;
      }
      else if (cantidad.value <= 0) {
        showToast(`La cantidad debe ser mayor a 0`, "warning", "WARNING");
        return;
      } else if (fecha <= new Date().toISOString().split("T")[0]) {
        showToast(
          "La fecha de vencimiento debe ser mayor a la fecha actual",
          "warning",
          "WARNING",
          2500
        );
        return;
      } else if ($("#loteP").value == "") {
        showToast("El campo lote es obligatorio", "warning", "WARNING", 2500);
        return;
      }
    } */

  // funcion para registrar en le kardex 
  async function registrarkardex() {
    console.log(idproducto)
    const params = new FormData();
    params.append("operation", "add");
    params.append("idusuario", $("#iduser").getAttribute("data-id"));
    params.append("idproducto", idproducto);
    params.append("idlote", $("#loteP").value);
    params.append("tipomovimiento", $("#tipomovimiento").value);
    params.append("cantidad", cantidad.value);
    params.append("motivo", $("#motivo").value);

    const options = {
      method: "POST",
      body: params,
    };
    try {
      const response = await fetch(
        `../../controller/kardex.controller.php`,
        options
      );
      const data = await response.json();
      console.log(" respuesta de la funcion registrar Kardex", data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  async function validarForm() {
    const stockProducto = parseInt(stock.value);
    const movimientoProducto = movimiento.value;
    const cantidadProducto = parseInt(cantidad.value);
    console.log(stockProducto, movimientoProducto, cantidadProducto);

    if (stockProducto == 0 && movimientoProducto == 'Salida') {
      showToast(`Este producto no cuenta con stock, registre un movimiento tipo 'Ingreso'.`, 'info', 'INFO');
      return false;
    } else if (cantidadProducto > stockProducto && movimientoProducto == 'Salida') {
      showToast(`La cantidad no debe ser mayor al stock actual de ${stockProducto}`, "warning", "WARNING");
      return false;
    }
    else if (cantidadProducto <= 0) {
      showToast(`La cantidad debe ser mayor a 0`, "warning", "WARNING");
      return false;
    }
    else if ($("#loteP").value == "") {
      showToast("El campo lote es obligatorio", "warning", "WARNING", 2500);
      return false;
    }
    return true;

  }
  // validarForm();

  // EVENTO DE REGISTRO DE KARDEX
  $("#form-registrar-kardex").addEventListener("submit", async (event) => {
    event.preventDefault();


    const isvalid = await validarForm();
    console.log(isvalid);
    if (!isvalid) {
      return;
    } else {
      if (
        await showConfirm(
          "¿Desea registrar el producto en el kardex?",
          "Kardex"
        )
      ) {

        const resultado = await registrarkardex();
        if (resultado.estado) {
          showToast(
            "Registro exitoso del producto en el kardex",
            "success",
            "SUCCESS",
            2500
          );
          $("#form-registrar-kardex").reset();
        } else {
          showToast(
            "Error al registrar el producto en el kardex",
            "error",
            "ERROR",
            2500
          );
        }
      }
    }
  });

  $("#btnCancelar").addEventListener("click", () => {
    $("#form-registrar-kardex").reset();
    $("#medida").textContent = "Unidad Medida";
  });
  // FIN DE EVENTO DE REGISTRO DE KARDEX
});
