document.addEventListener("DOMContentLoaded",()=>{
   const  Tpromocion = document.querySelector("#tipopromocion");
   const  descripcion =document.querySelector("#descripcion")
   const  formpromocion =document.querySelector("#form-promocion");
   const  optionTi     =document.querySelector("#idtipopromocion");
   (()=>{
      fetch(`../../controller/promocion.controller.php?operation=getAll`)
      .then(response=>response.json())
      .then(datos=>{
         datos.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value = element.idtipopromocion;
          tagOption.innerText = element.tipopromocion;
        
          optionTi.appendChild(tagOption);
         });
      })
      .catch(e=>{console.error(e)})
   })();

    
   
      formpromocion.addEventListener("submit",(event)=>{
      const params =  new FormData();
      params.append('operation','addPromocion');
      params.append('tipopromocion',Tpromocion.value);
      params.append('descripcion',descripcion.value)

      const options ={
        'method': 'POST',
        'body': params
      }
      
      fetch(`../../controller/promocion.controller.php`,options)
      .then(response=response.json()
      )
      .then(datos=>{
        alert("Yes")
      })
      .catch(e=>{console.error(e)})

   });

  
})