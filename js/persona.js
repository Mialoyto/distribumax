document.addEventListener("DOMContentLoaded", () => {
  const btnbuscardni = document.querySelector("#btnbuscardni");
  const optionDoc = document.querySelector("#idtipodocumento");
  // const searchDistritoInput  = document.querySelector("#searchDistrito");
  // const lista = document.querySelector("#lista");

  // variables para renderizar o capturar datos de las personas
  const doc = document.querySelector("#idtipodocumento"); // tipo documento
  const dni = document.querySelector("#idpersonanrodoc"); // nro de documento
  const iddistrito = document.querySelector("#searchDistrito"); // 
  const nombres = document.querySelector("#nombres");
  const appaterno = document.querySelector("#appaterno");
  const appmaterno = document.querySelector("#appmaterno");
  const telefono = document.querySelector("#telefono");
  const direccion = document.querySelector("#direccion");

  // funcion que trae los tipos de documentos desde la base de datos
  (() => {
    fetch(`../../controller/documento.controller.php`)
      .then(response => response.json())
      .then(data => {
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idtipodocumento;
          tagOption.innerText = element.documento;
          optionDoc.appendChild(tagOption);
        });
      })
      .catch(e => {
        console.error(e);
      })
  })();


  // registrar persona
  function validarDoc(response) {
    if (response.length == 0) {
      iddistrito.value = '';
      nombres.value = '';
      appaterno.value = '';
      appmaterno.value = '';
      telefono.value = '';
      direccion.value = '';

    } else {
      iddistrito.value = response[0].distrito;
      nombres.value = response[0].nombres;
      appaterno.value = response[0].appaterno;
      appmaterno.value = response[0].apmaterno;
      telefono.value = response[0].telefono ? response[0].telefono : 'No registrado';
      direccion.value = response[0].direccion

    }
  }

  async function searchDni() {
    const params = new URLSearchParams();
    params.append('operation', 'searchDni');
    params.append('idtipodocumento', doc.value)
    params.append('idpersonanrodoc', dni.value)

    const response = await fetch(`../../controller/persona.controller.php?${params}`)
    return response.json();
  }

  btnbuscardni.addEventListener("click", async () => {
    const response = await searchDni();
    console.log(response)
    // console.log(response[0].distrito)
    validarDoc(response);

  })

  /* buscador */
  /* searchDistritoInput .addEventListener("input", debounce(getDistritos, 300));

  async function getDistritos() {
    let inputDist = distrito.value.trim();
    let listDist = lista;
    console.log('Buscando distritos para:', inputDist);

    if (inputDist === "") {
      listDist.style.display = 'none';
      listDist.innerHTML = '';
      return;
    }

    const params = new FormData();
    params.append('operation', 'searchDistrito');
    params.append('distrito', inputDist)

    const options = {
      method: 'POST',
      body: params
    }

    const response = await fetch(`../../controller/distrito.controller.php`, options)
    const data = await response.json();
    console.log('Datos de distritos recibidos:', data);

    listDist.innerHTML = '';
    if (data.length > 0) {
      listDist.style.display = 'block';
      data.forEach(distrito => {
        const li = document.createElement('li');
        li.classList.add('list-group-item'); // Añadir clase de Bootstrap para estilizar
        li.textContent = `${distrito.distrito} - Provincia: ${distrito.provincia}, Departamento: ${distrito.departamento}`;
        li.addEventListener('click', () => {
          searchDistritoInput.value = distrito.distrito;
          listDist.style.display = 'none';
        });
        listDist.appendChild(li);
      });
    } else {
      listDist.style.display = 'none';
    }

  }

  // Función debounce para optimizar las llamadas al servidor
  function debounce(func, delay) {
    let timeout;
    return function (...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), delay);
    };
  }
 */




});

