document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  const optMarca = $("#idmarca");
  const optionsub = $("#idsubcategoria");
  let proveedores;
  let id;

  // obtener proveedores
  async function getProveedor(proveedor) {
    const params = new URLSearchParams();
    params.append('operation', 'getProveedor');
    params.append('idproveedor', proveedor);
    try {
      const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
      return response.json();

    } catch (e) {
      console.error(e);
    }
  }
  // function getMarcas
  async function getMarcas(id) {
    const params = new URLSearchParams();
    params.append('operation', 'getMarcas');
    params.append('id', id);
    try {
      const response = await fetch(`../../controller/marca.controller.php?${params}`);
      return await response.json();


    } catch (e) {
      console.error(e);
    }
  }
  // obtener categorias
  async function getCategorias() {
    const params = new URLSearchParams();
    params.append('operation', 'getCategorias');
    try {
      const response = await fetch(`../../controller/categoria.controller.php?${params}`);
      const categorias = await response.json();
      console.log(categorias);
      categorias.forEach(element => {
        const tagOption = document.createElement('option');
        tagOption.value = element.idcategoria;
        tagOption.innerText = element.categoria;
        $("#idcategoria").appendChild(tagOption);
      });
    } catch (e) {
      console.error(e);
    }
  }
  // obtener subcategorias
  async function getSubcategorias(id) {
    const params = new URLSearchParams();
    params.append('operation', 'getSubcategorias');
    params.append('idcategoria', id);
    try {
      const response = await fetch(`../../controller/subcategoria.controller.php?${params}`);
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }

  // funcion para obtener unidades de medida
  async function getUnidades() {
    const params = new URLSearchParams();
    params.append('operation', 'getUnidades');
    try {
      const response = await fetch(`../../controller/unidades.controller.php?${params}`);
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }

  // renderizar datos lista
  async function renderData() {
    $("#list-proveedor").innerHTML = "";
    const response = await getProveedor(proveedores);
    console.log(response);
    if (response.data.length > 0) {
      $("#list-proveedor").style.display = "block";

      response.data.forEach(item => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.proveedor} <h6 class="btn btn-secondary btn-sm h-25 d-inline-block">${item.idempresa}</h6>`;
        li.addEventListener("click", async () => {
          $("#list-proveedor").innerHTML = ``;
          $("#idproveedor").setAttribute("data-id", item.idproveedor);
          $("#idproveedor").value = item.proveedor;
          id = item.idproveedor;
          cleanCampos()
          await renderOption();
        });
        $("#list-proveedor").appendChild(li);
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Proveedor no encontrado</b>`;
      $("#list-proveedor").appendChild(li);
    }
  }
  // renderizar option de marcas
  async function renderOption() {
    const data = await getMarcas(id);
    console.log(data.marcas);
    optMarca.innerHTML = '<option value="">Seleccione una marca</option>';
    data.marcas.forEach(item => {
      const option = document.createElement('option');
      option.value = item.idmarca;
      option.innerText = item.marca;
      optMarca.appendChild(option);
    });
    await getCategorias();
  }
  // render options de presentaciones / unidades de medida
  async function renderOptions() {
    const data = await getUnidades();
    const options = $("#unidadmedida");
    data.forEach(item => {
      const option = document.createElement('option');
      option.value = item.idunidadmedida;
      option.innerText = item.unidadmedida;
      options.appendChild(option);
    });
  }
  renderOptions();

  // limpiar campos
  function cleanCampos() {
    $("#idmarca").innerHTML = "";
    $("#idcategoria").value = "";
    $("#idcategoria").innerHTML = "";
    $("#idsubcategoria").value = "";
    $("#unidadmedida").value = "";
    $("#nombreproducto").value = "";
    $("#cantidad").value = "";
    $("#cantidad").removeAttribute("disabled");
    $("#peso").value = "";
    $("#unidad").value = "";
    $("#codigo").value = "";
    $("#preciocompra").value = "";
    $("#precio-minorista").value = "";
    $("#precio-mayorista").value = "";
    $("#idcategoria").innerHTML = `<option value="">Seleccione una categoría</option>`
    $("#idmarca").innerHTML = `<option value="">Seleccione una marca</option>`
  }

  // verificar si el codigo ya existe
  async function verificarCodigo(codigo) {
    const params = new URLSearchParams();
    params.append('operation', 'getCodeProducto');
    params.append('codigo', codigo);
    try {
      const response = await fetch(`../../controller/producto.controller.php?${params}`);
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }
  // evento input para seleccionar categoria y cargar subcategorias
  $("#idcategoria").addEventListener("change", async () => {
    const id = $("#idcategoria").value;
    console.log(id);
    const data = await getSubcategorias(id);
    console.log("subcategorias", data);
    optionsub.innerHTML = '<option value="">Seleccione una subcategoria</option>';
    data.datos.forEach(item => {
      const option = document.createElement('option');
      option.value = item.idsubcategoria;
      option.innerText = item.subcategoria;
      optionsub.appendChild(option);
    });
  });

  // evento input para buscar proveedor
  $("#idproveedor").addEventListener("input", async () => {
    proveedores = $("#idproveedor").value.trim();
    console.log("letra de proveedore:" + proveedores.length);

    if (!proveedores) {
      $("#list-proveedor").style.display = "none";
      console.log("no hay proveedores");
      // $("#list-proveedor").innerHTML = "";
      cleanCampos();
    } else {
      await renderData();
    }
  });

  $("#unidadmedida").addEventListener("change", async (Event) => {
    if ($("#unidadmedida").value != 1) {
      $("#cantidad").removeAttribute("disabled");
      $("#cantidad").value = "";
    } else {
      $("#cantidad").setAttribute("disabled", true);
      $("#cantidad").value = "1";
    }
  });

  function validarPrecio() {
    const preciocompra = parseFloat($("#preciocompra").value);
    const precioMayorista = parseFloat($("#precio-mayorista").value);
    const preciominorista = parseFloat($("#precio-minorista").value);

    if (preciocompra == "" || precioMayorista == "" || preciominorista == "") {
      showToast("Los campos de precio no pueden estar vacíos", "info", "INFO");
      return false;
    } if (preciominorista <= precioMayorista) {
      showToast("El precio minorista no puede ser menor o igual al precio mayorista", "info", "INFO");
      return false;
    } if (precioMayorista >= preciominorista) {
      showToast("El precio mayorista no puede ser mayor o igual al precio minorista", "info", "INFO");
      return false;
    } if (precioMayorista <= preciocompra) {
      showToast("El precio mayorista no puede ser menor o igual al precio de compra", "info", "INFO");
      return false;
    }if(preciocompra >= precioMayorista){
      showToast("El precio de compra no puede ser menor o igual al precio mayorista", "info", "INFO");
      return false;
    }if(preciocompra >= preciominorista){
      showToast("El precio de compra no puede ser menor o igual al precio minorista", "info", "INFO");
      return false;
    }
    return true;
  }





  // registrar producto aun no terminado
  async function registrarproducto() {
    const params = new FormData();
    params.append('operation', 'addProducto');
    params.append('idproveedor', $("#idproveedor").getAttribute("data-id"));
    params.append('idmarca', optMarca.value);
    params.append('idsubcategoria', optionsub.value);
    params.append('nombreproducto', $("#nombreproducto").value);
    params.append('idunidadmedida', $("#unidadmedida").value);
    params.append('cantidad_presentacion', $("#cantidad").value);
    params.append('peso_unitario', $("#peso").value + " " + $("#unidad").value);
    params.append('codigo', $("#codigo").value);
    params.append('precio_compra', $("#preciocompra").value);
    params.append('precio_mayorista', $("#precio-mayorista").value);
    params.append('precio_minorista', $("#precio-minorista").value);

    /*  for (let [key, value] of params.entries()) {
       console.log(key, value);
     } */

    const options = {
      method: 'POST',
      body: params
    };

    const response = await fetch(`../../controller/producto.controller.php`, options);
    return response.json()
  }



  $("#formRegistrarProducto").addEventListener("submit", async (event) => {
    event.preventDefault();
    const codigo = $("#codigo").value;
    // validarPrecio();
    const data = await validarPrecio();
    if (data == false) {
      return;
    }
    const response = await verificarCodigo(codigo);
    console.log(response);
    if (response.length > 0) {
      showToast(`El código ${response[0].codigo} ya existe. \n Producto: ${response[0].nombreproducto}`, "error", "ERROR");
      return;
    } else {


      console.log(data);
      const resultado = await registrarproducto();
      console.log(resultado.id);
      if (resultado.id != null && resultado.id > 0) {
        showToast("Producto registrado correctamente", "success", "SUCCESS");
      } else {
        showToast("Error al registrar producto", "error", "ERROR");
      }

    }
  });
  // fin registrar producto
});
