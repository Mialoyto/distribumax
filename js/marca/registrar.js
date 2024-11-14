document.addEventListener("DOMContentLoaded", () => {
  const formarca = document.querySelector("#form-registrar-marca");
  const marca = document.querySelector("#marca");
  function $(object = null) {
    return document.querySelector(object);
  }

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
  // getCategorias();


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

  function desabilitarCampos() {
    $("#idcategoria").setAttribute("disabled", true);
    $("#marca").setAttribute("disabled", true);
    $("#btn-registrar").setAttribute("disabled", true);
  }

  function habilitarCampos() {
    $("#idcategoria").removeAttribute("disabled");
    $("#marca").removeAttribute("disabled");
    $("#btn-registrar").removeAttribute("disabled");
  }

  function cleanCampos() {
    $("#idcategoria").value = '';
    $("#marca").value = '';
  }

  async function renderData() {
    const response = await getProveedor(proveedores);
    $("#list-proveedor").innerHTML = "";
    if (response && response.data.length > 0) {
      $("#list-proveedor").style.display = "block";

      response.data.forEach((item) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.proveedor} <span class="badge text-bg-secondary">${item.idempresa}</span>`;
        li.addEventListener("click", () => {
          $("#list-proveedor").innerHTML = "";
          $("#idproveedor").setAttribute("data-id", item.idproveedor);
          $("#idproveedor").value = item.proveedor;
          cleanCampos();
          habilitarCampos();  // Habilitar los campos cuando se selecciona un proveedor
        });
        $("#list-proveedor").appendChild(li);
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Proveedor no encontrado</b>`;
      $("#list-proveedor").appendChild(li);
      desabilitarCampos(); // Mantener deshabilitados si no hay proveedor
    }
  }

  async function registrarmarca() {
    const params = new FormData();
    params.append("operation", "addMarca");
    params.append("idproveedor", $("#idproveedor").value);
    params.append("marca", $("#marca").value);
    params.append("idcategoria", $("#idcategoria").value);

    const options = {
      method: "POST",
      body: params,
    };

    try {
      const response = await fetch(`../../controller/marca.controller.php`, options);
      const data = await response.json();
      console.log(data);
      // Aquí puedes agregar lógica para mostrar el mensaje en la interfaz de usuario si es necesario
    } catch (e) {
      console.error('Error al registrar la marca:', e);
    }
  }

  $("#idproveedor").addEventListener("input", async () => {
    proveedores = $("#idproveedor").value.trim();

    if (!proveedores) {
      $("#list-proveedor").style.display = "none";
      cleanCampos();
      desabilitarCampos();  // Deshabilitar los campos si no hay proveedor
    } else {
      await renderData();
      // Se habilitarán los campos cuando se seleccione un proveedor en renderData()
    }
  });

  desabilitarCampos(); // Inicialmente deshabilitar los campos

  $("#form-registrar-marca").addEventListener("submit", async (event) => {
    event.preventDefault();

    if (showConfirm("Desea registrar", "Marcas")) {
      await registrarmarca();
      $("#form-registrar-marca").reset();
    }
  });
});
