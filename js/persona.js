document.addEventListener("DOMContentLoaded", () => {
  const dni = document.querySelector("#idpersonanrodoc");
  const doc = document.querySelector("#idtipodocumento");
  // let iddoc = doc.value;
  // capturar tipo de documento

  doc.addEventListener("change", () => {
    iddoc = doc.value;
    console.log(iddoc);
  });

  /* dni.addEventListener('changue', () =>{

    }) */
});
