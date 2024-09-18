document.addEventListener("DOMContentLoaded",()=>{
  
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




     
    
})