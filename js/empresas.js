document.addEventListener("DOMContentLoaded",()=>{
  
   const optionDis = document.querySelector("#iddistrito");
   const formempresa=document.querySelector("#form-registrar-empresa");
   const ruc =document.querySelector("#idempresaruc");
   const razon =document.querySelector("#razonsocial");
   const direccion = document.querySelector("#direccion");
   const email   = document.querySelector("#email");
   const telefono = document.querySelector("#telefono");
   const contentable =document.querySelector("#table-empresas tbody");
  // btnregistrar=document.querySelector("#btn-registrar-empresa");

  (() =>{
      fetch(`../../controller/distrito.controller.php?operation=getAll`)
          .then(response => response.json())
          .then(data =>{
              data.forEach(element => {
                  const tagOption = document.createElement('option');
                  tagOption.value = element.iddistrito;
                  tagOption.innerText= element.distrito;
                  optionDis.appendChild(tagOption);
              });
          })
          .catch(e =>{
              console.error(e);
          })
  })();

  (()=>{
    fetch(`../../controller/empresa.controller.php?operation=getAll`)
        .then(response=>response.json())
        .then(datos=>{
            datos.forEach(row=>{
                contentable.innerHTML+=`
                <tr>
                    <td>${row.idempresaruc}</td>
                    <td>${row.razonsocial}</td>
                    <td>${row.direccion}</td>
                    <td>${row.email}</td>
                    <td>${row.telefono}</td>
                    <td>${row.distrito}</td>
                   
                </tr>
                `
            });
        })
        .catch(e=>{
            console.error(e)
        })  
  })();
  formempresa.addEventListener("submit",(event)=>{
  
    const params = new FormData();
    params.append('operation','add');
    
    params.append('idempresaruc',ruc.value);
    params.append('iddistrito',optionDis.value);
    params.append('razonsocial',razon.value);
    params.append('direccion',direccion.value);
    params.append('email',email.value);
    params.append('telefono',telefono.value);

    const options ={
      'method': 'POST',
      'body' : params
    }

      fetch(`../../controller/empresa.controller.php`,options)
     .then(response=>response.json())
     .then(datos=>{
        if(confirm("¿Desea guardar datos?")){
          
          
        }
     })


     .catch(e=>{
       console.error(e)
     })
  })
  
})