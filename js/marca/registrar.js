document.addEventListener("DOMContentLoaded", () => {
  const formarca = document.querySelector("#form-registrar-marca");
  const marca = document.querySelector("#marca");
  function $(object = null) {
    return document.querySelector(object);
  }

  (()=>{
    fetch(`../../controller/categoria.controller.php?operation=getAll`)
    .then(response=>response.json())
    .then(data=>{
        const Tagoption=$("#idcategoria");
        data.forEach(element => {
            const option=document.createElement('option');
            option.value=element.idcategoria;
            option.innerText=element.categoria;
            Tagoption.appendChild(option);   
       });
    })
  })();
  async function getProveedor(proveedor) {
    const params = new URLSearchParams();
    params.append("operation", "getProveedor");
    params.append("proveedor", proveedor);
    try {
      const response = await fetch(
        `../../controller/proveedor.controller.php?${params}`
      );
      return response.json();
    } catch (e) {
      console.error(e);
    }
  }
  function desabilitarCampos() {
    $("#idcategoria").setAttribute("disabled", true);
    $("#marca").setAttribute("disabled", true);
    $("#btn-registrar").setAttribute("disabled",true);
  }
  function habilitarCampos(){
      $("#idcategoria").removeAttribute("disabled");
      $("#marca").removeAttribute("disabled");
      $("#btn-registrar").removeAttribute("disabled");
 
  }
  function cleanCampos(){
    $("#idcategoria").value = '';
    $("#marca").value = '';
    
}
  async function renderData() {
    $("#list-proveedor").innerHTML = "";
    const response = await getProveedor(proveedores);

    if (response && response.data.length > 0) {
      $("#list-proveedor").style.display = "block";

      response.data.forEach((item) => {
        const li = document.createElement("li");
        li.classList.add("list-group-item");
        li.innerHTML = `${item.proveedor} <h6 class="btn btn-secondary btn-sm h-25 d-inline-block">${item.idempresa}</h6>`;
        li.addEventListener("click", () => {
          $("#list-proveedor").innerHTML = "";
          $("#idproveedor").setAttribute("data-id", item.idproveedor);
          $("#idproveedor").value = item.proveedor;
          cleanCampos();
          // Guarda el proveedor seleccionado
        });
        $("#list-proveedor").appendChild(li);
      });
    } else {
      const li = document.createElement("li");
      li.classList.add("list-group-item");
      li.innerHTML = `<b>Proveedor no encontrado</b>`;
      $("#list-proveedor").appendChild(li);
      desabilitarCampos();
    }
  }

  async function registrarempresa() {
    const params = new FormData();
    params.append("operation", "addMarca");
    params.append("marca", marca.value);

    const options = {
      method: "POST",
      body: params,
    };

    const response = await fetch(
      `../../controller/marca.controller.php`,
      options
    );
    return response
      .json()

      .catch((e) => {
        console.error(e);
      });
  }
  $("#idproveedor").addEventListener("input", async () => {
    proveedores = $("#idproveedor").value.trim();

    if (!proveedores) {
      $("#list-proveedor").style.display = "none";
      cleanCampos();
      habilitarCampos();
    } else {
      await renderData();
      habilitarCampos();
    }
  });

  desabilitarCampos();

  $("#form-")
});
