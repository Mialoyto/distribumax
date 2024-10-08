document.addEventListener("DOMContentLoaded", () => {
  function $(selector = null) {
    return document.querySelector(selector);
  };


  // obtener el id del metodo.
  const optionMe = $("#idmetodopago");
  //const opntionMe = $("#idmetodopago_2");
  const optionCo = $("#idtipocomprobante");
  async function Validarfecha() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
    document.getElementById('fecha_venta').setAttribute('min', minDateTime);
  };
  Validarfecha();




  async function metodoPago(idmetodopago) {
    fetch(`../../controller/metodoP.controller.php?operation=getAll`)
      .then(response => response.json())
      .then(data => {
        const select = $(idmetodopago);
        data.forEach(metodo => {
          const tagOption = document.createElement('option');
          tagOption.value = metodo.idmetodopago;
          tagOption.innerText = metodo.metodopago;
          select.appendChild(tagOption);
        });
      })
      .catch(e => console.error(e));
  };
  //llamando el metodo y mostrarlo con su id.
  metodoPago('#idmetodopago');
  metodoPago('#idmetodopago_2');




  (() => {
    // Cargar todos los tipos de comprobantes una sola vez al cargar la página
    fetch(`../../controller/comprobante.controller.php?operation=getAll`)
      .then(response => response.json())
      .then(data => {
        window.comprobantesData = data; // Guardar en una variable global para su uso posterior
      })
      .catch(e => console.error(e));
  })();
  /* fin de la funciones autoejecutables */
  function generarFechaActual() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');

    // Formato que necesita el campo "datetime-local"
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  };

  const buscarPedido = async () => {
    const params = new URLSearchParams();
    params.append('operation', 'searchPedido');
    params.append('_idpedido', $("#idpedido").value.trim());

    try {
      const response = await fetch(`../../controller/pedido.controller.php?${params}`);
      return response.json();
    } catch (e) {
      console.error(e);
    }
  };

  const mostraResultados = async () => {
    const response = await buscarPedido();
    console.log("response", response);
    let datalist = $("#datalistIdPedido");
    datalist.innerHTML = '';

    if (response.length > 0) {
      datalist.style.display = 'block';
      response.forEach((item) => {
        //console.log("item", item);
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.value = `${item.idpedido}`;
        li.innerText = `${item.idpedido}` + '--' + `${item.nombre_o_razonsocial}`;
        li.addEventListener('click', () => {
          $("#idpedido").value = item.idpedido;
          CargarPedido(item.idpedido);
          datalist.style.display = 'none';
          datalist.value = '';
        });
        datalist.appendChild(li);
      });

    } else {
      datalist.style.display = 'none';
    }
  };

  const validarmontos = async () => {
    const tipoPagoSelect = $("#tipo_pago");
    // tipoPagoSelect.innerHTML = '';
    //console.log(tipoPagoSelect)
    
    tipoPagoSelect.addEventListener("change", () => {
      const monto1 = parseFloat($("#monto_pago_1").value);
      const ventatotal = parseFloat($("#total_venta").value);

      if (tipoPagoSelect.value === 'unico') {
        //console.log("El monto se bloquea en el tipo de pago único.");
        $("#monto_pago_1").value = ventatotal; // Se asigna el total de la venta al monto único
        $("#monto_pago_1").setAttribute('readonly', true);// Bloqueamos el campo de monto 1

        //$("#monto_pago_2").value = ''; // Limpiar el segundo campo de monto

      }
      if (tipoPagoSelect.value === 'mixto') {
        // Si el tipo de pago es mixto, se habilita la validación
        $("#monto_pago_1").removeAttribute('readonly');
        $("#monto_pago_2").setAttribute('readonly', true);
         // Desabilitamos  el campo de monto 1
        if (monto1 <= 0 || monto1 >= ventatotal) {

          showToast(`El monto debe de ser mayor a o y menor que la venta`, 'warning', 'WARNING');
         // $("#monto_pago_1").value = ''; // Limpiar el campo para forzar un nuevo ingreso
        } else {

          // Actualizar el monto restante en el segundo campo
          const resto = ventatotal - monto1;
          $("#monto_pago_2").value = resto.toFixed(2);
        }



      }
    });

  };
  const ValidarSelect = async () => {

    const tipoPagoSelect = $("#tipo_pago");
    const metodoPago1Select = $("#idmetodopago");
    const metodoPago2Select = $("#idmetodopago_2");
    const metodoPago2Container = $("#metodo_pago_2");

    // Función para manejar la selección de tipo de pago
    tipoPagoSelect.addEventListener("change", () => {
      if (tipoPagoSelect.value === "mixto") {
        metodoPago2Container.style.display = "block"; // Mostrar método de pago 2
      } else {
        metodoPago2Container.style.display = "none"; // Ocultar método de pago 2
        metodoPago2Select.value = ""; // Reiniciar selección del método de pago 2
      }
    });

    // Función para manejar la selección del primer método de pago
    metodoPago1Select.addEventListener("change", () => {
      const selectedOption = metodoPago1Select.value;

      // Habilitar todas las opciones del segundo select antes de proceder
      Array.from(metodoPago2Select.options).forEach(option => {
        option.disabled = false;
      });

      // Deshabilitar la opción seleccionada en el primer select en el segundo select
      if (selectedOption) {
        Array.from(metodoPago2Select.options).forEach(option => {
          if (option.value === selectedOption) {
            option.disabled = true;
          }
        });
      }
    });
  };

  const CargarPedido = async (idpedido) => {
    const params = new URLSearchParams();
    params.append('operation', 'getById');
    params.append('idpedido', idpedido);

    try {
      const response = await fetch(`../../controller/pedido.controller.php?${params}`);
      const data = await response.json();
      // console.log("datos del pedido", data);
      const tbody = $("#productosTabla tbody");
      tbody.innerHTML = ''; // Limpiar la tabla antes de añadir los nuevos resultados
      let subtotal = 0;
      let descuentoTotal = 0; // Variable para acumular el descuento total
      const fechaActual = generarFechaActual();
      $("#fecha_venta").value = fechaActual; // Establecer la fecha actual
      const tipoComprobanteSelect = $("#idtipocomprobante");
       // El select de tipo de comprobante
       tipoComprobanteSelect.innerHTML = '';
     
      data.forEach(pedido => {

        const tipo_cliente = $("#tipocliente").value = pedido.tipo_cliente;

        if (tipo_cliente === 'Empresa') {
          // Cargar datos de empresa
          $("#nombres").value = pedido.razonsocial;
          $("#direccion").value = pedido.direccion;

          // Filtrar y agregar la opción Factura al select
          const facturaOption = window.comprobantesData.find(comprobante => comprobante.comprobantepago === 'Factura');
          if (facturaOption) {
            const option = document.createElement('option');
            option.value = facturaOption.idtipocomprobante;
            option.text = facturaOption.comprobantepago;
            tipoComprobanteSelect.appendChild(option);
          }

          // Agregar la opción Boleta si es necesario
          const boletaOption = window.comprobantesData.find(comprobante => comprobante.comprobantepago === 'Boleta');
          if (boletaOption) {
            const option = document.createElement('option');
            option.value = boletaOption.idtipocomprobante;
            option.text = boletaOption.comprobantepago;
            tipoComprobanteSelect.appendChild(option);
          }

        } else if (tipo_cliente === 'Persona') {
          // Cargar datos de persona
          $("#nombres").value = pedido.nombres + ' ' + pedido.appaterno + ' ' + pedido.apmaterno;
          $("#direccion").value = pedido.direccion;

          // Filtrar y agregar la opción Boleta al select
          const boletaOption = window.comprobantesData.find(comprobante => comprobante.comprobantepago === 'Boleta');
          if (boletaOption) {
            const option = document.createElement('option');
            option.value = boletaOption.idtipocomprobante;
            option.text = boletaOption.comprobantepago;
            tipoComprobanteSelect.appendChild(option);
          }

          // Agregar la opción Factura si es necesario
          const facturaOption = window.comprobantesData.find(comprobante => comprobante.comprobantepago === 'Factura');
          if (facturaOption) {
            const option = document.createElement('option');
            option.value = facturaOption.idtipocomprobante;
            option.text = facturaOption.comprobantepago;
            tipoComprobanteSelect.appendChild(option);
          }
        }



        const row = document.createElement('tr');
        const cantidad_producto = parseFloat(pedido.cantidad_producto);
        const preciounitario = parseFloat(pedido.precio_unitario);
        const total_producto = cantidad_producto * preciounitario; // Calcular total por producto

        row.innerHTML = `
                    <td>${pedido.nombreproducto}</td>
                    <td>${pedido.unidad_medida}</td>
                    <td>${cantidad_producto}</td>
                    
                    <td>${preciounitario.toFixed(2)}</td>
                    <td>${pedido.precio_descuento}</td>
                    <td>${total_producto.toFixed(2)}</td>
                   
                `;
        tbody.appendChild(row);

        // Sumar al subtotal y al descuento total
        subtotal += total_producto;
        descuentoTotal += parseFloat(pedido.precio_descuento);
      });

      // Actualizar los totales
      const igv = subtotal * 0.18;
      subtotal = subtotal - igv;
      const total_venta = (subtotal + igv) - descuentoTotal;
      $("#subtotal").value = subtotal.toFixed(2);
      $("#igv").value = igv.toFixed(2);
      $("#total_venta").value = total_venta.toFixed(2);
      $("#descuento").value = descuentoTotal.toFixed(2);
      const tipo_pago = $("#tipo_pago");


      tipo_pago.addEventListener("click", () => {
        //console.log(tipo_pago.value);

        if (tipo_pago.value == 'unico') {
          $("#monto_pago_1").value = total_venta;
        } else {
          $("#monto_pago_1").value = ``;
          let total = $("#total_venta").value

          $("#monto_pago_1").addEventListener('input', () => {
            let monto = parseFloat($("#monto_pago_1").value);

            //console.log(monto)
            let resto = total - monto;
            // console.log(resto)

            $("#monto_pago_2").value = resto;
            $("#monto_pago_2").innerHTML = '';


          })

        }


      });

        // ValidarSelect();
         
      //  $("#monto_pago_2").value=total_venta-monto1;

      // console.log(tipo_pago);

    } catch (e) {
      console.error(e);
    }
  };

  async function RegistrarVenta() {
    const params = new FormData();
    params.append('operation', 'addVentas');
    params.append('idpedido', $("#idpedido").value);
    params.append('idmetodopago', optionMe.value);
    params.append('idtipocomprobante', optionCo.value);
    params.append('fecha_venta', $("#fecha_venta").value);
    params.append('subtotal', $("#subtotal").value);
    params.append('descuento', $("#descuento").value);
    params.append('igv', $("#igv").value);
    params.append('total_venta', $("#total_venta").value);

    const options = {
      method: 'POST',
      body: params
    }
    const response = await fetch(`../../controller/ventas.controller.php`, options)
    return response.text()

      .catch(e => { console.error(e) });
  };

  $("#idpedido").addEventListener('input', async () => {
    if ($("#idpedido").value.trim()) {
      await mostraResultados();
      // Si hay un valor en el campo, buscar el pedido
      $("#datalistIdPedido").style.display = 'block';
      // await CargarPedido(idpedido);
    }
    else {
      // Si el campo está vacío, limpiar todos los datos
      limpiarDatosPedido();
      $("#datalistIdPedido").style.display = 'none';
    }
  });

  // Función para limpiar los datos cuando el campo de pedido está vacío
  function limpiarDatosPedido() {
    // Limpiar los datos del cliente
    $("#nombres").value = '';
    $("#direccion").value = '';
    $("#tipocliente").value = '';

    // Limpiar la tabla de productos
    const tbody = $("#productosTabla tbody");
    tbody.innerHTML = ''; // Limpiar la tabla de productos

    // Limpiar los totales
    $("#subtotal").value = '';
    $("#igv").value = '';
    $("#total_venta").value = '';
    $("#descuento").value = '';

    // Limpiar el select de tipo de comprobante
    const tipoComprobanteSelect = $("#idtipocomprobante");
    tipoComprobanteSelect.innerHTML = ''; // Limpiar opciones previas
    $("#tipo_pago").value = '';

    // Ocultar el contenedor de métodos de pago
    document.getElementById('paymentMethodsContainer').style.display = 'none';

    // Si tienes un campo de método de pago adicional
    const select = $(".form-select");
    select.value = '';

    // Ocultar la lista de resultados de búsqueda
    $("#datalistIdPedido").style.display = 'none';
  }





  $("#form-venta-registrar").addEventListener("submit", async (event) => {
    event.preventDefault();
    const resultado = await RegistrarVenta();
    if (resultado) {
      alert("Venta registrada exitosamente");
      $("#form-venta-registrar").reset();
      console.log(resultado);
      limpiarDatosPedido();
    }
  });

 // ValidarSelect();
  validarmontos();
});
