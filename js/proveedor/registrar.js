document.addEventListener("DOMContentLoaded",()=>{

    const optionEmp = document.querySelector("#idempresaruc");
    const formproveedor =document.querySelector("#form-registrar-proveedor");
    const proveedor    =document.querySelector("#proveedor");
    const contacto  =document.querySelector("#contacto_principal");
    const telsecundario =document.querySelector("#telefono_contacto");
    const email         =document.querySelector("#email");
    const direccion     =document.querySelector("#direccion");
    
 
    (() =>{
         fetch(`../../controller/empresa.controller.php?operation=getAll`)
             .then(response => response.json())
             .then(data =>{
                 data.forEach(element => {
                     const tagOption = document.createElement('option');
                     tagOption.value = element.idempresaruc;
                     tagOption.innerText= element.razonsocial;
                     optionEmp.appendChild(tagOption);
                 })
             })
             .catch(e =>{
                 console.error(e);
             })
     })();
 
     
    async function registrarproveedor() {
        const params = new FormData();
        params.append('operation','addProveedor');
        params.append('idempresa',optionEmp.value);
        params.append('proveedor',proveedor.value);
        params.append('contacto_principal',contacto.value);
        params.append('telefono_contacto',telsecundario.value);
        params.append('direccion',direccion.value);
        params.append('email',email.value);

        const options ={
            'method': 'POST',
            'body': params
        }

     const response=  await   fetch(`../../controller/proveedor.controller.php`,options)
        return response.json()
        .catch(e=>{
            console.error(e)
        })
    
        
    }

    formproveedor.addEventListener("submit",async(event)=>{
        event.preventDefault();
        const resultado = await registrarproveedor();
        if(resultado){
            alert("Registro exitoso");
             formproveedor.reset();
             
        }
      })
       

})