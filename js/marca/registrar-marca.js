document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  const listProveedor = $("#list-proveedor");
  const idProveedor = $("#idproveedor");
  const formMarca = document.querySelector("#form-registrar-marca");
  const idmarca = document.querySelector("#idmarca");
  const listmarca = $("#list-marcas");
  let proveedores;

  async function getMarcas(marca) {
    const params = new URLSearchParams();
    params.append("operation", "searchMarcas");
    params.append("item", marca);
    try {
      const response = await fetch(`../../controller/marca.controller.php?${params}`);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }
 
  async function renderDataMarcas() {
    listmarca.innerHTML = "";
    if (dataMarca) {
      listmarca.style.display = "block";
      console.log(dataMarca);

      dataMarca.forEach((item) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.marca.toUpperCase()} <span class="badge text-bg-secondary" type="hidden">${item.idmarca}</span>`;

        li.addEventListener("click", () => {
          listmarca.innerHTML = "";
          idmarca.setAttribute("data-id", item.idmarca);
          idmarca.value = item.marca;
          console.log(dataMarca);
        });
        $("#list-marcas").appendChild(li);
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Marca no encontrada</b>`;
      $("#list-marcas").appendChild(li);
    }

  }
  


  // BUSCADOR DE PROVEEDORES
  async function getProveedor(proveedor) {
    const params = new URLSearchParams();
    params.append("operation", "getProveedor");
    params.append("idproveedor", proveedor);
    try {
      const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }

  async function renderData() {
    listProveedor.innerHTML = "";
    if (dataProveedor) {
      listProveedor.style.display = "block";
      console.log(dataProveedor);

      dataProveedor.forEach((item) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.proveedor} <span class="badge text-bg-secondary">${item.idempresa}</span>`;
        li.addEventListener("click", () => {
          listProveedor.innerHTML = "";
          idProveedor.setAttribute("data-id", item.idproveedor);
          idProveedor.value = item.proveedor;
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

  // async function validarDatos() {

  //   const idProveedorValue = idProveedor.getAttribute("data-id");
  //   const marcaValue = marca.value.trim();
  //   const categoriaValue = idselect.value;
  //   console.log(idProveedorValue);
  //   console.log(marcaValue);
  //   console.log(categoriaValue);

  //   if (!idProveedorValue) {
  //     showToast("Seleccione un proveedor", "info");
  //     return false;
  //   }
  //   if (!categoriaValue) {
  //     showToast("Seleccione una categoria", "info");
  //     return false;
  //   }
  //   return true;
  // }


  async function registrarMarca() {
    const inputMarca = document.querySelector("#marca").value.trim();
    const params = new FormData();
    params.append("operation", "addMarca");
    params.append("idproveedor", idProveedor.getAttribute("data-id"));
    params.append("marca", inputMarca);

    const options = {
      method: "POST",
      body: params
    };

    try {
      const response = await fetch(`../../controller/marca.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error('Error al registrar la marca:', e);
    }
  }

  formMarca.addEventListener("submit", async (event) => {
    event.preventDefault();
   
      if (await showConfirm("Desea registrar", "Marcas")) {
        const data = await registrarMarca();
        console.log(data[0].idmarca);

        if (data[0].idmarca > 0) {
          showToast(`${data[0].mensaje}`, "success", "SUCCESS");
          formMarca.reset();
        } else {
          showToast(`${data[0].mensaje}`, "error", "ERROR");
        }
      }
    
  });


  let dataProveedor;
  idProveedor.addEventListener("input", async () => {
    proveedores = idProveedor.value.trim();
    console.log(proveedores);
    dataProveedor = await getProveedor(proveedores);
    console.log(dataProveedor);

    if (!proveedores) {
      listProveedor.innerHTML = "";
      idProveedor.removeAttribute("data-id");
      return;
    }
    if (proveedores) {
      renderData();
    }
  });

  let dataMarca;
  idmarca.addEventListener("input", async () => {
    const marca = idmarca.value.trim();
    console.log(marca);
    dataMarca = await getMarcas(marca);
    console.log(dataMarca);

    if (!marca) {
      listmarca.innerHTML = "";
      idmarca.removeAttribute("data-id");
      return;
    }
    if (marca) {
      renderDataMarcas();
    }
  });

  formMarca.addEventListener("submit", async (event) => {
    event.preventDefault();

    if (await showConfirm("Desea registrar", "Marcas")) {
      const data = await registrarMarca();
      console.log(data[0].idmarca);

      if (data[0].idmarca > 0) {
        showToast(`${data[0].mensaje}`, "success", "SUCCESS");
        formMarca.reset();
      } else {
        showToast(`${data[0].mensaje}`, "error", "ERROR");
      }
    }

  });

  // const addSubcategoria = document.querySelector("#subcategoria");
  let contadorSubcategorias = 0;

  // Función para actualizar el contador en la vista
  function actualizarContador() {
    const contadorElement = document.querySelector("#contador-subcategorias");
    contadorElement.textContent = contadorSubcategorias;
  }

  function addSubcategoria() {
    const contenedor = document.querySelector("#addsubcategoria")
    const div = document.createElement("div");
    div.classList.add("input-group", "mb-3", "subcategoria");

    div.innerHTML = `
    <div class="form-floating">
        <input type="text" class="form-control inputSubcategoria" placeholder="Ej. Alimentos" required>
        <label for="subcategoria" class="form-label">
          <i class="bi bi-tag"></i>
          Subcategoría
        </label>
    </div>
      <button type="button" class="btn btn-danger  eliminar-subcategoria">
        <i class="bi bi-trash"></i>
      </button>
        `;
    contenedor.appendChild(div);
    contadorSubcategorias++;
    actualizarContador();
    div.querySelector(".eliminar-subcategoria").addEventListener("click", () => {
      div.remove();
      contadorSubcategorias--;
      actualizarContador();
    });
  }

  const btn_addsubcategoria = document.querySelector("#btn-subcategoria");
  btn_addsubcategoria.addEventListener("click", addSubcategoria);

});