
document.addEventListener("DOMContentLoaded",()=>{
  const optionEmpresa =$("#idmarca");
  const optionsub=$("#idsubcategoria");
  function $(object = null) {
    return document.querySelector(object);
  }
   
 

  (()=>{
    fetch(`../../controller/marca.controller.php?operation=getAll`)
    .then(Response=>Response.json())
    .then(data=>{
      
        data.forEach(element => {
        
        const tagOption =document.createElement('option');
        tagOption.value=element.idmarca;
        tagOption.innerText=element.marca;
        optionEmpresa.appendChild(tagOption);
      });
    })
    .catch(e=>{console.error(e)})
  })();

  (()=>{
    fetch(`../../controller/subcategoria.controller.php?operation=getAll`)
    .then(Response=>Response.json())
    .then(data=>{
      
        data.forEach(element => {
          const tagOption = document.createElement('option');
          tagOption.value=element.idsubcategoria;
          tagOption.innerText=element.subcategoria;
          optionsub.appendChild(tagOption);
        });
    })
    .catch(e=>{console.error(e)})
  })();

  async function registrarproducto() {
     const params = new FormData();
     params.append('operation','addProducto');
     params.append('idmarca',optionEmpresa.value);
     params.append('idsubcategoria',optionsub.value);
     params.append('nombreproducto',$("#nombreproducto").value);
     params.append('descripcion',$("#descripcion").value);
     params.append('codigo',$("#codigo").value);
     params.append('preciounitario',$("#preciounitario").value);

     const options={
      method : 'POST',
      body: params
     }

     const response = await fetch(`../../controller/producto.controller.php`,options)
     const res = await response.json()
     console.log(res)
     .catch(e=>{console.error(e)})
  }
   
   $("#form-registrar-producto").addEventListener("submit",async(event)=>{
    event.preventDefault();
    const resultado = await registrarproducto();
    console.log(resultado);
    if(resultado){
      alert("registro exitoso");
      $("#form-registrar-producto").reset();
    }
   })

})