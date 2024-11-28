document.addEventListener('DOMContentLoaded', function () {

  const proveedor = document.querySelector("#searchProveedor");
  const producto = document.querySelector("#searchProducto");
  const listProduct = document.querySelector("#listProduct");
  let inputProveedor;

  async function getProveedor(proveedor) {

    const params = new URLSearchParams();
    params.append('operation', 'getProductosProveedor');
    params.append('proveedor', proveedor);

    const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
    const data = await response.json();
    console.log(data);
    return data;
  }


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


  // obtener productos de proveedor
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
      data.forEach(producto => {
        // console.log(producto)
        const li = document.createElement("li")
        li.classList.add('list-group-item', 'list-group-item-action')
        li.textContent = producto.producto
        listProduct.appendChild(li)
        // listProduct.innerHTML= '';
      });
    } else {
      listProduct.innerHTML = '';
      const li = document.createElement("li")
      li.classList.add('list-group-item', 'list-group-item-action')
      li.innerHTML = '<strong>Producto no encontrado</strong>'
      listProduct.appendChild(li)
    }

  }


  // evento para buscar proveedor
  proveedor.addEventListener('input', async function () {
    renderListProveedor();
    // const data = await getProductosProveedor(1, 'a');

  });

  producto.addEventListener('input', async function () {
    renderListProduct();

  })



});