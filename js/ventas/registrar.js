document.addEventListener("DOMContentLoaded", () => {
  // Función para simplificar el selector
  function $(selector = null) {
    return document.querySelector(selector);
  }

  const tbody = $("#productosTabla tbody");
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

  // Cargar métodos de pago desde el servidor
  function metodoPago() {
    fetch(`../../controller/metodoP.controller.php?operation=getAll`)
      .then(response => response.json())
      .then(data => {
        const selector = document.querySelectorAll(".metodo");
        selector.forEach((select) => {
          data.forEach(metodo => {
            const tagOption = document.createElement('option');
            tagOption.value = metodo.idmetodopago;
            tagOption.innerText = metodo.metodopago;
            select.appendChild(tagOption);
          });
        });
      })
      .catch(e => console.error(e));
  }

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
  const buscarPedido = async (pedido) => {
    const params = new URLSearchParams();
    params.append('operation', 'searchPedido');
    params.append('_idpedido', pedido);

    try {
      const response = await fetch(`../../controller/pedido.controller.php?${params}`);
       return response.json();
       
    } catch (e) {
      console.error(e);
    }
  };

  // Mostrar resultados de la búsqueda del pedido
  const mostrarResultados = async () => {
    const response = await buscarPedido(inputPedido);
    let datalist = $("#datalistIdPedido");
    datalist.innerHTML = '';

    if (response.length > 0) {
      datalist.style.display = 'block';
      response.forEach((item) => {
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.value = `${item.idpedido}`;
        li.innerHTML = `<b>${item.idpedido}</b> (${item.nombre_o_razonsocial})`;
        li.addEventListener('click', () => {
          $("#idpedido").value = item.idpedido;
          CargarPedido(item.idpedido);
          datalist.style.display = 'none';
          datalist.innerHTML = '';
          focusCP();
        });
        datalist.appendChild(li);
      });
      $("#idpedido").focus();
      await moverse();
      Validarfecha();
    } else if (response.length == 0) {
      datalist.style.display = 'block';
      const li = document.createElement('li');
      li.classList.add('list-group-item');
      li.innerHTML = '<b>No se encontraron resultados</b>';
      datalist.appendChild(li);
    }
  };


  async function loadComprobante() {
    const response = await fetch(`../../controller/comprobante.controller.php?operation=getAll`);
    const data = await response.json();
    const select = document.querySelector("#idtipocomprobante");
    data.forEach(comprobante => {
      const option = document.createElement('option');
      option.value = comprobante.idtipocomprobante;
      option.text = comprobante.comprobantepago;
      select.appendChild(option);
    });
  }
  loadComprobante();

  // Cargar detalles del pedido seleccionado
  const CargarPedido = async (idpedido) => {
    const params = new URLSearchParams();
    params.append('operation', 'getById');
    params.append('idpedido', idpedido);

    try {
      const response = await fetch(`../../controller/pedido.controller.php?${params}`);
      const data = await response.json();

      tbody.innerHTML = '';
      let total = 0;
      let subtotal = 0;
      let descuentoTotal = 0;
      const fechaActual = generarFechaActual();
      $("#fecha_venta").value = fechaActual;


      data.forEach(pedido => {
        const tipo_cliente = $("#tipocliente").value = pedido.tipo_cliente;

        if (tipo_cliente === 'Empresa') {
          $("#nombres").value = pedido.razonsocial;
          $("#direccion").value = pedido.direccion;

        } else if (tipo_cliente === 'Persona') {
          $("#nombres").value = `${pedido.nombres} ${pedido.appaterno} ${pedido.apmaterno}`;
          $("#direccion").value = pedido.direccion;
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

      let igv = parseFloat(total * 0.18);
      subtotal = total - descuentoTotal - igv;
      const totalVenta = (subtotal) + igv;

      $("#subtotal").value = subtotal.toFixed(2);
      $("#descuento").value = descuentoTotal.toFixed(2);
      $("#igv").value = igv.toFixed(2);
      $("#total_venta").value = totalVenta.toFixed(2);
      const tipo_pago = $("#tipo_pago");

      tipo_pago.addEventListener("click", () => {

        if (tipo_pago.value == 'unico') {
          $("#monto_pago_1").value = totalVenta.toFixed(2);
          $("#monto_pago_1").disabled = true;
        } else {
          $("#monto_pago_1").value = '';
          $("#monto_pago_1").disabled = false;
        }
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
    params.append('idusuario',$("#idusuario").value);
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
      return idventa;
    } catch (e) {
      console.error(e);
    }
  }

  // Registrar detalle del método de pago
  async function RegistrarDetalleMetodo(idventa) {
    const rows = document.querySelectorAll(".metodos");
    // console.log(rows);
    const montos = [];
    rows.forEach((row) => {

      const selector = row.querySelectorAll(".metodo");
      let metodo_pago = '';
      let monto_01 = '';

      selector.forEach((select) => {
        metodo_pago = select.value;
      });

      const montoElement = row.querySelectorAll(".monto");
      montoElement.forEach((monto) => {
        monto_01 = monto.value;
      });

      montos.push({
        metodo_pago,
        monto_01,
      });
    });

    const params = new FormData();
    params.append('operation', 'addDetalleMetodo');
    params.append('idventa', idventa);
    console.log(montos);

    montos.forEach((monto, index) => {
      // console.log(`montos[${index}][idmetodopago]`, monto.metodo_pago);
      console.log(`montos[${index}][idmetodopago]`, monto.metodo_pago);
      console.log(`montos[${index}][monto]`, monto.monto_01);

      params.append(`montos[${index}][idmetodopago]`, monto.metodo_pago);
      params.append(`montos[${index}][monto]`, monto.monto_01);
    });
    const options = {
      method: 'POST',
      body: params
    };

    try {
      const response = await fetch(`../../controller/detallemetodo.controller.php`, options);
      const data = await response.json();
      console.log('Respuesta de detalle de método:', data);
      return data;
    } catch (e) {
      console.error('Error al registrar detalle de método:', e);
    }
  }

  // add metodo de pago dinamicamente 
  async function addMetodoPago() {

    const metodo = document.querySelector("#add-metodo"); // o usa $('#add-metodo') si usas jQuery

    metodo.addEventListener("click", async () => {
      const container = document.querySelector("#container-metodos");

      const metodos = document.querySelectorAll(".metodos");
      if (metodos.length > 3) {
        showToast("Solo se permiten 4 métodos de pago", "warning", "WARNING");
        return;
      }
      // Crear un nuevo div con el select y los inputs correspondientes
      const div = document.createElement("div");
      div.className = "col-md-6 mb-3 metodos load";
      div.innerHTML = ` 
          <div class="input-group">
            <div class="form-floating">
              <select class="form-select metodo" name="idmetodopago">
                <option value="">Selecione método</option>
              </select>
              <label for="idmetodopago">Método de Pago</label>
            </div>
            <div class="form-floating mb-3 montos">
              <input type="number" step="0.01" class="form-control monto" name="monto_pago" placeholder="Monto">
              <label for="monto_pago">Monto</label>
            </div>  
              <button class="btn btn-outline-danger mb-3" type="button"><i class="bi bi-trash-fill"></i></button>
          </div>
          `;
      container.appendChild(div);
      await metodoPago();
    });
  }

  function verificarCampos() {
    const rows = document.querySelectorAll(".metodos");
    let totalVenta = parseFloat($("#total_venta").value);
    console.log("total venta", totalVenta);
    const tipo_pago = $("#tipo_pago").value;
    const comprobante = $("#idtipocomprobante").value;
    let sumaMontos = 0;
    let montos = [];
    console.log("campo de metodo de pago", rows.length);


    if (comprobante === '') {
      showToast("Debe seleccionar un comprobante", "warning", "WARNING");
      return [];
    }

    if (tipo_pago === '') {
      showToast("Debe seleccionar un tipo de pago", "warning", "WARNING");
      return [];
    }

    if ($("#idmetodopago").value === '') {
      showToast("Debe seleccionar un método de pago", "warning", "WARNING");
      return [];
    }

    if ((rows.length > 1 && tipo_pago == 'mixto')) {

      if (comprobante === '') {
        showToast("Debe seleccionar un comprobante", "warning", "WARNING");
        return [];
      }

      if (tipo_pago === '') {
        showToast("Debe seleccionar un tipo de pago", "warning", "WARNING");
        return [];
      }

      if ($("#idmetodopago").value === '') {
        showToast("Debe seleccionar un método de pago", "warning", "WARNING");
        return [];
      }

      // Validar los métodos de pago y montos
      for (let i = 0; i < rows.length; i++) {
        const selectMetodoPago = rows[i].querySelector(".metodo");
        const inputMonto = rows[i].querySelector(".monto");

        let metodoPago = selectMetodoPago.value;
        let monto = parseFloat(inputMonto.value);

        // Validación del método de pago
        if (metodoPago === '') {
          showToast(`Debe seleccionar un método de pago en la fila ${i + 1}`, "warning", "WARNING");
          return []; // Detener la validación si no hay método seleccionado
        }

        // Validación del monto
        if (!monto || monto <= 0) {
          showToast(`El monto en la fila ${i + 1} debe ser mayor que 0`, "warning", "WARNING");
          return []; // Detener la validación si el monto es inválido
        }

        sumaMontos += monto;
        montos.push({
          metodo_pago: metodoPago,
          monto_01: monto.toFixed(2),
        });
      }

      // Validar que la suma de los montos sea igual al total de la venta
      if (sumaMontos !== totalVenta) {
        showToast("La suma de los montos de los métodos de pago debe ser igual al total de la venta", "warning", "WARNING");
        return [];
      }

      console.log("Montos validados:", montos);
      return montos;
    } else if (rows.length == 1 && tipo_pago == 'unico') {

      if (comprobante === '') {
        showToast("Debe seleccionar un comprobante", "warning", "WARNING");
        return [];
      }

      if (tipo_pago === '') {
        showToast("Debe seleccionar un tipo de pago", "warning", "WARNING");
        return [];
      }

      if ($("#idmetodopago").value === '') {
        showToast("Debe seleccionar un método de pago", "warning", "WARNING");
        return [];
      }
      for (let i = 0; i < rows.length; i++) {
        const selectMetodoPago = rows[i].querySelector(".metodo");
        const inputMonto = rows[i].querySelector(".monto");

        let metodoPago = selectMetodoPago.value;
        let monto = parseFloat(inputMonto.value);

        // Validación del método de pago
        if (metodoPago === '') {
          showToast(`Debe seleccionar un método de pago en la fila ${i + 1}`, "warning", "WARNING");
          return []; // Detener la validación si no hay método seleccionado
        }

        // Validación del monto
        if (!monto || monto <= 0) {
          showToast(`El monto en la fila ${i + 1} debe ser mayor que 0`, "warning", "WARNING");
          return []; // Detener la validación si el monto es inválido
        }

        sumaMontos += monto;
        montos.push({
          metodo_pago: metodoPago,
          monto_01: monto.toFixed(2),
        });
      }
      return montos;

    } else if (rows.length == 1 && tipo_pago == 'mixto') {
      showToast("El tipo de pago es mixto, debe agregar más de un método de pago", "info", "INFO");
      return [];
    }
  }


  // Función para cargar métodos de pago en los selectores existentes y nuevos
  async function metodoPago() {
    try {
      const response = await fetch(`../../controller/metodoP.controller.php?operation=getAll`);
      const data = await response.json();
      const selectors = document.querySelectorAll(".metodo:not(.metodo-cargado)");
      selectors.forEach(select => {
        select.innerHTML = '<option value="">Selecione método</option>';

        data.forEach(metodo => {
          const tagOption = document.createElement('option');
          tagOption.value = metodo.idmetodopago;
          tagOption.innerText = metodo.metodopago;
          select.appendChild(tagOption);
        });

        select.classList.add('metodo-cargado');
      });
    } catch (e) {
      console.error('Error al cargar los métodos de pago:', e);
    }
  }

  // Función para limpiar el formulario de pedido
  async function limpiarDatosPedido() {
    $("#form-venta-registrar").reset();
    const tbody = $("#productosTabla tbody");
    tbody.innerHTML = '';
    const selector = document.querySelectorAll(".load");
    selector.forEach((select) => {
      select.remove();
    })
    $("#idpedido").focus();
  };

  // Validar el formulario y realizar el registro de venta y métodos de pago
  $("#form-venta-registrar").addEventListener("submit", async (event) => {
    event.preventDefault();

    const validacion = verificarCampos();
    console.log("datos de la validacion", validacion);
    if (validacion.length != 0) {
      const resultado = await RegistrarVenta();
      console.log("id venta", resultado)
      let idventa = resultado.id;

      if (resultado) {
        showToast("Venta registrada correctamente", "success", "SUCCESS");
        await RegistrarDetalleMetodo(idventa);
        $("#form-venta-registrar").reset();
        limpiarDatosPedido();
      }
    }
  });

  let inputPedido;
  $("#idpedido").addEventListener('input', async () => {
    inputPedido = $("#idpedido").value;
    const data = await buscarPedido(inputPedido);

    if (inputPedido.trim().length != 0) {
      mostrarResultados();
        $("#idtipocomprobante").removeAttribute("disabled")
        $("#tipo_pago").removeAttribute("disabled")
      console.log(data);
    } if (inputPedido.trim().length == 0) {
      limpiarDatosPedido();
      $("#idtipocomprobante").setAttribute("disabled",true)
      $("#tipo_pago").setAttribute("disabled",true)
      $("#datalistIdPedido").style.display = 'none';

      
    } else {
      $("#datalistIdPedido").style.display = 'none';

    }
  });

  $("#tipo_pago").addEventListener("click", () => {
    const tipo_pago = $("#tipo_pago").value;
    const mostrar = $("#loadMetodos")
    if (tipo_pago == 'unico') {
      mostrar.removeAttribute("style")
      $("#add-metodo").style.display = 'none';
      $("#monto_pago_1").value = $("#total_venta").value;
      $("#monto_pago_1").disabled = true;
      const selector = document.querySelectorAll(".load");
      selector.forEach((select) => {
        select.remove();
      });
    } if (tipo_pago == 'mixto') {
      mostrar.removeAttribute("style")
      $("#add-metodo").style.display = 'block';
      $("#monto_pago_1").removeAttribute("disabled");
      
    }
  });

  async function moverse() {
    const pedido = document.querySelectorAll('.list-group-item');
    let positionY = 0;
    if (pedido.length === 0) return;

    pedido[positionY].classList.add('active');
    pedido[positionY].scrollIntoView({ block: 'nearest' });

    document.addEventListener('keydown', function (e) {
      pedido[positionY].classList.remove('active');
      if (e.key === 'ArrowDown') {
        positionY = (positionY + 1) % pedido.length;
      } else if (e.key === 'ArrowUp') {
        positionY = (positionY - 1 + pedido.length) % pedido.length;
      } else if (e.key === 'Enter') {
        pedido[positionY].click();
      }
      pedido[positionY].classList.add('active'); // Agregar clase active
      pedido[positionY].scrollIntoView({ block: 'nearest' }); // Hacer scroll al elemento
    });
  }

  // eliminar metodo de pago
  document.addEventListener('click', (e) => {
    if (e.target.classList.contains('btn-outline-danger') ||
      (e.target.tagName === 'I' && e.target.classList.contains('bi-trash-fill'))) {
      $(".load").remove();
    }
  });

  function focusCP() {
    const tipocomprobante = $("#idtipocomprobante");
    const tipoPago = $("#tipo_pago");
    const metodoPago = $("#idmetodopago");
    const btnVenta = $("#btnRVenta");

    // Verificar secuencialmente si cada campo está vacío, y enfocarlo en consecuencia
    if (tipocomprobante.value === '') {
      tipocomprobante.focus();
    } else if (tipoPago.value === '') {
      tipoPago.focus();
    } else if (metodoPago.value === '') {
      metodoPago.focus();
    } else {
      btnVenta.focus(); // Si todos los anteriores tienen valor, enfocar el botón del formulario
    }
  }

  function focopedido() {
    $("#idpedido").focus();
  }

  focopedido();
  metodoPago();
  addMetodoPago();
});
