document.addEventListener("DOMContentLoaded",()=>{
  
  const formarca = document.querySelector("#form-registrar-marca");
  const marca =document.querySelector("#marca");

  const contentable =document.querySelector("#table-marcas tbody");
   
  (()=>{
    fetch(`../../controller/marca.controller.php?operation=getAll`)
        .then(response=>response.json())
        .then(datos=>{
            datos.forEach(row=>{
                contentable.innerHTML+=`
                <tr>
                    <td>${row.marca}</td>
                    <td>${row.create_at}</td>
                   
                   
                </tr>
                `
            });
        })
        .catch(e=>{
            console.error(e)
        })  
  })();



   formarca.addEventListener("submit",(event)=>{
     
    const params = new FormData()
    params.append('operation','addMarca');
    params.append('marca',marca.value);
     
    const options ={
        'method':'POST',
        'body':params
    };

    fetch(`../../controller/marca.controller.php?`,options)
    .then(Response=>Response.json())
    .then(datos=>{
        if(datos=true){
            alert("registroo exitoso")
        }
    })
    .catch(e=>{console.error(e)})

   })
})