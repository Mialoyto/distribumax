document.addEventListener("DOMContentLoaded", () => {


  const btnbuscardni = document.querySelector("#btnbuscardni");
  const optionDoc = document.querySelector("#idtipodocumento");
  // variables para renderizar o capturar datos de las personas
  const doc = document.querySelector("#idtipodocumento");
  const dni = document.querySelector("#idpersonanrodoc");
  const iddistrito = document.querySelector("#iddistrito");
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
      telefono.value = response[0].telefono? response[0].telefono : 'No registrado';
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

});

