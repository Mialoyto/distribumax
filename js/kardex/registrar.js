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
          await renderLote(idproducto);
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
    const response = await renderLote(idproducto);
    console.log(response);
 
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
  let fecha;
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
  });

  async function validarFormulario() {
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
  }

  // funcion para registrar en le kardex 
  async function registrarkardex() {
    const params = new FormData();
    params.append("operation", "add");
    params.append("idusuario", $("#iduser").getAttribute("data-id"));
    params.append("idproducto", idproducto.getAttribute("producto"));
    params.append("fecha_vencimiento", $("#fechaVP").value);
    params.append("numlote", $("#loteP").value);
    params.append("tipomovimiento", $("#tipomovimiento").value);
    params.append("cantidad", $("#cantidad").value);
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

  // EVENTO DE REGISTRO DE KARDEX
  $("#form-registrar-kardex").addEventListener("submit", async (event) => {
    event.preventDefault();

    validarFormulario();
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
  });

  $("#btnCancelar").addEventListener("click", () => {
    $("#form-registrar-kardex").reset();
    $("#medida").textContent = "Unidad Medida";
  });
  // FIN DE EVENTO DE REGISTRO DE KARDEX
});
