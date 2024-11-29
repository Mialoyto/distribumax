document.addEventListener('DOMContentLoaded', function () {

  const producto = document.querySelector("#searchProducto");
  const listProduct = document.querySelector("#listProduct");
  let inputProveedor;

  // ? DATOS PARA REGISTRAR COMPRA
  const iduser = document.querySelector("#iduser");
  const proveedor = document.querySelector("#searchProveedor");
  const comprobante = document.querySelector("#id-comprobante");
  const nrofact = document.querySelector("#nro-fac");
  const fecha = document.querySelector("#fecha-emision");
  const formCompras = document.querySelector("#form-registrar-compras");



  // TODO: obtener proveedores (OK)
  async function getProveedor(proveedor) {

    const params = new URLSearchParams();
    params.append('operation', 'getProductosProveedor');
    params.append('proveedor', proveedor);

    const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
    const data = await response.json();
    console.log(data);
    return data;
  }

  // TODO:renderizar lista de proveedores (OK)
  async function renderListProveedor() {
    const list = document.querySelector('#listProveedor');
    inputProveedor = proveedor.value.trim();
    const data = await getProveedor(inputProveedor);
    list.innerHTML = '';
    if (data.length == 0) {
      console.log('No se encontraron productos');
      const li = document.createElement('li');
      li.classList.add('list-group-item', 'list-group-item-action');
      li.innerHTML = '<b><small>No se encontraron proveedores</small><b>';
      list.appendChild(li);
      return;
    } else {
      list.classList.remove('d-none');
      data.forEach(element => {
        console.log(element);
        const li = document.createElement('li');
        li.classList.add('list-group-item', 'list-group-item-action');
        li.textContent = element.proveedor;
        li.addEventListener('click', function () {
          proveedor.setAttribute('id-proveedor', element.idproveedor);
          proveedor.value = element.proveedor;
          list.innerHTML = '';
        });
        list.appendChild(li);
      });
    }
  }

  // TODO: obtener productos de proveedor (OK)
  async function getProductosProveedor(idproveedor, producto) {
    const params = new URLSearchParams();
    params.append('operation', 'getProductosProveedor');
    params.append('idproveedor', idproveedor);
    params.append('producto', producto);
    try {
      const response = await fetch(`../../controller/compras.controller.php?${params}`);
      const data = await response.json();
      // console.log(data);
      return data;
    } catch (error) {
      console.log(error);
    }
  }

  async function renderListProduct() {
    const id = proveedor.getAttribute('id-proveedor');
    const inputProducto = producto.value.trim();
    const data = await getProductosProveedor(id, inputProducto)
    console.log(data)
    const existe = data.length;
    if (existe) {
      listProduct.innerHTML = '';
      data.forEach(item => {
        // console.log(producto)
        const li = document.createElement("li")
        li.classList.add('list-group-item', 'list-group-item-action')
        li.innerHTML =
          `
        <strong>${item.producto}</strong>
        <small class="badge rounded-pill text-bg-success">${item.numlote}</small>
        <small class="badge rounded-pill text-bg-success">${item.stockactual}</small>
        `;

        li.addEventListener('click', function () {
          // producto.value = producto.producto;
          listProduct.innerHTML = '';
          const id = item.idproducto;
          const desProducto = item.producto;
          const unidadMedida = item.unidadmedida;
          const lote = item.numlote;
          const stock = item.stockactual;
          const idlote = item.idlote;
          addProductoTabla(id, desProducto, unidadMedida, lote, stock, idlote);
          listProduct.innerHTML = '';
          producto.value = '';
        });
        listProduct.appendChild(li)
      });
    } else {
      listProduct.innerHTML = '';
      const li = document.createElement("li")
      li.classList.add('list-group-item', 'list-group-item-action')
      li.innerHTML = '<strong>Producto no encontrado</strong>'
      listProduct.appendChild(li)
    }

  }

  // Cargar tipos de comprobantes

  (() => {
    fetch(`../../controller/comprobante.controller.php?operation=getAll`)
      .then(response => response.json())
      .then(data => {
        console.log(data);
        data.forEach(element => {
          const option = document.createElement('option');
          option.value = element.idtipocomprobante;
          option.textContent = element.comprobantepago;
          comprobante.appendChild(option);
        });
        // Guardar en una variable global
      })
      .catch(e => console.error(e));
  })();

  // evento para buscar proveedor
  proveedor.addEventListener('input', async function () {
    renderListProveedor();
    // const data = await getProductosProveedor(1, 'a');

  });

  producto.addEventListener('input', async function () {
    renderListProduct();
  })

  // TODO: FUNCION PARA AGREGAR PRODUCTO A LA TABLA DE COMPRAS (OK)
  function addProductoTabla(id, producto, unidadMedida, lote, stock, idlote) {
    const tbody = document.querySelector("#table-productos tbody");
    const existId = document.querySelector(`#table-productos tr td[lote="${lote}"]`);
    console.log("existe el ID en la tabla ?", existId);
    if (existId) {
      showToast('El producto con el mismo lote ya fue agregado', 'info', 'INFO');
      return;
    }
    console.log(tbody);
    const row = document.createElement('tr');
    let total = parseFloat(0.00).toFixed(2);
    row.innerHTML = `
      <td class="col-1" id-lote=${idlote}><small class="badge rounded-pill text-bg-success">${lote}</small></td>
      <td class="col-1"><small class="badge rounded-pill text-bg-success">${stock}</small></td>
      <td class="col-1"><input type="number" class="form-control cantidad" min="1" required></td>
      <td id-prod=${id} lote="${lote}">${producto}</td>
      <td class="col-1">${unidadMedida}</td>
      <td class="col-2"><input type="number" class="form-control precio" min="0.01 name="cantidad" required></td>
      <td class="col-2" class="form-control total">${total}</td>
      <td class="col-1">
        <div class="mt-1 d-flex align-item-center">
          <button type="button" class="btn btn-danger btn-sm w-50 eliminar-fila">
            <i class="bi bi-trash3 fs-6"></i>
          </button>
        </div>
      </td>`;
    tbody.appendChild(row);

    // eliminar fila de la tabla
    row.querySelector('.eliminar-fila').addEventListener('click', function () {
      row.remove();
    });
    const inputCantidad = row.querySelector('.cantidad');
    const inputPrecio = row.querySelector('.precio');

    function calcularTotal() {
      const cantidadValue = inputCantidad.value.trim();
      const precioValue = inputPrecio.value.trim();
      if (cantidadValue <= 0 || precioValue <= 0) {
        row.children[6].textContent = parseFloat('0.00').toFixed(2);
        return;
      } else if (cantidadValue === '' || precioValue === '') {
        row.children[6].textContent = parseFloat('0.00').toFixed(2);
        return;
      }
      const cantidad = parseFloat(cantidadValue).toFixed(2);
      const precio = parseFloat(precioValue).toFixed(2);
      total = parseFloat(cantidad * precio).toFixed(2).trim();
      row.children[6].textContent = total;
    };

    inputCantidad.addEventListener('input', calcularTotal);
    inputPrecio.addEventListener('input', calcularTotal);


  }

  // TODO: FUNCION PARA REGISTRAR COMPRA (OK)
  async function addCompra() {
    const id = iduser.getAttribute('data-id');
    const idproveedor = proveedor.getAttribute('id-proveedor');
    const tipocomprobante = comprobante.value;
    const nrofactura = nrofact.value.trim();
    const fechaemision = fecha.value.trim();

    const params = new FormData();
    params.append('operation', 'addCompra');
    params.append('idusuario', id);
    params.append('idproveedor', idproveedor);
    params.append('idcomprobante', tipocomprobante);
    params.append('numcomprobante', nrofactura);
    params.append('fechaemision', fechaemision);
    const options = {
      method: 'POST',
      body: params
    };
    params.forEach((value, key) => {
      console.log(key, value);
    });
    try {
      const response = await fetch(`../../controller/compras.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;

    } catch (error) {
      console.error(error);
    }

  }

  // TODO: 
  // !ESTA FUNCION ESTA EN DESARROLLO
  async function addDetalleCompra(idcompra) {
    const rows = document.querySelectorAll('#table-productos tbody tr');
    const productos = [];
    let idlote;
    let idproducto;
    let cantidad;
    let preciocompra;

    rows.forEach(row => {
      idlote = row.querySelector('td[id-lote]').getAttribute('id-lote');
      idproducto = row.querySelector('td[id-prod]').getAttribute('id-prod');
      cantidad = row.querySelector('.cantidad').value.trim();
      preciocompra = row.querySelector('.precio').value.trim();
      productos.push({
        idlote,
        idproducto,
        cantidad,
        preciocompra
      });
    });

    const params = new FormData();
    params.append('operation', 'addDetalleCompra');
    params.append('idcompra', idcompra);
    productos.forEach((producto, index) => {
      params.append(`productos[${index}][idlote]`, producto.idlote);
      params.append(`productos[${index}][idproducto]`, producto.idproducto);
      params.append(`productos[${index}][cantidad]`, producto.cantidad);
      params.append(`productos[${index}][preciocompra]`, producto.preciocompra);
    });
    params.forEach((value, key) => {
      console.log(key, value);
    });

    const options = {
      method: 'POST',
      body: params
    };

    try {
      const response = await fetch(`../../controller/compras.controller.php`, options);
      const data = await response.json();
      console.log(data);
      return data;

    } catch (error) {
      console.error(error);
    }
  }


  // TODO: EVENTO PARA REGISTRAR COMPRA
  formCompras.addEventListener('submit', async function (e) {
    e.preventDefault();
    const tbody = document.querySelector("#table-productos tbody");
    const row = tbody.querySelectorAll('tr');
    console.log(row.length ? true : false);
    if (!row) {
      showToast('No se han agregado productos a la compra', 'info', 'INFO');
      return;
    }

    if (await showConfirm('¿Desea Registrar esta compra?')) {
      showToast('Eliminado', 'success', 'INFO');
      const data = await addCompra();
      if(data.status){
        const idcompra = data.idcompra;
        const detalle = await addDetalleCompra(idcompra);
        if(detalle.status){
          showToast('Compra registrada con exito', 'success', 'INFO');
          // formCompras.reset();
          // tbody.innerHTML = '';
        }else{
          showToast('Error al registrar la compra', 'error', 'ERROR');
        }
      }
      
    }

  });




  // addProductoTabla(1, 'producto', 'unidadMedida');
  // addProductoTabla(1, 'producto', 'unidadMedida');


});