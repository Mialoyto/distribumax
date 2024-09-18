document.addEventListener("DOMContentLoaded",()=>{
    const formempresa = document.querySelector("#form-registrar-empresa");
    const ruc = document.querySelector("#idempresaruc");
    const razon = document.querySelector("#razonsocial");
    const direccion = document.querySelector("#direccion");
    const email = document.querySelector("#email");
    const telefono = document.querySelector("#telefono");
    
    const iddistrito = document.querySelector("#searchDistrito");
    const datalist   = document.querySelector("#datalistDistrito");
    let distrito='';
    if(iddistrito){
        iddistrito.addEventListener('input',event=>{
            distrito=event.target.value;
            mostraResultados();
        })
    }
    const searchDistrito = async ()=>{
        let searchData = new FormData();
        searchData.append('operation','searchDistrito');
        searchData.append('distrito',distrito);
        const option={
            method : 'POST',
            body:searchData
        }
        try{
            const response= await fetch(`../../controller/distrito.controller.php`,option)
            return response.json();
        }catch(e){
            console.error(e);
        }
    }

    const mostraResultados =()=>{
        searchDistrito()
        .then(response=>{
            datalist.innerHTML='';
            response.forEach(item => {
                const option = document.createElement('option');
                option.setAttribute('data-id', item.iddistrito)
                option.innerText=item.distrito;
                datalist.appendChild(option);
            })
           
        })
    }
    let selectedId;
    
    iddistrito.addEventListener('change',event=>{
        const selectedDistrito =event.target.value;
        const options =datalist.children;
        
        for(let i =0; i<options.length;i++){
            if(options[i].value===selectedDistrito){
                selectedId=options[i].getAttribute('data-id');
                break;
            }
        }
    });

    async function registrarempresa() {
        const params = new FormData();
        params.append('operation', 'add');
        params.append('idempresaruc', ruc.value);
        params.append('iddistrito', selectedId);
        params.append('razonsocial', razon.value);
        params.append('direccion', direccion.value);
        params.append('email', email.value);
        params.append('telefono', telefono.value);
       
        const options = {
            method: 'POST',
            body: params
        };

      const respuesta= await  fetch(`../../controller/empresa.controller.php`, options)
      return respuesta.json();
    }
    formempresa.addEventListener("submit",async (event) => {
        event.preventDefault(); // Evitar el comportamiento por defecto de recargar la página
        const result = await registrarempresa();
        if(result){
          alert("Registro realizado");
          formempresa.reset();
        }
        
    });
});