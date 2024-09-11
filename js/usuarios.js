document.addEventListener("DOMContentLoaded", () => {
  // const tagOption = document.querySelector("#")
  const optionDoc = document.querySelector("#idtipodocumento");

  (() => {
    fetch(`../../controller/documento.controller.php`)
      .then((response) => response.json())
      .then((data) => {
        data.forEach((element) => {
          const tagOption = document.createElement("option");
          tagOption.value = element.idtipodocumento;
          tagOption.innerText = element.documento;
          optionDoc.appendChild(tagOption);
        });
      })
      .catch((e) => {
        console.error(e);
      });
  })();
  (() => {
    const input = document.querySelector("#iddistrito");

    input.addEventListener("changue", () => {
      const distrito = input.value;

      const params = new URLSearchParams();
      params.append("operation", "searchDistrito");
      params.append("distrito", distrito);

      fetch(`../../controller/distrito.controller.php?${params.toString()}`)
        .then((response) => response, json())
        .then((data) => {
          const resultado = document.getElementById("resultadoBusqueda");
          resultado.innerHTML = "";
          data.forEach((distrito) => {
            const li = document.createElement("li");
            li.classList.add("list-group");
            li.textContent = distrito.nombre_distrito; // Ajusta según el formato de tu respuesta
            resultado.appendChild(li);
          });
        });
    });
  })();
});
