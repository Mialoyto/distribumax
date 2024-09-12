document.addEventListener("DOMContentLoaded", () => {
  const dni = document.querySelector("#idpersonanrodoc");
  const doc = document.querySelector("#idtipodocumento");
  const btnbuscardni = document.querySelector("#btnbuscardni");
  const optionDoc = document.querySelector("#idtipodocumento");


// funcion que trae los tipos de documentos desde la base de datos
  (() =>{
      fetch(`../../controller/documento.controller.php`)
          .then(response => response.json())
          .then(data =>{
              data.forEach(element => {
                  const tagOption = document.createElement('option');
                  tagOption.value = element.idtipodocumento;
                  tagOption.innerText= element.documento;
                  optionDoc.appendChild(tagOption);
              });
          })
          .catch(e =>{
              console.error(e);
          })
  })();


    // capturar tipo de documento

    doc.addEventListener("change", () => {
      iddoc = doc.value;
      console.log(iddoc);
    });
    

  async function searchDoc() {
    const params = new URLSearchParams();
    params.append("operation", "searchDoc");
    params.append("idtipodocumento", doc.value);
    params.append("idpersonanrodoc", dni.value);
 

    const response = await fetch(`../../controller/persona.controller.php?${params}`)
    return response.text();
  }

  btnbuscardni.addEventListener("click", async (event) => {

        const response =  await searchDoc()
        console.log(response)

    });


  });

