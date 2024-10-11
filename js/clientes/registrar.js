document.addEventListener("DOMContentLoaded", () => {
  function $(object = null) {
    return document.querySelector(object);
  }

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
    params.append("operation", "searProspecto");
    params.append("item", $("#nro-doc").value.trim());
    params.append("tipo_cliente",$("#cliente").value)

    try {
      const response = await fetch(`../../controller/cliente.controller.php?${params}`);
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
    $("#distrito").setAttribute("disabled", true);
    $("#email").setAttribute("disabled", true);
  }

  function resetCampos() {
    $("#cliente").value = "";
    $("#nro-doc").value = ""; // Reiniciar el número de documento
    $("#appaterno").value = "";
    $("#apmaterno").value = "";
    $("#nombres").value = "";
    $("#razon-social").value = "";
    $("#direccion-cliente").value = "";
    $("#distrito").value = "";
    $("#email").value = "";
  }

  async function validarNroDoc(response) {
    if (response.length === 0) {
      // resetCampos();
       alert("No existe la Persona o Empresa");
    } else {
      const clienteData = response[0];
  
      // Si el cliente está registrado pero es una empresa o una persona.
      if (clienteData.estado === 'Registrado') {
        resetCampos();
        desactivarCampos();
        alert(clienteData.estado);
      } else {
        // Ajusta los datos según sea Persona o Empresa
        $("#cliente").value = clienteData.tipo_cliente;
        $("#nro-doc").value = clienteData.identificador;
  
        if (clienteData.tipo_cliente === "Persona" && clienteData.identificador.length === 8) {
          // Manejo para "Persona"
          $("#nombres").value = clienteData.nombres;
          $("#appaterno").value = clienteData.nombre_razon_social;
          $("#apmaterno").value = clienteData.apellido_direccion;
          $("#direccion-cliente").value = clienteData.direccion;
          $("#distrito").value = clienteData.distrito;
          desactivarCampos();
          toggleForm("Persona");
        } else if (clienteData.tipo_cliente === "Empresa" && clienteData.identificador.length === 11) {
          // Manejo para "Empresa"
          $("#razon-social").value = clienteData.nombre_razon_social;
          $("#email").value = clienteData.email;  // Asegúrate de tener el campo email en el objeto clienteData
          $("#direccion-cliente").value = clienteData.direccion;
          $("#distrito").value = clienteData.distrito;
          
          desactivarCampos();
          toggleForm("Empresa");
        }
      }
    }
  }
  
  


  function toggleForm(tipoCliente) {
    const formPersona = $("#form-persona");
    const formEmpresa = $("#form-empresa");
    const nroDocInput = $("#nro-doc");

    if (tipoCliente === 'Persona') {
      formPersona.style.display = 'block';
      formEmpresa.style.display = 'none';

      // Para personas, ajusta el `maxlength` y `minlength` a 8 (DNI)
      nroDocInput.setAttribute('maxlength', '8');
      nroDocInput.setAttribute('minlength', '8');
      nroDocInput.setAttribute('pattern', '[0-9]{8}');
      //nroDocInput.value = ""; // Limpiar el campo para ingresar el nuevo documento

    } else {
      formPersona.style.display = 'none';
     formEmpresa.style.display = 'block';
//
     // // Para empresas, ajusta el `maxlength` y `minlength` a 11 (RUC)
      nroDocInput.setAttribute('maxlength', '11');
      nroDocInput.setAttribute('minlength', '11');
      nroDocInput.setAttribute('pattern', '[0-9]{11}');
      //nroDocInput.value = ""; // Limpiar el campo para ingresar el nuevo documento
    }
  }

  // Detectar el cambio en el select para ajustar el formulario y nro-doc


  async function registrarCliente() {
    const params = new FormData();
    params.append('operation', 'addcliente');
    params.append('idpersona', $("#nro-doc").value);
    params.append('idempresa', $("#nro-doc").value);
    params.append('tipo_cliente', $("#cliente").value);
    console.log();
    //console.log($("#nro-doc"))
    const option = {
      method: 'POST',
      body: params,
    };

    try {
      const response = await fetch(`../../controller/cliente.controller.php`, option);
      const data = await response.json();
      //console.log(data);
      console.log("id:", data);
      return data; // Retornar los datos para poder validar el resultado

    } catch (error) {
      console.error('Error al registrar cliente:', error);
      return null; // Retornar null en caso de error
    }
  }

  $("#nro-doc").addEventListener("input", debounce(async () => {
    if ($("#nro-doc").value === "") {
      resetCampos();
      // desactivarCampos();
    } else {
      const response = await dataCliente();
      await validarNroDoc(response);
    }
  }, 500));


  $("#cliente").addEventListener("change", () => {
    const tipo_cliente = $("#cliente").value;
    toggleForm(tipo_cliente); // Asegúrate de que esto esté habilitado
    console.log(tipo_cliente);
    
    //if (tipo_cliente === 'Persona') {
    //  resetCampos();
    //} else {
    //  resetCampos();
    //}
  });
  

  $("#form-registrar-Cliente").addEventListener("submit", async (event) => {
    const form = $("#form-registrar-Cliente");
    const idcliente = $("#nro-doc").value;
    event.preventDefault();
    if (confirm("desea registrar")) {

      const response = await registrarCliente();
      if (response) {
        alert("registro exitoso");
        form.reset();
      }
    }

  });

  // $("#reset").addEventListener("click",async (event)=>{
  // $("#form-registrar-Cliente").reset();
  // 
  // });



});
