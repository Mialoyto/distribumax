document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

  const listProveedor = $("#list-proveedor");
  const idProveedor = $("#idproveedor");
  const formMarca = document.querySelector("#form-registrar-marca");
  const marca = document.querySelector("#marca");
  const idselect = document.querySelector("#idcategoria");
  let proveedores;


  getCategorias();

  // BUSCADOR DE PROVEEDORES
  async function getProveedor(proveedor) {
    const params = new URLSearchParams();
    params.append("operation", "getProveedor");
    params.append("proveedor", proveedor);
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

      dataProveedor.data.forEach((item) => {
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

  async function validarDatos() {

    const idProveedorValue = idProveedor.getAttribute("data-id");
    const marcaValue = marca.value.trim();
    const categoriaValue = idselect.value;

    if (!idProveedorValue) {
      showToast("Seleccione un proveedor", "info");
      return false;
    }
    if (!categoriaValue) {
      showToast("Seleccione una categoria", "info");
      return false;
    }
    return true;


  }

  async function registrarMarca() {
    const inputMarca = marca.value.trim();
    const params = new FormData();
    params.append("operation", "addMarca");
    params.append("idproveedor", idProveedor.getAttribute("data-id"));
    params.append("marca", inputMarca);
    params.append("idcategoria", idselect.value);

    const options = {
      method: "POST",
      body: params,
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
    const data = await validarDatos();
    if (!data) {
      return;
    } else {
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
    }
  });


  let dataProveedor;
  idProveedor.addEventListener("input", async () => {
    proveedores = idProveedor.value.trim();
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
});
