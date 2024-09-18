
document.addEventListener("DOMContentLoaded",()=>{

    const formarca = document.querySelector("#form-registrar-marca");
    const marca =document.querySelector("#marca");


    async function registrarempresa() {

        const params = new FormData()
        params.append('operation','addMarca');
        params.append('marca',marca.value);
        
        const options ={
            'method':'POST',
            'body':params
        }

        const response = await  fetch(`../../controller/marca.controller.php`,options)
        return response.json()

        .catch(e=>{console.error(e)})

    }
     
    formarca.addEventListener("submit",async (event)=>{
        event.preventDefault();
        const resultado = await registrarempresa();
        if(resultado){
            alert("Registro exitoso");
            formarca.reset();
        }
    });

    

});