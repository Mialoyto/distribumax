document.addEventListener("DOMContentLoaded", () => {
  // Utilidad para seleccionar elementos
  function $(object = null) {
    return document.querySelector(object);
  }
  const distrito = $("#buscar-distrito");
  const dataList = $("#datalistDistrito");

  let selectedId;

  const searchDist = async () => {
    let searchData = new FormData();
    searchData.append('operation', 'searchDistrito'); // La operación de búsqueda
    searchData.append('distrito', distrito.value.trim()); // Toma el valor del input de distrito
    const option = {
      method: 'POST',
      body: searchData
    };
    try {
      const response = await fetch(`../../controller/distrito.controller.php`, option); // Llamada al backend
      return response.json(); // Retorna la respuesta en formato JSON
    } catch (e) {
      console.error(e); // Manejo de errores
    }
  }

  // Función para mostrar los resultados en el datalist
  const mostraResultados = async () => {
    const response = await searchDist(); // Obtiene los resultados de la API
    dataList.innerHTML = ''; // Limpiamos la lista antes de agregar nuevos elementos

    if (response.length !== 0) {
      dataList.style.display = 'block'; // Muestra la lista si hay resultados
      response.forEach(item => {
        const li = document.createElement('li');
        li.classList.add('list-group-item');
        li.setAttribute('data-id', item.iddistrito); // Establece el id del distrito como atributo
        li.textContent = item.distrito; // El nombre del distrito es el texto del elemento
        li.addEventListener('click', () => { // Cuando el usuario hace clic en un distrito
          distrito.value = li.textContent; // Actualiza el campo con el valor del distrito seleccionado
          selectedId = li.getAttribute('data-id'); // Guarda el id del distrito
          dataList.innerHTML = ''; // Limpiamos la lista de resultados
        });
        dataList.appendChild(li); // Añadimos el elemento li al datalist
      });
    } else {
      // Si no hay resultados, muestra un mensaje
      dataList.innerHTML = '';
      const li = document.createElement('li');
      li.classList.add('list-group-item');
      li.innerHTML = "<b>No se encontraron resultados</b>"; // Mensaje si no hay resultados
      dataList.appendChild(li);
    }
  }

  // Evento de input en el campo de distrito para realizar la búsqueda mientras se escribe
  distrito.addEventListener('input', async (e) => {
    e.target.value = e.target.value.toUpperCase(); // Convierte a mayúsculas el texto
    await mostraResultados(); // Muestra los resultados de la búsqueda
    if (e.target.value === '') {
      dataList.style.display = 'none'; // Oculta el datalist si el campo está vacío
    }
  });
});
