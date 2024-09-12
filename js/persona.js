document.addEventListener("DOMContentLoaded", () => {
  const dni = document.querySelector("#idpersonanrodoc");
  const doc = document.querySelector("#idtipodocumento");
  const btnbuscardni = document.querySelector("#btnbuscardni");


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

