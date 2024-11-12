document.addEventListener('DOMContentLoaded', () => {


  const Producto = document.querySelector('#productoSearch');
  const datalist = document.querySelector('#productoList');
  const formLote = document.querySelector('#form-registrar-lote');
  const lote = document.querySelector('#numlote');
  const caducidad = document.querySelector('#fecha_vencimiento');
  const iduser = document.querySelector('#user').getAttribute('data-id');


  async function searchProducto(producto) {
    const params = new URLSearchParams();
    params.append('operation', 'searchProducto');
    params.append('_item', producto);
    try {
      const response = await fetch(`../../controller/producto.controller.php?${params}`);
      return response.json();;

    } catch (e) {
      console.error(e);
    }
  }

  async function renderLista() {
    const producto = Producto.value.trim();
    console.log(producto);
    if (producto.length !== '') {
      const response = await searchProducto(producto);
      console.log(response);
      datalist.innerHTML = '';
      let productos = response.data;
      if (productos.length != 0) {
        productos.forEach((item) => {
          const li = document.createElement('li');
          li.classList.add('dropdown-item');
          li.textContent = item.nombreproducto;
          li.setAttribute('data-id', item.idproducto);
          console.log(producto.length)
          li.addEventListener('click', () => {
            Producto.value = item.nombreproducto;
            console.log(producto);

            Producto.setAttribute('data-value', item.idproducto);
            datalist.classList.remove('show');
            datalist.innerHTML = '';
          });
          datalist.appendChild(li);
        });
        datalist.classList.add('show');

      } else {
        const li = document.createElement('li');
        li.classList.add('dropdown-item');
        li.innerHTML = `<span class="text-muted">No se encontraron resultados</span>`;
        datalist.appendChild(li);
      }
    } else {
      datalist.classList.remove('show');
      datalist.innerHTML = '';
    }
  }


  Producto.addEventListener('input', () => {
    let item = Producto.value;
    if (item !== '') {
      console.log('buscando');
      renderLista();
    } else {
      datalist.classList.remove('show');
      datalist.innerHTML = '';
      item = '';
    }
  });


  async function registrarLote() {
    const params = new FormData();
    params.append('operation', 'addLote');
    params.append('idproducto', Producto.getAttribute('data-value'));
    params.append('numlote', lote.value);
    params.append('fecha_vencimiento', caducidad.value);
    console.log(iduser);
    console.log(Producto.getAttribute('data-value'));
    console.log(lote.value);
    console.log(caducidad.value);

    const options = {
      method: 'POST',
      body: params
    }

    try {
      const response = await fetch(`../../controller/lotes.controller.php`, options);
      const result = await response.json();
      return result;
    } catch (e) {
      console.error(e);
    }
  }
  formLote.addEventListener('submit', async (e) => {
    e.preventDefault();

    const existingSpans = document.querySelectorAll('.text-danger');
    existingSpans.forEach(span => span.remove());
    const existingInvalid = document.querySelectorAll('.is-invalid');
    existingInvalid.forEach(item => item.classList.remove('is-invalid'));

    const result = await registrarLote();
    console.log(result);
    if (result.id > 0) {
      showToast(`${result.message}`, 'success', 'SUCCESS');
      formLote.reset();
    } else if (result.id === 0) {
      // showToast(`${result.message}`, `${result.status}`, 'ERROR');
      lote.classList.remove('is-invalid');
      // caducidad.innerHTML = '';
      caducidad.classList.add('is-invalid');
      const span = document.createElement('span');
      span.classList.add('text-danger');
      span.innerHTML = `${result.message}`;
      caducidad.insertAdjacentElement('afterend', span);
    } else if (result.id < 0) {
      // showToast(`${result.message}`, `${result.status}`, 'ERROR');
      caducidad.classList.remove('is-invalid');
      // lote.innerHTML = '';
      lote.classList.add('is-invalid');
      const span = document.createElement('span');
      span.classList.add('text-danger');
      span.innerHTML = `${result.message}`;
      lote.insertAdjacentElement('afterend', span);
    }





  })

})