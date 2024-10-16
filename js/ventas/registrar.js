document.addEventListener("DOMContentLoaded", () => {
  // Función para simplificar el selector
  function $(selector = null) {
    return document.querySelector(selector);
  }

  // Validar y establecer la fecha mínima en el campo de fecha de venta
  async function Validarfecha() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
    document.getElementById('fecha_venta').setAttribute('min', minDateTime);
  }
  Validarfecha();

  // Cargar métodos de pago desde el servidor
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
  }
  metodoPago('#idmetodopago');
  metodoPago('#idmetodopago_2');

  // Cargar tipos de comprobantes
  (() => {
    fetch(`../../controller/comprobante.controller.php?operation=getAll`)
      .then(response => response.json())
      .then(data => {
        window.comprobantesData = data; // Guardar en una variable global
      })
      .catch(e => console.error(e));
  })();

  // Función para generar fecha actual en formato necesario
  function generarFechaActual() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  }

  // Función para buscar el pedido
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

  // Mostrar resultados de la búsqueda del pedido
  const mostraResultados = async () => {
    const response = await buscarPedido();
    console.log(response);
    let datalist = $("#datalistIdPedido");
    datalist.innerHTML = '';

    if (response.length > 0) {
      datalist.style.display = 'block';
      response.forEach((item) => {
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.value = `${item.idpedido}`;
        li.innerText = `${item.idpedido} -- ${item.nombre_o_razonsocial}`;
        li.addEventListener('click', () => {
          $("#idpedido").value = item.idpedido;
          CargarPedido(item.idpedido);
          datalist.style.display = 'none';
          datalist.value = '';
        });
        datalist.appendChild(li);
      });
    } else {
      li = document.createElement('li');
      li.classList.add('list-group-item');
      li.innerHTML = '<b>No se encontraron resultados</b>';
      datalist.appendChild(li);
    }
  };

  // // Función para validar y manejar montos
  // const validarmontos = async () => {

  //   const tipoPagoSelect = $("#tipo_pago");
  //   const monto1 = parseFloat($("#monto_pago_1").value);
  //   const ventatotal = parseFloat($("#total_venta").value);

  //   if(tipoPagoSelect=='unico'){
  //     console.log(tipoPagoSelect.value)
  //   }

  // };


  //validarmontos();
  // Validación para mostrar/ocultar campos según tipo de pago
  const ValidarSelect = async () => {
    const tipoPagoSelect = $("#tipo_pago");
    const metodoPago1Select = $("#idmetodopago");
    const metodoPago2Select = $("#idmetodopago_2");
    const metodoPago2Container = $("#metodo_pago_2");

    tipoPagoSelect.addEventListener("change", () => {
      if (tipoPagoSelect.value === "mixto") {
        metodoPago2Container.style.display = "block";
      } else {
        metodoPago2Container.style.display = "none";
        metodoPago2Select.value = "";
      }
    });

    metodoPago1Select.addEventListener("change", () => {
      const selectedOption = metodoPago1Select.value;

      Array.from(metodoPago2Select.options).forEach(option => {
        option.disabled = false;
      });

      if (selectedOption) {
        Array.from(metodoPago2Select.options).forEach(option => {
          if (option.value === selectedOption) {
            option.disabled = true;
          }
        });
      }
    });
  };

  // Cargar detalles del pedido seleccionado
  const CargarPedido = async (idpedido) => {
    const params = new URLSearchParams();
    params.append('operation', 'getById');
    params.append('idpedido', idpedido);

    try {
      const response = await fetch(`../../controller/pedido.controller.php?${params}`);
      const data = await response.json();
      const tbody = $("#productosTabla tbody");
      tbody.innerHTML = '';
      let total = 0;
      let subtotal = 0;
      let descuentoTotal = 0;
      const fechaActual = generarFechaActual();
      $("#fecha_venta").value = fechaActual;
      const tipoComprobanteSelect = $("#idtipocomprobante");
      tipoComprobanteSelect.innerHTML = '';

      data.forEach(pedido => {
        const tipo_cliente = $("#tipocliente").value = pedido.tipo_cliente;

        if (tipo_cliente === 'Empresa') {
          $("#nombres").value = pedido.razonsocial;
          $("#direccion").value = pedido.direccion;

          const facturaOption = window.comprobantesData.find(comprobante => comprobante.comprobantepago === 'Factura');
          if (facturaOption) {
            const option = document.createElement('option');
            option.value = facturaOption.idtipocomprobante;
            option.text = facturaOption.comprobantepago;
            tipoComprobanteSelect.appendChild(option);
          }

          const boletaOption = window.comprobantesData.find(comprobante => comprobante.comprobantepago === 'Boleta');
          if (boletaOption) {
            const option = document.createElement('option');
            option.value = boletaOption.idtipocomprobante;
            option.text = boletaOption.comprobantepago;
            tipoComprobanteSelect.appendChild(option);
          }

        } else if (tipo_cliente === 'Persona') {
          $("#nombres").value = `${pedido.nombres} ${pedido.appaterno} ${pedido.apmaterno}`;
          $("#direccion").value = pedido.direccion;

          const boletaOption = window.comprobantesData.find(comprobante => comprobante.comprobantepago === 'Boleta');
          if (boletaOption) {
            const option = document.createElement('option');
            option.value = boletaOption.idtipocomprobante;
            option.text = boletaOption.comprobantepago;
            tipoComprobanteSelect.appendChild(option);
          }

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
        const total_producto = cantidad_producto * preciounitario;

        row.innerHTML = `
          <td>${pedido.nombreproducto}</td>
          <td>${pedido.unidad_medida}</td>
          <td>${cantidad_producto}</td>
          <td>${preciounitario.toFixed(2)}</td>
          <td>${pedido.precio_descuento}</td>
          <td>${total_producto.toFixed(2)}</td>
        `;

        total += total_producto
        descuentoTotal += parseFloat(pedido.precio_descuento);
        tbody.appendChild(row);
      });

      let igv = total * 0.18;
      console.log("IGV", igv);
      subtotal = total - descuentoTotal - igv;
      const totalVenta = (subtotal) + igv;

      $("#subtotal").value = subtotal.toFixed(2);
      $("#descuento").value = descuentoTotal.toFixed(2);
      $("#igv").value = igv.toFixed(2);
      $("#total_venta").value = totalVenta.toFixed(2);
      const tipo_pago = $("#tipo_pago");

      tipo_pago.addEventListener("click", () => {
        //console.log(tipo_pago.value);
        if (tipo_pago.value == 'unico') {
          $("#monto_pago_1").value = totalVenta;
          $("#monto_pago_1").disabled = true;
        } else {
          $("#monto_pago_1").value = '';
          let total = $("#total_venta").value
          $("#monto_pago_1").disabled = false;
          $("#monto_pago_1").addEventListener('input', () => {
            let monto = parseFloat($("#monto_pago_1").value);
            let resto = parseFloat(total - monto);
            $("#monto_pago_2").value = resto;
            if (monto == 0 || monto > total) {
              $("#monto_pago_1").value = '';
              console.log("el monto dbe ser menor al total")
            }
          }
          )
        };
      });
    } catch (e) {
      console.error(e);
    }
  };

  // Función para registrar venta
  let idventa;
  async function RegistrarVenta() {
    const params = new FormData();
    params.append('operation', 'addVentas');
    params.append('idpedido', $("#idpedido").value);
    params.append('idtipocomprobante', $("#idtipocomprobante").value);
    params.append('fecha_venta', $("#fecha_venta").value);
    params.append('subtotal', $("#subtotal").value);
    params.append('descuento', $("#descuento").value);
    params.append('igv', $("#igv").value);
    params.append('total_venta', $("#total_venta").value);

    try {
      const options = {
        method: 'POST',
        body: params
      };
      const response = await fetch(`../../controller/ventas.controller.php`, options);
      idventa = await response.json();
      // console.log("idventa:",idventa);
      return idventa; // Asegúrate de devolver los datos
    } catch (e) {
      console.error(e);
    }
  }
$(".metodo").addEventListener("change", () => {
  let select = $(".metodo").value;
  console.log(select);
});
  

  // Registrar detalle del método de pago
  async function RegistrarDetalleMetodo(idventa) {
    const rows = document.querySelectorAll(".metodos");

    // console.log(rows);
    const montos = [];
    let metodo_pago = ''
    let monto_01 = '';
    rows.forEach((row) => {
      console.log(row);
      document.querySelectorAll(".metodo").forEach((select) => {
        metodo_pago = select.value;
      });
      document.querySelectorAll(".monto").forEach((input) => {
        monto_01 = input.value;
      });
      console.log(metodo_pago, monto_01);

      if (monto_01 == '') {
        alert("Debe ingresar los montos de pago");
        return;
      } else {
        montos.push({
          metodo_pago,
          monto_01,
        })
      }
    });

    const params = new FormData();
    params.append('operation', 'addDetalleMetodo');
    params.append('idventa', idventa);
    montos.forEach((monto, index) => {
      params.append(`montos[${index}][idmetodopago]`, monto.metodo_pago);
      params.append(`montos[${index}][monto]`, monto.monto_01);
    });


    try {
      const response = await fetch(`../../controller/detallemetodo.controller.php`, {
        method: 'POST',
        body: params
      });
      const data = await response.json();
      console.log('Respuesta de detalle de método:', data);
      return data;
    } catch (e) {
      console.error('Error al registrar detalle de método:', e);
    }
  }



  // Función para limpiar el formulario de pedido
  const limpiarDatosPedido = () => {
    $("#form-venta-registrar").reset();
    const tbody = $("#productosTabla tbody");
    tbody.innerHTML = '';
  };

  // Validar el formulario y realizar el registro de venta y métodos de pago
  $("#form-venta-registrar").addEventListener("submit", async (event) => {
    event.preventDefault();
    const resultado = await RegistrarVenta();
    console.log("id venta", resultado)
    let id = resultado[0];
    if (resultado) {
      alert("Venta registrada exitosamente");
      // Aquí asumiendo que `resultado` devuelve el `idventa` del registro recién creado
      await RegistrarDetalleMetodo(id);
      $("#form-venta-registrar").reset();
      limpiarDatosPedido();
    }
  });


  // Inicializar funciones de validación y búsqueda
  //validarmontos();
  ValidarSelect();

  $("#idpedido").addEventListener('input', async () => {
    const inputPedido = $("#idpedido").value;

    if (inputPedido.length > 0) {
      const data = await mostraResultados();

      if (inputPedido.length == 0) {
        $("#datalistIdPedido").style.display = 'none';
      }
    } else {
      $("#datalistIdPedido").style.display = 'none';
    }
  });
});
