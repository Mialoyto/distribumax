/* funcion para cargar datos tipo de documentos */
async function cargarTipoDoc(element) {
  try {
    const response = await fetch(`../../controller/documento.controller.php`);
    const data = await response.json();
    data.forEach(item => {
      const tagOption = document.createElement('option');
      tagOption.value = item.idtipodocumento;
      tagOption.innerText = item.documento;
      element.appendChild(tagOption);
    });
    return data;
  } catch (error) {
    console.error("Error al cargar los tipos de documentos :", error);
  }
}

async function renderListaSearch(buscador, targetId, dataListId, id, itemFormater) {
  const response = await buscador();
  const dataList = $(dataListId);
  dataList.innerHTML = ``;

  if (response.length > 0) {
    dataList.style.display = 'block';
    response.forEach((item) => {
      const li = document.createElement('li');
      li.classList.add('list-group-item');
      li.value = `${item[id]}`
      li.innerText = itemFormater(item);
      li.addEventListener('click', () => {
        $(targetId).value = li.id;
        dataList.style.display = 'none';
        dataList.innerHTML = ``;
      });
      dataList.appendChild(li);
    })
  } else {
    dataList.style.display = 'none';
  }
}

async function renderDocumento(clase) {
  const options = document.querySelectorAll(clase);
  try {
    const response = await fetch(`../../controller/documento.controller.php`);
    const data = await response.json();
    console.log(data);
    options.forEach(option => {
      option.innerHTML = '';
      option.innerHTML = `<option value="" selected>Seleccione un tipo de documento</option>`;
      data.forEach(item => {
        const tagOption = document.createElement('option');
        tagOption.value = item.idtipodocumento;
        tagOption.innerText = item.documento;
        option.appendChild(tagOption);
      });
    });
    // return data;
  } catch (error) {
    console.error("Error al renderizar los documentos :", error);
  }
}

