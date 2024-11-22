document.addEventListener('DOMContentLoaded', function () {

  const proveedor = document.querySelector("#searchProveedor");
  let inputProveedor;

  async function getProductosProveedor(proveedor) {

    const params = new URLSearchParams();
    params.append('operation', 'getProductosProveedor');
    params.append('proveedor', proveedor);

    const response = await fetch(`../../controller/proveedor.controller.php?${params}`);
    const data = await response.json();
    console.log(data);
    return data;
  }


  async function renderList() {
    const list = document.querySelector('#listProveedor');
    inputProveedor = proveedor.value.trim();
    const data = await getProductosProveedor(inputProveedor);
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

  // evento para buscar proveedor
  proveedor.addEventListener('input', async function () {
    renderList();
  })



});