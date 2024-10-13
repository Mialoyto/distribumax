document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  const optionEmpresa = $("#idmarca");
  const optionsub = $("#idsubcategoria");
  const optMarca = $("#idmarca");
  let proveedores;
  let id;

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


  // obtener proveedores
  async function getProveedor(proveedor) {
    const params = new URLSearchParams();
    params.append('operation', 'getProveedor');
    params.append('proveedor', proveedor);
    try {
      const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
      return response.json();

    } catch (e) {
      console.error(e);
    }
  }

  // renderizar datos lista
  async function renderData() {
    const response = await getProveedor(proveedores);
    $("#list-proveedor").innerHTML = "";
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
          await renderOption();
        });
        $("#list-proveedor").appendChild(li);
      });
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
    await renderData();
    proveedores = $("#idproveedor").value;
    if (proveedores === "") {
      $("#list-proveedor").style.display = "none";
      $("#list-proveedor").innerHTML = "";
      $("#idmarca").innerHTML = "";
      $("#idmarca").innerHTML = '<option value="">Seleccione una marca</option>';
      $("#idcategoria").innerHTML = '<option value="">Seleccione una categoria</option>';
      $("#idsubcategoria").innerHTML = '<option value="">Seleccione una subcategoria</option>';
    }
  });

  // registrar producto aun no terminado
  async function registrarproducto() {
    const params = new FormData();
    params.append('operation', 'addProducto');
    params.append('idmarca', optionEmpresa.value);
    params.append('idsubcategoria', optionsub.value);
    params.append('nombreproducto', $("#nombreproducto").value);
    params.append('descripcion', $("#descripcion").value);
    params.append('codigo', $("#codigo").value);
    params.append('preciounitario', $("#preciounitario").value);

    const options = {
      method: 'POST',
      body: params
    };

    const response = await fetch(`../../controller/producto.controller.php`, options);
    return response.json()
    // .catch(e => { console.error(e) });
  }

  $("#formRegistrarProducto").addEventListener("submit", async (event) => {
    event.preventDefault();
    const resultado = await registrarproducto();

    if (resultado) {
      alert("Registro exitoso");
    }
  });
  // fin registrar producto
});
