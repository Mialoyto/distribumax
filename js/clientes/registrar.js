document.addEventListener("DOMContentLoaded",()=>{
  function $(object = null){return document.querySelector(object)}
  
  function debounce(func, wait) {
    let timeout;
    return function (...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }
  async function dataCliente() {
    if (!$("#nro-doc")) {
      return;
    }
    const params = new URLSearchParams();
    params.append("operation", "searchCliente");
    params.append("nro_documento", $("#nro-doc").value.trim());

    try {
      const response = await fetch(
        `../../controller/cliente.controller.php?${params}`
      );
      const data = await response.json();
      console.log(data);
      return data;
    } catch (e) {
      console.error(e);
    }
  }
  function desactivarCampos() {
    $("#nombres").setAttribute("disabled", true);
    $("#appaterno").setAttribute("disabled", true);
    $("#apmaterno").setAttribute("disabled", true);
    $("#razon-social").setAttribute("disabled", true);
    $("#direccion-cliente").setAttribute("disabled", true);
  }
  let idCliente;
  async function validarNroDoc(response) {
    if (response.length === 0) {
      resetCampos();
      desactivarCampos();
      console.log("No existe el cliente");
    } else {
      if (response[0].tipo_cliente === "Persona") {
        $("#cliente").value = response[0].tipo_cliente;
        $("#nombres").value = response[0].nombres;
        $("#appaterno").value = response[0].appaterno;
        $("#apmaterno").value = response[0].apmaterno;
        $("#distrito").value    = response[0].distrito;
        desactivarCampos();
      } else if(response[0].tipo_cliente==="Empresa"){
        $("#razon-social").value = response[0].razonsocial;
        $("#distrito").value=response[0].distrito;
        $("#email").value=response[0].email;
        desactivarCampos();
      }

      $("#direccion-cliente").value = response[0].direccion_cliente;
      idCliente = response[0].idcliente;
      const option = document.createElement("option");
      option.value = response[0].idcliente;
      option.text = response[0].tipo_cliente;
      option.selected = true;

      $("#cliente").appendChild(option);
      console.log("id Cliente:", idCliente);
    }
  }
  $("#nro-doc").addEventListener("input", debounce(async () => {

    if ($("#nro-doc").value === "") {
      desactivarCampos();
      $("#detalle-pedido").innerHTML = "";
      resetCampos();
    } else {
      const response = await dataCliente();
      await validarNroDoc(response);
      $("#nro-doc").addEventListener('keydown', (event) => {
        if (event.keyCode == 13) {
          event.preventDefault();
          $("#addProducto").focus();
        }
      })

    }
  }, 500));
})