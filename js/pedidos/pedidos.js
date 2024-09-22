document.addEventListener('DOMContentLoaded', async () => {
  /* variable globa */
  function $(object = null) {
    return document.querySelector(object);
  }
  // Función de debounce
  function debounce(func, wait) {
    let timeout;
    return function (...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }

  // funcion para traer datos del cliente empresa o persona
  async function dataCliente() {
    if (!$("#nro-doc")) {
      return
    }
    const params = new URLSearchParams();
    params.append('operation', 'searchCliente');
    params.append('nro_documento', $("#nro-doc").value);

    try {
      const response = await fetch(`../../controller/cliente.controller.php?${params}`)
      const data = await response.json();
      console.log(data)
      return data;
    } catch (e) {
      console.error(e)
    }
  }

  let idCliente;
  async function validarNroDoc(response) {
    if (response.length === 0) {
      resetCampos();
      $("#nombres").removeAttribute("disabled");
      $("#appaterno").removeAttribute("disabled");
      $("#apmaterno").removeAttribute("disabled");
      $("#razon-social").removeAttribute("disabled");

      console.log("No existe el cliente")
    } else {
      if (response[0].tipo_cliente === 'Persona') {
        $("#cliente").value = response[0].tipo_cliente;
        $("#nombres").value = response[0].nombres;
        $("#appaterno").value = response[0].appaterno;
        $("#apmaterno").value = response[0].apmaterno;
        $("#razon-social").setAttribute("disabled", true)

      } else {
        $("#razon-social").value = response[0].razonsocial;
        $("#razon-social").removeAttribute("disabled");
        $("#nombres").setAttribute("disabled", true)
        $("#appaterno").setAttribute("disabled", true)
        $("#apmaterno").setAttribute("disabled", true)
      }

      $("#direccion-cliente").value = response[0].direccion_cliente;
      idCliente = response[0].idcliente;
      const option = document.createElement('option')
      option.value = response[0].idcliente;
      option.text = response[0].tipo_cliente;
      option.selected = true;

      $("#cliente").appendChild(option);
      console.log("id Cliente:", idCliente);
    }
  }
  function resetCampos() {
    $("#cliente").value = '';
    $("#cliente").innerHTML = '';
    $("#nombres").value = '';
    $("#appaterno").value = '';
    $("#apmaterno").value = '';
    $("#razon-social").value = '';
    $("#direccion-cliente").value = '';
  }



  async function getIdPedido() {
    let idusuario = $('#idvendedor').getAttribute('data-id');
    const params = new FormData();
    params.append('operation', 'addPedido');
    params.append('idusuario', idusuario);
    params.append('idcliente', $("#cliente").value);
    const options = {
      method: 'POST',
      body: params
    }
    try {
      const response = await fetch('../../controller/pedido.controller.php', options)
      return response.json();
    } catch (e) {
      console.error(e)
    }
  }

  $("#nro-doc").addEventListener('input', debounce(async () => {
    const response = await dataCliente();
    await validarNroDoc(response);
  }, 1000));

  // PRUEBA PARA RETORNR EL ID DEL PEDIDO - BORRAR
  $("#addpedido").addEventListener("click", async () => {
    const response = await getIdPedido();
    console.log(response.idpedido);
  });


  // FUNCIONES PARA AGREGAR DETALLE DE PRODUCTOS
  /* pruebas para ver si captura lod datos del campos */
  $("#registrar-pedido").addEventListener("submit", async (e) => {
    e.preventDefault();
    const form = new FormData($("#registrar-pedido"));
    console.log(form);

    // Capturar los datos del documento, nombres, apellidos, etc.
    console.log(form.get('idcliente'));
    console.log(form.get('id-tip-doc'));
    console.log(form.get('nro-doc'));
    console.log(form.get('nombres'));
    console.log(form.get('appaterno'));
    console.log(form.get('apmaterno'));
    console.log($("#idvendedor").value)

    // Capturar los valores de los productos
    const productos = [];
    const idproducto = document.querySelectorAll('.idproducto');
    const cantidades = document.querySelectorAll('.cantidad');
    const undMedidas = document.querySelectorAll('.und-medida');
    const preciosUnitarios = document.querySelectorAll('.precio-unitario');
    const descuentos = document.querySelectorAll('.descuento');
    const subtotales = document.querySelectorAll('.subtotal');

    // Recorrer los elementos y guardar los datos en un array de productos
    for (let i = 0; i < cantidades.length; i++) {
      productos.push({
        // idproducto : idproducto[i].value,
        cantidad: cantidades[i].value,
        undMedida: undMedidas[i].value,
        precioUnitario: preciosUnitarios[i].value,
        descuento: descuentos[i].value,
        subtotal: subtotales[i].value
      });
    }
    console.log(productos);
  })

  /* funcion para agregar detalle*/
  async function addDetalle() {
    const tbody = $('#detalle-productos tbody');
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <th class="col-md-3">
          <div class="mt-1">
              <select class="form-control form-control-sm" name="idproducto" id="idproducto" name="idproducto">
                  <option value="">Seleccione un producto</option>
                  <option value="1">Prodcuto 1</option>
                  <!-- Opciones dinámicas -->
              </select>
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm cantidad"name="cantidad" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm und-medida" name="und-medida" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm precio-unitario" name="precio-unitario" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm descuento" name="descuento" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1">
              <input class="form-control form-control-sm subtotal" name="subtotal" type="text" aria-label=".form-control-sm example">
          </div>
      </th>
      <th class="col-md-1">
          <div class="mt-1  d-flex justify-content-evenly">
              <button type="button" class="btn btn-warning btn-sm w-100">
                  <i class="bi bi-pencil-square"></i>
              </button>
              <button type="button" class="btn btn-danger btn-sm w-100">
                  <i class="bi bi-x-square"></i>
              </button>
          </div>
      </th>
  `;
    tbody.appendChild(tr);
  }


  // buscar producto
  const buscarProducto = async () => {
    const params = new URLSearchParams();
    params.append('operation', 'searchProducto');
    params.append('_item', $("#addProducto").value);

    try {
      const response = await fetch(`../../controller/producto.controller.php?${params}`);
      return response.json();
    } catch (e) {
      console.error(e)
    }
  }


  // mostrar resultados ✔️
  const mostraResultados = async () => {
    const response = await buscarProducto()
    $("#datalistProducto").innerHTML = '';
    if (response.length > 0) {
      $("#datalistProducto").style.display = 'block';

      // Iterar sobre los resultados y mostrarlos
      response.forEach(item => {
        const li = document.createElement('li');
        li.classList.add('list-group-item'); // Clase de Bootstrap para los ítems
        li.textContent = `${item.nombreproducto} (${item.preciounitario})`;
        li.addEventListener('click', () => {
          addProductToTable(item.idproducto, item.codigo, item.nombreproducto, item.preciounitario);
          $("#datalistProducto").style.display = 'none'; // Ocultar la lista cuando se selecciona un producto
          document.getElementById('addProducto').value = ''; // Limpiar el campo de búsqueda
        });
        $("#datalistProducto").appendChild(li);
      });
    } else {
      resultsList.style.display = 'none';
    }
    console.log(response);
  }

  $("#addProducto").addEventListener('input', async () => {
    const response = await mostraResultados()
    console.log(response);
  });

  // Función para añadir un producto a la tabla seleccionada
  function addProductToTable(codigo, nombre, precio) {
    const row = `
    <tr>
      <td>${codigo}</td>
      <td>${nombre}</td>
      <td>${precio}</td>
      <td><input type="number" class="form-control" value="1" min="1"></td>
    </tr>
  `;

    // Añadir la fila a la tabla
    document.getElementById('detalle-pedido').innerHTML += row;
  }


  $("#agregar-producto").addEventListener("click", async () => {
    await addDetalle();

  });

})
// export { getIdPedido }
/* fin */