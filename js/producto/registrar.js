document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  const optionEmpresa = $("#idmarca");
  const optionsub = $("#idsubcategoria");
  const optMarca = $("#idmarca");

  async function getCategorias() {
    const params = new URLSearchParams();
    params.append('operation', 'getAll');
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
  getCategorias();
  $("#idcategoria").addEventListener("change", async () => {

  });

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
  let id
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

  async function renderOption (){
    const data = await getMarcas(id);
    console.log(data.marcas);
    optMarca.innerHTML = '<option value="">Seleccione una marca</option>';
    data.marcas.forEach(item => {
      const option = document.createElement('option');
      option.value = item.idmarca;
      option.innerText = item.marca;
      optMarca.appendChild(option);
    });
  }

  let proveedores;
  $("#idproveedor").addEventListener("input", async () => {
    await renderData();
    proveedores = $("#idproveedor").value;
    if (proveedores === "") {
      $("#list-proveedor").style.display = "none";
      $("#list-proveedor").innerHTML = "";
      $("#idmarca").innerHTML = "";
      $("#idmarca").innerHTML = '<option value="">Seleccione una marca</option>';
    }
  });

  // Llamar a la función para obtener marcas y subcategorías
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
});
