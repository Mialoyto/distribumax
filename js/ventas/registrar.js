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
      datalist.style.display = 'none';
    }
  };

  // Función para validar y manejar montos
  const validarmontos = async () => {
    const tipoPagoSelect = $("#tipo_pago");

    tipoPagoSelect.addEventListener("change", () => {
      const monto1 = parseFloat($("#monto_pago_1").value);
      const ventatotal = parseFloat($("#total_venta").value);

      if (tipoPagoSelect.value === 'unico') {
        $("#monto_pago_1").value = ventatotal;
        $("#monto_pago_1").setAttribute('readonly', true);
      }
      if (tipoPagoSelect.value === 'mixto') {
        $("#monto_pago_1").removeAttribute('readonly');
        $("#monto_pago_2").setAttribute('readonly', true);
        if (monto1 <= 0 || monto1 >= ventatotal) {
          showToast(`El monto debe ser mayor que 0 y menor que la venta`, 'warning', 'WARNING');
        } else {
          const resto = ventatotal - monto1;
          $("#monto_pago_2").value = resto.toFixed(2);
        }
      }
    });
  };

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

        subtotal += total_producto;
        descuentoTotal += parseFloat(pedido.precio_descuento);
        tbody.appendChild(row);
      });

      const igv = subtotal * 0.18;
      const totalVenta = subtotal + igv - descuentoTotal;

      $("#subtotal").value = subtotal.toFixed(2);
      $("#descuento").value = descuentoTotal.toFixed(2);
      $("#igv").value = igv.toFixed(2);
      $("#total_venta").value = totalVenta.toFixed(2);
      const tipo_pago = $("#tipo_pago");


      tipo_pago.addEventListener("click", () => {
        //console.log(tipo_pago.value);

        if (tipo_pago.value == 'unico') {
          $("#monto_pago_1").value = total_venta;
        } else {
          $("#monto_pago_1").value = '';
          let total = $("#total_venta").value

          $("#monto_pago_1").addEventListener('input', () => {
            let monto = parseFloat($("#monto_pago_1").value);

            //console.log(monto)
            let resto = total - monto;
            // console.log(resto)

            $("#monto_pago_2").value = resto;
            $("#monto_pago_2").innerHTML = '';
        }

          )};
        });
    } catch (e) {
      console.error(e);
    }
  };

  // Función para registrar venta
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
      const data = await response.json();
      console.log(data);
      return data; // Asegúrate de devolver los datos
    } catch (e) {
      console.error(e);
    }
  }

  // Registrar detalle del método de pago
  async function RegistrarDetalleMetodo(idventa) {
    const metodo1Select = $("#idmetodopago");
    const monto1Input = $("#monto_pago_1");
    const metodo2Select = $("#idmetodopago_2");
    const monto2Input = $("#monto_pago_2");
  
    const params = new FormData();
    params.append('operation', 'addDetalleMetodo');
    params.append('idventa', idventa);
  
    // Agregar método de pago 1
    const metodo1 = {
      idmetodopago: metodo1Select.value,
      monto: parseFloat(monto1Input.value)
    };
    params.append('metodos[0][idmetodopago]', metodo1.idmetodopago);
    params.append('metodos[0][monto]', metodo1.monto);
  
    // Agregar método de pago 2 (si existe)
    if (metodo2Select.value) {
      const metodo2 = {
        idmetodopago: metodo2Select.value,
        monto: parseFloat(monto2Input.value)
      };
      params.append('metodos[1][idmetodopago]', metodo2.idmetodopago);
      params.append('metodos[1][monto]', metodo2.monto);
    }
  
    try {
      const response = await fetch(`../../controller/detallemetodo.controller.php`, {
        method: 'POST',
        body: params
      });
      const data = await response.json();
      console.log('Respuesta de detalle de método:', data);
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
    if (resultado) {
      alert("Venta registrada exitosamente");
      // Aquí asumiendo que `resultado` devuelve el `idventa` del registro recién creado
      await RegistrarDetalleMetodo(resultado.idventa); 
      $("#form-venta-registrar").reset();
      limpiarDatosPedido();
    }
  });
  

  // Inicializar funciones de validación y búsqueda
  validarmontos();
  ValidarSelect();

  $("#idpedido").addEventListener('input', mostraResultados);
});
