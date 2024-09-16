document.addEventListener("DOMContentLoaded", () =>{
  const persona = document.querySelector("#idpersona");
  const empresa = document.querySelector("#idempresa");
  const tipoCliente = document.querySelector("#tipo_cliente");
  const contentable = document.querySelector("#table-clientes tbody");

  (() =>{
    fetch(`../../controller/cliente.controller.php?operation=getAll`)
        .then(response => response.json())
        .then(data => {
          data.forEach(element => {
            const tagOption = document.createElement('option');
            tagOption.value = element.idpersona;
            tagOption.innerText = element.cliente;
            persona.appendChild(tagOption);
          });
        })
        .catch(e => {
          console.error(e);
        })
  })();

(() =>{
  fetch(`../../controller/cliente.controller.php?operation=getAll`)
      .then(response=>response.json())
      .then(datos=>{
        datos.forEach(row=>{
          contentable.innerHTML+= `
          <tr>
              <td>${row.idpersona}</td>
              <td>${row.idempresa}</td>
              <td>${row.tipoCliente}</td>
          </tr>
          `
        })
      })
      .catch(e=>{
        console.error(e);
      })
})();
  
})